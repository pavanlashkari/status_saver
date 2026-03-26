import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/constants/app_constants.dart';

// Events
sealed class SettingsEvent {}

class SettingsLoadRequested extends SettingsEvent {}

class SettingsDarkModeToggled extends SettingsEvent {}

class SettingsAlertsToggled extends SettingsEvent {}

// State
class SettingsState {
  final bool darkMode;
  final bool statusAlerts;

  const SettingsState({
    this.darkMode = true,
    this.statusAlerts = false,
  });

  SettingsState copyWith({bool? darkMode, bool? statusAlerts}) {
    return SettingsState(
      darkMode: darkMode ?? this.darkMode,
      statusAlerts: statusAlerts ?? this.statusAlerts,
    );
  }
}

// BLoC
class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc() : super(const SettingsState()) {
    on<SettingsLoadRequested>(_onLoad);
    on<SettingsDarkModeToggled>(_onDarkModeToggled);
    on<SettingsAlertsToggled>(_onAlertsToggled);
  }

  Future<void> _onLoad(SettingsLoadRequested event, Emitter<SettingsState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    emit(SettingsState(
      darkMode: prefs.getBool(AppConstants.keyDarkMode) ?? false,
      statusAlerts: prefs.getBool(AppConstants.keyStatusAlerts) ?? false,
    ));
  }

  Future<void> _onDarkModeToggled(SettingsDarkModeToggled event, Emitter<SettingsState> emit) async {
    final newValue = !state.darkMode;
    emit(state.copyWith(darkMode: newValue));
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(AppConstants.keyDarkMode, newValue);
  }

  Future<void> _onAlertsToggled(SettingsAlertsToggled event, Emitter<SettingsState> emit) async {
    final newValue = !state.statusAlerts;
    emit(state.copyWith(statusAlerts: newValue));
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(AppConstants.keyStatusAlerts, newValue);
  }
}
