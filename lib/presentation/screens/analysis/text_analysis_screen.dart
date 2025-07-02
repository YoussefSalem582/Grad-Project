import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../blocs/emotion/emotion_cubit.dart';
import '../../blocs/emotion/emotion_state.dart';
import '../../widgets/buttons/modern_button.dart';
import '../../widgets/cards/modern_card.dart';
import '../../widgets/common/loading_widgets.dart';
import '../../widgets/forms/modern_text_field.dart';

class TextAnalysisScreen extends StatefulWidget {
  const TextAnalysisScreen({super.key});

  @override
  State<TextAnalysisScreen> createState() => _TextAnalysisScreenState();
}

class _TextAnalysisScreenState extends State<TextAnalysisScreen> {
  final _textController = TextEditingController();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _analyzeText() {
    if (_textController.text.trim().isEmpty) return;
    context.read<EmotionCubit>().analyzeText(_textController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.primary.withOpacity(0.1), Colors.white],
          ),
        ),
        child: SafeArea(
          child: BlocConsumer<EmotionCubit, EmotionState>(
            listener: (context, state) {
              if (state is EmotionError) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(state.message)));
              }
            },
            builder: (context, state) {
              return LoadingOverlay(
                isLoading: state is EmotionLoading,
                message: 'Analyzing text...',
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeader(),
                      const SizedBox(height: 24),
                      _buildInputSection(),
                      const SizedBox(height: 24),
                      _buildAnalyzeButton(),
                      const SizedBox(height: 24),
                      if (state is EmotionLoaded) _buildResults(state),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.textAnalysisTitle,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          AppStrings.textAnalysisDescription,
          style: Theme.of(
            context,
          ).textTheme.bodyLarge?.copyWith(color: AppColors.textSecondary),
        ),
      ],
    );
  }

  Widget _buildInputSection() {
    return ModernCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Enter Text to Analyze',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          ModernTextField(
            controller: _textController,
            hint: 'Type or paste your text here...',
            maxLines: 5,
            keyboardType: TextInputType.multiline,
          ),
        ],
      ),
    );
  }

  Widget _buildAnalyzeButton() {
    return ModernButton(
      text: 'Analyze Text',
      icon: Icons.psychology,
      isFullWidth: true,
      onPressed: _analyzeText,
    );
  }

  Widget _buildResults(EmotionLoaded state) {
    if (state.analysisResults.isEmpty) return const SizedBox();
    final latestResult = state.analysisResults.first;

    return Column(
      children: [
        GradientCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Analysis Results',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  _buildEmotionIndicator(
                    'Primary Emotion',
                    latestResult.primaryEmotion.name.toUpperCase(),
                    AppColors.accent,
                  ),
                  const SizedBox(width: 16),
                  _buildEmotionIndicator(
                    'Sentiment',
                    '${(latestResult.sentiment * 100).toStringAsFixed(1)}%',
                    AppColors.success,
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        ModernCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Emotion Breakdown',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 16),
              ...latestResult.emotionScores.entries.map(
                (entry) => Column(
                  children: [
                    _buildEmotionBar(entry.key.name.toUpperCase(), entry.value),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEmotionIndicator(String label, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 14, color: Colors.white70),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmotionBar(String emotion, double score) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          emotion,
          style: const TextStyle(fontSize: 14, color: AppColors.textSecondary),
        ),
        const SizedBox(height: 4),
        Stack(
          children: [
            Container(
              height: 8,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            FractionallySizedBox(
              widthFactor: score,
              child: Container(
                height: 8,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.primary, AppColors.secondary],
                  ),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
