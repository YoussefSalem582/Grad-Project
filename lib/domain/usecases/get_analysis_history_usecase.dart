import 'package:dartz/dartz.dart' as dartz;
import '../../core/errors/failures.dart';
import '../../core/usecases/usecase.dart';
import '../entities/analysis_result.dart';
import '../repositories/analysis_repository.dart';

/// Use case for getting analysis history
class GetAnalysisHistoryUseCase
    implements NoParamsUseCase<List<AnalysisResult>> {
  final AnalysisRepository repository;

  GetAnalysisHistoryUseCase(this.repository);

  @override
  Future<dartz.Either<Failure, List<AnalysisResult>>> call() async {
    return await repository.getAnalysisHistory();
  }
}

class GetAnalysisHistoryParams {
  final AnalysisType? type;
  final int? limit;

  GetAnalysisHistoryParams({this.type, this.limit});
}
