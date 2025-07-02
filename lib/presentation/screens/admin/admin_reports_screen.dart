import 'package:flutter/material.dart';
import '../../../core/core.dart';

class AdminReportsScreen extends StatefulWidget {
  const AdminReportsScreen({super.key});

  @override
  State<AdminReportsScreen> createState() => _AdminReportsScreenState();
}

class _AdminReportsScreenState extends State<AdminReportsScreen> {
  String _selectedReportType = 'Customer Analytics';
  String _selectedPeriod = 'Last 30 Days';
  String _selectedFormat = 'PDF';

  final List<String> _reportTypes = [
    'Customer Analytics',
    'Team Performance',
    'System Usage',
    'Financial Summary',
    'Compliance Report',
  ];

  final List<String> _periods = [
    'Last 7 Days',
    'Last 30 Days',
    'Last 90 Days',
    'Last Year',
    'Custom Range',
  ];

  final List<String> _formats = ['PDF', 'Excel', 'CSV', 'PowerPoint'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 24),
            _buildReportGenerator(),
            const SizedBox(height: 24),
            _buildScheduledReports(),
            const SizedBox(height: 24),
            _buildRecentReports(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Reports & Analytics',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        Text(
          'Generate comprehensive business reports and analytics',
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
        ),
      ],
    );
  }

  Widget _buildReportGenerator() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.assessment, color: AppColors.primary),
                const SizedBox(width: 12),
                Text(
                  'Generate Report',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildDropdown(
              'Report Type',
              _selectedReportType,
              _reportTypes,
              (value) => setState(() => _selectedReportType = value!),
            ),
            const SizedBox(height: 16),
            _buildDropdown(
              'Time Period',
              _selectedPeriod,
              _periods,
              (value) => setState(() => _selectedPeriod = value!),
            ),
            const SizedBox(height: 16),
            _buildDropdown(
              'Export Format',
              _selectedFormat,
              _formats,
              (value) => setState(() => _selectedFormat = value!),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _generateReport,
                icon: const Icon(Icons.download),
                label: const Text('Generate Report'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScheduledReports() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.schedule, color: AppColors.secondary),
                    const SizedBox(width: 12),
                    Text(
                      'Scheduled Reports',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                ElevatedButton.icon(
                  onPressed: _addScheduledReport,
                  icon: const Icon(Icons.add, size: 16),
                  label: const Text('Add Schedule'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.secondary,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildScheduledReportTile(
              'Weekly Team Performance',
              'Every Monday at 9:00 AM',
              'PDF',
              true,
            ),
            _buildScheduledReportTile(
              'Monthly Customer Analytics',
              'First day of month at 8:00 AM',
              'Excel',
              true,
            ),
            _buildScheduledReportTile(
              'Daily System Usage',
              'Every day at 11:59 PM',
              'CSV',
              false,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentReports() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.history, color: AppColors.warning),
                const SizedBox(width: 12),
                Text(
                  'Recent Reports',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildRecentReportTile(
              'Customer Analytics Report',
              'Generated 2 hours ago',
              'PDF • 2.3 MB',
              Icons.picture_as_pdf,
            ),
            _buildRecentReportTile(
              'Team Performance Summary',
              'Generated yesterday',
              'Excel • 1.8 MB',
              Icons.table_chart,
            ),
            _buildRecentReportTile(
              'System Usage Report',
              'Generated 2 days ago',
              'CSV • 450 KB',
              Icons.insert_chart,
            ),
            _buildRecentReportTile(
              'Financial Summary',
              'Generated last week',
              'PDF • 3.1 MB',
              Icons.account_balance,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdown(
    String label,
    String value,
    List<String> items,
    ValueChanged<String?> onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: value,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 8,
            ),
          ),
          items: items.map((item) {
            return DropdownMenuItem(value: item, child: Text(item));
          }).toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildScheduledReportTile(
    String name,
    String schedule,
    String format,
    bool isActive,
  ) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: isActive
            ? AppColors.success.withValues(alpha: 0.1)
            : AppColors.textSecondary.withValues(alpha: 0.1),
        child: Icon(
          isActive ? Icons.schedule : Icons.schedule_outlined,
          color: isActive ? AppColors.success : AppColors.textSecondary,
        ),
      ),
      title: Text(name),
      subtitle: Text('$schedule • $format'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Switch(
            value: isActive,
            onChanged: (value) {
              // Toggle schedule
            },
            activeColor: AppColors.success,
          ),
          PopupMenuButton<String>(
            onSelected: (value) => _handleScheduledReportAction(value, name),
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'edit',
                child: Row(
                  children: [
                    Icon(Icons.edit),
                    SizedBox(width: 8),
                    Text('Edit Schedule'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(Icons.delete),
                    SizedBox(width: 8),
                    Text('Delete Schedule'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      contentPadding: EdgeInsets.zero,
    );
  }

  Widget _buildRecentReportTile(
    String name,
    String time,
    String details,
    IconData icon,
  ) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: AppColors.primary.withValues(alpha: 0.1),
        child: Icon(icon, color: AppColors.primary),
      ),
      title: Text(name),
      subtitle: Text('$time • $details'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () => _downloadReport(name),
          ),
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () => _shareReport(name),
          ),
        ],
      ),
      contentPadding: EdgeInsets.zero,
    );
  }

  void _generateReport() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            Text('Generating $_selectedReportType report...'),
          ],
        ),
      ),
    );

    // Simulate report generation
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$_selectedReportType report generated successfully'),
          action: SnackBarAction(label: 'Download', onPressed: () {}),
        ),
      );
    });
  }

  void _addScheduledReport() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Scheduled Report'),
        content: const Text(
          'Scheduled report configuration would be implemented here.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Add Schedule'),
          ),
        ],
      ),
    );
  }

  void _handleScheduledReportAction(String action, String reportName) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('$action action for $reportName')));
  }

  void _downloadReport(String reportName) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Downloading $reportName...')));
  }

  void _shareReport(String reportName) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Sharing $reportName...')));
  }
}

