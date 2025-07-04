import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Core
import 'core/constants/app_theme.dart';
import 'core/routing/app_router.dart';
import 'core/di/dependency_injection.dart' as di;

// Presentation
import 'presentation/cubit/video_analysis/video_analysis_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize dependency injection
  await di.init();

  runApp(const CustomerSenseApp());
}

class CustomerSenseApp extends StatelessWidget {
  const CustomerSenseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<VideoAnalysisCubit>(
          create: (_) => di.sl<VideoAnalysisCubit>(),
        ),
      ],
      child: MaterialApp(
        title: 'CustomerSense Pro',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        initialRoute: AppRouter.login,
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
    );
  }
}
