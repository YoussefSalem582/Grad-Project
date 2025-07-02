import '../entities/analysis_result.dart';
import '../repositories/analysis_repository.dart';
import '../../core/errors/failures.dart';
import '../../core/usecases/usecase.dart';

/// Use case for social media analysis
class AnalyzeSocialUseCase
    implements UseCase<AnalysisResult, AnalyzeSocialParams> {
  final AnalysisRepository repository;

  AnalyzeSocialUseCase(this.repository);

  @override
  Future<Either<Failure, AnalysisResult>> call(
    AnalyzeSocialParams params,
  ) async {
    try {
      if (params.url.trim().isEmpty) {
        return Left(ValidationFailure('URL cannot be empty'));
      }

      if (!_isValidUrl(params.url)) {
        return Left(ValidationFailure('Invalid URL format'));
      }

      final result = await repository.analyzeSocial(params.url);
      await repository.saveAnalysis(result);

      return Right(result);
    } catch (e) {
      return Left(
        ServerFailure('Failed to analyze social media: ${e.toString()}'),
      );
    }
  }

  bool _isValidUrl(String url) {
    try {
      final uri = Uri.parse(url);
      return uri.hasScheme && (uri.scheme == 'http' || uri.scheme == 'https');
    } catch (e) {
      return false;
    }
  }
}

class AnalyzeSocialParams {
  final String url;

  AnalyzeSocialParams({required this.url});
}
