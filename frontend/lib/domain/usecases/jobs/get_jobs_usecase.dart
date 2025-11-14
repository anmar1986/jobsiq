import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../../../core/usecases/usecase.dart';
import '../../repositories/job_repository.dart';

class GetJobsUseCase implements UseCase<JobsResult, GetJobsParams> {
  final JobRepository repository;

  GetJobsUseCase(this.repository);

  @override
  Future<Either<Failure, JobsResult>> call(GetJobsParams params) async {
    return await repository.getJobs(
      page: params.page,
      perPage: params.perPage,
      search: params.search,
      location: params.location,
      employmentTypes: params.employmentTypes,
      experienceLevels: params.experienceLevels,
      isRemote: params.isRemote,
      category: params.category,
      salaryMin: params.salaryMin,
      company: params.company,
      sort: params.sort,
      seed: params.seed,
    );
  }
}

class GetJobsParams {
  final int page;
  final int perPage;
  final String? search;
  final String? location;
  final List<String>? employmentTypes;
  final List<String>? experienceLevels;
  final bool? isRemote;
  final String? category;
  final double? salaryMin;
  final String? company;
  final String? sort;
  final int? seed;

  GetJobsParams({
    this.page = 1,
    this.perPage = 10,
    this.search,
    this.location,
    this.employmentTypes,
    this.experienceLevels,
    this.isRemote,
    this.category,
    this.salaryMin,
    this.company,
    this.sort,
    this.seed,
  });

  GetJobsParams copyWith({
    int? page,
    int? perPage,
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
  }) {
    return GetJobsParams(
      page: page ?? this.page,
      perPage: perPage ?? this.perPage,
      search: search ?? this.search,
      location: location ?? this.location,
      employmentTypes: employmentTypes ?? this.employmentTypes,
      experienceLevels: experienceLevels ?? this.experienceLevels,
      isRemote: isRemote ?? this.isRemote,
      category: category ?? this.category,
      salaryMin: salaryMin ?? this.salaryMin,
      company: company ?? this.company,
      sort: sort ?? this.sort,
      seed: seed ?? this.seed,
    );
  }
}
