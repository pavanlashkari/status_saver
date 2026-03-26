import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'features/settings/bloc/settings_bloc.dart';

class StatusSaverApp extends StatefulWidget {
  final bool onboardingComplete;

  const StatusSaverApp({super.key, required this.onboardingComplete});

  @override
  State<StatusSaverApp> createState() => _StatusSaverAppState();
}

class _StatusSaverAppState extends State<StatusSaverApp> {
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    _router = AppRouter.router(widget.onboardingComplete);
  }

  @override
  void dispose() {
    _router.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, state) {
        return MaterialApp.router(
          title: 'Status Saver',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: state.darkMode ? ThemeMode.dark : ThemeMode.light,
          routerConfig: _router,
        );
      },
    );
  }
}
