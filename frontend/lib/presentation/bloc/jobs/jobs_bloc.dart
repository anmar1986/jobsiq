import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/error/failures.dart';
import '../../../domain/usecases/jobs/get_jobs_usecase.dart';
import '../../../domain/usecases/jobs/get_featured_jobs_usecase.dart';
import 'jobs_event.dart';
import 'jobs_state.dart';

class JobsBloc extends Bloc<JobsEvent, JobsState> {
  final GetJobsUseCase getJobsUseCase;
  final GetFeaturedJobsUseCase getFeaturedJobsUseCase;

  // Store current filter parameters
  GetJobsParams? _currentParams;
  int? _currentSeed;

  JobsBloc({
    required this.getJobsUseCase,
    required this.getFeaturedJobsUseCase,
  }) : super(JobsInitial()) {
    on<LoadJobsEvent>(_onLoadJobs);
    on<LoadMoreJobsEvent>(_onLoadMoreJobs);
    on<LoadFeaturedJobsEvent>(_onLoadFeaturedJobs);
    on<SearchJobsEvent>(_onSearchJobs);
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
      seed: event.refresh ? null : _currentSeed, // Use existing seed unless refreshing
    );

    final result = await getJobsUseCase(_currentParams!);

    result.fold(
      (failure) => emit(JobsError(_mapFailureToMessage(failure))),
      (jobsResult) {
        // Store the seed for pagination
        _currentSeed = jobsResult.seed;

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
}
