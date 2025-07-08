import 'package:flutter/material.dart';
import '../../../../../core/core.dart';

// Using dynamic data type until cubit is implemented
class WelcomeHeaderWidget extends StatelessWidget {
  final dynamic data;

  const WelcomeHeaderWidget({super.key, this.data});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final customSpacing = theme.extension<CustomSpacing>()!;

    return Container(
      margin: EdgeInsets.all(customSpacing.md),
      padding: EdgeInsets.all(customSpacing.lg),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
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
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  Icons.dashboard_rounded,
                  color: AppColors.primary,
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
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      'Customer Experience Specialist',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// class _HeaderStatCard extends StatelessWidget {
//   final String value;
//   final String label;
//   final IconData icon;

//   const _HeaderStatCard({
//     required this.value,
//     required this.label,
//     required this.icon,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(14),
//       decoration: BoxDecoration(
//         color: AppColors.primary.withValues(alpha: 0.05),
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(
//           color: AppColors.primary.withValues(alpha: 0.1),
//           width: 1,
//         ),
//       ),
//       child: Column(
//         children: [
//           Icon(icon, color: AppColors.primary, size: 20),
//           const SizedBox(height: 8),
//           Text(
//             value,
//             style: TextStyle(
//               color: AppColors.textPrimary,
//               fontSize: 18,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           const SizedBox(height: 4),
//           Text(
//             label,
//             style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
//             textAlign: TextAlign.center,
//           ),
//         ],
//       ),
//     );
//   }
// }
