import 'package:equatable/equatable.dart';
import '../../../domain/entities/job_entity.dart';

abstract class SavedJobsState extends Equatable {
  const SavedJobsState();

  @override
  List<Object?> get props => [];
}

class SavedJobsInitial extends SavedJobsState {}

class SavedJobsLoading extends SavedJobsState {}

class SavedJobsLoaded extends SavedJobsState {
  final List<JobEntity> jobs;

  const SavedJobsLoaded(this.jobs);

  @override
  List<Object?> get props => [jobs];
}

class SavedJobsEmpty extends SavedJobsState {}

class SavedJobsError extends SavedJobsState {
  final String message;

  const SavedJobsError(this.message);

  @override
  List<Object?> get props => [message];
}
