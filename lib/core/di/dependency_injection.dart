import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

// Services
import '../../data/services/video_analysis_api_service.dart';
import '../../data/services/emotion_api_service.dart';

// Repositories
import '../../data/repositories/video_analysis_repository.dart';
import '../../data/repositories/mock_ticket_repository.dart';
import '../../domain/repositories/ticket_repository.dart';

// Use Cases
import '../../domain/usecases/ticket_usecases.dart';

// Cubits
import '../../presentation/cubit/video_analysis/video_analysis_cubit.dart';
import '../../presentation/cubit/emotion/emotion_cubit.dart';
import '../../presentation/cubit/user/user_cubit.dart';
import '../../presentation/cubit/text_analysis/text_analysis_cubit.dart';
import '../../presentation/cubit/voice_analysis/voice_analysis_cubit.dart';
import '../../presentation/cubit/analysis/analysis_cubit.dart';
import '../../presentation/cubit/employee_dashboard/employee_dashboard_cubit.dart';
import '../../presentation/cubit/employee_analytics/employee_analytics_cubit.dart';
import '../../presentation/cubit/employee_performance/employee_performance_cubit.dart';
import '../../presentation/cubit/admin_dashboard/admin_dashboard_cubit.dart';
import '../../presentation/cubit/tickets/tickets_cubit.dart';

final GetIt sl = GetIt.instance;

Future<void> init() async {
  // HTTP Client
  sl.registerLazySingleton<http.Client>(() => http.Client());

  // API Services
  sl.registerLazySingleton<VideoAnalysisApiService>(
    () => VideoAnalysisApiService(client: sl()),
  );
  sl.registerLazySingleton<EmotionApiService>(
    () => EmotionApiService(client: sl()),
  );

  // Repositories
  sl.registerLazySingleton<VideoAnalysisRepository>(
    () => VideoAnalysisRepository(sl()),
  );
  sl.registerLazySingleton<TicketRepository>(() => MockTicketRepository());

  // Use Cases
  sl.registerFactory<LoadTicketsUseCase>(() => LoadTicketsUseCase(sl()));
  sl.registerFactory<CreateTicketUseCase>(() => CreateTicketUseCase(sl()));
  sl.registerFactory<UpdateTicketStatusUseCase>(
    () => UpdateTicketStatusUseCase(sl()),
  );
  sl.registerFactory<AssignTicketUseCase>(() => AssignTicketUseCase(sl()));
  sl.registerFactory<GetTicketStatisticsUseCase>(
    () => GetTicketStatisticsUseCase(sl()),
  );

  // Analysis Cubits
  sl.registerFactory<VideoAnalysisCubit>(() => VideoAnalysisCubit(sl()));
  sl.registerFactory<TextAnalysisCubit>(() => TextAnalysisCubit(sl()));
  sl.registerFactory<VoiceAnalysisCubit>(() => VoiceAnalysisCubit());
  sl.registerFactory<AnalysisCubit>(() => AnalysisCubit(sl()));

  // Core Cubits
  sl.registerFactory<EmotionCubit>(() => EmotionCubit(sl()));
  sl.registerFactory<UserCubit>(() => UserCubit());

  // Employee Cubits
  sl.registerFactory<EmployeeDashboardCubit>(() => EmployeeDashboardCubit());
  sl.registerFactory<EmployeeAnalyticsCubit>(() => EmployeeAnalyticsCubit());
  sl.registerFactory<EmployeePerformanceCubit>(
    () => EmployeePerformanceCubit(),
  );

  // Admin Cubits
  sl.registerFactory<AdminDashboardCubit>(() => AdminDashboardCubit());

  // Unified Tickets Cubit with Use Cases
  sl.registerFactory<TicketsCubit>(
    () => TicketsCubit(
      loadTicketsUseCase: sl(),
      createTicketUseCase: sl(),
      updateTicketStatusUseCase: sl(),
      assignTicketUseCase: sl(),
      getTicketStatisticsUseCase: sl(),
    ),
  );
}
