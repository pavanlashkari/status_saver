import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app.dart';
import 'core/constants/app_constants.dart';
import 'core/services/ad_service.dart';
import 'features/settings/bloc/settings_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final onboardingComplete = prefs.getBool(AppConstants.keyOnboardingComplete) ?? false;
  await AdService().initialize();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => SettingsBloc()..add(SettingsLoadRequested())),
      ],
      child: StatusSaverApp(onboardingComplete: onboardingComplete),
    ),
  );
}
