import 'package:dartz/dartz.dart' as dartz;
import 'package:equatable/equatable.dart';
import '../../core/errors/failures.dart';
import '../../core/usecases/usecase.dart';
import '../entities/analysis_result.dart';
import '../repositories/analysis_repository.dart';

/// Use case for social media analysis
class AnalyzeSocialUseCase
    implements UseCase<AnalysisResult, AnalyzeSocialParams> {
  final AnalysisRepository repository;

  AnalyzeSocialUseCase(this.repository);

  @override
  Future<dartz.Either<Failure, AnalysisResult>> call(
    AnalyzeSocialParams params,
  ) async {
    return await repository.analyzeSocial(params.socialMediaUrl);
  }
}

class AnalyzeSocialParams extends Equatable {
  final String socialMediaUrl;

  const AnalyzeSocialParams(this.socialMediaUrl);

  @override
  List<Object?> get props => [socialMediaUrl];
}
