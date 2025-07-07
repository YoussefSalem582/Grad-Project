import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/core.dart';
import '../../cubit/employee_dashboard/employee_dashboard_cubit.dart';
import '../../widgets/common/animated_background_widget.dart';
import '../../widgets/employee_screen_widgets/dashboard/welcome_header_widget.dart';
import '../../widgets/employee_screen_widgets/dashboard/quick_stats_grid_widget.dart';
import '../../widgets/employee_screen_widgets/dashboard/analysis_tools_grid_widget.dart';
import '../../widgets/employee_screen_widgets/dashboard/recent_activity_list_widget.dart';
import '../screens.dart';

class EmployeeDashboardScreen extends StatefulWidget {
  const EmployeeDashboardScreen({super.key});

  @override
  State<EmployeeDashboardScreen> createState() =>
      _EmployeeDashboardScreenState();
}

class _EmployeeDashboardScreenState extends State<EmployeeDashboardScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _backgroundController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _backgroundAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    // Load dashboard data when the screen initializes
    context.read<EmployeeDashboardCubit>().loadDashboard();
  }

  void _initializeAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _backgroundController = AnimationController(
      duration: const Duration(seconds: 6),
      vsync: this,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );

    _backgroundAnimation = CurvedAnimation(
      parent: _backgroundController,
      curve: Curves.linear,
    );

    _fadeController.forward();
    _backgroundController.repeat();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _backgroundController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final customSpacing = theme.extension<CustomSpacing>()!;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Animated Background
          AnimatedBackgroundWidget(animation: _backgroundAnimation),

          // Dashboard Content
          FadeTransition(
            opacity: _fadeAnimation,
            child: BlocBuilder<EmployeeDashboardCubit, EmployeeDashboardState>(
              builder: (context, state) {
                if (state is EmployeeDashboardLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is EmployeeDashboardError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 64,
                          color: AppColors.error,
                        ),
                        SizedBox(height: customSpacing.md),
                        Text(
                          'Error loading dashboard',
                          style: theme.textTheme.headlineMedium?.copyWith(
                            color: AppColors.textPrimary,
                          ),
                        ),
                        SizedBox(height: customSpacing.sm),
                        Text(
                          state.message,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                        SizedBox(height: customSpacing.lg),
                        ElevatedButton(
                          onPressed: () {
                            context
                                .read<EmployeeDashboardCubit>()
                                .refreshDashboard();
                          },
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                }

                final data =
                    state is EmployeeDashboardSuccess ? state.data : null;

                return RefreshIndicator(
                  onRefresh: () async {
                    await context
                        .read<EmployeeDashboardCubit>()
                        .refreshDashboard();
                  },
                  child: CustomScrollView(
                    slivers: [
                      // Welcome Header
                      SliverToBoxAdapter(
                        child: WelcomeHeaderWidget(data: data),
                      ),

                      // Analysis Tools Section
                      SliverToBoxAdapter(
                        child: AnalysisToolsGridWidget(
                          onTextAnalysisTap: _navigateToTextAnalysis,
                          onVoiceAnalysisTap: _navigateToVoiceAnalysis,
                          onVideoAnalysisTap: _navigateToVideoAnalysis,
                          onAllToolsTap: _navigateToAnalysisTools,
                        ),
                      ),

                      // Recent Activity
                      SliverToBoxAdapter(
                        child: RecentActivityListWidget(data: data),
                      ),

                      // Quick Stats Overview
                      SliverToBoxAdapter(
                        child: QuickStatsGridWidget(data: data),
                      ),

                      // // Performance Summary
                      // SliverToBoxAdapter(
                      //   child: PerformanceGoalsWidget(data: data),
                      // ),

                      // Bottom padding
                      SliverToBoxAdapter(
                        child: SizedBox(height: customSpacing.xxl * 2),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Navigation methods
  void _navigateToTextAnalysis() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const EnhancedTextAnalysisScreen(),
      ),
    );
  }

  void _navigateToVoiceAnalysis() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const EnhancedVoiceAnalysisScreen(),
      ),
    );
  }

  void _navigateToVideoAnalysis() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const EmployeeVideoAnalysisScreen(),
      ),
    );
  }

  void _navigateToAnalysisTools() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const EmployeeAnalysisToolsScreen(),
      ),
    );
  }
}
