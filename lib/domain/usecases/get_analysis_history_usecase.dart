import '../entities/analysis_result.dart';
import '../repositories/analysis_repository.dart';
import '../../core/errors/failures.dart';
import '../../core/usecases/usecase.dart';

/// Use case for getting analysis history
class GetAnalysisHistoryUseCase
    implements UseCase<List<AnalysisResult>, GetAnalysisHistoryParams> {
  final AnalysisRepository repository;

  GetAnalysisHistoryUseCase(this.repository);

  @override
  Future<Either<Failure, List<AnalysisResult>>> call(
    GetAnalysisHistoryParams params,
  ) async {
    try {
      final results = await repository.getAnalysisHistory(
        type: params.type,
        limit: params.limit,
      );

      return Right(results);
    } catch (e) {
      return Left(
        ServerFailure('Failed to get analysis history: ${e.toString()}'),
      );
    }
  }
}

class GetAnalysisHistoryParams {
  final AnalysisType? type;
  final int? limit;

  GetAnalysisHistoryParams({this.type, this.limit});
}
