import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/network/dio_client.dart';
import '../../core/network/network_info.dart';
import '../../data/datasources/auth_local_data_source.dart';
import '../../data/datasources/auth_remote_data_source.dart';
import '../../data/datasources/job_remote_data_source.dart';
import '../../data/datasources/saved_job_remote_data_source.dart';
import '../../data/datasources/job_application_remote_data_source.dart';
import '../../data/datasources/cv_remote_data_source.dart';
import '../../data/datasources/company_remote_data_source.dart';
import '../../data/datasources/company_management_remote_data_source.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../data/repositories/job_repository_impl.dart';
import '../../data/repositories/company_repository_impl.dart';
import '../../data/repositories/company_management_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/repositories/job_repository.dart';
import '../../domain/repositories/company_repository.dart';
import '../../domain/repositories/company_management_repository.dart';
import '../../domain/usecases/auth/check_authentication_usecase.dart';
import '../../domain/usecases/auth/get_current_user_usecase.dart';
import '../../domain/usecases/auth/login_usecase.dart';
import '../../domain/usecases/auth/logout_usecase.dart';
import '../../domain/usecases/auth/register_usecase.dart';
import '../../domain/usecases/auth/update_profile_usecase.dart';
import '../../domain/usecases/auth/change_password_usecase.dart';
import '../../domain/usecases/jobs/get_jobs_usecase.dart';
import '../../domain/usecases/jobs/get_featured_jobs_usecase.dart';
import '../../domain/usecases/company_management/get_my_companies.dart';
import '../../domain/usecases/company_management/get_my_company.dart';
import '../../domain/usecases/company_management/create_company.dart';
import '../../domain/usecases/company_management/update_company.dart';
import '../../domain/usecases/company_management/delete_company.dart';
import '../../domain/usecases/company_management/get_my_jobs.dart';
import '../../domain/usecases/company_management/job_management.dart';
import '../../presentation/bloc/auth/auth_bloc.dart';
import '../../presentation/bloc/jobs/jobs_bloc.dart';
import '../../presentation/bloc/saved_jobs/saved_jobs_bloc.dart';
import '../../presentation/bloc/cvs/cvs_bloc.dart';
import '../../presentation/bloc/companies/companies_bloc.dart';
import '../../presentation/bloc/company_management/company_management_bloc.dart';
import '../../presentation/bloc/theme/theme_bloc.dart';

final sl = GetIt.instance;
// Alias for compatibility
final getIt = sl;

Future<void> initializeDependencies() async {
  // External Dependencies
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => const FlutterSecureStorage());
  sl.registerLazySingleton(() => Dio());
  sl.registerLazySingleton(() => Connectivity());
  sl.registerLazySingleton(() => Logger());

  // Core
  sl.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(sl()),
  );

  sl.registerLazySingleton(
    () => DioClient(
      dio: sl(),
      secureStorage: sl(),
      logger: sl(),
    ),
  );

  // Data Sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(client: sl()),
  );

  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(
      secureStorage: sl(),
      sharedPreferences: sl(),
    ),
  );

  sl.registerLazySingleton<JobRemoteDataSource>(
    () => JobRemoteDataSourceImpl(client: sl()),
  );

  sl.registerLazySingleton<SavedJobRemoteDataSource>(
    () => SavedJobRemoteDataSourceImpl(client: sl()),
  );

  sl.registerLazySingleton<JobApplicationRemoteDataSource>(
    () => JobApplicationRemoteDataSourceImpl(client: sl()),
  );

  sl.registerLazySingleton<CvRemoteDataSource>(
    () => CvRemoteDataSourceImpl(client: sl()),
  );

  sl.registerLazySingleton<CompanyRemoteDataSource>(
    () => CompanyRemoteDataSourceImpl(client: sl()),
  );

  sl.registerLazySingleton<CompanyManagementRemoteDataSource>(
    () => CompanyManagementRemoteDataSourceImpl(client: sl()),
  );

  // Repositories
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  sl.registerLazySingleton<JobRepository>(
    () => JobRepositoryImpl(
      remoteDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  sl.registerLazySingleton<CompanyRepository>(
    () => CompanyRepositoryImpl(
      remoteDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  sl.registerLazySingleton<CompanyManagementRepository>(
    () => CompanyManagementRepositoryImpl(
      remoteDataSource: sl(),
    ),
  );

  // Use Cases - Auth
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => RegisterUseCase(sl()));
  sl.registerLazySingleton(() => LogoutUseCase(sl()));
  sl.registerLazySingleton(() => GetCurrentUserUseCase(sl()));
  sl.registerLazySingleton(() => CheckAuthenticationUseCase(sl()));
  sl.registerLazySingleton(() => UpdateProfileUseCase(sl()));
  sl.registerLazySingleton(() => ChangePasswordUseCase(sl()));

  // Use Cases - Jobs
  sl.registerLazySingleton(() => GetJobsUseCase(sl()));
  sl.registerLazySingleton(() => GetFeaturedJobsUseCase(sl()));

  // Use Cases - Company Management
  sl.registerLazySingleton(() => GetMyCompanies(sl()));
  sl.registerLazySingleton(() => GetMyCompany(sl()));
  sl.registerLazySingleton(() => GetMyCompanyBySlug(sl()));
  sl.registerLazySingleton(() => CreateCompany(sl()));
  sl.registerLazySingleton(() => UpdateCompany(sl()));
  sl.registerLazySingleton(() => DeleteCompany(sl()));
  sl.registerLazySingleton(() => GetMyJobs(sl()));
  sl.registerLazySingleton(() => CreateJob(sl()));
  sl.registerLazySingleton(() => UpdateJob(sl()));
  sl.registerLazySingleton(() => DeleteJob(sl()));

  // BLoC
  sl.registerFactory(
    () => AuthBloc(
      loginUseCase: sl(),
      registerUseCase: sl(),
      logoutUseCase: sl(),
      getCurrentUserUseCase: sl(),
      checkAuthenticationUseCase: sl(),
      updateProfileUseCase: sl(),
      changePasswordUseCase: sl(),
    ),
  );

  sl.registerFactory(
    () => JobsBloc(
      getJobsUseCase: sl(),
      getFeaturedJobsUseCase: sl(),
      savedJobDataSource: sl(),
      jobApplicationDataSource: sl(),
      jobRepository: sl(),
    ),
  );

  sl.registerFactory(
    () => SavedJobsBloc(
      savedJobDataSource: sl(),
    ),
  );

  sl.registerFactory(
    () => CvsBloc(
      cvDataSource: sl(),
    ),
  );

  sl.registerFactory(
    () => CompaniesBloc(
      companyRepository: sl(),
    ),
  );

  sl.registerFactory(
    () => CompanyManagementBloc(
      getMyCompanies: sl(),
      getMyCompany: sl(),
      getMyCompanyBySlug: sl(),
      createCompany: sl(),
      updateCompany: sl(),
      deleteCompany: sl(),
      getMyJobs: sl(),
      createJob: sl(),
      updateJob: sl(),
      deleteJob: sl(),
    ),
  );

  sl.registerFactory(
    () => ThemeBloc(
      sharedPreferences: sl(),
    ),
  );
}
