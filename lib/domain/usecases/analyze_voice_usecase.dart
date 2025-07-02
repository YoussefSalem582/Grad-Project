import 'package:dartz/dartz.dart' as dartz;
import 'package:equatable/equatable.dart';
import '../../core/errors/failures.dart';
import '../../core/usecases/usecase.dart';
import '../entities/analysis_result.dart';
import '../repositories/analysis_repository.dart';

/// Use case for voice analysis
class AnalyzeVoiceUseCase
    implements UseCase<AnalysisResult, AnalyzeVoiceParams> {
  final AnalysisRepository repository;

  AnalyzeVoiceUseCase(this.repository);

  @override
  Future<dartz.Either<Failure, AnalysisResult>> call(
    AnalyzeVoiceParams params,
  ) async {
    return await repository.analyzeVoice(params.audioPath);
  }
}

class AnalyzeVoiceParams extends Equatable {
  final String audioPath;

  const AnalyzeVoiceParams(this.audioPath);

  @override
  List<Object?> get props => [audioPath];
}
