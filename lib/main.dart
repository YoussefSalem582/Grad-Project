import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Core
import 'core/di/injection_container.dart' as di;
import 'core/constants/app_theme.dart';
import 'core/routing/app_router.dart';

// Presentation
import 'presentation/providers/analysis_provider.dart';
import 'presentation/providers/user_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize dependencies
  await di.initializeDependencies();

  runApp(const CustomerSenseApp());
}

class CustomerSenseApp extends StatelessWidget {
  const CustomerSenseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AnalysisProvider>(
          create: (_) => di.sl<AnalysisProvider>(),
        ),
        ChangeNotifierProvider<UserProvider>(
          create: (_) => di.sl<UserProvider>(),
        ),
      ],
      child: MaterialApp(
        title: 'CustomerSense Pro',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.lightTheme,
        themeMode: ThemeMode.system,
        initialRoute: AppRouter.roleSelection,
        onGenerateRoute: AppRouter.generateRoute,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
