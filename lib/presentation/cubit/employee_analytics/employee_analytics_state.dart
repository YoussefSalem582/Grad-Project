part of 'employee_analytics_cubit.dart';

abstract class EmployeeAnalyticsState extends Equatable {
  const EmployeeAnalyticsState();

  @override
  List<Object?> get props => [];
}

class EmployeeAnalyticsInitial extends EmployeeAnalyticsState {
  const EmployeeAnalyticsInitial();
}

class EmployeeAnalyticsLoading extends EmployeeAnalyticsState {
  const EmployeeAnalyticsLoading();
}

class EmployeeAnalyticsSuccess extends EmployeeAnalyticsState {
  final EmployeeAnalyticsData data;

  const EmployeeAnalyticsSuccess(this.data);

  @override
  List<Object?> get props => [data];
}

class EmployeeAnalyticsError extends EmployeeAnalyticsState {
  final String message;

  const EmployeeAnalyticsError(this.message);

  @override
  List<Object?> get props => [message];
}

class EmployeeAnalyticsData extends Equatable {
  final String timeRange;
  final List<Map<String, dynamic>> metrics;
  final Map<String, dynamic> performanceData;
  final List<Map<String, dynamic>> ticketTypes;
  final Map<String, dynamic> priorityDistribution;
  final List<Map<String, dynamic>> resolutionSpeed;
  final List<Map<String, dynamic>> goals;

  const EmployeeAnalyticsData({
    required this.timeRange,
    required this.metrics,
    required this.performanceData,
    required this.ticketTypes,
    required this.priorityDistribution,
    required this.resolutionSpeed,
    required this.goals,
  });

  @override
  List<Object?> get props => [
    timeRange,
    metrics,
    performanceData,
    ticketTypes,
    priorityDistribution,
    resolutionSpeed,
    goals,
  ];
}
