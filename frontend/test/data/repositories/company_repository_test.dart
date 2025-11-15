import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jobsiq_mobile/core/error/exceptions.dart';
import 'package:jobsiq_mobile/core/error/failures.dart';
import 'package:jobsiq_mobile/core/network/network_info.dart';
import 'package:jobsiq_mobile/data/datasources/company_remote_data_source.dart';
import 'package:jobsiq_mobile/data/models/company_model.dart';
import 'package:jobsiq_mobile/data/repositories/company_repository_impl.dart';
import 'package:jobsiq_mobile/domain/repositories/company_repository.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'company_repository_test.mocks.dart';

@GenerateMocks([
  CompanyRemoteDataSource,
  NetworkInfo,
])
void main() {
  late CompanyRepository repository;
  late MockCompanyRemoteDataSource mockRemoteDataSource;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockRemoteDataSource = MockCompanyRemoteDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = CompanyRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  group('getCompanies', () {
    final tCompanies = [
      CompanyModel(
        id: 1,
        name: 'Test Company',
        slug: 'test-company',
        logo: null,
        cover: null,
        description: 'Test description',
        website: null,
        industry: null,
        size: null,
        foundedYear: null,
        email: null,
        phone: null,
        city: null,
        country: null,
        address: null,
        jobsCount: 5,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    ];

    test('should check if device is online', () async {
      // arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockRemoteDataSource.getCompanies(
        search: anyNamed('search'),
        city: anyNamed('city'),
        country: anyNamed('country'),
        sort: anyNamed('sort'),
        page: anyNamed('page'),
        perPage: anyNamed('perPage'),
      )).thenAnswer((_) async => tCompanies);

      // act
      await repository.getCompanies();

      // assert
      verify(mockNetworkInfo.isConnected);
    });

    test(
        'should return companies when call to remote data source is successful',
        () async {
      // arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockRemoteDataSource.getCompanies(
        search: anyNamed('search'),
        city: anyNamed('city'),
        country: anyNamed('country'),
        sort: anyNamed('sort'),
        page: anyNamed('page'),
        perPage: anyNamed('perPage'),
      )).thenAnswer((_) async => tCompanies);

      // act
      final result = await repository.getCompanies();

      // assert
      verify(mockRemoteDataSource.getCompanies(
        search: null,
        city: null,
        country: null,
        sort: null,
        page: 1,
        perPage: 15,
      ));
      expect(result, equals(Right(tCompanies)));
    });

    test('should return network failure when device is offline', () async {
      // arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);

      // act
      final result = await repository.getCompanies();

      // assert
      verifyZeroInteractions(mockRemoteDataSource);
      expect(
          result, equals(const Left(NetworkFailure('No internet connection'))));
    });

    test('should return server failure when remote call throws ServerException',
        () async {
      // arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockRemoteDataSource.getCompanies(
        search: anyNamed('search'),
        city: anyNamed('city'),
        country: anyNamed('country'),
        sort: anyNamed('sort'),
        page: anyNamed('page'),
        perPage: anyNamed('perPage'),
      )).thenThrow(ServerException('Server error'));

      // act
      final result = await repository.getCompanies();

      // assert
      expect(result, isA<Left<Failure, dynamic>>());
      expect((result as Left).value, isA<ServerFailure>());
    });

    test(
        'should return authentication failure when remote call throws AuthenticationException',
        () async {
      // arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockRemoteDataSource.getCompanies(
        search: anyNamed('search'),
        city: anyNamed('city'),
        country: anyNamed('country'),
        sort: anyNamed('sort'),
        page: anyNamed('page'),
        perPage: anyNamed('perPage'),
      )).thenThrow(AuthenticationException('Not authenticated'));

      // act
      final result = await repository.getCompanies();

      // assert
      expect(result, isA<Left<Failure, dynamic>>());
      expect((result as Left).value, isA<AuthenticationFailure>());
    });

    test('should pass filters to remote data source', () async {
      // arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockRemoteDataSource.getCompanies(
        search: anyNamed('search'),
        city: anyNamed('city'),
        country: anyNamed('country'),
        sort: anyNamed('sort'),
        page: anyNamed('page'),
        perPage: anyNamed('perPage'),
      )).thenAnswer((_) async => tCompanies);

      // act
      await repository.getCompanies(
        search: 'test',
        city: 'New York',
        country: 'USA',
        sort: 'name',
        page: 2,
        perPage: 20,
      );

      // assert
      verify(mockRemoteDataSource.getCompanies(
        search: 'test',
        city: 'New York',
        country: 'USA',
        sort: 'name',
        page: 2,
        perPage: 20,
      ));
    });
  });

  group('getCompanyBySlug', () {
    final tCompany = CompanyModel(
      id: 1,
      name: 'Test Company',
      slug: 'test-company',
      logo: null,
      cover: null,
      description: 'Test description',
      website: null,
      industry: null,
      size: null,
      foundedYear: null,
      email: null,
      phone: null,
      city: null,
      country: null,
      address: null,
      jobsCount: 5,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    test('should return company when call to remote data source is successful',
        () async {
      // arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockRemoteDataSource.getCompanyBySlug(any))
          .thenAnswer((_) async => tCompany);

      // act
      final result = await repository.getCompanyBySlug('test-company');

      // assert
      verify(mockRemoteDataSource.getCompanyBySlug('test-company'));
      expect(result, equals(Right(tCompany)));
    });

    test('should return network failure when device is offline', () async {
      // arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);

      // act
      final result = await repository.getCompanyBySlug('test-company');

      // assert
      verifyZeroInteractions(mockRemoteDataSource);
      expect(
          result, equals(const Left(NetworkFailure('No internet connection'))));
    });

    test(
        'should return not found failure when remote call throws NotFoundException',
        () async {
      // arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockRemoteDataSource.getCompanyBySlug(any))
          .thenThrow(NotFoundException('Company not found'));

      // act
      final result = await repository.getCompanyBySlug('test-company');

      // assert
      expect(result, isA<Left<Failure, dynamic>>());
      expect((result as Left).value, isA<NotFoundFailure>());
    });
  });
}
