import 'package:flutter/foundation.dart';
import '../../domain/entities/analysis_result.dart';
import '../../domain/usecases/analyze_text_usecase.dart';
import '../../domain/usecases/analyze_voice_usecase.dart';
import '../../domain/usecases/analyze_social_usecase.dart';
import '../../domain/usecases/get_analysis_history_usecase.dart';
import '../../core/usecases/usecase.dart';

/// State management for analysis operations
class AnalysisProvider extends ChangeNotifier {
  final AnalyzeTextUseCase analyzeTextUseCase;
  final AnalyzeVoiceUseCase analyzeVoiceUseCase;
  final AnalyzeSocialUseCase analyzeSocialUseCase;
  final GetAnalysisHistoryUseCase getAnalysisHistoryUseCase;

  AnalysisProvider({
    required this.analyzeTextUseCase,
    required this.analyzeVoiceUseCase,
    required this.analyzeSocialUseCase,
    required this.getAnalysisHistoryUseCase,
  });

  // State variables
  bool _isLoading = false;
  String? _errorMessage;
  AnalysisResult? _currentResult;
  List<AnalysisResult> _analysisHistory = [];

  // Getters
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  AnalysisResult? get currentResult => _currentResult;
  List<AnalysisResult> get analysisHistory => _analysisHistory;

  /// Analyze text content
  Future<void> analyzeText(String content) async {
    _setLoading(true);
    _clearError();

    final result = await analyzeTextUseCase.call(
      AnalyzeTextParams(content: content),
    );

    result.fold(
      (failure) => _setError(failure.message),
      (analysisResult) => _setCurrentResult(analysisResult),
    );

    _setLoading(false);
  }

  /// Analyze voice content
  Future<void> analyzeVoice(String audioPath) async {
    _setLoading(true);
    _clearError();

    final result = await analyzeVoiceUseCase.call(
      AnalyzeVoiceParams(audioPath: audioPath),
    );

    result.fold(
      (failure) => _setError(failure.message),
      (analysisResult) => _setCurrentResult(analysisResult),
    );

    _setLoading(false);
  }

  /// Analyze social media content
  Future<void> analyzeSocial(String url) async {
    _setLoading(true);
    _clearError();

    final result = await analyzeSocialUseCase.call(
      AnalyzeSocialParams(url: url),
    );

    result.fold(
      (failure) => _setError(failure.message),
      (analysisResult) => _setCurrentResult(analysisResult),
    );

    _setLoading(false);
  }

  /// Get analysis history
  Future<void> getHistory({AnalysisType? type, int? limit}) async {
    _setLoading(true);
    _clearError();

    final result = await getAnalysisHistoryUseCase.call(
      GetAnalysisHistoryParams(type: type, limit: limit),
    );

    result.fold(
      (failure) => _setError(failure.message),
      (history) => _setAnalysisHistory(history),
    );

    _setLoading(false);
  }

  /// Clear current result
  void clearResult() {
    _currentResult = null;
    notifyListeners();
  }

  /// Clear error message
  void clearError() {
    _clearError();
  }

  // Private methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _errorMessage = error;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void _setCurrentResult(AnalysisResult result) {
    _currentResult = result;
    // Add to history
    _analysisHistory.insert(0, result);
    notifyListeners();
  }

  void _setAnalysisHistory(List<AnalysisResult> history) {
    _analysisHistory = history;
    notifyListeners();
  }
}
