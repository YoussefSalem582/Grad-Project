part of 'analysis_cubit.dart';

abstract class AnalysisState extends Equatable {
  const AnalysisState();

  @override
  List<Object?> get props => [];
}

class AnalysisInitial extends AnalysisState {
  const AnalysisInitial();
}

class AnalysisLoading extends AnalysisState {
  const AnalysisLoading();
}

class AnalysisSuccess extends AnalysisState {
  final Map<String, dynamic>? currentResult;
  final List<Map<String, dynamic>> analysisHistory;

  const AnalysisSuccess(this.currentResult, this.analysisHistory);

  @override
  List<Object?> get props => [currentResult, analysisHistory];
}

class AnalysisError extends AnalysisState {
  final String message;

  const AnalysisError(this.message);

  @override
  List<Object?> get props => [message];
}
