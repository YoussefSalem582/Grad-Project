import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/core.dart';
import '../../cubit/admin_dashboard/admin_dashboard_cubit.dart';
import '../../cubit/admin_dashboard/admin_dashboard_state.dart';
import '../../widgets/auth/animated_background_widget.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _backgroundController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _backgroundAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    // Load dashboard data when the screen initializes
    context.read<AdminDashboardCubit>().loadDashboard();
  }

  void _initializeAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _backgroundController = AnimationController(
      duration: const Duration(seconds: 6),
      vsync: this,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );

    _backgroundAnimation = CurvedAnimation(
      parent: _backgroundController,
      curve: Curves.linear,
    );

    _fadeController.forward();
    _backgroundController.repeat();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _backgroundController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final customSpacing = theme.extension<CustomSpacing>()!;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Animated Background
          AnimatedBackgroundWidget(animation: _backgroundAnimation),

          // Dashboard Content
          FadeTransition(
            opacity: _fadeAnimation,
            child: BlocBuilder<AdminDashboardCubit, AdminDashboardState>(
              builder: (context, state) {
                if (state is AdminDashboardLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is AdminDashboardError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 64,
                          color: AppColors.error,
                        ),
                        SizedBox(height: customSpacing.md),
                        Text(
                          'Error loading dashboard',
                          style: theme.textTheme.headlineSmall?.copyWith(
                            color: AppColors.textPrimary,
                          ),
                        ),
                        SizedBox(height: customSpacing.sm),
                        Text(
                          state.message,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: customSpacing.lg),
                        ElevatedButton(
                          onPressed: () {
                            context.read<AdminDashboardCubit>().loadDashboard();
                          },
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                }

                if (state is AdminDashboardLoaded) {
                  return _buildDashboardContent(
                    state.dashboardData,
                    customSpacing,
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDashboardContent(
    Map<String, dynamic> data,
    CustomSpacing customSpacing,
  ) {
    return RefreshIndicator(
      onRefresh: () => context.read<AdminDashboardCubit>().refreshDashboard(),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.all(customSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: customSpacing.xl * 2), // Space for admin badge
            _buildWelcomeHeader(customSpacing),
            SizedBox(height: customSpacing.xl),
            _buildSystemOverview(data, customSpacing),
            SizedBox(height: customSpacing.xl),
            SizedBox(height: customSpacing.xl),
            _buildSystemHealth(data, customSpacing),
            SizedBox(height: customSpacing.xl),
            SizedBox(height: customSpacing.xl),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeHeader(CustomSpacing customSpacing) {
    return Container(
      padding: EdgeInsets.all(customSpacing.lg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFFFF6B6B).withValues(alpha: 0.1),
            const Color(0xFFFF8E53).withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFFF6B6B).withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(customSpacing.md),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [const Color(0xFFFF6B6B), const Color(0xFFFF8E53)],
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFFF6B6B).withValues(alpha: 0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: const Icon(
              Icons.admin_panel_settings,
              color: Colors.white,
              size: 32,
            ),
          ),
          SizedBox(width: customSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Admin Dashboard',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: customSpacing.xs),
                Text(
                  'System overview and management',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSystemOverview(
    Map<String, dynamic> data,
    CustomSpacing customSpacing,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'System Overview',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        SizedBox(height: customSpacing.md),
        Row(
          children: [
            Expanded(
              child: _buildMetricCard(
                'Total Users',
                '${data['totalUsers']}',
                Icons.people,
                const Color(0xFF4CAF50),
                'Registered',
              ),
            ),
            SizedBox(width: customSpacing.md),
            Expanded(
              child: _buildMetricCard(
                'Active Users',
                '${data['activeUsers']}',
                Icons.online_prediction,
                const Color(0xFF2196F3),
                'Online now',
              ),
            ),
          ],
        ),
        SizedBox(height: customSpacing.md),
        Row(
          children: [
            Expanded(
              child: _buildMetricCard(
                'Total Analyses',
                '${data['totalAnalyses']}',
                Icons.analytics,
                const Color(0xFF9C27B0),
                'All time',
              ),
            ),
            SizedBox(width: customSpacing.md),
            Expanded(
              child: _buildMetricCard(
                'System Health',
                '${data['systemHealth']}%',
                Icons.health_and_safety,
                const Color(0xFFFF9800),
                'Excellent',
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSystemHealth(
    Map<String, dynamic> data,
    CustomSpacing customSpacing,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'System Status',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        SizedBox(height: customSpacing.md),
        Row(
          children: [
            Expanded(
              child: _buildStatusCard(
                'Critical Alerts',
                '${data['criticalAlerts']}',
                Icons.warning,
                data['criticalAlerts'] > 5
                    ? AppColors.error
                    : AppColors.warning,
              ),
            ),
            SizedBox(width: customSpacing.md),
            Expanded(
              child: _buildStatusCard(
                'Pending Tasks',
                '${data['pendingTasks']}',
                Icons.task,
                AppColors.primary,
              ),
            ),
          ],
        ),
        SizedBox(height: customSpacing.md),
        _buildStatusCard(
          'Server Uptime',
          '${data['serverUptime']}%',
          Icons.dns,
          AppColors.success,
          isWide: true,
        ),
      ],
    );
  }

  Widget _buildMetricCard(
    String title,
    String value,
    IconData icon,
    Color color,
    String subtitle,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              // const Spacer(),
              // Icon(Icons.trending_up, color: AppColors.success, size: 16),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w900,
              color: color,
            ),
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          Text(
            subtitle,
            style: TextStyle(fontSize: 10, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusCard(
    String title,
    String value,
    IconData icon,
    Color color, {
    bool isWide = false,
  }) {
    return Container(
      width: isWide ? double.infinity : null,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.2)),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: color,
                  ),
                ),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
