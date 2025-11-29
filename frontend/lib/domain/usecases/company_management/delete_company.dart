import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../../repositories/company_management_repository.dart';

class DeleteCompany {
  final CompanyManagementRepository repository;

  DeleteCompany(this.repository);

  Future<Either<Failure, void>> call(int id) async {
    return await repository.deleteCompany(id);
  }
}
