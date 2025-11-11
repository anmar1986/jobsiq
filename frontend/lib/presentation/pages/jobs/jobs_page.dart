import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../widgets/common/job_card.dart';

class JobsPage extends StatefulWidget {
  const JobsPage({super.key});

  @override
  State<JobsPage> createState() => _JobsPageState();
}

class _JobsPageState extends State<JobsPage> {
  final _searchController = TextEditingController();
  final _searchNotifier = ValueNotifier<bool>(false);

  @override
  void dispose() {
    _searchController.dispose();
    _searchNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
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
                child: ValueListenableBuilder<bool>(
                  valueListenable: _searchNotifier,
                  builder: (context, hasText, _) => TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search jobs, companies...',
                      prefixIcon: const Icon(Icons.search_rounded),
                      suffixIcon: hasText
                          ? IconButton(
                              icon: const Icon(Icons.clear_rounded),
                              onPressed: () {
                                _searchController.clear();
                                _searchNotifier.value = false;
                              },
                            )
                          : null,
                    ),
                    onChanged: (value) {
                      _searchNotifier.value = value.isNotEmpty;
                    },
                  ),
                ),
              ),
            ),
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              sliver: SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Featured Jobs',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 12.h),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return JobCard(
                      title: 'Senior Flutter Developer',
                      companyName: 'Tech Company Inc.',
                      location: 'Remote',
                      employmentType: 'Full-time',
                      experienceLevel: 'Senior',
                      salaryRange: '\$80,000 - \$120,000/year',
                      onTap: () {
                        // TODO: Navigate to job details
                      },
                      onSaveToggle: () {
                        // TODO: Toggle save job
                      },
                    );
                  },
                  childCount: 10, // TODO: Replace with actual data
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
