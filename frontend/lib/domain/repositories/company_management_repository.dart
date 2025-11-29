import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../entities/company_entity.dart';
import '../entities/job_entity.dart';

abstract class CompanyManagementRepository {
  /// Get all companies owned by the authenticated user
  Future<Either<Failure, List<CompanyEntity>>> getMyCompanies();

  /// Get a single owned company by ID
  Future<Either<Failure, CompanyEntity>> getMyCompany(int id);

  /// Get a single owned company by slug
  Future<Either<Failure, CompanyEntity>> getMyCompanyBySlug(String slug);

  /// Create a new company
  Future<Either<Failure, CompanyEntity>> createCompany(
      Map<String, dynamic> data);

  /// Update an existing company
  Future<Either<Failure, CompanyEntity>> updateCompany(
      int id, Map<String, dynamic> data);

  /// Delete a company
  Future<Either<Failure, void>> deleteCompany(int id);

  /// Get all jobs for owned companies
  Future<Either<Failure, List<JobEntity>>> getMyJobs({
    int? companyId,
    String? status,
    int page = 1,
    int perPage = 15,
  });

  /// Create a new job
  Future<Either<Failure, JobEntity>> createJob(Map<String, dynamic> data);

  /// Update an existing job
  Future<Either<Failure, JobEntity>> updateJob(
      int id, Map<String, dynamic> data);

  /// Delete a job
  Future<Either<Failure, void>> deleteJob(int id);
}
