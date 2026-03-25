import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/models/status_file.dart';
import '../../../core/services/storage_service.dart';

// Events
sealed class SavedEvent {}

class SavedLoadRequested extends SavedEvent {}

class SavedDeleteRequested extends SavedEvent {
  final StatusFile status;
  SavedDeleteRequested(this.status);
}

// States
sealed class SavedState {}

class SavedInitial extends SavedState {}

class SavedLoading extends SavedState {}

class SavedLoaded extends SavedState {
  final List<StatusFile> statuses;
  SavedLoaded(this.statuses);
}

class SavedEmpty extends SavedState {}

// BLoC
class SavedBloc extends Bloc<SavedEvent, SavedState> {
  final StorageService _storageService;

  SavedBloc({required StorageService storageService})
      : _storageService = storageService,
        super(SavedInitial()) {
    on<SavedLoadRequested>(_onLoad);
    on<SavedDeleteRequested>(_onDelete);
  }

  Future<void> _onLoad(SavedLoadRequested event, Emitter<SavedState> emit) async {
    emit(SavedLoading());
    final statuses = await _storageService.loadSavedStatuses();
    emit(statuses.isEmpty ? SavedEmpty() : SavedLoaded(statuses));
  }

  Future<void> _onDelete(SavedDeleteRequested event, Emitter<SavedState> emit) async {
    await _storageService.deleteFile(event.status.path);
    add(SavedLoadRequested());
  }
}
