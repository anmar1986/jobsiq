import 'package:equatable/equatable.dart';

abstract class CompaniesEvent extends Equatable {
  const CompaniesEvent();

  @override
  List<Object?> get props => [];
}

class LoadCompaniesEvent extends CompaniesEvent {
  final String? search;
  final String? city;
  final String? country;
  final String? sort;
  final int page;

  const LoadCompaniesEvent({
    this.search,
    this.city,
    this.country,
    this.sort,
    this.page = 1,
  });

  @override
  List<Object?> get props => [search, city, country, sort, page];
}

class LoadCompanyBySlugEvent extends CompaniesEvent {
  final String slug;

  const LoadCompanyBySlugEvent(this.slug);

  @override
  List<Object?> get props => [slug];
}

class RefreshCompaniesEvent extends CompaniesEvent {
  const RefreshCompaniesEvent();
}
