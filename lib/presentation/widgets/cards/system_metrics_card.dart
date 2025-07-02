import 'package:flutter/material.dart';
import '../../../data/data.dart';
import '../../../core/core.dart';

class SystemMetricsCard extends StatelessWidget {
  final SystemMetrics? metrics;
  final VoidCallback? onRefresh;
  final bool isAutoRefresh;
  final VoidCallback? onToggleAutoRefresh;

  const SystemMetricsCard({
    super.key,
    this.metrics,
    this.onRefresh,
    this.isAutoRefresh = false,
    this.onToggleAutoRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.primary.withValues(alpha: 0.1),
              AppColors.accent.withValues(alpha: 0.1),
            ],
          ),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.monitor, color: AppColors.primary, size: 28),
                const SizedBox(width: 12),
                const Text(
                  'System Metrics',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const Spacer(),
                if (onToggleAutoRefresh != null)
                  IconButton(
                    onPressed: onToggleAutoRefresh,
                    icon: Icon(
                      isAutoRefresh ? Icons.pause : Icons.play_arrow,
                      color: isAutoRefresh
                          ? AppColors.error
                          : AppColors.success,
                    ),
                    tooltip: isAutoRefresh
                        ? 'Pause auto-refresh'
                        : 'Start auto-refresh',
                  ),
                if (onRefresh != null)
                  IconButton(
                    onPressed: onRefresh,
                    icon: const Icon(Icons.refresh, color: AppColors.primary),
                    tooltip: 'Refresh metrics',
                  ),
              ],
            ),
            const SizedBox(height: 20),
            if (metrics == null)
              const Center(
                child: Column(
                  children: [
                    CircularProgressIndicator(color: AppColors.primary),
                    SizedBox(height: 16),
                    Text(
                      'Loading system metrics...',
                      style: TextStyle(color: AppColors.textSecondary),
                    ),
                  ],
                ),
              )
            else
              Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _buildMetricItem(
                          'CPU Usage',
                          metrics!.cpuUsageFormatted,
                          _getUsageColor(metrics!.cpuUsage),
                          Icons.memory,
                          metrics!.cpuUsage / 100,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildMetricItem(
                          'Memory',
                          metrics!.memoryUsageFormatted,
                          _getUsageColor(metrics!.memoryUsage),
                          Icons.storage,
                          metrics!.memoryUsage / 100,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildMetricItem(
                          'Success Rate',
                          '${metrics!.successRate.toStringAsFixed(1)}%',
                          _getSuccessRateColor(metrics!.successRate),
                          Icons.check_circle,
                          metrics!.successRate / 100,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildMetricItem(
                          'Response Time',
                          metrics!.averageResponseTimeFormatted,
                          _getResponseTimeColor(metrics!.averageResponseTime),
                          Icons.speed,
                          null,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildRequestStats(),
                  const SizedBox(height: 16),
                  _buildCacheMetrics(),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 16,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Uptime: ${metrics!.uptime}',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        'Last updated: ${_formatTimestamp()}',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricItem(
    String label,
    String value,
    Color color,
    IconData icon,
    double? progress,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (progress != null) ...[
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: progress,
              backgroundColor: color.withValues(alpha: 0.2),
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildRequestStats() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatColumn(
            'Total Requests',
            metrics!.totalRequests.toString(),
            Icons.api,
            AppColors.primary,
          ),
          _buildStatColumn(
            'Successful',
            metrics!.successfulRequests.toString(),
            Icons.check_circle_outline,
            AppColors.success,
          ),
          _buildStatColumn(
            'Failed',
            metrics!.failedRequests.toString(),
            Icons.error_outline,
            AppColors.error,
          ),
        ],
      ),
    );
  }

  Widget _buildCacheMetrics() {
    final cache = metrics!.cacheMetrics;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.accent.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.accent.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.memory, color: AppColors.accent, size: 20),
              const SizedBox(width: 8),
              Text(
                'Cache Performance',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatColumn(
                'Hit Rate',
                cache.hitRateFormatted,
                Icons.trending_up,
                _getCacheColor(cache.hitRate),
              ),
              _buildStatColumn(
                'Cache Size',
                cache.size.toString(),
                Icons.storage,
                AppColors.accent,
              ),
              _buildStatColumn(
                'Hits/Misses',
                '${cache.hits}/${cache.misses}',
                Icons.analytics,
                AppColors.textPrimary,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatColumn(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Column(
      children: [
        Icon(icon, color: color, size: 18),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Color _getUsageColor(double usage) {
    if (usage >= 90) return AppColors.error;
    if (usage >= 70) return Colors.orange;
    if (usage >= 50) return Colors.yellow[700]!;
    return AppColors.success;
  }

  Color _getSuccessRateColor(double rate) {
    if (rate >= 98) return AppColors.success;
    if (rate >= 95) return Colors.green[600]!;
    if (rate >= 90) return Colors.orange;
    return AppColors.error;
  }

  Color _getResponseTimeColor(double time) {
    if (time <= 100) return AppColors.success;
    if (time <= 300) return Colors.yellow[700]!;
    if (time <= 500) return Colors.orange;
    return AppColors.error;
  }

  Color _getCacheColor(double hitRate) {
    if (hitRate >= 0.9) return AppColors.success;
    if (hitRate >= 0.7) return Colors.green[600]!;
    if (hitRate >= 0.5) return Colors.orange;
    return AppColors.error;
  }

  String _formatTimestamp() {
    if (metrics?.timestamp == null) return 'Never';
    try {
      final time = DateTime.parse(metrics!.timestamp);
      final now = DateTime.now();
      final diff = now.difference(time);

      if (diff.inSeconds < 60) return '${diff.inSeconds}s ago';
      if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
      if (diff.inHours < 24) return '${diff.inHours}h ago';
      return '${diff.inDays}d ago';
    } catch (e) {
      return 'Invalid';
    }
  }
}
