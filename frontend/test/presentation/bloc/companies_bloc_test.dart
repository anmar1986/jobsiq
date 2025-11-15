import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:jobsiq_mobile/core/error/failures.dart';
import 'package:jobsiq_mobile/domain/repositories/company_repository.dart';
import 'package:jobsiq_mobile/data/models/company_model.dart';
import 'package:jobsiq_mobile/presentation/bloc/companies/companies_bloc.dart';
import 'package:jobsiq_mobile/presentation/bloc/companies/companies_event.dart';
import 'package:jobsiq_mobile/presentation/bloc/companies/companies_state.dart';

import 'companies_bloc_test.mocks.dart';

@GenerateMocks([
  CompanyRepository,
])
void main() {
  late CompaniesBloc bloc;
  late MockCompanyRepository mockCompanyRepository;

  setUp(() {
    mockCompanyRepository = MockCompanyRepository();
    bloc = CompaniesBloc(companyRepository: mockCompanyRepository);
  });

  tearDown(() {
    bloc.close();
  });

  group('CompaniesBloc', () {
    final tCompany1 = CompanyModel(
      id: 1,
      name: 'Tech Corp',
      slug: 'tech-corp',
      logo: 'tech-corp-logo.png',
      description: 'Leading tech company',
      website: 'https://techcorp.com',
      industry: 'Technology',
      size: '100-500',
      foundedYear: '2010',
      jobsCount: 25,
      city: 'New York',
      country: 'USA',
      createdAt: DateTime(2024, 1, 1),
      updatedAt: DateTime(2024, 1, 1),
    );

    final tCompany2 = CompanyModel(
      id: 2,
      name: 'Design Studio',
      slug: 'design-studio',
      logo: 'design-studio-logo.png',
      description: 'Creative design agency',
      website: 'https://designstudio.com',
      industry: 'Design',
      size: '10-50',
      foundedYear: '2015',
      jobsCount: 10,
      city: 'Los Angeles',
      country: 'USA',
      createdAt: DateTime(2024, 1, 2),
      updatedAt: DateTime(2024, 1, 2),
    );

    final List<CompanyModel> tCompanies = [tCompany1, tCompany2];

    test('initial state should be CompaniesInitial', () {
      expect(bloc.state, equals(const CompaniesInitial()));
    });

    group('LoadCompaniesEvent', () {
      blocTest<CompaniesBloc, CompaniesState>(
        'emits [CompaniesLoading, CompaniesLoaded] when loading first page succeeds',
        build: () {
          when(mockCompanyRepository.getCompanies(
            search: anyNamed('search'),
            city: anyNamed('city'),
            country: anyNamed('country'),
            sort: anyNamed('sort'),
            page: anyNamed('page'),
          )).thenAnswer(
            (_) async => Right(tCompanies),
          );
          return bloc;
        },
        act: (bloc) => bloc.add(const LoadCompaniesEvent(page: 1)),
        expect: () => [
          const CompaniesLoading(),
          CompaniesLoaded(
            companies: tCompanies,
            hasMore: false, // Less than 15 companies
            currentPage: 1,
          ),
        ],
        verify: (_) {
          verify(mockCompanyRepository.getCompanies(
            search: null,
            city: null,
            country: null,
            sort: null,
            page: 1,
          )).called(1);
        },
      );

      blocTest<CompaniesBloc, CompaniesState>(
        'emits [CompaniesLoading, CompaniesEmpty] when first page returns empty',
        build: () {
          when(mockCompanyRepository.getCompanies(
            search: anyNamed('search'),
            city: anyNamed('city'),
            country: anyNamed('country'),
            sort: anyNamed('sort'),
            page: anyNamed('page'),
          )).thenAnswer(
            (_) async => const Right([]),
          );
          return bloc;
        },
        act: (bloc) => bloc.add(const LoadCompaniesEvent(page: 1)),
        expect: () => [
          const CompaniesLoading(),
          const CompaniesEmpty(),
        ],
      );

      blocTest<CompaniesBloc, CompaniesState>(
        'emits [CompaniesLoadingMore, CompaniesLoaded] when loading additional pages',
        build: () {
          when(mockCompanyRepository.getCompanies(
            search: anyNamed('search'),
            city: anyNamed('city'),
            country: anyNamed('country'),
            sort: anyNamed('sort'),
            page: anyNamed('page'),
          )).thenAnswer(
            (_) async => Right([tCompany1]),
          );
          return bloc;
        },
        seed: () => CompaniesLoaded(
          companies: [tCompany2],
          hasMore: true,
          currentPage: 1,
        ),
        act: (bloc) => bloc.add(const LoadCompaniesEvent(page: 2)),
        expect: () => [
          CompaniesLoadingMore(
            companies: [tCompany2],
            currentPage: 1,
          ),
          CompaniesLoaded(
            companies: [tCompany2, tCompany1],
            hasMore: false,
            currentPage: 2,
          ),
        ],
      );

      blocTest<CompaniesBloc, CompaniesState>(
        'sets hasMore to true when full page of 15+ companies is returned',
        build: () {
          final fullPage = List.generate(
            15,
            (index) => CompanyModel(
              id: index + 1,
              name: 'Company $index',
              slug: 'company-$index',
              jobsCount: 10,
              createdAt: DateTime(2024, 1, 1),
              updatedAt: DateTime(2024, 1, 1),
            ),
          );
          when(mockCompanyRepository.getCompanies(
            search: anyNamed('search'),
            city: anyNamed('city'),
            country: anyNamed('country'),
            sort: anyNamed('sort'),
            page: anyNamed('page'),
          )).thenAnswer(
            (_) async => Right(fullPage),
          );
          return bloc;
        },
        act: (bloc) => bloc.add(const LoadCompaniesEvent(page: 1)),
        expect: () => [
          const CompaniesLoading(),
          predicate<CompaniesState>((state) {
            if (state is CompaniesLoaded) {
              return state.hasMore == true && state.companies.length == 15;
            }
            return false;
          }),
        ],
      );

      blocTest<CompaniesBloc, CompaniesState>(
        'passes search parameters correctly',
        build: () {
          when(mockCompanyRepository.getCompanies(
            search: anyNamed('search'),
            city: anyNamed('city'),
            country: anyNamed('country'),
            sort: anyNamed('sort'),
            page: anyNamed('page'),
          )).thenAnswer(
            (_) async => Right(tCompanies),
          );
          return bloc;
        },
        act: (bloc) => bloc.add(
          const LoadCompaniesEvent(
            search: 'Tech',
            city: 'New York',
            country: 'USA',
            sort: 'name',
            page: 1,
          ),
        ),
        expect: () => [
          const CompaniesLoading(),
          CompaniesLoaded(
            companies: tCompanies,
            hasMore: false,
            currentPage: 1,
          ),
        ],
        verify: (_) {
          verify(mockCompanyRepository.getCompanies(
            search: 'Tech',
            city: 'New York',
            country: 'USA',
            sort: 'name',
            page: 1,
          )).called(1);
        },
      );

      blocTest<CompaniesBloc, CompaniesState>(
        'emits [CompaniesLoading, CompaniesError] when loading fails',
        build: () {
          when(mockCompanyRepository.getCompanies(
            search: anyNamed('search'),
            city: anyNamed('city'),
            country: anyNamed('country'),
            sort: anyNamed('sort'),
            page: anyNamed('page'),
          )).thenAnswer(
            (_) async => const Left(ServerFailure('Failed to load companies')),
          );
          return bloc;
        },
        act: (bloc) => bloc.add(const LoadCompaniesEvent(page: 1)),
        expect: () => [
          const CompaniesLoading(),
          const CompaniesError('Failed to load companies'),
        ],
      );

      blocTest<CompaniesBloc, CompaniesState>(
        'emits login message when 401 error occurs',
        build: () {
          when(mockCompanyRepository.getCompanies(
            search: anyNamed('search'),
            city: anyNamed('city'),
            country: anyNamed('country'),
            sort: anyNamed('sort'),
            page: anyNamed('page'),
          )).thenAnswer(
            (_) async => const Left(
                AuthenticationFailure('Please login to view companies')),
          );
          return bloc;
        },
        act: (bloc) => bloc.add(const LoadCompaniesEvent(page: 1)),
        expect: () => [
          const CompaniesLoading(),
          const CompaniesError('Please login to view companies'),
        ],
      );
    });

    group('LoadCompanyBySlugEvent', () {
      final tCompanyDetails = CompanyModel(
        id: 1,
        name: 'Tech Corp',
        slug: 'tech-corp',
        logo: 'tech-corp-logo.png',
        description: 'Leading tech company with innovative solutions',
        website: 'https://techcorp.com',
        email: 'contact@techcorp.com',
        phone: '+1234567890',
        industry: 'Technology',
        size: '100-500',
        foundedYear: '2010',
        jobsCount: 25,
        city: 'New York',
        country: 'USA',
        address: '123 Tech Street',
        createdAt: DateTime(2024, 1, 1),
        updatedAt: DateTime(2024, 1, 1),
      );

      blocTest<CompaniesBloc, CompaniesState>(
        'emits [CompaniesLoading, CompanyDetailsLoaded] when loading company details succeeds',
        build: () {
          when(mockCompanyRepository.getCompanyBySlug(any)).thenAnswer(
            (_) async => Right(tCompanyDetails),
          );
          return bloc;
        },
        act: (bloc) => bloc.add(const LoadCompanyBySlugEvent('tech-corp')),
        expect: () => [
          const CompaniesLoading(),
          CompanyDetailsLoaded(tCompanyDetails),
        ],
        verify: (_) {
          verify(mockCompanyRepository.getCompanyBySlug('tech-corp')).called(1);
        },
      );

      blocTest<CompaniesBloc, CompaniesState>(
        'emits [CompaniesLoading, CompaniesError] when loading company details fails',
        build: () {
          when(mockCompanyRepository.getCompanyBySlug(any)).thenAnswer(
            (_) async => const Left(NotFoundFailure('Company not found')),
          );
          return bloc;
        },
        act: (bloc) => bloc.add(const LoadCompanyBySlugEvent('non-existent')),
        expect: () => [
          const CompaniesLoading(),
          const CompaniesError('Company not found'),
        ],
      );

      blocTest<CompaniesBloc, CompaniesState>(
        'emits login message when 401 error occurs',
        build: () {
          when(mockCompanyRepository.getCompanyBySlug(any)).thenAnswer(
            (_) async => const Left(
                AuthenticationFailure('Please login to view company details')),
          );
          return bloc;
        },
        act: (bloc) => bloc.add(const LoadCompanyBySlugEvent('tech-corp')),
        expect: () => [
          const CompaniesLoading(),
          const CompaniesError('Please login to view company details'),
        ],
      );
    });

    group('RefreshCompaniesEvent', () {
      blocTest<CompaniesBloc, CompaniesState>(
        'triggers LoadCompaniesEvent with page 1',
        build: () {
          when(mockCompanyRepository.getCompanies(
            search: anyNamed('search'),
            city: anyNamed('city'),
            country: anyNamed('country'),
            sort: anyNamed('sort'),
            page: anyNamed('page'),
          )).thenAnswer(
            (_) async => Right(tCompanies),
          );
          return bloc;
        },
        act: (bloc) => bloc.add(const RefreshCompaniesEvent()),
        expect: () => [
          const CompaniesLoading(),
          CompaniesLoaded(
            companies: tCompanies,
            hasMore: false,
            currentPage: 1,
          ),
        ],
        verify: (_) {
          verify(mockCompanyRepository.getCompanies(
            search: null,
            city: null,
            country: null,
            sort: null,
            page: 1,
          )).called(1);
        },
      );
    });
  });
}
