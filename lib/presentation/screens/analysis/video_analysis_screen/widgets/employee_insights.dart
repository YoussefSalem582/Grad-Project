import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/core.dart';
import '../../../../cubit/video_analysis/video_analysis_cubit.dart';

/// Employee insights and action items widget
class EmployeeInsights extends StatelessWidget {
  const EmployeeInsights({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VideoAnalysisCubit, VideoAnalysisState>(
      builder: (context, state) {
        if (state is! VideoAnalysisSuccess && state is! VideoAnalysisDemo) {
          return const SizedBox.shrink();
        }

        return Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border.withValues(alpha: 0.3)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.06),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 16),
              _buildActionItem(
                'Follow up on customer concerns',
                'Schedule a call to address any issues raised',
                Icons.phone_rounded,
                const Color(0xFF667EEA),
                onTap:
                    () => _showActionDialog(context, 'Schedule Follow-up Call'),
              ),
              const SizedBox(height: 12),
              _buildActionItem(
                'Document customer feedback',
                'Add insights to customer profile and CRM',
                Icons.edit_note_rounded,
                const Color(0xFF764BA2),
                onTap: () => _showActionDialog(context, 'Document Feedback'),
              ),
              const SizedBox(height: 12),
              _buildActionItem(
                'Share with team',
                'Discuss findings in next team meeting',
                Icons.people_rounded,
                const Color(0xFF10B981),
                onTap: () => _showActionDialog(context, 'Share with Team'),
              ),
              const SizedBox(height: 16),
              _buildQuickStats(state),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFF10B981).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(
            Icons.lightbulb_rounded,
            color: Color(0xFF10B981),
            size: 18,
          ),
        ),
        const SizedBox(width: 12),
        const Text(
          'Employee Action Items',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildActionItem(
    String title,
    String description,
    IconData icon,
    Color color, {
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color.withValues(alpha: 0.2)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 16),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: color,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 12,
              color: color.withValues(alpha: 0.7),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickStats(VideoAnalysisState state) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF667EEA).withValues(alpha: 0.05),
            const Color(0xFF10B981).withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildQuickStatItem(
            'Priority',
            'High',
            Icons.priority_high,
            const Color(0xFFF59E0B),
          ),
          _buildQuickStatItem(
            'Status',
            'Pending',
            Icons.schedule,
            const Color(0xFF667EEA),
          ),
          _buildQuickStatItem(
            'Due',
            '2 days',
            Icons.calendar_today,
            const Color(0xFF10B981),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStatItem(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Column(
      children: [
        Icon(icon, color: color, size: 16),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w500,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  void _showActionDialog(BuildContext context, String actionTitle) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            title: Text(actionTitle),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'This action will help you follow up on the customer video analysis results.',
                  style: TextStyle(color: AppColors.textSecondary),
                ),
                const SizedBox(height: 16),
                if (actionTitle.contains('Schedule'))
                  _buildScheduleOptions()
                else if (actionTitle.contains('Document'))
                  _buildDocumentOptions()
                else
                  _buildShareOptions(),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('$actionTitle completed successfully!'),
                      backgroundColor: const Color(0xFF10B981),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF667EEA),
                  foregroundColor: Colors.white,
                ),
                child: const Text('Complete'),
              ),
            ],
          ),
    );
  }

  Widget _buildScheduleOptions() {
    return Column(
      children: [
        ListTile(
          leading: const Icon(Icons.phone, color: Color(0xFF667EEA)),
          title: const Text('Schedule phone call'),
          subtitle: const Text('Call customer within 24 hours'),
          onTap: () {},
        ),
        ListTile(
          leading: const Icon(Icons.video_call, color: Color(0xFF667EEA)),
          title: const Text('Schedule video meeting'),
          subtitle: const Text('Face-to-face discussion'),
          onTap: () {},
        ),
      ],
    );
  }

  Widget _buildDocumentOptions() {
    return Column(
      children: [
        ListTile(
          leading: const Icon(Icons.note_add, color: Color(0xFF764BA2)),
          title: const Text('Add to customer notes'),
          subtitle: const Text('Record insights in CRM'),
          onTap: () {},
        ),
        ListTile(
          leading: const Icon(Icons.analytics, color: Color(0xFF764BA2)),
          title: const Text('Update analytics'),
          subtitle: const Text('Add to customer sentiment tracking'),
          onTap: () {},
        ),
      ],
    );
  }

  Widget _buildShareOptions() {
    return Column(
      children: [
        ListTile(
          leading: const Icon(Icons.email, color: Color(0xFF10B981)),
          title: const Text('Email team summary'),
          subtitle: const Text('Send analysis results to team'),
          onTap: () {},
        ),
        ListTile(
          leading: const Icon(Icons.calendar_today, color: Color(0xFF10B981)),
          title: const Text('Add to meeting agenda'),
          subtitle: const Text('Discuss in next team meeting'),
          onTap: () {},
        ),
      ],
    );
  }
}
