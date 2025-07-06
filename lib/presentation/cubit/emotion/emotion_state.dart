part of 'emotion_cubit.dart';

abstract class EmotionState extends Equatable {
  const EmotionState();

  @override
  List<Object?> get props => [];
}

class EmotionInitial extends EmotionState {
  const EmotionInitial();
}

class EmotionLoading extends EmotionState {
  const EmotionLoading();
}

class EmotionConnectionChecking extends EmotionState {
  const EmotionConnectionChecking();
}

class EmotionConnectionResult extends EmotionState {
  final bool isConnected;
  final Map<String, dynamic>? connectionDetails;
  final Map<String, bool> endpointStatus;

  const EmotionConnectionResult({
    required this.isConnected,
    this.connectionDetails,
    this.endpointStatus = const {},
  });

  @override
  List<Object?> get props => [isConnected, connectionDetails, endpointStatus];
}

class EmotionSuccess extends EmotionState {
  final EmotionResult emotionResult;
  final SystemMetrics? systemMetrics;
  final AnalyticsSummary? analyticsSummary;
  final DemoResult? demoResult;
  final Map<String, dynamic>? cacheStats;
  final Map<String, dynamic>? modelInfo;

  const EmotionSuccess(
    this.emotionResult, {
    this.systemMetrics,
    this.analyticsSummary,
    this.demoResult,
    this.cacheStats,
    this.modelInfo,
  });

  @override
  List<Object?> get props => [
    emotionResult,
    systemMetrics,
    analyticsSummary,
    demoResult,
    cacheStats,
    modelInfo,
  ];

  EmotionSuccess copyWith({
    EmotionResult? emotionResult,
    SystemMetrics? systemMetrics,
    AnalyticsSummary? analyticsSummary,
    DemoResult? demoResult,
    Map<String, dynamic>? cacheStats,
    Map<String, dynamic>? modelInfo,
  }) {
    return EmotionSuccess(
      emotionResult ?? this.emotionResult,
      systemMetrics: systemMetrics ?? this.systemMetrics,
      analyticsSummary: analyticsSummary ?? this.analyticsSummary,
      demoResult: demoResult ?? this.demoResult,
      cacheStats: cacheStats ?? this.cacheStats,
      modelInfo: modelInfo ?? this.modelInfo,
    );
  }
}

class EmotionDemo extends EmotionState {
  final DemoResult demoResult;

  const EmotionDemo(this.demoResult);

  @override
  List<Object?> get props => [demoResult];
}

class EmotionError extends EmotionState {
  final String message;

  const EmotionError(this.message);

  @override
  List<Object?> get props => [message];
}
