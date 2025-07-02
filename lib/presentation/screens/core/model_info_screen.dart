import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/core.dart';
import '../../blocs/emotion/emotion_cubit.dart';
import '../../blocs/emotion/emotion_state.dart';

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
      // Load model information if needed
      // context.read<EmotionCubit>().loadModelInfo();
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
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
            style: IconButton.styleFrom(
              backgroundColor: Colors.white.withValues(alpha: 0.2),
              padding: const EdgeInsets.all(12),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Model Information',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'AI Model Information',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.8),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              // Refresh model info if needed
              // context.read<EmotionCubit>().loadModelInfo();
            },
            icon: const Icon(Icons.refresh, color: Colors.white),
            style: IconButton.styleFrom(
              backgroundColor: Colors.white.withValues(alpha: 0.2),
              padding: const EdgeInsets.all(12),
            ),
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
                  _buildModelOverviewCard(),
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

  Widget _buildModelOverviewCard() {
    return _buildInfoCard(
      title: 'Model Overview',
      icon: Icons.psychology,
      color: AppColors.primary,
      child: Column(
        children: [
          _buildInfoRow('Model Name', 'GraphSmile EmotionAI'),
          _buildInfoRow('Version', '3.0.0'),
          _buildInfoRow('Architecture', 'Transformer Neural Network'),
          _buildInfoRow('Last Updated', 'December 2024'),
          _buildInfoRow('Model Size', '1.2GB'),
          _buildInfoRow('Parameters', '850M'),
        ],
      ),
    );
  }

  Widget _buildCapabilitiesCard() {
    return _buildInfoCard(
      title: 'Capabilities',
      icon: Icons.star,
      color: AppColors.accent,
      child: Column(
        children: [
          _buildInfoRow('Emotions Detected', '7 primary emotions'),
          _buildInfoRow('Languages Supported', '15+ languages'),
          _buildInfoRow('Real-time Processing', 'Yes'),
          _buildInfoRow('Batch Processing', 'Up to 1000 items'),
          _buildInfoRow('Audio Analysis', 'Yes'),
          _buildInfoRow('Video Analysis', 'Yes'),
        ],
      ),
    );
  }

  Widget _buildAccuracyCard() {
    return _buildInfoCard(
      title: 'Accuracy Metrics',
      icon: Icons.analytics,
      color: AppColors.success,
      child: Column(
        children: [
          _buildInfoRow('Overall Accuracy', '94.2%'),
          _buildInfoRow('Text Analysis', '96.1%'),
          _buildInfoRow('Voice Analysis', '92.8%'),
          _buildInfoRow('Video Analysis', '90.5%'),
          _buildInfoRow('Cross-validation', '93.7%'),
          _buildInfoRow('F1-Score', '0.941'),
        ],
      ),
    );
  }

  Widget _buildTrainingDataCard() {
    return _buildInfoCard(
      title: 'Training Data',
      icon: Icons.dataset,
      color: AppColors.warning,
      child: Column(
        children: [
          _buildInfoRow('Dataset Size', '10M+ samples'),
          _buildInfoRow('Text Samples', '6.2M entries'),
          _buildInfoRow('Audio Samples', '2.8M clips'),
          _buildInfoRow('Video Samples', '1.2M clips'),
          _buildInfoRow('Languages', '15 languages'),
          _buildInfoRow('Last Training', 'November 2024'),
        ],
      ),
    );
  }

  Widget _buildSupportedLanguagesCard() {
    return _buildInfoCard(
      title: 'Supported Languages',
      icon: Icons.language,
      color: AppColors.info,
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          'English',
          'Spanish',
          'French',
          'German',
          'Italian',
          'Portuguese',
          'Russian',
          'Chinese',
          'Japanese',
          'Korean',
          'Arabic',
          'Hindi',
          'Dutch',
          'Swedish',
          'Norwegian',
        ].map((language) => _buildLanguageChip(language)).toList(),
      ),
    );
  }

  Widget _buildInfoCard({
    required String title,
    required IconData icon,
    required Color color,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          child,
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageChip(String language) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
      ),
      child: Text(
        language,
        style: TextStyle(
          fontSize: 12,
          color: AppColors.primary,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
