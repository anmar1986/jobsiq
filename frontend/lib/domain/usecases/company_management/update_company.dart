import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../../entities/company_entity.dart';
import '../../repositories/company_management_repository.dart';

class UpdateCompany {
  final CompanyManagementRepository repository;

  UpdateCompany(this.repository);

  Future<Either<Failure, CompanyEntity>> call(
      int id, Map<String, dynamic> data) async {
    return await repository.updateCompany(id, data);
  }
}
