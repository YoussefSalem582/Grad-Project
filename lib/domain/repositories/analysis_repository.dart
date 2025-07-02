import '../entities/analysis_result.dart';

/// Repository interface for analysis operations
abstract class AnalysisRepository {
  /// Analyze text content
  Future<AnalysisResult> analyzeText(String content);

  /// Analyze voice content
  Future<AnalysisResult> analyzeVoice(String audioPath);

  /// Analyze social media content
  Future<AnalysisResult> analyzeSocial(String url);

  /// Get analysis history
  Future<List<AnalysisResult>> getAnalysisHistory({
    AnalysisType? type,
    int? limit,
  });

  /// Save analysis result
  Future<void> saveAnalysis(AnalysisResult result);

  /// Delete analysis
  Future<void> deleteAnalysis(String id);

  /// Get analysis by ID
  Future<AnalysisResult?> getAnalysisById(String id);
}
