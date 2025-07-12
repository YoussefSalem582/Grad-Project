import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/core.dart';
import '../../../core/di/dependency_injection.dart' as di;
import '../../cubit/text_analysis/text_analysis_cubit.dart';

/// Simple Text Analysis Screen
/// 
/// A clean, simple text analysis interface with:
/// - Text input field
/// - Analysis button
/// - Results display
/// - Simple animations
class EnhancedTextAnalysisScreen extends StatefulWidget {
  const EnhancedTextAnalysisScreen({super.key});

  @override
  State<EnhancedTextAnalysisScreen> createState() => _EnhancedTextAnalysisScreenState();
}

class _EnhancedTextAnalysisScreenState extends State<EnhancedTextAnalysisScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _textController = TextEditingController();
  final FocusNode _textFocusNode = FocusNode();
  
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _textFocusNode.addListener(_onFocusChanged);
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _animationController.forward();
  }

  void _onFocusChanged() {
    if (_textFocusNode.hasFocus) {
      HapticFeedback.lightImpact();
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    _textFocusNode.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di.sl<TextAnalysisCubit>(),
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: const Text('Text Analysis'),
          backgroundColor: Colors.transparent,
          elevation: 0,
          foregroundColor: AppColors.textPrimary,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  _buildHeader(),
                  const SizedBox(height: 24),

                  // Text Input
                  _buildTextInput(),
                  const SizedBox(height: 20),

                  // Analyze Button
                  _buildAnalyzeButton(),
                  const SizedBox(height: 24),

                  // Results
                  _buildResults(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.text_fields,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Text Emotion Analysis',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Analyze emotions in your text',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextInput() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
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
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF667EEA).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.edit_rounded,
                  color: Color(0xFF667EEA),
                  size: 18,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Enter Text to Analyze',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _textController,
            focusNode: _textFocusNode,
            maxLines: 5,
            onChanged: (_) => setState(() {}),
            decoration: InputDecoration(
              hintText: 'Type your text here... (e.g., "I am very happy today!")',
              hintStyle: TextStyle(
                color: AppColors.textSecondary.withValues(alpha: 0.6),
                fontSize: 14,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: AppColors.border.withValues(alpha: 0.3),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: AppColors.border.withValues(alpha: 0.3),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: Color(0xFF667EEA),
                  width: 2,
                ),
              ),
              filled: true,
              fillColor: AppColors.background,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnalyzeButton() {
    final canAnalyze = _textController.text.trim().isNotEmpty;
    
    return BlocBuilder<TextAnalysisCubit, TextAnalysisState>(
      builder: (context, state) {
        final isLoading = state is TextAnalysisLoading;
        
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: (canAnalyze && !isLoading) ? _analyzeText : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: canAnalyze 
                  ? const Color(0xFF667EEA) 
                  : AppColors.border.withValues(alpha: 0.3),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: canAnalyze ? 4 : 0,
              shadowColor: const Color(0xFF667EEA).withValues(alpha: 0.3),
            ),
            child: isLoading
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      strokeWidth: 2,
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.analytics_rounded, color: Colors.white),
                      const SizedBox(width: 8),
                      Text(
                        'Analyze Emotion',
                        style: TextStyle(
                          color: canAnalyze ? Colors.white : AppColors.textSecondary,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
          ),
        );
      },
    );
  }

  Widget _buildResults() {
    return BlocBuilder<TextAnalysisCubit, TextAnalysisState>(
      builder: (context, state) {
        if (state is TextAnalysisSuccess) {
          return _buildSuccessResults(state.result);
        } else if (state is TextAnalysisError) {
          return _buildErrorResults(state.message);
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildSuccessResults(TextAnalysisResult result) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
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
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.check_circle_rounded,
                  color: Colors.green,
                  size: 18,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Analysis Results',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildResultItem('Emotion', result.metrics['emotion']?.toString() ?? 'Unknown'),
          _buildResultItem('Sentiment', result.metrics['sentiment']?.toString() ?? 'Unknown'),
          _buildResultItem('Confidence', '${(result.confidence * 100).toStringAsFixed(1)}%'),
          if (result.metrics['processing_time'] != null)
            _buildResultItem('Processing Time', '${result.metrics['processing_time'].toStringAsFixed(1)}ms'),
        ],
      ),
    );
  }

  Widget _buildResultItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorResults(String error) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.red.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_rounded, color: Colors.red),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              error,
              style: const TextStyle(
                color: Colors.red,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _analyzeText() {
    final text = _textController.text.trim();
    if (text.isNotEmpty) {
      context.read<TextAnalysisCubit>().analyzeText(
        text: text,
        analysisType: 'emotion',
      );
      HapticFeedback.mediumImpact();
    }
  }
}
