part of 'employee_performance_cubit.dart';

abstract class EmployeePerformanceState extends Equatable {
  const EmployeePerformanceState();

  @override
  List<Object?> get props => [];
}

class EmployeePerformanceInitial extends EmployeePerformanceState {
  const EmployeePerformanceInitial();
}

class EmployeePerformanceLoading extends EmployeePerformanceState {
  const EmployeePerformanceLoading();
}

class EmployeePerformanceSuccess extends EmployeePerformanceState {
  final EmployeePerformanceData data;

  const EmployeePerformanceSuccess(this.data);

  @override
  List<Object?> get props => [data];
}

class EmployeePerformanceError extends EmployeePerformanceState {
  final String message;

  const EmployeePerformanceError(this.message);

  @override
  List<Object?> get props => [message];
}

class EmployeePerformanceData extends Equatable {
  final int overallScore;
  final int ranking;
  final int totalEmployees;
  final double monthlyProgress;
  final List<Map<String, dynamic>> keyMetrics;
  final Map<String, dynamic> performanceBreakdown;
  final List<Map<String, dynamic>> achievements;
  final List<Map<String, dynamic>> weeklyTrends;
  final List<Map<String, dynamic>> goals;

  const EmployeePerformanceData({
    required this.overallScore,
    required this.ranking,
    required this.totalEmployees,
    required this.monthlyProgress,
    required this.keyMetrics,
    required this.performanceBreakdown,
    required this.achievements,
    required this.weeklyTrends,
    required this.goals,
  });

  @override
  List<Object?> get props => [
    overallScore,
    ranking,
    totalEmployees,
    monthlyProgress,
    keyMetrics,
    performanceBreakdown,
    achievements,
    weeklyTrends,
    goals,
  ];
}
