import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../entities/company_entity.dart';

abstract class CompanyRepository {
  /// Get all companies with optional filters
  Future<Either<Failure, List<CompanyEntity>>> getCompanies({
    String? search,
    String? city,
    String? country,
    String? sort,
    int page = 1,
    int perPage = 15,
  });

  /// Get a single company by slug
  Future<Either<Failure, CompanyEntity>> getCompanyBySlug(String slug);
}
