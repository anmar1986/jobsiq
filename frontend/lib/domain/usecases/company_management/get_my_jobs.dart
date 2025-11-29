import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../../entities/job_entity.dart';
import '../../repositories/company_management_repository.dart';

class GetMyJobs {
  final CompanyManagementRepository repository;

  GetMyJobs(this.repository);

  Future<Either<Failure, List<JobEntity>>> call({
    int? companyId,
    String? status,
    int page = 1,
    int perPage = 15,
  }) async {
    return await repository.getMyJobs(
      companyId: companyId,
      status: status,
      page: page,
      perPage: perPage,
    );
  }
}
