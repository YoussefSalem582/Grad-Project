import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Core
import 'core/constants/app_theme.dart';
import 'core/routing/app_router.dart';
import 'core/di/dependency_injection.dart' as di;
import 'core/config/app_config.dart';

// Presentation - Cubits
import 'presentation/cubit/video_analysis/video_analysis_cubit.dart';
import 'presentation/cubit/emotion/emotion_cubit.dart';
import 'presentation/cubit/user/user_cubit.dart';
import 'presentation/cubit/text_analysis/text_analysis_cubit.dart';
import 'presentation/cubit/voice_analysis/voice_analysis_cubit.dart';
import 'presentation/cubit/employee_dashboard/employee_dashboard_cubit.dart';
import 'presentation/cubit/employee_analytics/employee_analytics_cubit.dart';
import 'presentation/cubit/employee_performance/employee_performance_cubit.dart';
import 'presentation/cubit/admin_dashboard/admin_dashboard_cubit.dart';
import 'presentation/cubit/connection_cubit.dart';

// Presentation - Widgets
import 'presentation/widgets/backend_connection_widget.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load application configuration
  await AppConfig.loadConfig();

  // Initialize dependency injection
  await di.init();

  runApp(const EmosenseApp());
}

class EmosenseApp extends StatelessWidget {
  const EmosenseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // Analysis Cubits
        BlocProvider<VideoAnalysisCubit>(
          create: (_) => di.sl<VideoAnalysisCubit>(),
        ),
        BlocProvider<TextAnalysisCubit>(
          create: (_) => di.sl<TextAnalysisCubit>(),
        ),
        BlocProvider<VoiceAnalysisCubit>(
          create: (_) => di.sl<VoiceAnalysisCubit>(),
        ),

        // Core Cubits
        BlocProvider<EmotionCubit>(create: (_) => di.sl<EmotionCubit>()),
        BlocProvider<UserCubit>(create: (_) => di.sl<UserCubit>()),

        // Employee Cubits
        BlocProvider<EmployeeDashboardCubit>(
          create: (_) => di.sl<EmployeeDashboardCubit>(),
        ),
        BlocProvider<EmployeeAnalyticsCubit>(
          create: (_) => di.sl<EmployeeAnalyticsCubit>(),
        ),
        BlocProvider<EmployeePerformanceCubit>(
          create: (_) => di.sl<EmployeePerformanceCubit>(),
        ),

        // Admin Cubits
        BlocProvider<AdminDashboardCubit>(
          create: (_) => di.sl<AdminDashboardCubit>(),
        ),

        // Connection Management
        BlocProvider<ConnectionCubit>(create: (_) => ConnectionCubit()),
      ],
      child: BackendConnectionWidget(
        child: MaterialApp(
          title: 'Emosense',
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: ThemeMode.system,
          initialRoute: AppRouter.splash,
          onGenerateRoute: AppRouter.generateRoute,
          debugShowCheckedModeBanner: false,
          builder: (context, child) {
            return MediaQuery(
              data: MediaQuery.of(
                context,
              ).copyWith(textScaler: const TextScaler.linear(1.0)),
              child: child!,
            );
          },
        ),
      ),
    );
  }
}
