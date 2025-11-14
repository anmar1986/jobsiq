import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../entities/job_entity.dart';
import '../../data/datasources/job_remote_data_source.dart';

abstract class JobRepository {
  /// Get paginated list of jobs with filters
  Future<Either<Failure, JobsResult>> getJobs({
    int page = 1,
    int perPage = 15,
    String? search,
    String? location,
    List<String>? employmentTypes,
    List<String>? experienceLevels,
    bool? isRemote,
    String? category,
    double? salaryMin,
    String? company,
    String? sort,
    int? seed,
  });

  /// Get featured jobs
  Future<Either<Failure, List<JobEntity>>> getFeaturedJobs({int limit = 6});

  /// Get job by slug
  Future<Either<Failure, JobEntity>> getJobBySlug(String slug);

  /// Get jobs posted by authenticated user's companies
  Future<Either<Failure, List<JobEntity>>> getMyJobs();
}

/// Result model for paginated jobs
class JobsResult {
  final List<JobEntity> jobs;
  final int currentPage;
  final int lastPage;
  final int perPage;
  final int total;
  final int? seed;

  JobsResult({
    required this.jobs,
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
    this.seed,
  });

  bool get hasMore => currentPage < lastPage;
}
