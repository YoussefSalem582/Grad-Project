import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
part 'text_analysis_state.dart';

class TextAnalysisCubit extends Cubit<TextAnalysisState> {
  TextAnalysisCubit() : super(const TextAnalysisInitial());

  /// Analyze text input
  Future<void> analyzeText({
    required String text,
    required String analysisType,
  }) async {
    if (text.trim().isEmpty) {
      emit(const TextAnalysisError('Text cannot be empty'));
      return;
    }

    if (text.trim().length < 5) {
      emit(const TextAnalysisError('Text must be at least 5 characters long'));
      return;
    }

    emit(const TextAnalysisLoading());

    try {
      // Simulate analysis process
      await Future.delayed(const Duration(seconds: 2));

      final result = _createAnalysisResult(text, analysisType);
      emit(TextAnalysisSuccess(result));
    } catch (e) {
      emit(TextAnalysisError('Analysis failed: ${e.toString()}'));
    }
  }

  /// Load demo data for testing
  void loadDemoData(String analysisType) {
    emit(TextAnalysisDemo(_createDemoResult(analysisType)));
  }

  /// Reset to initial state
  void reset() {
    emit(const TextAnalysisInitial());
  }

  /// Clear current analysis
  void clearAnalysis() {
    emit(const TextAnalysisInitial());
  }

  /// Create analysis result based on type
  TextAnalysisResult _createAnalysisResult(String text, String analysisType) {
    final now = DateTime.now();

    return TextAnalysisResult(
      id: now.millisecondsSinceEpoch.toString(),
      text: text,
      analysisType: analysisType,
      confidence: _generateConfidence(analysisType),
      timestamp: now,
      summary: _generateSummary(analysisType, text),
      details: _generateAnalysisDetails(analysisType, text),
      sentiments: _generateSentimentData(analysisType, text),
      keywords: _extractKeywords(text),
      metrics: _generateMetrics(text),
    );
  }

  /// Create demo result for testing
  TextAnalysisResult _createDemoResult(String analysisType) {
    final now = DateTime.now();
    const demoText =
        "This is a great product! I'm really happy with my purchase and would definitely recommend it to others.";

    return TextAnalysisResult(
      id: 'demo_${now.millisecondsSinceEpoch}',
      text: demoText,
      analysisType: analysisType,
      confidence: 0.91,
      timestamp: now,
      summary: 'Demo analysis completed successfully for $analysisType',
      details: _generateAnalysisDetails(analysisType, demoText),
      sentiments: _generateSentimentData(analysisType, demoText),
      keywords: _extractKeywords(demoText),
      metrics: _generateMetrics(demoText),
    );
  }

  double _generateConfidence(String analysisType) {
    switch (analysisType) {
      case 'Sentiment Analysis':
        return 0.91;
      case 'Emotion Detection':
        return 0.88;
      case 'Topic Classification':
        return 0.93;
      case 'Intent Recognition':
        return 0.86;
      case 'Language Detection':
        return 0.95;
      default:
        return 0.89;
    }
  }

  String _generateSummary(String analysisType, String text) {
    switch (analysisType) {
      case 'Sentiment Analysis':
        return text.length > 100
            ? 'Positive sentiment detected with high confidence'
            : 'Brief positive text analyzed successfully';
      case 'Emotion Detection':
        return 'Primary emotions: Joy and satisfaction identified';
      case 'Topic Classification':
        return 'Category: Product Review - Customer Feedback';
      case 'Intent Recognition':
        return 'Intent: Product Recommendation and Positive Review';
      case 'Language Detection':
        return 'Language: English (US) - Confidence: 95%';
      default:
        return 'Text analysis completed successfully';
    }
  }

  List<String> _generateAnalysisDetails(String analysisType, String text) {
    switch (analysisType) {
      case 'Sentiment Analysis':
        return [
          'Overall sentiment: Positive (89%)',
          'Positive indicators: ${text.contains('great') || text.contains('good') ? 'Strong' : 'Moderate'}',
          'Negative indicators: Minimal (3%)',
          'Neutral content: 8%',
        ];
      case 'Emotion Detection':
        return [
          'Primary emotion: Joy (72%)',
          'Secondary emotion: Satisfaction (18%)',
          'Confidence level: High',
          'Emotional intensity: Moderate to High',
        ];
      case 'Topic Classification':
        return [
          'Main topic: Product/Service Review',
          'Sub-category: Customer Experience',
          'Domain: E-commerce/Retail',
          'Relevance score: 94%',
        ];
      case 'Intent Recognition':
        return [
          'Primary intent: Recommendation (85%)',
          'Secondary intent: Review sharing (12%)',
          'Action likelihood: High',
          'User engagement level: Positive',
        ];
      case 'Language Detection':
        return [
          'Detected language: English',
          'Regional variant: US English',
          'Confidence: 95%',
          'Character encoding: UTF-8',
        ];
      default:
        return [
          'Analysis completed successfully',
          'Results are ready for review',
        ];
    }
  }

  Map<String, double> _generateSentimentData(String analysisType, String text) {
    if (analysisType == 'Sentiment Analysis') {
      final hasPositive = text.toLowerCase().contains(
        RegExp(
          r'good|great|excellent|amazing|wonderful|perfect|love|like|recommend',
        ),
      );
      final hasNegative = text.toLowerCase().contains(
        RegExp(r'bad|terrible|awful|hate|dislike|worst|horrible'),
      );

      if (hasPositive && !hasNegative) {
        return {'Positive': 0.89, 'Neutral': 0.08, 'Negative': 0.03};
      } else if (hasNegative && !hasPositive) {
        return {'Negative': 0.82, 'Neutral': 0.12, 'Positive': 0.06};
      } else {
        return {'Neutral': 0.65, 'Positive': 0.25, 'Negative': 0.10};
      }
    } else if (analysisType == 'Emotion Detection') {
      return {
        'Joy': 0.72,
        'Satisfaction': 0.18,
        'Excitement': 0.06,
        'Neutral': 0.04,
      };
    }

    return {'Positive': 0.75, 'Neutral': 0.20, 'Negative': 0.05};
  }

  List<String> _extractKeywords(String text) {
    final words = text
        .toLowerCase()
        .replaceAll(RegExp(r'[^\w\s]'), '')
        .split(' ')
        .where((word) => word.length > 3)
        .toSet()
        .toList();

    // Filter out common stop words
    const stopWords = {
      'this',
      'that',
      'with',
      'have',
      'will',
      'from',
      'they',
      'know',
      'want',
      'been',
      'good',
      'much',
      'some',
      'time',
      'very',
      'when',
      'come',
      'here',
      'just',
      'like',
      'long',
      'make',
      'many',
      'over',
      'such',
      'take',
      'than',
      'them',
      'well',
      'were',
    };

    return words.where((word) => !stopWords.contains(word)).take(10).toList();
  }

  Map<String, dynamic> _generateMetrics(String text) {
    final words = text.split(' ').length;
    final characters = text.length;
    final sentences = text
        .split(RegExp(r'[.!?]'))
        .where((s) => s.trim().isNotEmpty)
        .length;

    return {
      'wordCount': words,
      'characterCount': characters,
      'sentenceCount': sentences,
      'averageWordsPerSentence': sentences > 0
          ? (words / sentences).toStringAsFixed(1)
          : '0',
      'readabilityScore': _calculateReadabilityScore(
        words,
        sentences,
        characters,
      ),
      'complexity': words > 50
          ? 'Complex'
          : words > 20
          ? 'Moderate'
          : 'Simple',
    };
  }

  double _calculateReadabilityScore(int words, int sentences, int characters) {
    if (sentences == 0 || words == 0) return 0.0;

    final avgWordsPerSentence = words / sentences;
    final avgSyllablesPerWord = characters / words / 2; // Rough estimate

    // Simplified Flesch Reading Ease Score
    final score =
        206.835 - (1.015 * avgWordsPerSentence) - (84.6 * avgSyllablesPerWord);
    return (score / 100).clamp(0.0, 1.0);
  }
}
