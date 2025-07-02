import 'package:get_it/get_it.dart';
import '../../core/network/network_info.dart';
import '../../data/datasources/analysis_local_datasource.dart';
import '../../data/datasources/analysis_remote_datasource.dart';
import '../../data/repositories/analysis_repository_impl.dart';
import '../../data/services/emotion_api_service.dart';
import '../../domain/repositories/analysis_repository.dart';
import '../../domain/usecases/analyze_text_usecase.dart';
import '../../domain/usecases/analyze_voice_usecase.dart';
import '../../domain/usecases/analyze_social_usecase.dart';
import '../../domain/usecases/get_analysis_history_usecase.dart';
import '../../presentation/blocs/emotion/emotion_cubit.dart';
import '../../presentation/blocs/user/user_cubit.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Blocs/Cubits
  sl.registerFactory(
    () => EmotionCubit(
      analyzeTextUseCase: sl(),
      analyzeVoiceUseCase: sl(),
      analyzeSocialUseCase: sl(),
      getAnalysisHistoryUseCase: sl(),
    ),
  );
  sl.registerFactory(() => UserCubit());

  // Use cases
  sl.registerLazySingleton(() => AnalyzeTextUseCase(sl()));
  sl.registerLazySingleton(() => AnalyzeVoiceUseCase(sl()));
  sl.registerLazySingleton(() => AnalyzeSocialUseCase(sl()));
  sl.registerLazySingleton(() => GetAnalysisHistoryUseCase(sl()));

  // Repository
  sl.registerLazySingleton<AnalysisRepository>(
    () => AnalysisRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<AnalysisRemoteDataSource>(
    () => AnalysisRemoteDataSourceImpl(),
  );
  sl.registerLazySingleton<AnalysisLocalDataSource>(
    () => AnalysisLocalDataSourceImpl(),
  );

  // Core
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl());

  // External
  sl.registerLazySingleton(() => EmotionApiService());
}
