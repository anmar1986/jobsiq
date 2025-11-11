import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/theme/app_colors.dart';

class CvsPage extends StatelessWidget {
  const CvsPage({super.key});

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
                'My CVs',
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.add_rounded),
                  onPressed: () {
                    // TODO: Create new CV
                  },
                ),
              ],
            ),
            SliverPadding(
              padding: EdgeInsets.all(16.w),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return _buildCvCard(context, isPrimary: index == 0);
                  },
                  childCount: 3, // TODO: Replace with actual data
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // TODO: Create new CV
        },
        icon: const Icon(Icons.add_rounded),
        label: const Text('New CV'),
      ),
    );
  }

  Widget _buildCvCard(BuildContext context, {bool isPrimary = false}) {
    return Card(
      margin: EdgeInsets.only(bottom: 12.h),
      child: InkWell(
        onTap: () {
          // TODO: Navigate to CV details
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                'Software Engineer CV',
                                style: TextStyle(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            if (isPrimary) ...[
                              SizedBox(width: 8.w),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8.w,
                                  vertical: 2.h,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.primary,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  'PRIMARY',
                                  style: TextStyle(
                                    fontSize: 10.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          'Last updated: 2 days ago',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  PopupMenuButton(
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'edit',
                        child: Text('Edit'),
                      ),
                      if (!isPrimary)
                        const PopupMenuItem(
                          value: 'primary',
                          child: Text('Set as Primary'),
                        ),
                      const PopupMenuItem(
                        value: 'download',
                        child: Text('Download PDF'),
                      ),
                      const PopupMenuItem(
                        value: 'share',
                        child: Text('Share'),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Text('Delete'),
                      ),
                    ],
                    onSelected: (value) {
                      // TODO: Handle menu actions
                    },
                  ),
                ],
              ),
              SizedBox(height: 12.h),
              const Divider(),
              SizedBox(height: 8.h),
              Row(
                children: [
                  _buildStatItem(
                    icon: Icons.work_outline_rounded,
                    label: '3 Experiences',
                  ),
                  SizedBox(width: 16.w),
                  _buildStatItem(
                    icon: Icons.school_outlined,
                    label: '2 Education',
                  ),
                  SizedBox(width: 16.w),
                  _buildStatItem(
                    icon: Icons.code_rounded,
                    label: '8 Skills',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem({required IconData icon, required String label}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 16.sp,
          color: AppColors.primary,
        ),
        SizedBox(width: 4.w),
        Text(
          label,
          style: TextStyle(
            fontSize: 12.sp,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
