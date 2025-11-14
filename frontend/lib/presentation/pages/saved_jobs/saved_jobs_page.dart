import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../config/di/injection.dart';
import '../../../config/routes/app_router.dart';
import '../../bloc/saved_jobs/saved_jobs_bloc.dart';
import '../../bloc/saved_jobs/saved_jobs_event.dart';
import '../../bloc/saved_jobs/saved_jobs_state.dart';
import '../../widgets/common/job_card.dart';

class SavedJobsPage extends StatelessWidget {
  const SavedJobsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<SavedJobsBloc>()..add(const LoadSavedJobsEvent()),
      child: Scaffold(
        body: SafeArea(
          child: RefreshIndicator(
            onRefresh: () async {
              context.read<SavedJobsBloc>().add(const LoadSavedJobsEvent());
              await Future.delayed(const Duration(seconds: 1));
            },
            child: CustomScrollView(
              slivers: [
                SliverAppBar(
                  floating: true,
                  snap: true,
                  title: BlocBuilder<SavedJobsBloc, SavedJobsState>(
                    builder: (context, state) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Saved Jobs',
                            style: TextStyle(
                              fontSize: 24.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (state is SavedJobsLoaded && state.jobs.isNotEmpty)
                            Text(
                              '${state.jobs.length} job${state.jobs.length != 1 ? 's' : ''} saved',
                              style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.normal,
                                color: Colors.grey[600],
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                ),
                BlocBuilder<SavedJobsBloc, SavedJobsState>(
                  builder: (context, state) {
                    if (state is SavedJobsLoading) {
                      return const SliverFillRemaining(
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }

                    if (state is SavedJobsError) {
                      return SliverFillRemaining(
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.error_outline_rounded,
                                size: 64.sp,
                                color: Colors.red,
                              ),
                              SizedBox(height: 16.h),
                              Text(
                                state.message,
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 16.sp),
                              ),
                              SizedBox(height: 16.h),
                              ElevatedButton(
                                onPressed: () {
                                  context
                                      .read<SavedJobsBloc>()
                                      .add(const LoadSavedJobsEvent());
                                },
                                child: const Text('Retry'),
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    if (state is SavedJobsEmpty) {
                      return SliverFillRemaining(
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.bookmark_border,
                                size: 64.sp,
                                color: Colors.grey,
                              ),
                              SizedBox(height: 16.h),
                              Text(
                                'No saved jobs yet',
                                style: TextStyle(fontSize: 18.sp),
                              ),
                              SizedBox(height: 8.h),
                              Text(
                                'Start saving jobs to see them here',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    if (state is SavedJobsLoaded) {
                      return SliverPadding(
                        padding: EdgeInsets.all(16.w),
                        sliver: SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              final job = state.jobs[index];
                              return JobCard(
                                job: job,
                                onTap: () {
                                  context.push(
                                    AppRouter.jobDetails
                                        .replaceAll(':slug', job.slug),
                                    extra: job,
                                  );
                                },
                                onSaveToggle: () {
                                  context
                                      .read<SavedJobsBloc>()
                                      .add(RemoveSavedJobEvent(job.id));
                                },
                              );
                            },
                            childCount: state.jobs.length,
                          ),
                        ),
                      );
                    }

                    return const SliverToBoxAdapter(child: SizedBox.shrink());
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
