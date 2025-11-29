import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../../entities/job_entity.dart';
import '../../repositories/company_management_repository.dart';

class CreateJob {
  final CompanyManagementRepository repository;

  CreateJob(this.repository);

  Future<Either<Failure, JobEntity>> call(Map<String, dynamic> data) async {
    return await repository.createJob(data);
  }
}

class UpdateJob {
  final CompanyManagementRepository repository;

  UpdateJob(this.repository);

  Future<Either<Failure, JobEntity>> call(
      int id, Map<String, dynamic> data) async {
    return await repository.updateJob(id, data);
  }
}

class DeleteJob {
  final CompanyManagementRepository repository;

  DeleteJob(this.repository);

  Future<Either<Failure, void>> call(int id) async {
    return await repository.deleteJob(id);
  }
}
