import 'package:dartz/dartz.dart';
import '../../core/error/exceptions.dart';
import '../../core/error/failures.dart';
import '../../core/network/network_info.dart';
import '../../domain/entities/job_entity.dart';
import '../../domain/repositories/job_repository.dart';
import '../datasources/job_remote_data_source.dart';

class JobRepositoryImpl implements JobRepository {
  final JobRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  JobRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, JobsResult>> getJobs({
    int page = 1,
    int perPage = 15,
    String? search,
    String? location,
    List<String>? employmentTypes,
    List<String>? experienceLevels,
    bool? isRemote,
    String? category,
    double? salaryMin,
    String? company,
    String? sort,
    int? seed,
  }) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure('No internet connection'));
    }

    try {
      final response = await remoteDataSource.getJobs(
        page: page,
        perPage: perPage,
        search: search,
        location: location,
        employmentTypes: employmentTypes,
        experienceLevels: experienceLevels,
        isRemote: isRemote,
        category: category,
        salaryMin: salaryMin,
        company: company,
        sort: sort,
        seed: seed,
      );

      return Right(JobsResult(
        jobs: response.data,
        currentPage: response.currentPage,
        lastPage: response.lastPage,
        perPage: response.perPage,
        total: response.total,
        seed: response.seed,
      ));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('An unexpected error occurred: $e'));
    }
  }

  @override
  Future<Either<Failure, List<JobEntity>>> getFeaturedJobs({
    int limit = 6,
  }) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure('No internet connection'));
    }

    try {
      final jobs = await remoteDataSource.getFeaturedJobs(limit: limit);
      return Right(jobs);
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('An unexpected error occurred: $e'));
    }
  }

  @override
  Future<Either<Failure, JobEntity>> getJobBySlug(String slug) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure('No internet connection'));
    }

    try {
      final job = await remoteDataSource.getJobBySlug(slug);
      return Right(job);
    } on NotFoundException catch (e) {
      return Left(NotFoundFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('An unexpected error occurred: $e'));
    }
  }

  @override
  Future<Either<Failure, List<JobEntity>>> getMyJobs() async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure('No internet connection'));
    }

    try {
      final jobs = await remoteDataSource.getMyJobs();
      return Right(jobs);
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('An unexpected error occurred: $e'));
    }
  }
}
