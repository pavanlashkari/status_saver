import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/models/status_file.dart';
import '../../../core/services/file_service.dart';

// Events
sealed class StatusEvent {}

class StatusLoadRequested extends StatusEvent {}

class StatusRefreshRequested extends StatusEvent {}

// States
sealed class StatusState {}

class StatusInitial extends StatusState {}

class StatusLoading extends StatusState {}

class StatusLoaded extends StatusState {
  final List<StatusFile> images;
  final List<StatusFile> videos;

  StatusLoaded({required this.images, required this.videos});
}

class StatusEmpty extends StatusState {}

class StatusError extends StatusState {
  final String message;
  StatusError(this.message);
}

// BLoC
class StatusBloc extends Bloc<StatusEvent, StatusState> {
  final FileService _fileService;

  StatusBloc({required FileService fileService})
      : _fileService = fileService,
        super(StatusInitial()) {
    on<StatusLoadRequested>(_onLoad);
    on<StatusRefreshRequested>(_onRefresh);
  }

  Future<void> _onLoad(StatusLoadRequested event, Emitter<StatusState> emit) async {
    emit(StatusLoading());
    await _loadStatuses(emit);
  }

  Future<void> _onRefresh(StatusRefreshRequested event, Emitter<StatusState> emit) async {
    await _loadStatuses(emit);
  }

  Future<void> _loadStatuses(Emitter<StatusState> emit) async {
    try {
      final statuses = await _fileService.loadStatuses();
      if (statuses.isEmpty) {
        emit(StatusEmpty());
        return;
      }
      final images = statuses.where((s) => s.isImage).toList();
      final videos = statuses.where((s) => s.isVideo).toList();
      emit(StatusLoaded(images: images, videos: videos));
    } catch (e) {
      emit(StatusError(e.toString()));
    }
  }
}
