import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'employee_analytics_state.dart';

class EmployeeAnalyticsCubit extends Cubit<EmployeeAnalyticsState> {
  EmployeeAnalyticsCubit() : super(const EmployeeAnalyticsInitial());

  String _selectedTimeRange = 'This Week';

  String get selectedTimeRange => _selectedTimeRange;

  /// Load analytics data
  Future<void> loadAnalytics([String? timeRange]) async {
    if (timeRange != null) {
      _selectedTimeRange = timeRange;
    }

    emit(const EmployeeAnalyticsLoading());

    try {
      // Simulate loading analytics data
      await Future.delayed(const Duration(milliseconds: 800));

      final analyticsData = EmployeeAnalyticsData(
        timeRange: _selectedTimeRange,
        metrics: _getMetricsForTimeRange(),
        performanceData: _getPerformanceData(),
        ticketTypes: _getTicketTypes(),
        priorityDistribution: _getPriorityDistribution(),
        resolutionSpeed: _getResolutionSpeed(),
        goals: _getGoals(),
      );

      emit(EmployeeAnalyticsSuccess(analyticsData));
    } catch (e) {
      emit(EmployeeAnalyticsError(e.toString()));
    }
  }

  /// Change time range and reload data
  Future<void> changeTimeRange(String timeRange) async {
    await loadAnalytics(timeRange);
  }

  /// Refresh analytics data
  Future<void> refreshAnalytics() async {
    await loadAnalytics();
  }

  List<Map<String, dynamic>> _getMetricsForTimeRange() {
    return [
      {
        'title': 'Ticket Volume',
        'value': _selectedTimeRange == 'Today' ? '18' : '89',
        'unit': _selectedTimeRange == 'Today' ? 'today' : 'this week',
        'trend': _selectedTimeRange == 'Today'
            ? '+15% vs yesterday'
            : '+8% vs last week',
        'isPositiveTrend': true,
      },
      {
        'title': 'Resolution Rate',
        'value': _selectedTimeRange == 'Today' ? '96%' : '94%',
        'unit': 'success',
        'trend': _selectedTimeRange == 'Today'
            ? '+2% vs yesterday'
            : '+5% vs last week',
        'isPositiveTrend': true,
      },
      {
        'title': 'Customer Satisfaction',
        'value': '4.8/5',
        'unit': 'rating',
        'trend': '+0.2 vs last period',
        'isPositiveTrend': true,
      },
      {
        'title': 'Tickets Handled',
        'value': _selectedTimeRange == 'Today' ? '15' : '78',
        'unit': _selectedTimeRange == 'Today' ? 'today' : 'this week',
        'trend': _selectedTimeRange == 'Today' ? 'Target: 20' : 'Target: 80',
        'isPositiveTrend': _selectedTimeRange == 'Today' ? false : true,
      },
      {
        'title': 'First Resolution',
        'value': '87%',
        'unit': 'resolved',
        'trend': '+3% improvement',
        'isPositiveTrend': true,
      },
      {
        'title': 'Customer Escalations',
        'value': '2',
        'unit': _selectedTimeRange == 'Today' ? 'today' : 'this week',
        'trend': '-50% vs last period',
        'isPositiveTrend': true,
      },
    ];
  }

  Map<String, dynamic> _getPerformanceData() {
    return {
      'bestDay': 'Wednesday',
      'bestDayImprovement': '+12%',
      'peakHour': '2-3 PM',
      'peakHourTickets': '23 tickets',
      'avgResolution': '2.1h',
      'avgResolutionUnit': 'per ticket',
    };
  }

  List<Map<String, dynamic>> _getTicketTypes() {
    return [
      {'label': 'Product Issues', 'percentage': 0.45},
      {'label': 'Shipping', 'percentage': 0.25},
      {'label': 'Account', 'percentage': 0.20},
      {'label': 'Other', 'percentage': 0.10},
    ];
  }

  Map<String, dynamic> _getPriorityDistribution() {
    return {'high': 32, 'medium': 48, 'low': 20};
  }

  List<Map<String, dynamic>> _getResolutionSpeed() {
    return [
      {'timeRange': 'Same Day', 'percentage': '45%'},
      {'timeRange': '1-2 Days', 'percentage': '35%'},
      {'timeRange': '3-5 Days', 'percentage': '15%'},
      {'timeRange': '> 5 Days', 'percentage': '5%'},
    ];
  }

  List<Map<String, dynamic>> _getGoals() {
    return [
      {
        'title': 'Ticket Efficiency',
        'progress': 0.87,
        'target': '> 85%',
        'current': '87% current',
      },
      {
        'title': 'Resolution Rate',
        'progress': 0.94,
        'target': '> 90%',
        'current': '94% current',
      },
      {
        'title': 'Customer Satisfaction',
        'progress': 0.96,
        'target': '> 4.5/5',
        'current': '4.8/5 current',
      },
      {
        'title': 'Daily Tickets',
        'progress': 0.75,
        'target': '20 tickets',
        'current': '15 completed today',
      },
    ];
  }
}
