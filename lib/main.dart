import 'package:flutter/material.dart';
import 'package:template_app/core/config/environment.dart';
import 'package:template_app/core/router/app_router.dart';
import 'package:template_app/injection/injection.dart';

void main() {
  // Initialize environment configuration
  const env = String.fromEnvironment('ENV', defaultValue: 'dev');
  EnvironmentConfig.init(env: env);

  // Configure dependency injection
  configureDependencies();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final _appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Template App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routerConfig: _appRouter.config(),
    );
  }
}
