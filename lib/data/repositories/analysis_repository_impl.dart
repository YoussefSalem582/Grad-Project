import 'package:dartz/dartz.dart' as dartz;
import '../../domain/entities/analysis_result.dart';
import '../../domain/repositories/analysis_repository.dart';
import '../../core/network/network_info.dart';
import '../../core/errors/failures.dart';
import '../datasources/analysis_remote_datasource.dart';
import '../datasources/analysis_local_datasource.dart';
import '../models/analysis_result_model.dart';

/// Implementation of AnalysisRepository
class AnalysisRepositoryImpl implements AnalysisRepository {
  final AnalysisRemoteDataSource remoteDataSource;
  final AnalysisLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  AnalysisRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<dartz.Either<Failure, AnalysisResult>> analyzeText(String text) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.analyzeText(text);
        await localDataSource.cacheAnalysis(result);
        return dartz.Right(result.toEntity());
      } catch (e) {
        return dartz.Left(
          ServerFailure('Failed to analyze text: ${e.toString()}'),
        );
      }
    } else {
      return dartz.Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<dartz.Either<Failure, AnalysisResult>> analyzeVoice(
    String audioPath,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.analyzeVoice(audioPath);
        await localDataSource.cacheAnalysis(result);
        return dartz.Right(result.toEntity());
      } catch (e) {
        return dartz.Left(
          ServerFailure('Failed to analyze voice: ${e.toString()}'),
        );
      }
    } else {
      return dartz.Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<dartz.Either<Failure, AnalysisResult>> analyzeSocial(
    String socialMediaUrl,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.analyzeSocial(socialMediaUrl);
        await localDataSource.cacheAnalysis(result);
        return dartz.Right(result.toEntity());
      } catch (e) {
        return dartz.Left(
          ServerFailure('Failed to analyze social media: ${e.toString()}'),
        );
      }
    } else {
      return dartz.Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<dartz.Either<Failure, List<AnalysisResult>>>
  getAnalysisHistory() async {
    try {
      final results = await localDataSource.getAnalysisHistory();
      return dartz.Right(results.map((model) => model.toEntity()).toList());
    } catch (e) {
      return dartz.Left(
        CacheFailure('Failed to get analysis history: ${e.toString()}'),
      );
    }
  }

  @override
  Future<dartz.Either<Failure, void>> saveAnalysis(
    AnalysisResult result,
  ) async {
    try {
      final model = AnalysisResultModel.fromEntity(result);
      await localDataSource.cacheAnalysis(model);
      return const dartz.Right(null);
    } catch (e) {
      return dartz.Left(
        CacheFailure('Failed to save analysis: ${e.toString()}'),
      );
    }
  }

  @override
  Future<void> deleteAnalysis(String id) async {
    try {
      await localDataSource.deleteAnalysis(id);

      if (await networkInfo.isConnected) {
        await remoteDataSource.deleteAnalysis(id);
      }
    } catch (e) {
      throw ServerFailure('Failed to delete analysis: ${e.toString()}');
    }
  }

  @override
  Future<AnalysisResult?> getAnalysisById(String id) async {
    try {
      // Try cache first
      final cached = await localDataSource.getAnalysisById(id);
      if (cached != null) {
        return cached.toEntity();
      }

      // Try remote if we have internet
      if (await networkInfo.isConnected) {
        final remote = await remoteDataSource.getAnalysisById(id);
        if (remote != null) {
          await localDataSource.cacheAnalysis(remote);
          return remote.toEntity();
        }
      }

      return null;
    } catch (e) {
      throw ServerFailure('Failed to get analysis: ${e.toString()}');
    }
  }
}
