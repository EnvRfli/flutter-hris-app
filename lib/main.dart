import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'data/repos/auth_repository.dart';
import 'data/repos/clock_repository.dart';
import 'state/providers/auth_provider.dart';
import 'state/providers/clock_provider.dart';
import 'routes/app_router.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Repositories
        Provider(create: (_) => AuthRepository()),
        Provider(create: (_) => ClockRepository()),

        // Providers
        ChangeNotifierProvider(
          create: (context) => AuthProvider(
            context.read<AuthRepository>(),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => ClockProvider(
            context.read<ClockRepository>(),
          ),
        ),
      ],
      child: Builder(
        builder: (context) {
          final router = AppRouter.createRouter(context);

          return MaterialApp.router(
            title: 'HRIS App',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            routerConfig: router,
          );
        },
      ),
    );
  }
}
