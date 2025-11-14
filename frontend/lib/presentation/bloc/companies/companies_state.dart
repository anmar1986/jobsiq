import 'package:equatable/equatable.dart';
import '../../../domain/entities/company_entity.dart';

abstract class CompaniesState extends Equatable {
  const CompaniesState();

  @override
  List<Object?> get props => [];
}

class CompaniesInitial extends CompaniesState {
  const CompaniesInitial();
}

class CompaniesLoading extends CompaniesState {
  const CompaniesLoading();
}

class CompaniesLoaded extends CompaniesState {
  final List<CompanyEntity> companies;
  final bool hasMore;
  final int currentPage;

  const CompaniesLoaded({
    required this.companies,
    this.hasMore = true,
    this.currentPage = 1,
  });

  @override
  List<Object?> get props => [companies, hasMore, currentPage];

  CompaniesLoaded copyWith({
    List<CompanyEntity>? companies,
    bool? hasMore,
    int? currentPage,
  }) {
    return CompaniesLoaded(
      companies: companies ?? this.companies,
      hasMore: hasMore ?? this.hasMore,
      currentPage: currentPage ?? this.currentPage,
    );
  }
}

class CompanyDetailsLoaded extends CompaniesState {
  final CompanyEntity company;

  const CompanyDetailsLoaded(this.company);

  @override
  List<Object?> get props => [company];
}

class CompaniesEmpty extends CompaniesState {
  const CompaniesEmpty();
}

class CompaniesError extends CompaniesState {
  final String message;

  const CompaniesError(this.message);

  @override
  List<Object?> get props => [message];
}

class CompaniesLoadingMore extends CompaniesState {
  final List<CompanyEntity> companies;
  final int currentPage;

  const CompaniesLoadingMore({
    required this.companies,
    required this.currentPage,
  });

  @override
  List<Object?> get props => [companies, currentPage];
}
