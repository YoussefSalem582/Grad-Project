import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'employee_dashboard_state.dart';

class EmployeeDashboardCubit extends Cubit<EmployeeDashboardState> {
  EmployeeDashboardCubit() : super(const EmployeeDashboardInitial());

  /// Load dashboard data
  Future<void> loadDashboard() async {
    emit(const EmployeeDashboardLoading());

    try {
      // Simulate loading dashboard data
      await Future.delayed(const Duration(milliseconds: 500));

      final dashboardData = EmployeeDashboardData(
        ticketsResolved: 42,
        activeTickets: 8,
        customerSatisfaction: 4.8,
        efficiencyScore: 94,
        recentTickets: _getRecentTickets(),
        quickStats: _getQuickStats(),
      );

      emit(EmployeeDashboardSuccess(dashboardData));
    } catch (e) {
      emit(EmployeeDashboardError(e.toString()));
    }
  }

  /// Refresh dashboard data
  Future<void> refreshDashboard() async {
    await loadDashboard();
  }

  /// Get recent tickets data
  List<Map<String, dynamic>> _getRecentTickets() {
    return [
      {
        'id': '#TK-001',
        'title': 'Product Quality Issue',
        'customer': 'Sarah Johnson',
        'priority': 'High',
        'status': 'Open',
        'time': '2 hours ago',
      },
      {
        'id': '#TK-002',
        'title': 'Shipping Delay',
        'customer': 'Mike Chen',
        'priority': 'Medium',
        'status': 'In Progress',
        'time': '4 hours ago',
      },
      {
        'id': '#TK-003',
        'title': 'Account Access',
        'customer': 'Emily Davis',
        'priority': 'Low',
        'status': 'Resolved',
        'time': '1 day ago',
      },
    ];
  }

  /// Get quick stats data
  List<Map<String, dynamic>> _getQuickStats() {
    return [
      {
        'title': 'Today\'s Tickets',
        'value': '15',
        'trend': '+3 from yesterday',
        'isPositive': true,
      },
      {
        'title': 'Avg Resolution Time',
        'value': '2.1h',
        'trend': '-0.3h improvement',
        'isPositive': true,
      },
      {
        'title': 'Customer Rating',
        'value': '4.8/5',
        'trend': '+0.2 vs last week',
        'isPositive': true,
      },
    ];
  }
}
