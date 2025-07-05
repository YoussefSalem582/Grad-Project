import 'package:flutter_bloc/flutter_bloc.dart';
import 'admin_dashboard_state.dart';

class AdminDashboardCubit extends Cubit<AdminDashboardState> {
  AdminDashboardCubit() : super(AdminDashboardInitial());

  Future<void> loadDashboard() async {
    emit(AdminDashboardLoading());

    try {
      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 1));

      // Mock data for admin dashboard
      final dashboardData = {
        'totalUsers': 5,
        'activeUsers': 3,
        'totalAnalyses': 57,
        'systemHealth': 89.5,
        // 'monthlyGrowth': 1,
        'criticalAlerts': 3,
        'pendingTasks': 17,
        'serverUptime': 99.9,
      };

      emit(AdminDashboardLoaded(dashboardData));
    } catch (e) {
      emit(AdminDashboardError(e.toString()));
    }
  }

  Future<void> refreshDashboard() async {
    // Don't show loading state for refresh
    try {
      await Future.delayed(const Duration(milliseconds: 800));

      final dashboardData = {
        'totalUsers': 5 + (DateTime.now().millisecond % 10),
        'activeUsers': 3 + (DateTime.now().millisecond % 5),
        'totalAnalyses': 57 + (DateTime.now().millisecond % 20),
        'systemHealth': 89.5 + (DateTime.now().millisecond % 10) / 10,
        // 'monthlyGrowth': 1 + (DateTime.now().millisecond % 5) / 10,
        'criticalAlerts': DateTime.now().millisecond % 5,
        'pendingTasks': 17 + (DateTime.now().millisecond % 8),
        'serverUptime': 99.9,
      };

      emit(AdminDashboardLoaded(dashboardData));
    } catch (e) {
      emit(AdminDashboardError(e.toString()));
    }
  }

  void clearError() {
    if (state is AdminDashboardError) {
      emit(AdminDashboardInitial());
    }
  }
}
