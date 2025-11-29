import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/error/failures.dart';
import '../../../data/datasources/saved_job_remote_data_source.dart';
import '../../../data/datasources/job_application_remote_data_source.dart';
import '../../../domain/usecases/jobs/get_jobs_usecase.dart';
import '../../../domain/usecases/jobs/get_featured_jobs_usecase.dart';
import '../../../domain/repositories/job_repository.dart';
import 'jobs_event.dart';
import 'jobs_state.dart';

class JobsBloc extends Bloc<JobsEvent, JobsState> {
  final GetJobsUseCase getJobsUseCase;
  final GetFeaturedJobsUseCase getFeaturedJobsUseCase;
  final SavedJobRemoteDataSource savedJobDataSource;
  final JobApplicationRemoteDataSource jobApplicationDataSource;
  final JobRepository jobRepository;

  // Store current filter parameters
  GetJobsParams? _currentParams;
  int? _currentSeed;

  JobsBloc({
    required this.getJobsUseCase,
    required this.getFeaturedJobsUseCase,
    required this.savedJobDataSource,
    required this.jobApplicationDataSource,
    required this.jobRepository,
  }) : super(JobsInitial()) {
    on<LoadJobsEvent>(_onLoadJobs);
    on<LoadMoreJobsEvent>(_onLoadMoreJobs);
    on<LoadFeaturedJobsEvent>(_onLoadFeaturedJobs);
    on<SearchJobsEvent>(_onSearchJobs);
    on<ToggleSaveJobEvent>(_onToggleSaveJob);
    on<ApplyForJobEvent>(_onApplyForJob);
    on<LoadJobBySlugEvent>(_onLoadJobBySlug);
  }

  Future<void> _onLoadJobs(
    LoadJobsEvent event,
    Emitter<JobsState> emit,
  ) async {
    emit(JobsLoading());

    // Create params for this request
    _currentParams = GetJobsParams(
      page: 1,
      perPage: 15,
      search: event.search,
      location: event.location,
      employmentTypes: event.employmentTypes,
      experienceLevels: event.experienceLevels,
      isRemote: event.isRemote,
      category: event.category,
      salaryMin: event.salaryMin,
      company: event.company,
      sort: event.sort,
      seed: event.refresh
          ? null
          : _currentSeed, // Use existing seed unless refreshing
    );

    final result = await getJobsUseCase(_currentParams!);

    result.fold(
      (failure) => emit(JobsError(_mapFailureToMessage(failure))),
      (jobsResult) {
        // Store the seed for pagination
        _currentSeed = jobsResult.seed;

        debugPrint(
            '✅ Jobs loaded: ${jobsResult.jobs.length} jobs, Page ${jobsResult.currentPage}/${jobsResult.lastPage}, Total: ${jobsResult.total}, HasMore: ${jobsResult.hasMore}');

        emit(JobsLoaded(
          jobs: jobsResult.jobs,
          currentPage: jobsResult.currentPage,
          lastPage: jobsResult.lastPage,
          total: jobsResult.total,
          hasMore: jobsResult.hasMore,
          seed: jobsResult.seed,
        ));
      },
    );
  }

  Future<void> _onLoadMoreJobs(
    LoadMoreJobsEvent event,
    Emitter<JobsState> emit,
  ) async {
    final currentState = state;
    if (currentState is! JobsLoaded) return;
    if (!currentState.hasMore) return;
    if (_currentParams == null) return;

    emit(JobsLoadingMore(currentState.jobs));

    // Use current params but increment page
    final params = _currentParams!.copyWith(
      page: currentState.currentPage + 1,
      seed: _currentSeed,
    );

    final result = await getJobsUseCase(params);

    result.fold(
      (failure) => emit(currentState), // Revert to previous state on error
      (jobsResult) {
        final allJobs = List.of(currentState.jobs)..addAll(jobsResult.jobs);

        debugPrint(
            '📄 More jobs loaded: +${jobsResult.jobs.length} jobs, Total now: ${allJobs.length}, Page ${jobsResult.currentPage}/${jobsResult.lastPage}');

        emit(JobsLoaded(
          jobs: allJobs,
          currentPage: jobsResult.currentPage,
          lastPage: jobsResult.lastPage,
          total: jobsResult.total,
          hasMore: jobsResult.hasMore,
          seed: jobsResult.seed,
        ));
      },
    );
  }

  Future<void> _onLoadFeaturedJobs(
    LoadFeaturedJobsEvent event,
    Emitter<JobsState> emit,
  ) async {
    emit(FeaturedJobsLoading());

    final result = await getFeaturedJobsUseCase(
      GetFeaturedJobsParams(limit: event.limit),
    );

    result.fold(
      (failure) => emit(FeaturedJobsError(_mapFailureToMessage(failure))),
      (jobs) => emit(FeaturedJobsLoaded(jobs)),
    );
  }

  Future<void> _onSearchJobs(
    SearchJobsEvent event,
    Emitter<JobsState> emit,
  ) async {
    // Trigger load jobs with search query
    add(LoadJobsEvent(
      refresh: true,
      search: event.query.isEmpty ? null : event.query,
    ));
  }

  Future<void> _onToggleSaveJob(
    ToggleSaveJobEvent event,
    Emitter<JobsState> emit,
  ) async {
    final currentState = state;

    try {
      final isSaved = await savedJobDataSource.toggleSaveJob(event.jobId);

      debugPrint('💾 Job ${event.jobId} ${isSaved ? "saved" : "unsaved"}');

      // Update the job in the current state
      if (currentState is JobsLoaded) {
        final updatedJobs = currentState.jobs.map((job) {
          if (job.id == event.jobId) {
            // Create a new job entity with updated isSaved status
            return job.copyWith(isSaved: isSaved);
          }
          return job;
        }).toList();

        emit(currentState.copyWith(jobs: updatedJobs));
      }

      // Emit save toggled event for UI feedback (e.g., showing snackbar)
      emit(JobSaveToggled(jobId: event.jobId, isSaved: isSaved));
    } catch (e) {
      debugPrint('❌ Error toggling save job: $e');

      // Check if it's an authentication error
      final errorMessage = e.toString().contains('401') ||
              e.toString().toLowerCase().contains('unauthorized')
          ? 'Please login to save jobs'
          : 'Failed to save job. Please try again.';

      emit(JobSaveError(errorMessage));

      // Restore previous state
      if (currentState is JobsLoaded) {
        emit(currentState);
      }
    }
  }

  Future<void> _onApplyForJob(
    ApplyForJobEvent event,
    Emitter<JobsState> emit,
  ) async {
    final currentState = state;

    try {
      await jobApplicationDataSource.applyForJob(
        event.jobSlug,
        event.cvId,
        event.coverLetter,
      );

      debugPrint('✅ Applied for job: ${event.jobSlug}');

      emit(JobApplicationSuccess(
          'Application submitted successfully!', event.jobSlug));

      // Update the job's isApplied flag in the state
      if (currentState is JobsLoaded) {
        final updatedJobs = currentState.jobs.map((job) {
          if (job.slug == event.jobSlug) {
            return job.copyWith(isApplied: true);
          }
          return job;
        }).toList();

        emit(currentState.copyWith(jobs: updatedJobs));
      } else {
        emit(currentState);
      }
    } catch (e) {
      debugPrint('❌ Error applying for job: $e');

      // Check if it's an authentication error
      final errorMessage = e.toString().contains('401') ||
              e.toString().toLowerCase().contains('unauthorized')
          ? 'Please login to apply for jobs'
          : 'Failed to submit application. Please try again.';

      emit(JobApplicationError(errorMessage));

      // Restore previous state
      if (currentState is JobsLoaded) {
        emit(currentState);
      }
    }
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case const (ServerFailure):
        return failure.message;
      case const (NetworkFailure):
        return 'No internet connection. Please check your connection.';
      case const (NotFoundFailure):
        return failure.message;
      default:
        return 'An unexpected error occurred. Please try again.';
    }
  }

  Future<void> _onLoadJobBySlug(
    LoadJobBySlugEvent event,
    Emitter<JobsState> emit,
  ) async {
    emit(JobsLoading());

    final result = await jobRepository.getJobBySlug(event.slug);

    result.fold(
      (failure) => emit(JobsError(_mapFailureToMessage(failure))),
      (job) => emit(JobLoaded(job)),
    );
  }
}
