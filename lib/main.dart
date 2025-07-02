import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

// Core
import 'core/constants/app_theme.dart';
import 'core/routing/app_router.dart';
import 'core/di/injection_container.dart' as di;

// Presentation
import 'presentation/blocs/emotion/emotion_cubit.dart';
import 'presentation/blocs/user/user_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const CustomerSenseApp());
}

class CustomerSenseApp extends StatelessWidget {
  const CustomerSenseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<EmotionCubit>(create: (_) => GetIt.I<EmotionCubit>()),
        BlocProvider<UserCubit>(create: (_) => GetIt.I<UserCubit>()),
      ],
      child: MaterialApp(
        title: 'CustomerSense Pro',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        initialRoute: AppRouter.mainDashboard,
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
