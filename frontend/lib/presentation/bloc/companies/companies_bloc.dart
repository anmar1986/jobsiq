import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/company_entity.dart';
import '../../../domain/repositories/company_repository.dart';
import 'companies_event.dart';
import 'companies_state.dart';

class CompaniesBloc extends Bloc<CompaniesEvent, CompaniesState> {
  final CompanyRepository companyRepository;

  CompaniesBloc({required this.companyRepository})
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

    final result = await companyRepository.getCompanies(
      search: event.search,
      city: event.city,
      country: event.country,
      sort: event.sort,
      page: event.page,
    );

    result.fold(
      (failure) {
        emit(CompaniesError(failure.message));
      },
      (companies) {
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
      },
    );
  }

  Future<void> _onLoadCompanyBySlug(
      LoadCompanyBySlugEvent event, Emitter<CompaniesState> emit) async {
    emit(const CompaniesLoading());

    final result = await companyRepository.getCompanyBySlug(event.slug);

    result.fold(
      (failure) {
        emit(CompaniesError(failure.message));
      },
      (company) {
        emit(CompanyDetailsLoaded(company));
      },
    );
  }

  Future<void> _onRefreshCompanies(
      RefreshCompaniesEvent event, Emitter<CompaniesState> emit) async {
    // Reset to first page
    add(const LoadCompaniesEvent(page: 1));
  }
}
