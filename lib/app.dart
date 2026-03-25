import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'features/settings/bloc/settings_bloc.dart';

class StatusSaverApp extends StatelessWidget {
  final bool onboardingComplete;

  const StatusSaverApp({super.key, required this.onboardingComplete});

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
          routerConfig: AppRouter.router(onboardingComplete),
        );
      },
    );
  }
}
