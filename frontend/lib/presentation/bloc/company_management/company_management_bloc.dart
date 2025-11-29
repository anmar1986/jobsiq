import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/company_management/create_company.dart';
import '../../../domain/usecases/company_management/delete_company.dart';
import '../../../domain/usecases/company_management/get_my_companies.dart';
import '../../../domain/usecases/company_management/get_my_company.dart';
import '../../../domain/usecases/company_management/get_my_jobs.dart';
import '../../../domain/usecases/company_management/job_management.dart';
import '../../../domain/usecases/company_management/update_company.dart';
import 'company_management_event.dart';
import 'company_management_state.dart';

class CompanyManagementBloc
    extends Bloc<CompanyManagementEvent, CompanyManagementState> {
  final GetMyCompanies getMyCompanies;
  final GetMyCompany getMyCompany;
  final GetMyCompanyBySlug getMyCompanyBySlug;
  final CreateCompany createCompany;
  final UpdateCompany updateCompany;
  final DeleteCompany deleteCompany;
  final GetMyJobs getMyJobs;
  final CreateJob createJob;
  final UpdateJob updateJob;
  final DeleteJob deleteJob;

  CompanyManagementBloc({
    required this.getMyCompanies,
    required this.getMyCompany,
    required this.getMyCompanyBySlug,
    required this.createCompany,
    required this.updateCompany,
    required this.deleteCompany,
    required this.getMyJobs,
    required this.createJob,
    required this.updateJob,
    required this.deleteJob,
  }) : super(CompanyManagementInitial()) {
    on<LoadMyCompaniesEvent>(_onLoadMyCompanies);
    on<LoadMyCompanyEvent>(_onLoadMyCompany);
    on<LoadMyCompanyBySlugEvent>(_onLoadMyCompanyBySlug);
    on<CreateCompanyEvent>(_onCreateCompany);
    on<UpdateCompanyEvent>(_onUpdateCompany);
    on<DeleteCompanyEvent>(_onDeleteCompany);
    on<LoadMyJobsEvent>(_onLoadMyJobs);
    on<CreateJobEvent>(_onCreateJob);
    on<UpdateJobEvent>(_onUpdateJob);
    on<DeleteJobEvent>(_onDeleteJob);
  }

  Future<void> _onLoadMyCompanies(
    LoadMyCompaniesEvent event,
    Emitter<CompanyManagementState> emit,
  ) async {
    emit(CompanyManagementLoading());

    final result = await getMyCompanies();

    result.fold(
      (failure) => emit(CompanyManagementError(failure.message)),
      (companies) => emit(MyCompaniesLoaded(companies)),
    );
  }

  Future<void> _onLoadMyCompany(
    LoadMyCompanyEvent event,
    Emitter<CompanyManagementState> emit,
  ) async {
    emit(CompanyManagementLoading());

    final result = await getMyCompany(event.id);

    result.fold(
      (failure) => emit(CompanyManagementError(failure.message)),
      (company) => emit(MyCompanyLoaded(company)),
    );
  }

  Future<void> _onLoadMyCompanyBySlug(
    LoadMyCompanyBySlugEvent event,
    Emitter<CompanyManagementState> emit,
  ) async {
    emit(CompanyManagementLoading());

    final result = await getMyCompanyBySlug(event.slug);

    result.fold(
      (failure) => emit(CompanyManagementError(failure.message)),
      (company) => emit(MyCompanyLoaded(company)),
    );
  }

  Future<void> _onCreateCompany(
    CreateCompanyEvent event,
    Emitter<CompanyManagementState> emit,
  ) async {
    emit(CompanyManagementLoading());

    final result = await createCompany(event.data);

    result.fold(
      (failure) => emit(CompanyManagementError(failure.message)),
      (company) => emit(CompanyCreated(company)),
    );
  }

  Future<void> _onUpdateCompany(
    UpdateCompanyEvent event,
    Emitter<CompanyManagementState> emit,
  ) async {
    emit(CompanyManagementLoading());

    final result = await updateCompany(event.id, event.data);

    result.fold(
      (failure) => emit(CompanyManagementError(failure.message)),
      (company) => emit(CompanyUpdated(company)),
    );
  }

  Future<void> _onDeleteCompany(
    DeleteCompanyEvent event,
    Emitter<CompanyManagementState> emit,
  ) async {
    emit(CompanyManagementLoading());

    final result = await deleteCompany(event.id);

    result.fold(
      (failure) => emit(CompanyManagementError(failure.message)),
      (_) => emit(CompanyDeleted()),
    );
  }

  Future<void> _onLoadMyJobs(
    LoadMyJobsEvent event,
    Emitter<CompanyManagementState> emit,
  ) async {
    // Only show loading on first page
    if (event.page == 1) {
      emit(CompanyManagementLoading());
    }

    final result = await getMyJobs(
      companyId: event.companyId,
      status: event.status,
      page: event.page,
    );

    result.fold(
      (failure) => emit(CompanyManagementError(failure.message)),
      (jobs) {
        // If we're loading more pages, append to existing jobs
        if (state is MyJobsLoaded && event.page > 1) {
          final currentState = state as MyJobsLoaded;
          final allJobs = [...currentState.jobs, ...jobs];
          emit(MyJobsLoaded(
            jobs: allJobs,
            currentPage: event.page,
            hasMore: jobs.length >= 15, // Has more if we got full page
          ));
        } else {
          emit(MyJobsLoaded(
            jobs: jobs,
            currentPage: event.page,
            hasMore: jobs.length >= 15,
          ));
        }
      },
    );
  }

  Future<void> _onCreateJob(
    CreateJobEvent event,
    Emitter<CompanyManagementState> emit,
  ) async {
    emit(CompanyManagementLoading());

    final result = await createJob(event.data);

    result.fold(
      (failure) => emit(CompanyManagementError(failure.message)),
      (job) => emit(JobCreated(job)),
    );
  }

  Future<void> _onUpdateJob(
    UpdateJobEvent event,
    Emitter<CompanyManagementState> emit,
  ) async {
    emit(CompanyManagementLoading());

    final result = await updateJob(event.id, event.data);

    result.fold(
      (failure) => emit(CompanyManagementError(failure.message)),
      (job) => emit(JobUpdated(job)),
    );
  }

  Future<void> _onDeleteJob(
    DeleteJobEvent event,
    Emitter<CompanyManagementState> emit,
  ) async {
    emit(CompanyManagementLoading());

    final result = await deleteJob(event.id);

    result.fold(
      (failure) => emit(CompanyManagementError(failure.message)),
      (_) => emit(JobDeleted()),
    );
  }
}
