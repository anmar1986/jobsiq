import 'package:equatable/equatable.dart';
import '../../../domain/entities/job_entity.dart';

abstract class JobsState extends Equatable {
  const JobsState();

  @override
  List<Object?> get props => [];
}

class JobsInitial extends JobsState {}

class JobsLoading extends JobsState {}

class JobsLoaded extends JobsState {
  final List<JobEntity> jobs;
  final int currentPage;
  final int lastPage;
  final int total;
  final bool hasMore;
  final int? seed;

  const JobsLoaded({
    required this.jobs,
    required this.currentPage,
    required this.lastPage,
    required this.total,
    required this.hasMore,
    this.seed,
  });

  @override
  List<Object?> get props =>
      [jobs, currentPage, lastPage, total, hasMore, seed];

  JobsLoaded copyWith({
    List<JobEntity>? jobs,
    int? currentPage,
    int? lastPage,
    int? total,
    bool? hasMore,
    int? seed,
  }) {
    return JobsLoaded(
      jobs: jobs ?? this.jobs,
      currentPage: currentPage ?? this.currentPage,
      lastPage: lastPage ?? this.lastPage,
      total: total ?? this.total,
      hasMore: hasMore ?? this.hasMore,
      seed: seed ?? this.seed,
    );
  }
}

class JobsLoadingMore extends JobsState {
  final List<JobEntity> currentJobs;

  const JobsLoadingMore(this.currentJobs);

  @override
  List<Object?> get props => [currentJobs];
}

class JobsError extends JobsState {
  final String message;

  const JobsError(this.message);

  @override
  List<Object?> get props => [message];
}

class FeaturedJobsLoading extends JobsState {}

class FeaturedJobsLoaded extends JobsState {
  final List<JobEntity> jobs;

  const FeaturedJobsLoaded(this.jobs);

  @override
  List<Object?> get props => [jobs];
}

class FeaturedJobsError extends JobsState {
  final String message;

  const FeaturedJobsError(this.message);

  @override
  List<Object?> get props => [message];
}

class JobSaveToggled extends JobsState {
  final int jobId;
  final bool isSaved;

  const JobSaveToggled({required this.jobId, required this.isSaved});

  @override
  List<Object?> get props => [jobId, isSaved];
}

class JobSaveError extends JobsState {
  final String message;

  const JobSaveError(this.message);

  @override
  List<Object?> get props => [message];
}

class JobApplicationSuccess extends JobsState {
  final String message;
  final String jobSlug;

  const JobApplicationSuccess(this.message, this.jobSlug);

  @override
  List<Object?> get props => [message, jobSlug];
}

class JobApplicationError extends JobsState {
  final String message;

  const JobApplicationError(this.message);

  @override
  List<Object?> get props => [message];
}

class JobLoaded extends JobsState {
  final JobEntity job;

  const JobLoaded(this.job);

  @override
  List<Object?> get props => [job];
}
