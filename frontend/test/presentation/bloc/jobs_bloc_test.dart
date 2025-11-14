import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:jobsiq_mobile/core/error/failures.dart';
import 'package:jobsiq_mobile/data/datasources/saved_job_remote_data_source.dart';
import 'package:jobsiq_mobile/data/datasources/job_application_remote_data_source.dart';
import 'package:jobsiq_mobile/domain/entities/job_entity.dart';
import 'package:jobsiq_mobile/domain/repositories/job_repository.dart';
import 'package:jobsiq_mobile/domain/usecases/jobs/get_jobs_usecase.dart';
import 'package:jobsiq_mobile/domain/usecases/jobs/get_featured_jobs_usecase.dart';
import 'package:jobsiq_mobile/presentation/bloc/jobs/jobs_bloc.dart';
import 'package:jobsiq_mobile/presentation/bloc/jobs/jobs_event.dart';
import 'package:jobsiq_mobile/presentation/bloc/jobs/jobs_state.dart';

import 'jobs_bloc_test.mocks.dart';

@GenerateMocks([
  GetJobsUseCase,
  GetFeaturedJobsUseCase,
  SavedJobRemoteDataSource,
  JobApplicationRemoteDataSource,
])
void main() {
  late JobsBloc bloc;
  late MockGetJobsUseCase mockGetJobsUseCase;
  late MockGetFeaturedJobsUseCase mockGetFeaturedJobsUseCase;
  late MockSavedJobRemoteDataSource mockSavedJobDataSource;
  late MockJobApplicationRemoteDataSource mockJobApplicationDataSource;

  setUp(() {
    mockGetJobsUseCase = MockGetJobsUseCase();
    mockGetFeaturedJobsUseCase = MockGetFeaturedJobsUseCase();
    mockSavedJobDataSource = MockSavedJobRemoteDataSource();
    mockJobApplicationDataSource = MockJobApplicationRemoteDataSource();

    bloc = JobsBloc(
      getJobsUseCase: mockGetJobsUseCase,
      getFeaturedJobsUseCase: mockGetFeaturedJobsUseCase,
      savedJobDataSource: mockSavedJobDataSource,
      jobApplicationDataSource: mockJobApplicationDataSource,
    );
  });

  tearDown(() {
    bloc.close();
  });

  group('JobsBloc', () {
    final tJob = JobEntity(
      id: 1,
      title: 'Flutter Developer',
      slug: 'flutter-developer',
      description: 'Build amazing apps',
      employmentType: 'full-time',
      isRemote: true,
      isFeatured: false,
      isActive: true,
      createdAt: DateTime(2024, 1, 1),
      updatedAt: DateTime(2024, 1, 1),
      company: const CompanyBriefEntity(
        id: 1,
        name: 'Tech Corp',
        slug: 'tech-corp',
      ),
    );

    final tJobsResult = JobsResult(
      jobs: [tJob],
      currentPage: 1,
      lastPage: 5,
      perPage: 15,
      total: 75,
      seed: 12345,
    );

    test('initial state should be JobsInitial', () {
      expect(bloc.state, equals(JobsInitial()));
    });

    group('LoadJobsEvent', () {
      blocTest<JobsBloc, JobsState>(
        'emits [JobsLoading, JobsLoaded] when getJobs succeeds',
        build: () {
          when(mockGetJobsUseCase(any)).thenAnswer(
            (_) async => Right(tJobsResult),
          );
          return bloc;
        },
        act: (bloc) => bloc.add(const LoadJobsEvent()),
        expect: () => [
          JobsLoading(),
          JobsLoaded(
            jobs: [tJob],
            currentPage: 1,
            lastPage: 5,
            total: 75,
            hasMore: true,
            seed: 12345,
          ),
        ],
        verify: (_) {
          verify(mockGetJobsUseCase(any)).called(1);
        },
      );

      blocTest<JobsBloc, JobsState>(
        'emits [JobsLoading, JobsError] when getJobs fails',
        build: () {
          when(mockGetJobsUseCase(any)).thenAnswer(
            (_) async => const Left(ServerFailure('Server error')),
          );
          return bloc;
        },
        act: (bloc) => bloc.add(const LoadJobsEvent()),
        expect: () => [
          JobsLoading(),
          const JobsError('Server error'),
        ],
      );

      blocTest<JobsBloc, JobsState>(
        'emits JobsLoaded with correct hasMore=false when on last page',
        build: () {
          final lastPageResult = JobsResult(
            jobs: [tJob],
            currentPage: 5,
            lastPage: 5,
            perPage: 15,
            total: 75,
            seed: 12345,
          );
          when(mockGetJobsUseCase(any)).thenAnswer(
            (_) async => Right(lastPageResult),
          );
          return bloc;
        },
        act: (bloc) => bloc.add(const LoadJobsEvent()),
        expect: () => [
          JobsLoading(),
          JobsLoaded(
            jobs: [tJob],
            currentPage: 5,
            lastPage: 5,
            total: 75,
            hasMore: false,
            seed: 12345,
          ),
        ],
      );

      blocTest<JobsBloc, JobsState>(
        'passes search parameters correctly',
        build: () {
          when(mockGetJobsUseCase(any)).thenAnswer(
            (_) async => Right(tJobsResult),
          );
          return bloc;
        },
        act: (bloc) => bloc.add(
          const LoadJobsEvent(
            search: 'Flutter',
            location: 'Remote',
            employmentTypes: ['full-time'],
            experienceLevels: ['senior'],
            isRemote: true,
          ),
        ),
        verify: (_) {
          final captured = verify(mockGetJobsUseCase(captureAny)).captured;
          final params = captured.first as GetJobsParams;
          expect(params.search, 'Flutter');
          expect(params.location, 'Remote');
          expect(params.employmentTypes, ['full-time']);
          expect(params.experienceLevels, ['senior']);
          expect(params.isRemote, true);
        },
      );

      blocTest<JobsBloc, JobsState>(
        'generates new seed when refresh=true',
        build: () {
          when(mockGetJobsUseCase(any)).thenAnswer(
            (_) async => Right(tJobsResult),
          );
          return bloc;
        },
        act: (bloc) => bloc.add(const LoadJobsEvent(refresh: true)),
        verify: (_) {
          final captured = verify(mockGetJobsUseCase(captureAny)).captured;
          final params = captured.first as GetJobsParams;
          expect(params.seed, isNull);
        },
      );
    });

    group('LoadMoreJobsEvent', () {
      final tJob2 = JobEntity(
        id: 2,
        title: 'Senior Flutter Developer',
        slug: 'senior-flutter-developer',
        description: 'Lead amazing projects',
        employmentType: 'full-time',
        isRemote: true,
        isFeatured: false,
        isActive: true,
        createdAt: DateTime(2024, 1, 2),
        updatedAt: DateTime(2024, 1, 2),
      );

      final tMoreJobsResult = JobsResult(
        jobs: [tJob2],
        currentPage: 2,
        lastPage: 5,
        perPage: 15,
        total: 75,
        seed: 12345,
      );

      blocTest<JobsBloc, JobsState>(
        'emits [JobsLoadingMore, JobsLoaded] with combined jobs when getJobs succeeds',
        build: () {
          // Setup mock to return both initial jobs and more jobs
          when(mockGetJobsUseCase(any)).thenAnswer((invocation) async {
            final params = invocation.positionalArguments[0] as GetJobsParams;
            if (params.page == 1) {
              return Right(tJobsResult);
            } else {
              return Right(tMoreJobsResult);
            }
          });
          return bloc;
        },
        act: (bloc) async {
          // First load jobs to initialize _currentParams
          bloc.add(const LoadJobsEvent());
          await Future.delayed(const Duration(milliseconds: 100));
          // Then load more jobs
          bloc.add(const LoadMoreJobsEvent());
        },
        expect: () => [
          JobsLoading(),
          JobsLoaded(
            jobs: [tJob],
            currentPage: 1,
            lastPage: 5,
            total: 75,
            hasMore: true,
            seed: 12345,
          ),
          JobsLoadingMore([tJob]),
          JobsLoaded(
            jobs: [tJob, tJob2],
            currentPage: 2,
            lastPage: 5,
            total: 75,
            hasMore: true,
            seed: 12345,
          ),
        ],
      );

      blocTest<JobsBloc, JobsState>(
        'does nothing when state is not JobsLoaded',
        build: () => bloc,
        seed: () => JobsLoading(),
        act: (bloc) => bloc.add(const LoadMoreJobsEvent()),
        expect: () => [],
        verify: (_) {
          verifyNever(mockGetJobsUseCase(any));
        },
      );

      blocTest<JobsBloc, JobsState>(
        'does nothing when hasMore is false',
        build: () => bloc,
        seed: () => JobsLoaded(
          jobs: [tJob],
          currentPage: 5,
          lastPage: 5,
          total: 75,
          hasMore: false,
          seed: 12345,
        ),
        act: (bloc) => bloc.add(const LoadMoreJobsEvent()),
        expect: () => [],
        verify: (_) {
          verifyNever(mockGetJobsUseCase(any));
        },
      );

      blocTest<JobsBloc, JobsState>(
        'reverts to previous state on error',
        build: () {
          // Setup mock to return success first, then error
          when(mockGetJobsUseCase(any)).thenAnswer((invocation) async {
            final params = invocation.positionalArguments[0] as GetJobsParams;
            if (params.page == 1) {
              return Right(tJobsResult);
            } else {
              return const Left(ServerFailure('Network error'));
            }
          });
          return bloc;
        },
        act: (bloc) async {
          // First load jobs
          bloc.add(const LoadJobsEvent());
          await Future.delayed(const Duration(milliseconds: 100));
          // Then try to load more (will fail)
          bloc.add(const LoadMoreJobsEvent());
        },
        expect: () => [
          JobsLoading(),
          JobsLoaded(
            jobs: [tJob],
            currentPage: 1,
            lastPage: 5,
            total: 75,
            hasMore: true,
            seed: 12345,
          ),
          JobsLoadingMore([tJob]),
          JobsLoaded(
            jobs: [tJob],
            currentPage: 1,
            lastPage: 5,
            total: 75,
            hasMore: true,
            seed: 12345,
          ),
        ],
      );

      blocTest<JobsBloc, JobsState>(
        'uses existing seed for pagination consistency',
        build: () {
          // Setup mock to return both initial jobs and more jobs
          when(mockGetJobsUseCase(any)).thenAnswer((invocation) async {
            final params = invocation.positionalArguments[0] as GetJobsParams;
            if (params.page == 1) {
              return Right(tJobsResult);
            } else {
              return Right(tMoreJobsResult);
            }
          });
          return bloc;
        },
        act: (bloc) async {
          // First load jobs
          bloc.add(const LoadJobsEvent());
          await Future.delayed(const Duration(milliseconds: 100));
          // Then load more
          bloc.add(const LoadMoreJobsEvent());
        },
        verify: (_) {
          final captured = verify(mockGetJobsUseCase(captureAny)).captured;
          // Should have 2 calls: first for initial load, second for loading more
          expect(captured.length, 2);
          final firstParams = captured[0] as GetJobsParams;
          final secondParams = captured[1] as GetJobsParams;
          expect(firstParams.page, 1);
          expect(secondParams.page, 2);
          expect(secondParams.seed, 12345);
        },
      );
    });

    group('LoadFeaturedJobsEvent', () {
      final tFeaturedJob = JobEntity(
        id: 1,
        title: 'Flutter Developer',
        slug: 'flutter-developer',
        description: 'Build amazing apps',
        employmentType: 'full-time',
        isRemote: true,
        isFeatured: true,
        isActive: true,
        createdAt: DateTime(2024, 1, 1),
        updatedAt: DateTime(2024, 1, 1),
        company: const CompanyBriefEntity(
          id: 1,
          name: 'Tech Corp',
          slug: 'tech-corp',
        ),
      );
      final tFeaturedJobs = [tFeaturedJob];

      blocTest<JobsBloc, JobsState>(
        'emits [FeaturedJobsLoading, FeaturedJobsLoaded] when getFeaturedJobs succeeds',
        build: () {
          when(mockGetFeaturedJobsUseCase(any)).thenAnswer(
            (_) async => Right(tFeaturedJobs),
          );
          return bloc;
        },
        act: (bloc) => bloc.add(const LoadFeaturedJobsEvent()),
        expect: () => [
          FeaturedJobsLoading(),
          FeaturedJobsLoaded(tFeaturedJobs),
        ],
      );

      blocTest<JobsBloc, JobsState>(
        'emits [FeaturedJobsLoading, FeaturedJobsError] when getFeaturedJobs fails',
        build: () {
          when(mockGetFeaturedJobsUseCase(any)).thenAnswer(
            (_) async => const Left(ServerFailure('Server error')),
          );
          return bloc;
        },
        act: (bloc) => bloc.add(const LoadFeaturedJobsEvent()),
        expect: () => [
          FeaturedJobsLoading(),
          const FeaturedJobsError('Server error'),
        ],
      );

      blocTest<JobsBloc, JobsState>(
        'passes limit parameter correctly',
        build: () {
          when(mockGetFeaturedJobsUseCase(any)).thenAnswer(
            (_) async => Right(tFeaturedJobs),
          );
          return bloc;
        },
        act: (bloc) => bloc.add(const LoadFeaturedJobsEvent(limit: 10)),
        verify: (_) {
          final captured =
              verify(mockGetFeaturedJobsUseCase(captureAny)).captured;
          final params = captured.first as GetFeaturedJobsParams;
          expect(params.limit, 10);
        },
      );
    });

    group('SearchJobsEvent', () {
      blocTest<JobsBloc, JobsState>(
        'triggers LoadJobsEvent with search parameters',
        build: () {
          when(mockGetJobsUseCase(any)).thenAnswer(
            (_) async => Right(tJobsResult),
          );
          return bloc;
        },
        act: (bloc) => bloc.add(const SearchJobsEvent('Flutter')),
        expect: () => [
          JobsLoading(),
          JobsLoaded(
            jobs: [tJob],
            currentPage: 1,
            lastPage: 5,
            total: 75,
            hasMore: true,
            seed: 12345,
          ),
        ],
        verify: (_) {
          final captured = verify(mockGetJobsUseCase(captureAny)).captured;
          final params = captured.first as GetJobsParams;
          expect(params.search, 'Flutter');
        },
      );
    });

    group('Network Failures', () {
      blocTest<JobsBloc, JobsState>(
        'emits JobsError with network message on NetworkFailure',
        build: () {
          when(mockGetJobsUseCase(any)).thenAnswer(
            (_) async => const Left(NetworkFailure('No internet connection')),
          );
          return bloc;
        },
        act: (bloc) => bloc.add(const LoadJobsEvent()),
        expect: () => [
          JobsLoading(),
          const JobsError(
              'No internet connection. Please check your connection.'),
        ],
      );

      blocTest<JobsBloc, JobsState>(
        'emits FeaturedJobsError with network message on NetworkFailure',
        build: () {
          when(mockGetFeaturedJobsUseCase(any)).thenAnswer(
            (_) async => const Left(NetworkFailure('No internet connection')),
          );
          return bloc;
        },
        act: (bloc) => bloc.add(const LoadFeaturedJobsEvent()),
        expect: () => [
          FeaturedJobsLoading(),
          const FeaturedJobsError(
              'No internet connection. Please check your connection.'),
        ],
      );
    });
  });
}
