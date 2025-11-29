import 'package:equatable/equatable.dart';

abstract class JobsEvent extends Equatable {
  const JobsEvent();

  @override
  List<Object?> get props => [];
}

class LoadJobsEvent extends JobsEvent {
  final bool refresh;
  final String? search;
  final String? location;
  final List<String>? employmentTypes;
  final List<String>? experienceLevels;
  final bool? isRemote;
  final String? category;
  final double? salaryMin;
  final String? company;
  final String? sort;

  const LoadJobsEvent({
    this.refresh = false,
    this.search,
    this.location,
    this.employmentTypes,
    this.experienceLevels,
    this.isRemote,
    this.category,
    this.salaryMin,
    this.company,
    this.sort,
  });

  @override
  List<Object?> get props => [
        refresh,
        search,
        location,
        employmentTypes,
        experienceLevels,
        isRemote,
        category,
        salaryMin,
        company,
        sort,
      ];
}

class LoadMoreJobsEvent extends JobsEvent {
  const LoadMoreJobsEvent();
}

class LoadFeaturedJobsEvent extends JobsEvent {
  final int limit;

  const LoadFeaturedJobsEvent({this.limit = 6});

  @override
  List<Object?> get props => [limit];
}

class SearchJobsEvent extends JobsEvent {
  final String query;

  const SearchJobsEvent(this.query);

  @override
  List<Object?> get props => [query];
}

class ToggleSaveJobEvent extends JobsEvent {
  final int jobId;

  const ToggleSaveJobEvent(this.jobId);

  @override
  List<Object?> get props => [jobId];
}

class ApplyForJobEvent extends JobsEvent {
  final String jobSlug;
  final int? cvId;
  final String? coverLetter;

  const ApplyForJobEvent({
    required this.jobSlug,
    this.cvId,
    this.coverLetter,
  });

  @override
  List<Object?> get props => [jobSlug, cvId, coverLetter];
}

class LoadJobBySlugEvent extends JobsEvent {
  final String slug;

  const LoadJobBySlugEvent(this.slug);

  @override
  List<Object?> get props => [slug];
}
