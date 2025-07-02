import '../models/analysis_result_model.dart';
import '../../domain/entities/analysis_result.dart';

/// Local data source for analysis caching
abstract class AnalysisLocalDataSource {
  Future<void> cacheAnalysis(AnalysisResultModel analysis);
  Future<List<AnalysisResultModel>> getAnalysisHistory({
    AnalysisType? type,
    int? limit,
  });
  Future<void> deleteAnalysis(String id);
  Future<AnalysisResultModel?> getAnalysisById(String id);
  Future<void> clearCache();
}

/// Implementation of local data source
class AnalysisLocalDataSourceImpl implements AnalysisLocalDataSource {
  // Simulate local storage with in-memory cache
  static final List<AnalysisResultModel> _cache = [];

  @override
  Future<void> cacheAnalysis(AnalysisResultModel analysis) async {
    // Remove existing analysis with same ID if exists
    _cache.removeWhere((item) => item.id == analysis.id);
    _cache.insert(0, analysis); // Insert at beginning for recency

    // Keep only latest 100 items
    if (_cache.length > 100) {
      _cache.removeRange(100, _cache.length);
    }
  }

  @override
  Future<List<AnalysisResultModel>> getAnalysisHistory({
    AnalysisType? type,
    int? limit,
  }) async {
    var results = _cache;

    // Filter by type if specified
    if (type != null) {
      final typeString = _analysisTypeToString(type);
      results = results.where((item) => item.type == typeString).toList();
    }

    // Apply limit if specified
    if (limit != null && limit > 0) {
      results = results.take(limit).toList();
    }

    return results;
  }

  @override
  Future<void> deleteAnalysis(String id) async {
    _cache.removeWhere((item) => item.id == id);
  }

  @override
  Future<AnalysisResultModel?> getAnalysisById(String id) async {
    try {
      return _cache.firstWhere((item) => item.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> clearCache() async {
    _cache.clear();
  }

  String _analysisTypeToString(AnalysisType type) {
    switch (type) {
      case AnalysisType.text:
        return 'text';
      case AnalysisType.voice:
        return 'voice';
      case AnalysisType.social:
        return 'social';
    }
  }
}
