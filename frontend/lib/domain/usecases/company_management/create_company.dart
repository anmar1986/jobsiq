import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../../entities/company_entity.dart';
import '../../repositories/company_management_repository.dart';

class CreateCompany {
  final CompanyManagementRepository repository;

  CreateCompany(this.repository);

  Future<Either<Failure, CompanyEntity>> call(Map<String, dynamic> data) async {
    return await repository.createCompany(data);
  }
}
