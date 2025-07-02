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
  Future<AnalysisResult> analyzeText(String content) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.analyzeText(content);
        await localDataSource.cacheAnalysis(result);
        return result.toEntity();
      } catch (e) {
        throw ServerFailure('Failed to analyze text: ${e.toString()}');
      }
    } else {
      throw NetworkFailure('No internet connection');
    }
  }

  @override
  Future<AnalysisResult> analyzeVoice(String audioPath) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.analyzeVoice(audioPath);
        await localDataSource.cacheAnalysis(result);
        return result.toEntity();
      } catch (e) {
        throw ServerFailure('Failed to analyze voice: ${e.toString()}');
      }
    } else {
      throw NetworkFailure('No internet connection');
    }
  }

  @override
  Future<AnalysisResult> analyzeSocial(String url) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.analyzeSocial(url);
        await localDataSource.cacheAnalysis(result);
        return result.toEntity();
      } catch (e) {
        throw ServerFailure('Failed to analyze social media: ${e.toString()}');
      }
    } else {
      throw NetworkFailure('No internet connection');
    }
  }

  @override
  Future<List<AnalysisResult>> getAnalysisHistory({
    AnalysisType? type,
    int? limit,
  }) async {
    try {
      // Try to get from cache first
      final cachedResults = await localDataSource.getAnalysisHistory(
        type: type,
        limit: limit,
      );

      if (cachedResults.isNotEmpty) {
        return cachedResults.map((model) => model.toEntity()).toList();
      }

      // If cache is empty and we have internet, fetch from remote
      if (await networkInfo.isConnected) {
        final remoteResults = await remoteDataSource.getAnalysisHistory(
          type: type,
          limit: limit,
        );

        // Cache the results
        for (final result in remoteResults) {
          await localDataSource.cacheAnalysis(result);
        }

        return remoteResults.map((model) => model.toEntity()).toList();
      }

      return [];
    } catch (e) {
      throw ServerFailure('Failed to get analysis history: ${e.toString()}');
    }
  }

  @override
  Future<void> saveAnalysis(AnalysisResult result) async {
    try {
      final model = AnalysisResultModel.fromEntity(result);
      await localDataSource.cacheAnalysis(model);
    } catch (e) {
      throw CacheFailure('Failed to save analysis: ${e.toString()}');
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
