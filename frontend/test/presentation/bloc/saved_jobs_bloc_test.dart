import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:jobsiq_mobile/data/datasources/saved_job_remote_data_source.dart';
import 'package:jobsiq_mobile/data/models/job_model.dart';
import 'package:jobsiq_mobile/presentation/bloc/saved_jobs/saved_jobs_bloc.dart';
import 'package:jobsiq_mobile/presentation/bloc/saved_jobs/saved_jobs_event.dart';
import 'package:jobsiq_mobile/presentation/bloc/saved_jobs/saved_jobs_state.dart';

import 'saved_jobs_bloc_test.mocks.dart';

@GenerateMocks([
  SavedJobRemoteDataSource,
])
void main() {
  late SavedJobsBloc bloc;
  late MockSavedJobRemoteDataSource mockSavedJobDataSource;

  setUp(() {
    mockSavedJobDataSource = MockSavedJobRemoteDataSource();
    bloc = SavedJobsBloc(savedJobDataSource: mockSavedJobDataSource);
  });

  tearDown(() {
    bloc.close();
  });

  group('SavedJobsBloc', () {
    final tJob1 = JobModel(
      id: 1,
      title: 'Flutter Developer',
      slug: 'flutter-developer',
      description: 'Build amazing apps',
      employmentType: 'full-time',
      isRemote: true,
      isFeatured: false,
      isActive: true,
      isSaved: true,
      createdAt: DateTime(2024, 1, 1),
      updatedAt: DateTime(2024, 1, 1),
    );

    final tJob2 = JobModel(
      id: 2,
      title: 'Senior Flutter Developer',
      slug: 'senior-flutter-developer',
      description: 'Lead amazing projects',
      employmentType: 'full-time',
      isRemote: true,
      isFeatured: true,
      isActive: true,
      isSaved: true,
      createdAt: DateTime(2024, 1, 2),
      updatedAt: DateTime(2024, 1, 2),
    );

    final List<JobModel> tSavedJobs = [tJob1, tJob2];

    test('initial state should be SavedJobsInitial', () {
      expect(bloc.state, equals(SavedJobsInitial()));
    });

    group('LoadSavedJobsEvent', () {
      blocTest<SavedJobsBloc, SavedJobsState>(
        'emits [SavedJobsLoading, SavedJobsLoaded] when loading succeeds with jobs',
        build: () {
          when(mockSavedJobDataSource.getSavedJobs()).thenAnswer(
            (_) async => tSavedJobs,
          );
          return bloc;
        },
        act: (bloc) => bloc.add(const LoadSavedJobsEvent()),
        expect: () => [
          SavedJobsLoading(),
          SavedJobsLoaded(tSavedJobs),
        ],
        verify: (_) {
          verify(mockSavedJobDataSource.getSavedJobs()).called(1);
        },
      );

      blocTest<SavedJobsBloc, SavedJobsState>(
        'emits [SavedJobsLoading, SavedJobsEmpty] when loading succeeds with empty list',
        build: () {
          when(mockSavedJobDataSource.getSavedJobs()).thenAnswer(
            (_) async => [],
          );
          return bloc;
        },
        act: (bloc) => bloc.add(const LoadSavedJobsEvent()),
        expect: () => [
          SavedJobsLoading(),
          SavedJobsEmpty(),
        ],
      );

      blocTest<SavedJobsBloc, SavedJobsState>(
        'emits [SavedJobsLoading, SavedJobsError] when loading fails',
        build: () {
          when(mockSavedJobDataSource.getSavedJobs()).thenThrow(
            Exception('Failed to load saved jobs'),
          );
          return bloc;
        },
        act: (bloc) => bloc.add(const LoadSavedJobsEvent()),
        expect: () => [
          SavedJobsLoading(),
          const SavedJobsError('Failed to load saved jobs. Please try again.'),
        ],
      );

      blocTest<SavedJobsBloc, SavedJobsState>(
        'emits login message when 401 error occurs',
        build: () {
          when(mockSavedJobDataSource.getSavedJobs()).thenThrow(
            Exception('401 Unauthorized'),
          );
          return bloc;
        },
        act: (bloc) => bloc.add(const LoadSavedJobsEvent()),
        expect: () => [
          SavedJobsLoading(),
          const SavedJobsError('Please login to view saved jobs'),
        ],
      );

      blocTest<SavedJobsBloc, SavedJobsState>(
        'emits login message when unauthorized error occurs',
        build: () {
          when(mockSavedJobDataSource.getSavedJobs()).thenThrow(
            Exception('Unauthorized access'),
          );
          return bloc;
        },
        act: (bloc) => bloc.add(const LoadSavedJobsEvent()),
        expect: () => [
          SavedJobsLoading(),
          const SavedJobsError('Please login to view saved jobs'),
        ],
      );
    });

    group('RemoveSavedJobEvent', () {
      blocTest<SavedJobsBloc, SavedJobsState>(
        'emits SavedJobsLoaded with remaining jobs when removal succeeds',
        build: () {
          when(mockSavedJobDataSource.toggleSaveJob(any)).thenAnswer(
            (_) async => true,
          );
          return bloc;
        },
        seed: () => SavedJobsLoaded(tSavedJobs),
        act: (bloc) => bloc.add(const RemoveSavedJobEvent(1)),
        expect: () => [
          SavedJobsLoaded([tJob2]),
        ],
        verify: (_) {
          verify(mockSavedJobDataSource.toggleSaveJob(1)).called(1);
        },
      );

      blocTest<SavedJobsBloc, SavedJobsState>(
        'emits SavedJobsEmpty when removing the last job',
        build: () {
          when(mockSavedJobDataSource.toggleSaveJob(any)).thenAnswer(
            (_) async => true,
          );
          return bloc;
        },
        seed: () => SavedJobsLoaded([tJob1]),
        act: (bloc) => bloc.add(const RemoveSavedJobEvent(1)),
        expect: () => [
          SavedJobsEmpty(),
        ],
      );

      blocTest<SavedJobsBloc, SavedJobsState>(
        'keeps current state when removal fails',
        build: () {
          when(mockSavedJobDataSource.toggleSaveJob(any)).thenThrow(
            Exception('Failed to remove saved job'),
          );
          return bloc;
        },
        seed: () => SavedJobsLoaded(tSavedJobs),
        act: (bloc) => bloc.add(const RemoveSavedJobEvent(1)),
        // The bloc catches the error but doesn't emit (keeps same state instance)
        expect: () => [],
      );

      blocTest<SavedJobsBloc, SavedJobsState>(
        'does nothing when state is not SavedJobsLoaded',
        build: () => bloc,
        seed: () => SavedJobsLoading(),
        act: (bloc) => bloc.add(const RemoveSavedJobEvent(1)),
        expect: () => [],
        verify: (_) {
          verifyNever(mockSavedJobDataSource.toggleSaveJob(any));
        },
      );

      blocTest<SavedJobsBloc, SavedJobsState>(
        'removes correct job from list',
        build: () {
          when(mockSavedJobDataSource.toggleSaveJob(any)).thenAnswer(
            (_) async => true,
          );
          return bloc;
        },
        seed: () => SavedJobsLoaded(tSavedJobs),
        act: (bloc) => bloc.add(const RemoveSavedJobEvent(2)),
        expect: () => [
          SavedJobsLoaded([tJob1]),
        ],
        verify: (_) {
          verify(mockSavedJobDataSource.toggleSaveJob(2)).called(1);
        },
      );
    });
  });
}
