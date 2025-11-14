import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/datasources/company_remote_data_source.dart';
import '../../../domain/entities/company_entity.dart';
import 'companies_event.dart';
import 'companies_state.dart';

class CompaniesBloc extends Bloc<CompaniesEvent, CompaniesState> {
  final CompanyRemoteDataSource companyDataSource;

  CompaniesBloc({required this.companyDataSource})
      : super(const CompaniesInitial()) {
    on<LoadCompaniesEvent>(_onLoadCompanies);
    on<LoadCompanyBySlugEvent>(_onLoadCompanyBySlug);
    on<RefreshCompaniesEvent>(_onRefreshCompanies);
  }

  Future<void> _onLoadCompanies(
      LoadCompaniesEvent event, Emitter<CompaniesState> emit) async {
    // If it's the first page, show loading
    if (event.page == 1) {
      emit(const CompaniesLoading());
    } else {
      // If loading more, show loading more state with current companies
      if (state is CompaniesLoaded) {
        final currentState = state as CompaniesLoaded;
        emit(CompaniesLoadingMore(
          companies: currentState.companies,
          currentPage: currentState.currentPage,
        ));
      }
    }

    try {
      final companies = await companyDataSource.getCompanies(
        search: event.search,
        city: event.city,
        country: event.country,
        sort: event.sort,
        page: event.page,
      );

      if (companies.isEmpty && event.page == 1) {
        emit(const CompaniesEmpty());
      } else {
        List<CompanyEntity> allCompanies = companies;

        // If loading more, append to existing companies
        if (event.page > 1 && state is CompaniesLoadingMore) {
          final currentState = state as CompaniesLoadingMore;
          allCompanies = [...currentState.companies, ...companies];
        }

        emit(CompaniesLoaded(
          companies: allCompanies,
          hasMore: companies.length >=
              15, // If we got a full page, there might be more
          currentPage: event.page,
        ));
      }
    } catch (e) {
      final errorMessage = e.toString().contains('401')
          ? 'Please login to view companies'
          : 'Failed to load companies. Please try again.';
      emit(CompaniesError(errorMessage));
    }
  }

  Future<void> _onLoadCompanyBySlug(
      LoadCompanyBySlugEvent event, Emitter<CompaniesState> emit) async {
    emit(const CompaniesLoading());

    try {
      final company = await companyDataSource.getCompanyBySlug(event.slug);
      emit(CompanyDetailsLoaded(company));
    } catch (e) {
      final errorMessage = e.toString().contains('401')
          ? 'Please login to view company details'
          : 'Failed to load company details. Please try again.';
      emit(CompaniesError(errorMessage));
    }
  }

  Future<void> _onRefreshCompanies(
      RefreshCompaniesEvent event, Emitter<CompaniesState> emit) async {
    // Reset to first page
    add(const LoadCompaniesEvent(page: 1));
  }
}
