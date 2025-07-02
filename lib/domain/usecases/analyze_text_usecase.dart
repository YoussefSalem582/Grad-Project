import 'package:dartz/dartz.dart' as dartz;
import 'package:equatable/equatable.dart';
import '../../core/errors/failures.dart';
import '../../core/usecases/usecase.dart';
import '../entities/analysis_result.dart';
import '../repositories/analysis_repository.dart';

/// Use case for text analysis
class AnalyzeTextUseCase implements UseCase<AnalysisResult, AnalyzeTextParams> {
  final AnalysisRepository repository;

  AnalyzeTextUseCase(this.repository);

  @override
  Future<dartz.Either<Failure, AnalysisResult>> call(
    AnalyzeTextParams params,
  ) async {
    return await repository.analyzeText(params.text);
  }
}

class AnalyzeTextParams extends Equatable {
  final String text;

  const AnalyzeTextParams(this.text);

  @override
  List<Object?> get props => [text];
}
