import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/theme/app_colors.dart';
import '../../../domain/entities/job_entity.dart';

class JobCard extends StatelessWidget {
  final JobEntity job;
  final VoidCallback? onTap;
  final VoidCallback? onSaveToggle;

  const JobCard({
    super.key,
    required this.job,
    this.onTap,
    this.onSaveToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 12.h),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _buildCompanyLogo(),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          job.title,
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          job.company?.name ?? 'Unknown Company',
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      job.isSaved == true
                          ? Icons.bookmark_rounded
                          : Icons.bookmark_border_rounded,
                      color: job.isSaved == true ? AppColors.primary : null,
                    ),
                    onPressed: onSaveToggle,
                  ),
                ],
              ),
              SizedBox(height: 12.h),
              Wrap(
                spacing: 8.w,
                runSpacing: 8.h,
                children: [
                  _InfoChip(
                    icon: Icons.location_on_outlined,
                    label: job.location ?? 'Remote',
                  ),
                  _InfoChip(
                    icon: Icons.work_outline_rounded,
                    label: _formatEmploymentType(job.employmentType),
                  ),
                  if (job.experienceLevel != null)
                    _InfoChip(
                      icon: Icons.stars_rounded,
                      label: _formatExperienceLevel(job.experienceLevel)!,
                    ),
                  if (job.isRemote)
                    const _InfoChip(
                      icon: Icons.home_work_outlined,
                      label: 'Remote',
                    ),
                ],
              ),
              SizedBox(height: 12.h),
              Text(
                job.salaryRange,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCompanyLogo() {
    return Container(
      width: 48.w,
      height: 48.w,
      decoration: BoxDecoration(
        color: AppColors.grey100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: job.company?.logo != null
          ? ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                job.company!.logo!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.business_rounded),
              ),
            )
          : const Icon(Icons.business_rounded),
    );
  }

  String _formatEmploymentType(String type) {
    switch (type) {
      case 'full-time':
        return 'Full Time';
      case 'part-time':
        return 'Part Time';
      case 'contract':
        return 'Contract';
      case 'freelance':
        return 'Freelance';
      case 'internship':
        return 'Internship';
      default:
        return type;
    }
  }

  String? _formatExperienceLevel(String? level) {
    if (level == null) return null;
    switch (level) {
      case 'entry':
        return 'Entry Level';
      case 'junior':
        return 'Junior';
      case 'mid':
        return 'Mid Level';
      case 'senior':
        return 'Senior';
      case 'lead':
        return 'Lead';
      default:
        return level;
    }
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoChip({
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: AppColors.grey100,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14.sp,
            color: AppColors.textSecondary,
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
      ),
    );
  }
}
