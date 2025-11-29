import 'package:equatable/equatable.dart';
import '../../../domain/entities/company_entity.dart';
import '../../../domain/entities/job_entity.dart';

abstract class CompanyManagementState extends Equatable {
  const CompanyManagementState();

  @override
  List<Object?> get props => [];
}

class CompanyManagementInitial extends CompanyManagementState {}

class CompanyManagementLoading extends CompanyManagementState {}

// Company States
class MyCompaniesLoaded extends CompanyManagementState {
  final List<CompanyEntity> companies;

  const MyCompaniesLoaded(this.companies);

  @override
  List<Object?> get props => [companies];
}

class MyCompanyLoaded extends CompanyManagementState {
  final CompanyEntity company;

  const MyCompanyLoaded(this.company);

  @override
  List<Object?> get props => [company];
}

class CompanyCreated extends CompanyManagementState {
  final CompanyEntity company;

  const CompanyCreated(this.company);

  @override
  List<Object?> get props => [company];
}

class CompanyUpdated extends CompanyManagementState {
  final CompanyEntity company;

  const CompanyUpdated(this.company);

  @override
  List<Object?> get props => [company];
}

class CompanyDeleted extends CompanyManagementState {}

// Job States
class MyJobsLoaded extends CompanyManagementState {
  final List<JobEntity> jobs;
  final int currentPage;
  final bool hasMore;

  const MyJobsLoaded({
    required this.jobs,
    required this.currentPage,
    this.hasMore = false,
  });

  @override
  List<Object?> get props => [jobs, currentPage, hasMore];
}

class JobCreated extends CompanyManagementState {
  final JobEntity job;

  const JobCreated(this.job);

  @override
  List<Object?> get props => [job];
}

class JobUpdated extends CompanyManagementState {
  final JobEntity job;

  const JobUpdated(this.job);

  @override
  List<Object?> get props => [job];
}

class JobDeleted extends CompanyManagementState {}

// Error State
class CompanyManagementError extends CompanyManagementState {
  final String message;

  const CompanyManagementError(this.message);

  @override
  List<Object?> get props => [message];
}
