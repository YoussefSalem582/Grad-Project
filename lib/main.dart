import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Core
import 'core/constants/app_theme.dart';
import 'core/routing/app_router.dart';

// Presentation
import 'presentation/providers/emotion_provider.dart';
import 'presentation/providers/user_provider.dart';
import 'data/services/emotion_api_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const CustomerSenseApp());
}

class CustomerSenseApp extends StatelessWidget {
  const CustomerSenseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<EmotionProvider>(
          create: (_) => EmotionProvider(EmotionApiService()),
        ),
        ChangeNotifierProvider<UserProvider>(create: (_) => UserProvider()),
      ],
      child: MaterialApp(
        title: 'CustomerSense Pro',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        initialRoute: AppRouter.roleSelection,
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
