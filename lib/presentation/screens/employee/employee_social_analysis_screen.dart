import 'package:flutter/material.dart';
import '../../../core/core.dart';

class EmployeeSocialAnalysisScreen extends StatefulWidget {
  const EmployeeSocialAnalysisScreen({super.key});

  @override
  State<EmployeeSocialAnalysisScreen> createState() =>
      _EmployeeSocialAnalysisScreenState();
}

class _EmployeeSocialAnalysisScreenState
    extends State<EmployeeSocialAnalysisScreen> {
  final TextEditingController _linkController = TextEditingController();
  String _selectedPlatform = 'Auto-detect';
  bool _isAnalyzing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 24),
            _buildAnalysisInput(),
            const SizedBox(height: 24),
            _buildRecentAnalysis(),
            const SizedBox(height: 24),
            _buildSocialMediaTrends(),
            const SizedBox(height: 24),
            _buildQuickActions(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
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
                Icon(Icons.link, color: AppColors.primary, size: 28),
                const SizedBox(width: 12),
                Text(
                  'Social Media Analysis',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Analyze customer sentiment from social media posts, reviews, and comments',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _buildStatChip('Analyzed Today', '23', AppColors.primary),
                const SizedBox(width: 12),
                _buildStatChip('Positive', '18', AppColors.success),
                const SizedBox(width: 12),
                _buildStatChip('Negative', '3', AppColors.error),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatChip(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: color,
              fontSize: 14,
            ),
          ),
          const SizedBox(width: 4),
          Text(label, style: TextStyle(color: color, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildAnalysisInput() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Analyze Social Media Link',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedPlatform,
              decoration: InputDecoration(
                labelText: 'Platform',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                prefixIcon: const Icon(Icons.public),
              ),
              items:
                  [
                        'Auto-detect',
                        'Twitter/X',
                        'Facebook',
                        'Instagram',
                        'LinkedIn',
                        'TikTok',
                        'YouTube',
                        'Reddit',
                      ]
                      .map(
                        (platform) => DropdownMenuItem(
                          value: platform,
                          child: Text(platform),
                        ),
                      )
                      .toList(),
              onChanged: (value) => setState(() => _selectedPlatform = value!),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _linkController,
              decoration: InputDecoration(
                labelText: 'Social Media Link or Post URL',
                hintText: 'https://twitter.com/user/status/123...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                prefixIcon: const Icon(Icons.link),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.paste),
                  onPressed: _pasteFromClipboard,
                ),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _isAnalyzing ? null : _analyzeLink,
                icon: _isAnalyzing
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.analytics),
                label: Text(_isAnalyzing ? 'Analyzing...' : 'Analyze Link'),
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

  Widget _buildRecentAnalysis() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recent Analysis',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 4,
          itemBuilder: (context, index) => _buildAnalysisCard(index),
        ),
      ],
    );
  }

  Widget _buildAnalysisCard(int index) {
    final platforms = ['Twitter', 'Facebook', 'Instagram', 'LinkedIn'];
    final sentiments = ['Positive', 'Negative', 'Positive', 'Neutral'];
    final contents = [
      'Amazing customer service! Really happy with my purchase...',
      'Product arrived damaged. Very disappointed with the quality...',
      'Love this brand! Great products and fast delivery 🔥',
      'Decent product, nothing special but does the job well.',
    ];
    final times = ['2 min ago', '15 min ago', '1 hour ago', '3 hours ago'];

    final sentimentColors = {
      'Positive': AppColors.success,
      'Negative': AppColors.error,
      'Neutral': AppColors.textSecondary,
    };

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    platforms[index],
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: sentimentColors[sentiments[index]]!.withValues(
                      alpha: 0.1,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    sentiments[index],
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: sentimentColors[sentiments[index]],
                    ),
                  ),
                ),
                const Spacer(),
                Text(
                  times[index],
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              contents[index],
              style: Theme.of(context).textTheme.bodyMedium,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                TextButton.icon(
                  onPressed: () => _viewFullAnalysis(index),
                  icon: const Icon(Icons.visibility, size: 16),
                  label: const Text('View Details'),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                  ),
                ),
                const SizedBox(width: 8),
                TextButton.icon(
                  onPressed: () => _respondToPost(index),
                  icon: const Icon(Icons.reply, size: 16),
                  label: const Text('Respond'),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialMediaTrends() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Social Media Trends',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),
            _buildTrendItem(
              'Positive mentions increased',
              '+15%',
              AppColors.success,
              Icons.trending_up,
            ),
            _buildTrendItem(
              'Response time improved',
              '2.1 min avg',
              AppColors.primary,
              Icons.timer,
            ),
            _buildTrendItem(
              'Customer satisfaction',
              '4.8/5.0 stars',
              AppColors.warning,
              Icons.star,
            ),
            _buildTrendItem(
              'Platform engagement',
              'Instagram +23%',
              AppColors.secondary,
              Icons.photo_camera,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrendItem(
    String title,
    String value,
    Color color,
    IconData icon,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
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
            child: Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
            ),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 2.5,
          children: [
            _buildActionCard(
              'Bulk Analysis',
              Icons.upload_file,
              () => _bulkAnalysis(),
            ),
            _buildActionCard(
              'Export Report',
              Icons.download,
              () => _exportReport(),
            ),
            _buildActionCard(
              'Set Alerts',
              Icons.notifications,
              () => _setAlerts(),
            ),
            _buildActionCard(
              'Integration',
              Icons.extension,
              () => _manageIntegrations(),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionCard(String title, IconData icon, VoidCallback onTap) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Icon(icon, color: AppColors.primary),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _pasteFromClipboard() {
    // Implementation for pasting from clipboard
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Paste functionality would be implemented here'),
      ),
    );
  }

  void _analyzeLink() {
    if (_linkController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a social media link')),
      );
      return;
    }

    setState(() => _isAnalyzing = true);

    // Simulate analysis
    Future.delayed(const Duration(seconds: 3), () {
      setState(() => _isAnalyzing = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Analysis completed! Check results below.'),
        ),
      );
      _linkController.clear();
    });
  }

  void _viewFullAnalysis(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Detailed Analysis'),
        content: const Text(
          'Full analysis details would be shown here including sentiment breakdown, keywords, engagement metrics, and recommendations.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _respondToPost(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Respond to Post'),
        content: const TextField(
          decoration: InputDecoration(
            labelText: 'Your response',
            border: OutlineInputBorder(),
          ),
          maxLines: 4,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Send'),
          ),
        ],
      ),
    );
  }

  void _bulkAnalysis() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Bulk analysis feature would be implemented here'),
      ),
    );
  }

  void _exportReport() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Exporting social media analysis report...'),
      ),
    );
  }

  void _setAlerts() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Alert configuration would be implemented here'),
      ),
    );
  }

  void _manageIntegrations() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Integration management would be implemented here'),
      ),
    );
  }

  @override
  void dispose() {
    _linkController.dispose();
    super.dispose();
  }
}
