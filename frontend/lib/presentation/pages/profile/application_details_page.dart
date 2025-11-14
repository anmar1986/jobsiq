import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:timeline_tile/timeline_tile.dart';
import '../../../core/theme/app_colors.dart';

class ApplicationDetailsPage extends StatelessWidget {
  final Map<String, dynamic> application;

  const ApplicationDetailsPage({
    super.key,
    required this.application,
  });

  @override
  Widget build(BuildContext context) {
    final job = application['job'];
    final company = job?['company'];
    final cv = application['cv'];
    final status = application['status'] ?? 'pending';
    final appliedAt = application['applied_at'];
    final reviewedAt = application['reviewed_at'];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Application Details'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Job Information Card
            _buildJobCard(job, company),

            SizedBox(height: 24.h),

            // Application Status Timeline
            _buildSectionTitle('Application Timeline'),
            SizedBox(height: 16.h),
            _buildTimeline(status, appliedAt, reviewedAt),

            SizedBox(height: 24.h),

            // CV Used Section
            if (cv != null) ...[
              _buildSectionTitle('CV Used'),
              SizedBox(height: 12.h),
              _buildCvCard(cv),
              SizedBox(height: 24.h),
            ],

            // Cover Letter Section
            if (application['cover_letter'] != null &&
                application['cover_letter'].toString().isNotEmpty) ...[
              _buildSectionTitle('Cover Letter'),
              SizedBox(height: 12.h),
              _buildCoverLetterCard(application['cover_letter']),
              SizedBox(height: 24.h),
            ],

            // Application Details
            _buildSectionTitle('Application Information'),
            SizedBox(height: 12.h),
            _buildInfoCard(application),
          ],
        ),
      ),
    );
  }

  Widget _buildJobCard(
      Map<String, dynamic>? job, Map<String, dynamic>? company) {
    if (job == null) return const SizedBox.shrink();

    return Card(
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Company Logo & Name
            if (company != null) ...[
              Row(
                children: [
                  if (company['logo'] != null)
                    Container(
                      width: 48.w,
                      height: 48.w,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child:
                          const Icon(Icons.business, color: AppColors.primary),
                    )
                  else
                    const Icon(Icons.business, color: AppColors.primary),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          company['name'] ?? '',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        if (company['city'] != null ||
                            company['country'] != null)
                          Text(
                            [company['city'], company['country']]
                                .where((e) => e != null)
                                .join(', '),
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: Colors.grey,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12.h),
              const Divider(),
              SizedBox(height: 12.h),
            ],

            // Job Title & Type
            Text(
              job['title'] ?? 'Job Title',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.h),

            // Job Details
            Wrap(
              spacing: 8.w,
              runSpacing: 8.h,
              children: [
                if (job['employment_type'] != null)
                  _buildChip(job['employment_type'], Icons.work_outline),
                if (job['experience_level'] != null)
                  _buildChip(job['experience_level'], Icons.star_outline),
                if (job['location'] != null)
                  _buildChip(job['location'], Icons.location_on_outlined),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeline(String status, String? appliedAt, String? reviewedAt) {
    final List<TimelineStep> steps = [
      TimelineStep(
        title: 'Application Submitted',
        description: appliedAt != null
            ? 'Submitted on ${_formatDate(appliedAt)}'
            : 'Submitted',
        icon: Icons.send,
        isCompleted: true,
        color: Colors.blue,
      ),
      TimelineStep(
        title: 'Under Review',
        description: status == 'reviewed' ||
                status == 'accepted' ||
                status == 'rejected'
            ? 'Reviewed ${reviewedAt != null ? 'on ${_formatDate(reviewedAt)}' : ''}'
            : 'Waiting for review',
        icon: Icons.preview,
        isCompleted: status == 'reviewed' ||
            status == 'accepted' ||
            status == 'rejected',
        color: Colors.orange,
      ),
      TimelineStep(
        title: status == 'accepted'
            ? 'Accepted'
            : status == 'rejected'
                ? 'Rejected'
                : 'Final Decision',
        description: status == 'accepted'
            ? 'Congratulations! Your application was accepted'
            : status == 'rejected'
                ? 'Unfortunately, your application was not selected'
                : 'Waiting for final decision',
        icon: status == 'accepted'
            ? Icons.check_circle
            : status == 'rejected'
                ? Icons.cancel
                : Icons.hourglass_empty,
        isCompleted: status == 'accepted' || status == 'rejected',
        color: status == 'accepted'
            ? Colors.green
            : status == 'rejected'
                ? Colors.red
                : Colors.grey,
      ),
    ];

    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: EdgeInsets.all(16.w),
      child: Column(
        children: steps.asMap().entries.map((entry) {
          final index = entry.key;
          final step = entry.value;
          final isFirst = index == 0;
          final isLast = index == steps.length - 1;

          return TimelineTile(
            isFirst: isFirst,
            isLast: isLast,
            alignment: TimelineAlign.start,
            lineXY: 0.2,
            indicatorStyle: IndicatorStyle(
              width: 40.w,
              height: 40.w,
              indicator: Container(
                decoration: BoxDecoration(
                  color: step.isCompleted ? step.color : Colors.grey.shade300,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  step.icon,
                  color: Colors.white,
                  size: 20.sp,
                ),
              ),
            ),
            beforeLineStyle: LineStyle(
              color: step.isCompleted ? step.color : Colors.grey.shade300,
              thickness: 2,
            ),
            endChild: Padding(
              padding: EdgeInsets.only(left: 16.w, bottom: isLast ? 0 : 24.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    step.title,
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.bold,
                      color: step.isCompleted ? Colors.black : Colors.grey,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    step.description,
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: step.isCompleted
                          ? AppColors.textSecondary
                          : Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildCvCard(Map<String, dynamic> cv) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Row(
          children: [
            Icon(
              Icons.description,
              size: 40.sp,
              color: AppColors.primary,
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    cv['title'] ?? 'CV',
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    cv['full_name'] ?? '',
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildCoverLetterCard(String coverLetter) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.mail_outline, color: AppColors.primary),
                SizedBox(width: 8.w),
                Text(
                  'Your Cover Letter',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            Text(
              coverLetter,
              style: TextStyle(
                fontSize: 13.sp,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(Map<String, dynamic> application) {
    final appliedAt = application['applied_at'];
    final updatedAt = application['updated_at'];

    return Card(
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          children: [
            _buildInfoRow('Application ID', '#${application['id']}'),
            Divider(height: 24.h),
            _buildInfoRow('Applied Date',
                appliedAt != null ? _formatDate(appliedAt) : 'N/A'),
            Divider(height: 24.h),
            _buildInfoRow('Last Updated',
                updatedAt != null ? _formatDate(updatedAt) : 'N/A'),
            if (application['reviewed_at'] != null) ...[
              Divider(height: 24.h),
              _buildInfoRow(
                  'Reviewed Date', _formatDate(application['reviewed_at'])),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13.sp,
            color: AppColors.textSecondary,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildChip(String label, IconData icon) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14.sp, color: AppColors.primary),
          SizedBox(width: 4.w),
          Text(
            label,
            style: TextStyle(
              fontSize: 12.sp,
              color: AppColors.primary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18.sp,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return DateFormat('MMM dd, yyyy - HH:mm').format(date);
    } catch (e) {
      return dateString;
    }
  }
}

class TimelineStep {
  final String title;
  final String description;
  final IconData icon;
  final bool isCompleted;
  final Color color;

  TimelineStep({
    required this.title,
    required this.description,
    required this.icon,
    required this.isCompleted,
    required this.color,
  });
}
