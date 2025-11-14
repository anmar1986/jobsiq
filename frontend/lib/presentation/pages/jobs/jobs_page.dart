import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../config/di/injection.dart';
import '../../bloc/jobs/jobs_bloc.dart';
import '../../bloc/jobs/jobs_event.dart';
import '../../bloc/jobs/jobs_state.dart';
import '../../widgets/common/job_card.dart';

class JobsPage extends StatelessWidget {
  const JobsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<JobsBloc>()..add(const LoadJobsEvent()),
      child: const _JobsPageContent(),
    );
  }
}

class _JobsPageContent extends StatefulWidget {
  const _JobsPageContent();

  @override
  State<_JobsPageContent> createState() => _JobsPageContentState();
}

class _JobsPageContentState extends State<_JobsPageContent> {
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      context.read<JobsBloc>().add(const LoadMoreJobsEvent());
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  void _onSearch(String query) {
    context.read<JobsBloc>().add(SearchJobsEvent(query));
  }

  void _onRefresh() {
    context.read<JobsBloc>().add(const LoadJobsEvent(refresh: true));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            _onRefresh();
            // Wait for the state to update
            await Future.delayed(const Duration(seconds: 1));
          },
          child: CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverAppBar(
                floating: true,
                snap: true,
                title: Text(
                  'Find Jobs',
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.tune_rounded),
                    onPressed: () {
                      // TODO: Open filters
                    },
                  ),
                ],
              ),
              SliverPadding(
                padding: EdgeInsets.all(16.w),
                sliver: SliverToBoxAdapter(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search jobs, companies...',
                      prefixIcon: const Icon(Icons.search_rounded),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear_rounded),
                              onPressed: () {
                                _searchController.clear();
                                _onSearch('');
                              },
                            )
                          : null,
                    ),
                    onChanged: (value) {
                      setState(() {});
                    },
                    onSubmitted: _onSearch,
                  ),
                ),
              ),
              SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                sliver: BlocBuilder<JobsBloc, JobsState>(
                  builder: (context, state) {
                    if (state is JobsLoading) {
                      return const SliverFillRemaining(
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }

                    if (state is JobsError) {
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
                                onPressed: _onRefresh,
                                child: const Text('Retry'),
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    if (state is JobsLoaded) {
                      if (state.jobs.isEmpty) {
                        return SliverFillRemaining(
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.work_off_outlined,
                                  size: 64.sp,
                                  color: Colors.grey,
                                ),
                                SizedBox(height: 16.h),
                                Text(
                                  'No jobs found',
                                  style: TextStyle(fontSize: 18.sp),
                                ),
                                SizedBox(height: 8.h),
                                Text(
                                  'Try adjusting your search or filters',
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

                      return SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            if (index == state.jobs.length) {
                              // Loading indicator at the bottom
                              return state.hasMore
                                  ? Padding(
                                      padding: EdgeInsets.all(16.w),
                                      child: const Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                    )
                                  : Padding(
                                      padding: EdgeInsets.all(16.w),
                                      child: Center(
                                        child: Text(
                                          'No more jobs',
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 14.sp,
                                          ),
                                        ),
                                      ),
                                    );
                            }

                            final job = state.jobs[index];
                            return JobCard(
                              job: job,
                              onTap: () {
                                // TODO: Navigate to job details
                              },
                              onSaveToggle: () {
                                // TODO: Toggle save job
                              },
                            );
                          },
                          childCount: state.jobs.length + 1,
                        ),
                      );
                    }

                    if (state is JobsLoadingMore) {
                      return SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            if (index == state.currentJobs.length) {
                              return Padding(
                                padding: EdgeInsets.all(16.w),
                                child: const Center(
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            }

                            final job = state.currentJobs[index];
                            return JobCard(
                              job: job,
                              onTap: () {
                                // TODO: Navigate to job details
                              },
                              onSaveToggle: () {
                                // TODO: Toggle save job
                              },
                            );
                          },
                          childCount: state.currentJobs.length + 1,
                        ),
                      );
                    }

                    return const SliverToBoxAdapter(child: SizedBox.shrink());
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
