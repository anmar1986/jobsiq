import 'package:equatable/equatable.dart';

abstract class SavedJobsEvent extends Equatable {
  const SavedJobsEvent();

  @override
  List<Object?> get props => [];
}

class LoadSavedJobsEvent extends SavedJobsEvent {
  const LoadSavedJobsEvent();
}

class RemoveSavedJobEvent extends SavedJobsEvent {
  final int jobId;

  const RemoveSavedJobEvent(this.jobId);

  @override
  List<Object?> get props => [jobId];
}
