import 'package:flutter/material.dart';
import '../../../core/core.dart';

class EmployeeTextAnalysisScreen extends StatefulWidget {
  const EmployeeTextAnalysisScreen({super.key});

  @override
  State<EmployeeTextAnalysisScreen> createState() =>
      _EmployeeTextAnalysisScreenState();
}

class _EmployeeTextAnalysisScreenState
    extends State<EmployeeTextAnalysisScreen> {
  final TextEditingController _textController = TextEditingController();
  String _selectedAnalysisType = 'Sentiment Analysis';
  bool _isAnalyzing = false;
  Map<String, dynamic>? _analysisResult;

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
            _buildTextInput(),
            const SizedBox(height: 24),
            if (_analysisResult != null) _buildAnalysisResult(),
            if (_analysisResult != null) const SizedBox(height: 24),
            _buildQuickTemplates(),
            const SizedBox(height: 24),
            _buildAnalysisHistory(),
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
                Icon(Icons.text_fields, color: AppColors.primary, size: 28),
                const SizedBox(width: 12),
                Text(
                  'Text Analysis',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Analyze customer messages, emails, reviews, and feedback for sentiment, emotion, and intent',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _buildStatChip('Analyzed Today', '47', AppColors.primary),
                const SizedBox(width: 12),
                _buildStatChip('Accuracy', '94.2%', AppColors.success),
                const SizedBox(width: 12),
                _buildStatChip('Avg Time', '1.2s', AppColors.secondary),
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

  Widget _buildTextInput() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Analyze Customer Text',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedAnalysisType,
              decoration: InputDecoration(
                labelText: 'Analysis Type',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                prefixIcon: const Icon(Icons.psychology),
              ),
              items:
                  [
                        'Sentiment Analysis',
                        'Emotion Detection',
                        'Intent Classification',
                        'Keyword Extraction',
                        'Language Detection',
                        'Toxicity Detection',
                        'Topic Modeling',
                      ]
                      .map(
                        (type) =>
                            DropdownMenuItem(value: type, child: Text(type)),
                      )
                      .toList(),
              onChanged: (value) =>
                  setState(() => _selectedAnalysisType = value!),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _textController,
              decoration: InputDecoration(
                labelText: 'Customer Text',
                hintText:
                    'Paste customer message, email, review, or feedback here...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                prefixIcon: const Icon(Icons.message),
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.paste),
                      onPressed: _pasteFromClipboard,
                    ),
                    IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () => _textController.clear(),
                    ),
                  ],
                ),
              ),
              maxLines: 6,
              maxLength: 2000,
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _isAnalyzing ? null : _analyzeText,
                    icon: _isAnalyzing
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.analytics),
                    label: Text(_isAnalyzing ? 'Analyzing...' : 'Analyze Text'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                OutlinedButton.icon(
                  onPressed: _saveTemplate,
                  icon: const Icon(Icons.save),
                  label: const Text('Save'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnalysisResult() {
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
                Icon(Icons.analytics, color: AppColors.success),
                const SizedBox(width: 8),
                Text(
                  'Analysis Results',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildResultSection(
              'Overall Sentiment',
              _analysisResult!['sentiment'],
              Colors.blue,
            ),
            const SizedBox(height: 16),
            _buildResultSection(
              'Confidence Score',
              _analysisResult!['confidence'],
              Colors.green,
            ),
            const SizedBox(height: 16),
            _buildResultSection(
              'Detected Emotions',
              _analysisResult!['emotions'],
              Colors.orange,
            ),
            const SizedBox(height: 16),
            _buildResultSection(
              'Key Topics',
              _analysisResult!['topics'],
              Colors.purple,
            ),
            const SizedBox(height: 16),
            _buildResultSection(
              'Recommended Actions',
              _analysisResult!['actions'],
              Colors.red,
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _generateResponse,
                    icon: const Icon(Icons.auto_fix_high),
                    label: const Text('Generate Response'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.secondary,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  onPressed: _exportAnalysis,
                  icon: const Icon(Icons.share),
                  label: const Text('Share'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultSection(String title, dynamic content, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: color.withValues(alpha: 0.3)),
          ),
          child: Text(
            content.toString(),
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      ],
    );
  }

  Widget _buildQuickTemplates() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Templates',
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
            _buildTemplateCard(
              'Customer Email',
              Icons.email,
              _fillEmailTemplate,
            ),
            _buildTemplateCard(
              'Product Review',
              Icons.star,
              _fillReviewTemplate,
            ),
            _buildTemplateCard('Support Chat', Icons.chat, _fillChatTemplate),
            _buildTemplateCard(
              'Social Media',
              Icons.share,
              _fillSocialTemplate,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTemplateCard(String title, IconData icon, VoidCallback onTap) {
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

  Widget _buildAnalysisHistory() {
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
          itemCount: 3,
          itemBuilder: (context, index) => _buildHistoryCard(index),
        ),
      ],
    );
  }

  Widget _buildHistoryCard(int index) {
    final types = [
      'Sentiment Analysis',
      'Emotion Detection',
      'Intent Classification',
    ];
    final previews = [
      'I am very disappointed with the product quality...',
      'Thank you so much for the excellent service!',
      'Can you help me with my order status?',
    ];
    final results = ['Negative (85%)', 'Happy (92%)', 'Support Request (78%)'];
    final times = ['5 min ago', '20 min ago', '1 hour ago'];

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppColors.primary.withValues(alpha: 0.1),
          child: Icon(Icons.text_fields, color: AppColors.primary),
        ),
        title: Text(types[index]),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(previews[index], maxLines: 1, overflow: TextOverflow.ellipsis),
            Text(
              results[index],
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(times[index]),
            const Icon(Icons.arrow_forward_ios, size: 12),
          ],
        ),
        onTap: () => _viewHistoryItem(index),
      ),
    );
  }

  void _pasteFromClipboard() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Paste functionality would be implemented here'),
      ),
    );
  }

  void _analyzeText() {
    if (_textController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter some text to analyze')),
      );
      return;
    }

    setState(() => _isAnalyzing = true);

    // Simulate analysis with realistic results
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _isAnalyzing = false;
        _analysisResult = {
          'sentiment': 'Positive (87% confidence)',
          'confidence': '87.3% - High reliability',
          'emotions': 'Satisfaction: 65%, Hope: 23%, Trust: 12%',
          'topics': 'Product Quality, Customer Service, Delivery',
          'actions':
              'Follow up with appreciation, Offer additional support, Monitor for feedback',
        };
      });
    });
  }

  void _saveTemplate() {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Text saved as template')));
  }

  void _generateResponse() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Generated Response'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Based on the analysis, here\'s a suggested response:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
            Text(
              'Thank you for your feedback! We\'re delighted to hear about your positive experience. Your satisfaction is our priority, and we appreciate you taking the time to share your thoughts.',
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Use Response'),
          ),
        ],
      ),
    );
  }

  void _exportAnalysis() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Analysis exported successfully')),
    );
  }

  void _fillEmailTemplate() {
    _textController.text =
        'Dear Support Team,\n\nI recently purchased your product and wanted to share my experience. The ordering process was smooth and delivery was on time. The product quality exceeded my expectations and I\'m very satisfied with my purchase.\n\nThank you for the excellent service!\n\nBest regards,\nCustomer';
    setState(() => _selectedAnalysisType = 'Sentiment Analysis');
  }

  void _fillReviewTemplate() {
    _textController.text =
        'Amazing product! Great quality and fast shipping. Customer service was very helpful when I had questions. Definitely recommend this to others. 5 stars!';
    setState(() => _selectedAnalysisType = 'Emotion Detection');
  }

  void _fillChatTemplate() {
    _textController.text =
        'Hi, I need help with my order #12345. I placed it 3 days ago but haven\'t received any tracking information yet. Can you please check the status? Thank you.';
    setState(() => _selectedAnalysisType = 'Intent Classification');
  }

  void _fillSocialTemplate() {
    _textController.text =
        'Just received my order from @company! Packaging was perfect and the product looks exactly like the photos. Really impressed with the quality 👍 #customerservice #quality';
    setState(() => _selectedAnalysisType = 'Sentiment Analysis');
  }

  void _viewHistoryItem(int index) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Opening analysis history item ${index + 1}')),
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }
}
