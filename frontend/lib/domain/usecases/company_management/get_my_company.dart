import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../../entities/company_entity.dart';
import '../../repositories/company_management_repository.dart';

class GetMyCompany {
  final CompanyManagementRepository repository;

  GetMyCompany(this.repository);

  Future<Either<Failure, CompanyEntity>> call(int id) async {
    return await repository.getMyCompany(id);
  }
}

class GetMyCompanyBySlug {
  final CompanyManagementRepository repository;

  GetMyCompanyBySlug(this.repository);

  Future<Either<Failure, CompanyEntity>> call(String slug) async {
    return await repository.getMyCompanyBySlug(slug);
  }
}
