import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

import '../../data/services/video_analysis_api_service.dart';
import '../../data/repositories/video_analysis_repository.dart';
import '../../presentation/cubit/video_analysis/video_analysis_cubit.dart';

final GetIt sl = GetIt.instance;

Future<void> init() async {
  // HTTP Client
  sl.registerLazySingleton<http.Client>(() => http.Client());

  // API Services
  sl.registerLazySingleton<VideoAnalysisApiService>(
    () => VideoAnalysisApiService(client: sl()),
  );

  // Repositories
  sl.registerLazySingleton<VideoAnalysisRepository>(
    () => VideoAnalysisRepository(sl()),
  );

  // Cubits
  sl.registerFactory<VideoAnalysisCubit>(
    () => VideoAnalysisCubit(sl()),
  );
}
