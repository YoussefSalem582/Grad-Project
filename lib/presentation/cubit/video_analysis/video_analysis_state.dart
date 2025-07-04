part of 'video_analysis_cubit.dart';

abstract class VideoAnalysisState extends Equatable {
  const VideoAnalysisState();

  @override
  List<Object?> get props => [];
}

class VideoAnalysisInitial extends VideoAnalysisState {
  const VideoAnalysisInitial();
}

class VideoAnalysisLoading extends VideoAnalysisState {
  const VideoAnalysisLoading();
}

class VideoAnalysisSuccess extends VideoAnalysisState {
  final VideoAnalysisResponse result;

  const VideoAnalysisSuccess(this.result);

  @override
  List<Object?> get props => [result];
}

class VideoAnalysisError extends VideoAnalysisState {
  final String message;

  const VideoAnalysisError(this.message);

  @override
  List<Object?> get props => [message];
}

class VideoAnalysisDemo extends VideoAnalysisState {
  final VideoAnalysisResponse demoResult;

  const VideoAnalysisDemo(this.demoResult);

  @override
  List<Object?> get props => [demoResult];
}
