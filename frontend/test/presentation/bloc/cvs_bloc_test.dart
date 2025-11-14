import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:jobsiq_mobile/data/datasources/cv_remote_data_source.dart';
import 'package:jobsiq_mobile/data/models/cv_model.dart';
import 'package:jobsiq_mobile/presentation/bloc/cvs/cvs_bloc.dart';
import 'package:jobsiq_mobile/presentation/bloc/cvs/cvs_event.dart';
import 'package:jobsiq_mobile/presentation/bloc/cvs/cvs_state.dart';

import 'cvs_bloc_test.mocks.dart';

@GenerateMocks([
  CvRemoteDataSource,
])
void main() {
  late CvsBloc bloc;
  late MockCvRemoteDataSource mockCvDataSource;

  setUp(() {
    mockCvDataSource = MockCvRemoteDataSource();
    bloc = CvsBloc(cvDataSource: mockCvDataSource);
  });

  tearDown(() {
    bloc.close();
  });

  group('CvsBloc', () {
    final tCv1 = CvModel(
      id: 1,
      userId: 1,
      title: 'Software Engineer CV',
      slug: 'software-engineer-cv',
      fullName: 'John Doe',
      email: 'john@example.com',
      phone: '+1234567890',
      isPublic: false,
      isPrimary: true,
      createdAt: DateTime(2024, 1, 1),
      updatedAt: DateTime(2024, 1, 1),
    );

    final tCv2 = CvModel(
      id: 2,
      userId: 1,
      title: 'Senior Developer CV',
      slug: 'senior-developer-cv',
      fullName: 'John Doe',
      email: 'john@example.com',
      phone: '+1234567890',
      isPublic: false,
      isPrimary: false,
      createdAt: DateTime(2024, 1, 2),
      updatedAt: DateTime(2024, 1, 2),
    );

    final List<CvModel> tCvs = [tCv1, tCv2];

    test('initial state should be CvsInitial', () {
      expect(bloc.state, equals(const CvsInitial()));
    });

    group('LoadCvsEvent', () {
      blocTest<CvsBloc, CvsState>(
        'emits [CvsLoading, CvsLoaded] when loading succeeds with CVs',
        build: () {
          when(mockCvDataSource.getMyCvs()).thenAnswer(
            (_) async => tCvs,
          );
          return bloc;
        },
        act: (bloc) => bloc.add(const LoadCvsEvent()),
        expect: () => [
          const CvsLoading(),
          CvsLoaded(tCvs),
        ],
        verify: (_) {
          verify(mockCvDataSource.getMyCvs()).called(1);
        },
      );

      blocTest<CvsBloc, CvsState>(
        'emits [CvsLoading, CvsEmpty] when loading succeeds with empty list',
        build: () {
          when(mockCvDataSource.getMyCvs()).thenAnswer(
            (_) async => [],
          );
          return bloc;
        },
        act: (bloc) => bloc.add(const LoadCvsEvent()),
        expect: () => [
          const CvsLoading(),
          const CvsEmpty(),
        ],
      );

      blocTest<CvsBloc, CvsState>(
        'emits [CvsLoading, CvsError] when loading fails',
        build: () {
          when(mockCvDataSource.getMyCvs()).thenThrow(
            Exception('Failed to load CVs'),
          );
          return bloc;
        },
        act: (bloc) => bloc.add(const LoadCvsEvent()),
        expect: () => [
          const CvsLoading(),
          const CvsError('Failed to load CVs. Please try again.'),
        ],
      );

      blocTest<CvsBloc, CvsState>(
        'emits login message when 401 error occurs',
        build: () {
          when(mockCvDataSource.getMyCvs()).thenThrow(
            Exception('401 Unauthorized'),
          );
          return bloc;
        },
        act: (bloc) => bloc.add(const LoadCvsEvent()),
        expect: () => [
          const CvsLoading(),
          const CvsError('Please login to view your CVs'),
        ],
      );
    });

    group('DeleteCvEvent', () {
      blocTest<CvsBloc, CvsState>(
        'emits [CvDeleting, CvsLoaded] when delete succeeds with remaining CVs',
        build: () {
          when(mockCvDataSource.deleteCv(any)).thenAnswer(
            (_) async => {},
          );
          return bloc;
        },
        seed: () => CvsLoaded(tCvs),
        act: (bloc) => bloc.add(const DeleteCvEvent(1)),
        expect: () => [
          CvDeleting(1, tCvs),
          CvsLoaded([tCv2]),
        ],
        verify: (_) {
          verify(mockCvDataSource.deleteCv(1)).called(1);
        },
      );

      blocTest<CvsBloc, CvsState>(
        'emits [CvDeleting, CvsEmpty] when delete succeeds with no remaining CVs',
        build: () {
          when(mockCvDataSource.deleteCv(any)).thenAnswer(
            (_) async => {},
          );
          return bloc;
        },
        seed: () => CvsLoaded([tCv1]),
        act: (bloc) => bloc.add(const DeleteCvEvent(1)),
        expect: () => [
          CvDeleting(1, [tCv1]),
          const CvsEmpty(),
        ],
      );

      blocTest<CvsBloc, CvsState>(
        'emits [CvDeleting, CvsError, CvsLoading] and reloads when delete fails',
        build: () {
          when(mockCvDataSource.deleteCv(any)).thenThrow(
            Exception('Failed to delete CV'),
          );
          when(mockCvDataSource.getMyCvs()).thenAnswer(
            (_) async => tCvs,
          );
          return bloc;
        },
        seed: () => CvsLoaded(tCvs),
        act: (bloc) => bloc.add(const DeleteCvEvent(1)),
        expect: () => [
          CvDeleting(1, tCvs),
          const CvsError('Failed to delete CV. Please try again.'),
          const CvsLoading(),
          CvsLoaded(tCvs),
        ],
      );

      blocTest<CvsBloc, CvsState>(
        'does nothing when state is not CvsLoaded',
        build: () => bloc,
        seed: () => const CvsLoading(),
        act: (bloc) => bloc.add(const DeleteCvEvent(1)),
        expect: () => [],
        verify: (_) {
          verifyNever(mockCvDataSource.deleteCv(any));
        },
      );

      blocTest<CvsBloc, CvsState>(
        'emits login message when delete fails with 401',
        build: () {
          when(mockCvDataSource.deleteCv(any)).thenThrow(
            Exception('401 Unauthorized'),
          );
          when(mockCvDataSource.getMyCvs()).thenAnswer(
            (_) async => tCvs,
          );
          return bloc;
        },
        seed: () => CvsLoaded(tCvs),
        act: (bloc) => bloc.add(const DeleteCvEvent(1)),
        expect: () => [
          CvDeleting(1, tCvs),
          const CvsError('Please login to delete CVs'),
          const CvsLoading(),
          CvsLoaded(tCvs),
        ],
      );
    });

    group('SetPrimaryCvEvent', () {
      blocTest<CvsBloc, CvsState>(
        'emits [CvSettingPrimary, CvsLoading, CvsLoaded] when setting primary succeeds',
        build: () {
          when(mockCvDataSource.setPrimaryCv(any)).thenAnswer(
            (_) async => {},
          );
          when(mockCvDataSource.getMyCvs()).thenAnswer(
            (_) async => tCvs,
          );
          return bloc;
        },
        seed: () => CvsLoaded(tCvs),
        act: (bloc) => bloc.add(const SetPrimaryCvEvent(2)),
        expect: () => [
          CvSettingPrimary(2, tCvs),
          const CvsLoading(),
          CvsLoaded(tCvs),
        ],
        verify: (_) {
          verify(mockCvDataSource.setPrimaryCv(2)).called(1);
          verify(mockCvDataSource.getMyCvs()).called(1);
        },
      );

      blocTest<CvsBloc, CvsState>(
        'emits [CvSettingPrimary, CvsError, CvsLoading] and reloads when setting primary fails',
        build: () {
          when(mockCvDataSource.setPrimaryCv(any)).thenThrow(
            Exception('Failed to set primary CV'),
          );
          when(mockCvDataSource.getMyCvs()).thenAnswer(
            (_) async => tCvs,
          );
          return bloc;
        },
        seed: () => CvsLoaded(tCvs),
        act: (bloc) => bloc.add(const SetPrimaryCvEvent(2)),
        expect: () => [
          CvSettingPrimary(2, tCvs),
          const CvsError('Failed to set primary CV. Please try again.'),
          const CvsLoading(),
          CvsLoaded(tCvs),
        ],
      );

      blocTest<CvsBloc, CvsState>(
        'does nothing when state is not CvsLoaded',
        build: () => bloc,
        seed: () => const CvsEmpty(),
        act: (bloc) => bloc.add(const SetPrimaryCvEvent(1)),
        expect: () => [],
        verify: (_) {
          verifyNever(mockCvDataSource.setPrimaryCv(any));
        },
      );

      blocTest<CvsBloc, CvsState>(
        'emits login message when setting primary fails with 401',
        build: () {
          when(mockCvDataSource.setPrimaryCv(any)).thenThrow(
            Exception('401 Unauthorized'),
          );
          when(mockCvDataSource.getMyCvs()).thenAnswer(
            (_) async => tCvs,
          );
          return bloc;
        },
        seed: () => CvsLoaded(tCvs),
        act: (bloc) => bloc.add(const SetPrimaryCvEvent(2)),
        expect: () => [
          CvSettingPrimary(2, tCvs),
          const CvsError('Please login to set primary CV'),
          const CvsLoading(),
          CvsLoaded(tCvs),
        ],
      );
    });

    group('UpdateCvEvent', () {
      final tUpdatedCv = CvModel(
        id: 1,
        userId: 1,
        title: 'Updated CV',
        slug: 'updated-cv',
        fullName: 'John Updated',
        email: 'johnupdated@example.com',
        phone: '+0987654321',
        isPublic: false,
        isPrimary: true,
        createdAt: DateTime(2024, 1, 1),
        updatedAt: DateTime(2024, 1, 3),
      );

      final tCvData = {
        'title': 'Updated CV',
        'fullName': 'John Updated',
        'email': 'johnupdated@example.com',
        'phone': '+0987654321',
      };

      blocTest<CvsBloc, CvsState>(
        'emits [CvUpdating, CvUpdated, CvsLoading, CvsLoaded] when update succeeds',
        build: () {
          when(mockCvDataSource.updateCv(any, any)).thenAnswer(
            (_) async => tUpdatedCv,
          );
          when(mockCvDataSource.getMyCvs()).thenAnswer(
            (_) async => [tUpdatedCv, tCv2],
          );
          return bloc;
        },
        act: (bloc) => bloc.add(UpdateCvEvent(1, tCvData)),
        expect: () => [
          const CvUpdating(),
          CvUpdated(tUpdatedCv),
          const CvsLoading(),
          CvsLoaded([tUpdatedCv, tCv2]),
        ],
        verify: (_) {
          verify(mockCvDataSource.updateCv(1, tCvData)).called(1);
          verify(mockCvDataSource.getMyCvs()).called(1);
        },
      );

      blocTest<CvsBloc, CvsState>(
        'emits [CvUpdating, CvsError] when update fails',
        build: () {
          when(mockCvDataSource.updateCv(any, any)).thenThrow(
            Exception('Failed to update CV'),
          );
          return bloc;
        },
        act: (bloc) => bloc.add(UpdateCvEvent(1, tCvData)),
        expect: () => [
          const CvUpdating(),
          const CvsError('Failed to update CV. Please try again.'),
        ],
      );

      blocTest<CvsBloc, CvsState>(
        'emits login message when update fails with 401',
        build: () {
          when(mockCvDataSource.updateCv(any, any)).thenThrow(
            Exception('401 Unauthorized'),
          );
          return bloc;
        },
        act: (bloc) => bloc.add(UpdateCvEvent(1, tCvData)),
        expect: () => [
          const CvUpdating(),
          const CvsError('Please login to update CV'),
        ],
      );
    });
  });
}
