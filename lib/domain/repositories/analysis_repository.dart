import 'package:dartz/dartz.dart' as dartz;
import '../../core/errors/failures.dart';
import '../entities/analysis_result.dart';

/// Repository interface for analysis operations
abstract class AnalysisRepository {
  /// Analyze text content
  Future<dartz.Either<Failure, AnalysisResult>> analyzeText(String text);

  /// Analyze voice content
  Future<dartz.Either<Failure, AnalysisResult>> analyzeVoice(String audioPath);

  /// Analyze social media content
  Future<dartz.Either<Failure, AnalysisResult>> analyzeSocial(
    String socialMediaUrl,
  );

  /// Get analysis history
  Future<dartz.Either<Failure, List<AnalysisResult>>> getAnalysisHistory();

  /// Save analysis result
  Future<dartz.Either<Failure, void>> saveAnalysis(AnalysisResult result);

  /// Delete analysis
  Future<void> deleteAnalysis(String id);

  /// Get analysis by ID
  Future<AnalysisResult?> getAnalysisById(String id);
}
