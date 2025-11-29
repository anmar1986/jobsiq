import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../../entities/company_entity.dart';
import '../../repositories/company_management_repository.dart';

class GetMyCompanies {
  final CompanyManagementRepository repository;

  GetMyCompanies(this.repository);

  Future<Either<Failure, List<CompanyEntity>>> call() async {
    return await repository.getMyCompanies();
  }
}
