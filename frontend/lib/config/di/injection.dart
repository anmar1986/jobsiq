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
import '../../data/repositories/auth_repository_impl.dart';
import '../../data/repositories/job_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/repositories/job_repository.dart';
import '../../domain/usecases/auth/check_authentication_usecase.dart';
import '../../domain/usecases/auth/get_current_user_usecase.dart';
import '../../domain/usecases/auth/login_usecase.dart';
import '../../domain/usecases/auth/logout_usecase.dart';
import '../../domain/usecases/auth/register_usecase.dart';
import '../../domain/usecases/auth/update_profile_usecase.dart';
import '../../domain/usecases/auth/change_password_usecase.dart';
import '../../domain/usecases/jobs/get_jobs_usecase.dart';
import '../../domain/usecases/jobs/get_featured_jobs_usecase.dart';
import '../../presentation/bloc/auth/auth_bloc.dart';
import '../../presentation/bloc/jobs/jobs_bloc.dart';
import '../../presentation/bloc/saved_jobs/saved_jobs_bloc.dart';
import '../../presentation/bloc/cvs/cvs_bloc.dart';
import '../../presentation/bloc/companies/companies_bloc.dart';

final sl = GetIt.instance;

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
      companyDataSource: sl(),
    ),
  );
}
