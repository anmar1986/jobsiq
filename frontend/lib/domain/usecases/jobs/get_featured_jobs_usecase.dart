import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../../../core/usecases/usecase.dart';
import '../../entities/job_entity.dart';
import '../../repositories/job_repository.dart';

class GetFeaturedJobsUseCase
    implements UseCase<List<JobEntity>, GetFeaturedJobsParams> {
  final JobRepository repository;

  GetFeaturedJobsUseCase(this.repository);

  @override
  Future<Either<Failure, List<JobEntity>>> call(
      GetFeaturedJobsParams params) async {
    return await repository.getFeaturedJobs(limit: params.limit);
  }
}

class GetFeaturedJobsParams {
  final int limit;

  GetFeaturedJobsParams({this.limit = 6});
}
