import 'package:flutter/material.dart';
import '../../../core/core.dart';
import '../../cubit/employee_dashboard/employee_dashboard_cubit.dart';

class WelcomeHeaderWidget extends StatelessWidget {
  final EmployeeDashboardData? data;

  const WelcomeHeaderWidget({super.key, this.data});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final customSpacing = theme.extension<CustomSpacing>()!;

    return Container(
      margin: EdgeInsets.all(customSpacing.md),
      padding: EdgeInsets.all(customSpacing.lg),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF667EEA).withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(customSpacing.md),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.dashboard_rounded,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              SizedBox(width: customSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome Back! 👋',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      'Customer Experience Specialist',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.white.withValues(alpha: 0.9),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: customSpacing.lg),
          Text(
            'Today\'s Overview',
            style: theme.textTheme.titleMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: customSpacing.md),
          Row(
            children: [
              Expanded(
                child: _HeaderStatCard(
                  value: data?.quickStats.isNotEmpty == true
                      ? '${data!.quickStats[0]['value'] ?? '12'}'
                      : '12',
                  label: data?.quickStats.isNotEmpty == true
                      ? (data!.quickStats[0]['title'] as String? ??
                            'Today\'s Tickets')
                      : 'Today\'s Tickets',
                  icon: Icons.assignment_outlined,
                ),
              ),
              SizedBox(width: customSpacing.md),
              Expanded(
                child: _HeaderStatCard(
                  value:
                      '${((data?.customerSatisfaction ?? 4.8) * 20).toInt()}%',
                  label: 'Satisfaction',
                  icon: Icons.star_outline,
                ),
              ),
              SizedBox(width: customSpacing.md),
              Expanded(
                child: _HeaderStatCard(
                  value:
                      data?.quickStats.length != null &&
                          data!.quickStats.length > 1
                      ? (data!.quickStats[1]['value'] as String? ?? '2.1h')
                      : '2.1h',
                  label: 'Avg Response',
                  icon: Icons.schedule_outlined,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeaderStatCard extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon;

  const _HeaderStatCard({
    required this.value,
    required this.label,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.white, size: 20),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.8),
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
