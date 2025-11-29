import 'package:dartz/dartz.dart';
import '../../core/error/exceptions.dart';
import '../../core/error/failures.dart';
import '../../domain/entities/company_entity.dart';
import '../../domain/entities/job_entity.dart';
import '../../domain/repositories/company_management_repository.dart';
import '../datasources/company_management_remote_data_source.dart';

class CompanyManagementRepositoryImpl implements CompanyManagementRepository {
  final CompanyManagementRemoteDataSource remoteDataSource;

  CompanyManagementRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<CompanyEntity>>> getMyCompanies() async {
    try {
      final companies = await remoteDataSource.getMyCompanies();
      return Right(companies);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error occurred: $e'));
    }
  }

  @override
  Future<Either<Failure, CompanyEntity>> getMyCompany(int id) async {
    try {
      final company = await remoteDataSource.getMyCompany(id);
      return Right(company);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error occurred: $e'));
    }
  }

  @override
  Future<Either<Failure, CompanyEntity>> getMyCompanyBySlug(String slug) async {
    try {
      final company = await remoteDataSource.getMyCompanyBySlug(slug);
      return Right(company);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error occurred: $e'));
    }
  }

  @override
  Future<Either<Failure, CompanyEntity>> createCompany(
      Map<String, dynamic> data) async {
    try {
      final company = await remoteDataSource.createCompany(data);
      return Right(company);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error occurred: $e'));
    }
  }

  @override
  Future<Either<Failure, CompanyEntity>> updateCompany(
      int id, Map<String, dynamic> data) async {
    try {
      final company = await remoteDataSource.updateCompany(id, data);
      return Right(company);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error occurred: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteCompany(int id) async {
    try {
      await remoteDataSource.deleteCompany(id);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error occurred: $e'));
    }
  }

  @override
  Future<Either<Failure, List<JobEntity>>> getMyJobs({
    int? companyId,
    String? status,
    int page = 1,
    int perPage = 15,
  }) async {
    try {
      final jobs = await remoteDataSource.getMyJobs(
        companyId: companyId,
        status: status,
        page: page,
        perPage: perPage,
      );
      return Right(jobs);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error occurred: $e'));
    }
  }

  @override
  Future<Either<Failure, JobEntity>> createJob(
      Map<String, dynamic> data) async {
    try {
      final job = await remoteDataSource.createJob(data);
      return Right(job);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error occurred: $e'));
    }
  }

  @override
  Future<Either<Failure, JobEntity>> updateJob(
      int id, Map<String, dynamic> data) async {
    try {
      final job = await remoteDataSource.updateJob(id, data);
      return Right(job);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error occurred: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteJob(int id) async {
    try {
      await remoteDataSource.deleteJob(id);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error occurred: $e'));
    }
  }
}
