import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/services/permission_service.dart';

// Events
sealed class OnboardingEvent {}

class OnboardingNextPressed extends OnboardingEvent {}

class OnboardingPermissionRequested extends OnboardingEvent {}

class OnboardingCompleted extends OnboardingEvent {}

// States
sealed class OnboardingState {
  final int page;
  const OnboardingState({required this.page});
}

class OnboardingInitial extends OnboardingState {
  const OnboardingInitial() : super(page: 0);
}

class OnboardingPermissionPage extends OnboardingState {
  const OnboardingPermissionPage() : super(page: 1);
}

class OnboardingPermissionGranted extends OnboardingState {
  const OnboardingPermissionGranted() : super(page: 2);
}

class OnboardingDone extends OnboardingState {
  const OnboardingDone() : super(page: 2);
}

// BLoC
class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  final PermissionService _permissionService;

  OnboardingBloc({required PermissionService permissionService})
      : _permissionService = permissionService,
        super(const OnboardingInitial()) {
    on<OnboardingNextPressed>(_onNext);
    on<OnboardingPermissionRequested>(_onPermissionRequested);
    on<OnboardingCompleted>(_onCompleted);
  }

  void _onNext(OnboardingNextPressed event, Emitter<OnboardingState> emit) {
    if (state is OnboardingInitial) {
      emit(const OnboardingPermissionPage());
    }
  }

  Future<void> _onPermissionRequested(
    OnboardingPermissionRequested event,
    Emitter<OnboardingState> emit,
  ) async {
    final granted = await _permissionService.requestStoragePermission();
    if (granted) {
      emit(const OnboardingPermissionGranted());
    }
  }

  Future<void> _onCompleted(
    OnboardingCompleted event,
    Emitter<OnboardingState> emit,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(AppConstants.keyOnboardingComplete, true);
    emit(const OnboardingDone());
  }
}
