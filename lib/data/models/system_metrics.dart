import 'package:equatable/equatable.dart';

class SystemMetrics extends Equatable {
  final double cpuUsage;
  final double memoryUsage;
  final double diskUsage;
  final int totalRequests;
  final int successfulRequests;
  final int failedRequests;
  final double averageResponseTime;
  final String uptime;
  final CacheMetrics cacheMetrics;
  final String timestamp;
  final Map<String, dynamic>? additionalMetrics;

  const SystemMetrics({
    required this.cpuUsage,
    required this.memoryUsage,
    required this.diskUsage,
    required this.totalRequests,
    required this.successfulRequests,
    required this.failedRequests,
    required this.averageResponseTime,
    required this.uptime,
    required this.cacheMetrics,
    required this.timestamp,
    this.additionalMetrics,
  });

  factory SystemMetrics.fromJson(Map<String, dynamic> json) {
    return SystemMetrics(
      cpuUsage: (json['cpu_usage'] as num?)?.toDouble() ?? 0.0,
      memoryUsage: (json['memory_usage'] as num?)?.toDouble() ?? 0.0,
      diskUsage: (json['disk_usage'] as num?)?.toDouble() ?? 0.0,
      totalRequests: json['total_requests'] as int? ?? 0,
      successfulRequests: json['successful_requests'] as int? ?? 0,
      failedRequests: json['failed_requests'] as int? ?? 0,
      averageResponseTime:
          (json['average_response_time'] as num?)?.toDouble() ?? 0.0,
      uptime: json['uptime'] as String? ?? 'Unknown',
      cacheMetrics: CacheMetrics.fromJson(
        json['cache_metrics'] as Map<String, dynamic>? ?? {},
      ),
      timestamp:
          json['timestamp'] as String? ?? DateTime.now().toIso8601String(),
      additionalMetrics: json['additional_metrics'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cpu_usage': cpuUsage,
      'memory_usage': memoryUsage,
      'disk_usage': diskUsage,
      'total_requests': totalRequests,
      'successful_requests': successfulRequests,
      'failed_requests': failedRequests,
      'average_response_time': averageResponseTime,
      'uptime': uptime,
      'cache_metrics': cacheMetrics.toJson(),
      'timestamp': timestamp,
      if (additionalMetrics != null) 'additional_metrics': additionalMetrics,
    };
  }

  double get successRate {
    if (totalRequests == 0) return 0.0;
    return (successfulRequests / totalRequests) * 100;
  }

  String get memoryUsageFormatted {
    return '${memoryUsage.toStringAsFixed(1)}%';
  }

  String get cpuUsageFormatted {
    return '${cpuUsage.toStringAsFixed(1)}%';
  }

  String get averageResponseTimeFormatted {
    return '${averageResponseTime.toStringAsFixed(0)}ms';
  }

  @override
  List<Object?> get props => [
    cpuUsage,
    memoryUsage,
    diskUsage,
    totalRequests,
    successfulRequests,
    failedRequests,
    averageResponseTime,
    uptime,
    cacheMetrics,
    timestamp,
    additionalMetrics,
  ];
}

class CacheMetrics extends Equatable {
  final int hits;
  final int misses;
  final int size;
  final double hitRate;

  const CacheMetrics({
    required this.hits,
    required this.misses,
    required this.size,
    required this.hitRate,
  });

  factory CacheMetrics.fromJson(Map<String, dynamic> json) {
    return CacheMetrics(
      hits: json['hits'] as int? ?? 0,
      misses: json['misses'] as int? ?? 0,
      size: json['size'] as int? ?? 0,
      hitRate: (json['hit_rate'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {'hits': hits, 'misses': misses, 'size': size, 'hit_rate': hitRate};
  }

  String get hitRateFormatted {
    return '${(hitRate * 100).toStringAsFixed(1)}%';
  }

  @override
  List<Object?> get props => [hits, misses, size, hitRate];
}
