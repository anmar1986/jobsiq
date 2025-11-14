import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/datasources/saved_job_remote_data_source.dart';
import 'saved_jobs_event.dart';
import 'saved_jobs_state.dart';

class SavedJobsBloc extends Bloc<SavedJobsEvent, SavedJobsState> {
  final SavedJobRemoteDataSource savedJobDataSource;

  SavedJobsBloc({
    required this.savedJobDataSource,
  }) : super(SavedJobsInitial()) {
    on<LoadSavedJobsEvent>(_onLoadSavedJobs);
    on<RemoveSavedJobEvent>(_onRemoveSavedJob);
  }

  Future<void> _onLoadSavedJobs(
    LoadSavedJobsEvent event,
    Emitter<SavedJobsState> emit,
  ) async {
    emit(SavedJobsLoading());

    try {
      final jobs = await savedJobDataSource.getSavedJobs();

      if (jobs.isEmpty) {
        emit(SavedJobsEmpty());
      } else {
        debugPrint('✅ Loaded ${jobs.length} saved jobs');
        emit(SavedJobsLoaded(jobs));
      }
    } catch (e) {
      debugPrint('❌ Error loading saved jobs: $e');

      final errorMessage = e.toString().contains('401') ||
              e.toString().toLowerCase().contains('unauthorized')
          ? 'Please login to view saved jobs'
          : 'Failed to load saved jobs. Please try again.';

      emit(SavedJobsError(errorMessage));
    }
  }

  Future<void> _onRemoveSavedJob(
    RemoveSavedJobEvent event,
    Emitter<SavedJobsState> emit,
  ) async {
    final currentState = state;
    if (currentState is! SavedJobsLoaded) return;

    try {
      // Call the API to unsave the job
      await savedJobDataSource.toggleSaveJob(event.jobId);

      // Remove the job from the list
      final updatedJobs =
          currentState.jobs.where((job) => job.id != event.jobId).toList();

      if (updatedJobs.isEmpty) {
        emit(SavedJobsEmpty());
      } else {
        emit(SavedJobsLoaded(updatedJobs));
      }

      debugPrint('💾 Job ${event.jobId} removed from saved jobs');
    } catch (e) {
      debugPrint('❌ Error removing saved job: $e');
      // Keep the current state and show error through snackbar
      emit(currentState);
    }
  }
}
