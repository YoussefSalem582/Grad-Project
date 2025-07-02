import '../entities/analysis_result.dart';
import '../repositories/analysis_repository.dart';
import '../../core/errors/failures.dart';
import '../../core/usecases/usecase.dart';

/// Use case for voice analysis
class AnalyzeVoiceUseCase
    implements UseCase<AnalysisResult, AnalyzeVoiceParams> {
  final AnalysisRepository repository;

  AnalyzeVoiceUseCase(this.repository);

  @override
  Future<Either<Failure, AnalysisResult>> call(
    AnalyzeVoiceParams params,
  ) async {
    try {
      if (params.audioPath.isEmpty) {
        return Left(ValidationFailure('Audio path cannot be empty'));
      }

      final result = await repository.analyzeVoice(params.audioPath);
      await repository.saveAnalysis(result);

      return Right(result);
    } catch (e) {
      return Left(ServerFailure('Failed to analyze voice: ${e.toString()}'));
    }
  }
}

class AnalyzeVoiceParams {
  final String audioPath;

  AnalyzeVoiceParams({required this.audioPath});
}
