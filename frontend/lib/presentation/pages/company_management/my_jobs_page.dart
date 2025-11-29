import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import '../../../config/di/injection.dart';
import '../../../core/theme/app_colors.dart';
import '../../../domain/entities/job_entity.dart';
import '../../bloc/company_management/company_management_bloc.dart';
import '../../bloc/company_management/company_management_event.dart';
import '../../bloc/company_management/company_management_state.dart';

class MyJobsPage extends StatelessWidget {
  const MyJobsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          getIt<CompanyManagementBloc>()..add(const LoadMyJobsEvent()),
      child: const _MyJobsView(),
    );
  }
}

class _MyJobsView extends StatefulWidget {
  const _MyJobsView();

  @override
  State<_MyJobsView> createState() => _MyJobsViewState();
}

class _MyJobsViewState extends State<_MyJobsView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_onTabChanged);
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onTabChanged() {
    if (_tabController.indexIsChanging) {
      String? status;
      switch (_tabController.index) {
        case 0:
          status = null; // All jobs
          break;
        case 1:
          status = 'active';
          break;
        case 2:
          status = 'closed';
          break;
      }
      context
          .read<CompanyManagementBloc>()
          .add(LoadMyJobsEvent(status: status));
    }
  }

  void _onScroll() {
    if (_isBottom) {
      final state = context.read<CompanyManagementBloc>().state;
      if (state is MyJobsLoaded && state.hasMore) {
        String? status;
        switch (_tabController.index) {
          case 0:
            status = null;
            break;
          case 1:
            status = 'active';
            break;
          case 2:
            status = 'closed';
            break;
        }
        context.read<CompanyManagementBloc>().add(
              LoadMyJobsEvent(status: status, page: state.currentPage + 1),
            );
      }
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text('My Jobs'),
        backgroundColor: AppColors.backgroundLight,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              context.push('/company-management/create-job');
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primary,
          unselectedLabelColor: Colors.grey,
          indicatorColor: AppColors.primary,
          tabs: const [
            Tab(text: 'All'),
            Tab(text: 'Active'),
            Tab(text: 'Closed'),
          ],
        ),
      ),
      body: BlocConsumer<CompanyManagementBloc, CompanyManagementState>(
        listener: (context, state) {
          if (state is CompanyManagementError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          } else if (state is JobDeleted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Job deleted successfully'),
                backgroundColor: Colors.green,
              ),
            );
            String? status;
            switch (_tabController.index) {
              case 1:
                status = 'active';
                break;
              case 2:
                status = 'closed';
                break;
            }
            context
                .read<CompanyManagementBloc>()
                .add(LoadMyJobsEvent(status: status));
          }
        },
        builder: (context, state) {
          if (state is CompanyManagementLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is MyJobsLoaded) {
            if (state.jobs.isEmpty) {
              return _buildEmptyState(context);
            }

            return RefreshIndicator(
              onRefresh: () async {
                String? status;
                switch (_tabController.index) {
                  case 1:
                    status = 'active';
                    break;
                  case 2:
                    status = 'closed';
                    break;
                }
                context
                    .read<CompanyManagementBloc>()
                    .add(LoadMyJobsEvent(status: status));
              },
              child: ListView.builder(
                controller: _scrollController,
                padding: EdgeInsets.all(16.w),
                itemCount: state.jobs.length + (state.hasMore ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index >= state.jobs.length) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                  final job = state.jobs[index];
                  return _buildJobCard(context, job);
                },
              ),
            );
          }

          return const SizedBox();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.push('/company-management/create-job');
        },
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.work_outline,
            size: 80.sp,
            color: Colors.grey[400],
          ),
          SizedBox(height: 16.h),
          Text(
            'No Jobs Posted Yet',
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Post your first job to start receiving applications',
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 24.h),
          ElevatedButton.icon(
            onPressed: () {
              context.push('/company-management/create-job');
            },
            icon: const Icon(Icons.add),
            label: const Text('Post a Job'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildJobCard(BuildContext context, JobEntity job) {
    return Card(
      margin: EdgeInsets.only(bottom: 16.h),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: InkWell(
        onTap: () {
          context.push('/jobs/${job.slug}');
        },
        borderRadius: BorderRadius.circular(12.r),
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // Company Logo
                  if (job.company != null && job.company!.logo != null)
                    Container(
                      width: 50.w,
                      height: 50.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.r),
                        color: Colors.grey[200],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.r),
                        child: CachedNetworkImage(
                          imageUrl: job.company!.logoUrl,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => const Center(
                            child: CircularProgressIndicator(),
                          ),
                          errorWidget: (context, url, error) => Icon(
                            Icons.business,
                            size: 25.sp,
                            color: Colors.grey[400],
                          ),
                        ),
                      ),
                    ),
                  if (job.company != null && job.company!.logo != null)
                    SizedBox(width: 12.w),
                  // Job Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          job.title,
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (job.company != null) ...[
                          SizedBox(height: 4.h),
                          Text(
                            job.company!.name,
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  // Status Badge
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: job.status == 'active'
                          ? Colors.green[100]
                          : Colors.red[100],
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Text(
                      (job.status ?? 'unknown').toUpperCase(),
                      style: TextStyle(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.bold,
                        color: job.status == 'active'
                            ? Colors.green[700]
                            : Colors.red[700],
                      ),
                    ),
                  ),
                  // Actions
                  PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'edit') {
                        context.push('/company-management/edit-job/${job.id}');
                      } else if (value == 'delete') {
                        _showDeleteConfirmation(context, job);
                      } else if (value == 'applications') {
                        context.push(
                            '/company-management/job-applications/${job.id}');
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'applications',
                        child: Row(
                          children: [
                            Icon(Icons.people, size: 18),
                            SizedBox(width: 8),
                            Text('Applications'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'edit',
                        child: Row(
                          children: [
                            Icon(Icons.edit, size: 18),
                            SizedBox(width: 8),
                            Text('Edit'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete, size: 18, color: Colors.red),
                            SizedBox(width: 8),
                            Text('Delete', style: TextStyle(color: Colors.red)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 12.h),
              // Job Details
              Wrap(
                spacing: 12.w,
                runSpacing: 8.h,
                children: [
                  _buildInfoChip(
                      Icons.location_on, job.location ?? 'Not specified'),
                  _buildInfoChip(
                      Icons.work_outline, job.jobType ?? job.employmentType),
                  if (job.salary != null)
                    _buildInfoChip(Icons.attach_money, job.salary!),
                ],
              ),
              SizedBox(height: 12.h),
              // Stats Row
              Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    size: 14.sp,
                    color: Colors.grey[600],
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    'Posted ${DateFormat('MMM dd, yyyy').format(job.createdAt)}',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.grey[600],
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    Icons.people,
                    size: 14.sp,
                    color: AppColors.primary,
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    '${job.applicantsCount ?? 0} Applicants',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: AppColors.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14.sp, color: Colors.grey[600]),
        SizedBox(width: 4.w),
        Text(
          label,
          style: TextStyle(
            fontSize: 12.sp,
            color: Colors.grey[700],
          ),
        ),
      ],
    );
  }

  void _showDeleteConfirmation(BuildContext context, JobEntity job) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete Job'),
        content: Text(
            'Are you sure you want to delete "${job.title}"? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              context.read<CompanyManagementBloc>().add(DeleteJobEvent(job.id));
              Navigator.pop(dialogContext);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
