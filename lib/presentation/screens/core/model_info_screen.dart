import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/core.dart';
import '../../cubit/emotion/emotion_cubit.dart';

class ModelInfoScreen extends StatefulWidget {
  const ModelInfoScreen({super.key});

  @override
  State<ModelInfoScreen> createState() => _ModelInfoScreenState();
}

class _ModelInfoScreenState extends State<ModelInfoScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<EmotionCubit>().loadModelInfo();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
        child: SafeArea(
          child: Column(
            children: [
              _buildAppBar(),
              Expanded(child: _buildContent()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back, color: Colors.white, size: 24),
          ),
          const SizedBox(width: 8),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Model Information',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'AI models and capabilities',
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => context.read<EmotionCubit>().loadModelInfo(),
            icon: const Icon(Icons.refresh, color: Colors.white, size: 24),
            tooltip: 'Refresh model info',
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
        ),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 32, 24, 32),
          child: BlocBuilder<EmotionCubit, EmotionState>(
            builder: (context, state) {
              return Column(
                children: [
                  _buildModelOverviewCard(state),
                  const SizedBox(height: 24),
                  _buildCapabilitiesCard(),
                  const SizedBox(height: 24),
                  _buildAccuracyCard(),
                  const SizedBox(height: 24),
                  _buildTrainingDataCard(),
                  const SizedBox(height: 24),
                  _buildSupportedLanguagesCard(),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildModelOverviewCard(EmotionState state) {
    final modelInfo = state is EmotionSuccess ? state.modelInfo : null;

    return _buildInfoCard(
      title: 'Model Overview',
      icon: Icons.psychology,
      color: AppColors.primary,
      child: modelInfo != null
          ? Column(
              children: [
                _buildInfoRow(
                  'Model Name',
                  modelInfo['name'] ?? 'GraphSmile EmotionAI',
                ),
                _buildInfoRow('Version', modelInfo['version'] ?? '3.0.0'),
                _buildInfoRow(
                  'Architecture',
                  modelInfo['architecture'] ?? 'Transformer Neural Network',
                ),
                _buildInfoRow(
                  'Last Updated',
                  modelInfo['last_updated'] ?? 'December 2024',
                ),
                _buildInfoRow('Model Size', modelInfo['size'] ?? '1.2GB'),
                _buildInfoRow('Parameters', modelInfo['parameters'] ?? '850M'),
              ],
            )
          : const Center(
              child: Column(
                children: [
                  CircularProgressIndicator(color: AppColors.primary),
                  SizedBox(height: 16),
                  Text(
                    'Loading model information...',
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildCapabilitiesCard() {
    return _buildInfoCard(
      title: 'Capabilities',
      icon: Icons.auto_awesome,
      color: AppColors.accent,
      child: Column(
        children: [
          _buildCapabilityItem(
            'Emotion Recognition',
            '7 primary emotions with 95.8% accuracy',
            Icons.emoji_emotions,
            AppColors.success,
          ),
          _buildCapabilityItem(
            'Sentiment Analysis',
            'Positive, negative, neutral classification',
            Icons.sentiment_satisfied,
            AppColors.info,
          ),
          _buildCapabilityItem(
            'Confidence Scoring',
            'Probabilistic confidence for each prediction',
            Icons.verified,
            AppColors.warning,
          ),
          _buildCapabilityItem(
            'Real-time Processing',
            'Average response time under 300ms',
            Icons.speed,
            AppColors.primary,
          ),
          _buildCapabilityItem(
            'Batch Processing',
            'Process up to 100 texts simultaneously',
            Icons.batch_prediction,
            AppColors.accent,
          ),
          _buildCapabilityItem(
            'Context Awareness',
            'Understanding of text context and nuance',
            Icons.psychology,
            AppColors.success,
          ),
        ],
      ),
    );
  }

  Widget _buildAccuracyCard() {
    return _buildInfoCard(
      title: 'Performance Metrics',
      icon: Icons.analytics,
      color: AppColors.success,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildMetricColumn(
                'Overall Accuracy',
                '95.8%',
                AppColors.success,
              ),
              _buildMetricColumn('Precision', '94.2%', AppColors.primary),
              _buildMetricColumn('Recall', '91.8%', AppColors.accent),
            ],
          ),
          const SizedBox(height: 20),
          _buildEmotionAccuracyChart(),
        ],
      ),
    );
  }

  Widget _buildTrainingDataCard() {
    return _buildInfoCard(
      title: 'Training Data',
      icon: Icons.dataset,
      color: AppColors.info,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildMetricColumn('Total Samples', '2.1M', AppColors.info),
              _buildMetricColumn('Languages', '7', AppColors.primary),
              _buildMetricColumn('Data Sources', '15+', AppColors.accent),
            ],
          ),
          const SizedBox(height: 16),
          _buildDataSourcesList(),
        ],
      ),
    );
  }

  Widget _buildSupportedLanguagesCard() {
    return _buildInfoCard(
      title: 'Supported Languages',
      icon: Icons.language,
      color: AppColors.warning,
      child: Column(
        children: [
          _buildLanguageGrid(),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.warning.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(Icons.info, color: AppColors.warning, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Additional languages are being added regularly. Request support for specific languages through our feedback system.',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard({
    required String title,
    required IconData icon,
    required Color color,
    required Widget child,
  }) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [color.withValues(alpha: 0.1), AppColors.surface],
          ),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: color, size: 24),
                ),
                const SizedBox(width: 16),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            child,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 16, color: AppColors.textSecondary),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCapabilityItem(
    String title,
    String description,
    IconData icon,
    Color color,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14,
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

  Widget _buildMetricColumn(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildEmotionAccuracyChart() {
    final emotions = [
      'Joy',
      'Sadness',
      'Anger',
      'Fear',
      'Surprise',
      'Disgust',
      'Neutral',
    ];
    final accuracies = [97.2, 94.8, 96.1, 93.5, 95.9, 94.2, 98.1];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Accuracy by Emotion',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        ...emotions.asMap().entries.map((entry) {
          final index = entry.key;
          final emotion = entry.value;
          final accuracy = accuracies[index];

          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                SizedBox(
                  width: 80,
                  child: Text(
                    emotion,
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                Expanded(
                  child: LinearProgressIndicator(
                    value: accuracy / 100,
                    backgroundColor: AppColors.success.withValues(alpha: 0.2),
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      AppColors.success,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '${accuracy.toStringAsFixed(1)}%',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.success,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildDataSourcesList() {
    final sources = [
      'Social Media Posts',
      'Movie Reviews',
      'Product Reviews',
      'News Articles',
      'Literary Texts',
      'Academic Papers',
      'Chat Conversations',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Data Sources',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: sources.map((source) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.info.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                source,
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.info,
                  fontWeight: FontWeight.w500,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildLanguageGrid() {
    final languages = [
      {'name': 'English', 'code': 'EN', 'support': '100%'},
      {'name': 'Spanish', 'code': 'ES', 'support': '95%'},
      {'name': 'French', 'code': 'FR', 'support': '92%'},
      {'name': 'German', 'code': 'DE', 'support': '89%'},
      {'name': 'Italian', 'code': 'IT', 'support': '87%'},
      {'name': 'Portuguese', 'code': 'PT', 'support': '85%'},
      {'name': 'Chinese', 'code': 'ZH', 'support': '82%'},
      {'name': 'Japanese', 'code': 'JA', 'support': '78%'},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 2.5,
      ),
      itemCount: languages.length,
      itemBuilder: (context, index) {
        final language = languages[index];
        final support = double.parse(language['support']!.replaceAll('%', ''));

        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.warning.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.warning.withValues(alpha: 0.3)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    language['code']!,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppColors.warning,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    language['support']!,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppColors.success,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                language['name']!,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              LinearProgressIndicator(
                value: support / 100,
                backgroundColor: AppColors.warning.withValues(alpha: 0.2),
                valueColor: AlwaysStoppedAnimation<Color>(
                  support >= 90 ? AppColors.success : AppColors.warning,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
