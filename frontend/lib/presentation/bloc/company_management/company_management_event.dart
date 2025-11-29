import 'package:equatable/equatable.dart';

abstract class CompanyManagementEvent extends Equatable {
  const CompanyManagementEvent();

  @override
  List<Object?> get props => [];
}

class LoadMyCompaniesEvent extends CompanyManagementEvent {}

class LoadMyCompanyEvent extends CompanyManagementEvent {
  final int id;

  const LoadMyCompanyEvent(this.id);

  @override
  List<Object?> get props => [id];
}

class LoadMyCompanyBySlugEvent extends CompanyManagementEvent {
  final String slug;

  const LoadMyCompanyBySlugEvent(this.slug);

  @override
  List<Object?> get props => [slug];
}

class CreateCompanyEvent extends CompanyManagementEvent {
  final Map<String, dynamic> data;

  const CreateCompanyEvent(this.data);

  @override
  List<Object?> get props => [data];
}

class UpdateCompanyEvent extends CompanyManagementEvent {
  final int id;
  final Map<String, dynamic> data;

  const UpdateCompanyEvent(this.id, this.data);

  @override
  List<Object?> get props => [id, data];
}

class DeleteCompanyEvent extends CompanyManagementEvent {
  final int id;

  const DeleteCompanyEvent(this.id);

  @override
  List<Object?> get props => [id];
}

class LoadMyJobsEvent extends CompanyManagementEvent {
  final int? companyId;
  final String? status;
  final int page;

  const LoadMyJobsEvent({
    this.companyId,
    this.status,
    this.page = 1,
  });

  @override
  List<Object?> get props => [companyId, status, page];
}

class CreateJobEvent extends CompanyManagementEvent {
  final Map<String, dynamic> data;

  const CreateJobEvent(this.data);

  @override
  List<Object?> get props => [data];
}

class UpdateJobEvent extends CompanyManagementEvent {
  final int id;
  final Map<String, dynamic> data;

  const UpdateJobEvent(this.id, this.data);

  @override
  List<Object?> get props => [id, data];
}

class DeleteJobEvent extends CompanyManagementEvent {
  final int id;

  const DeleteJobEvent(this.id);

  @override
  List<Object?> get props => [id];
}
