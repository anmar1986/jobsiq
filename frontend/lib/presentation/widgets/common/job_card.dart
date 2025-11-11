import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/theme/app_colors.dart';

class JobCard extends StatelessWidget {
  final String title;
  final String companyName;
  final String? companyLogo;
  final String location;
  final String employmentType;
  final String experienceLevel;
  final String salaryRange;
  final bool isSaved;
  final VoidCallback? onTap;
  final VoidCallback? onSaveToggle;

  const JobCard({
    super.key,
    required this.title,
    required this.companyName,
    this.companyLogo,
    required this.location,
    required this.employmentType,
    required this.experienceLevel,
    required this.salaryRange,
    this.isSaved = false,
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
                          title,
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          companyName,
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
                      isSaved
                          ? Icons.bookmark_rounded
                          : Icons.bookmark_border_rounded,
                      color: isSaved ? AppColors.primary : null,
                    ),
                    onPressed: onSaveToggle,
                  ),
                ],
              ),
              SizedBox(height: 12.h),
              Row(
                children: [
                  _InfoChip(
                    icon: Icons.location_on_outlined,
                    label: location,
                  ),
                  SizedBox(width: 8.w),
                  _InfoChip(
                    icon: Icons.work_outline_rounded,
                    label: employmentType,
                  ),
                  SizedBox(width: 8.w),
                  _InfoChip(
                    icon: Icons.stars_rounded,
                    label: experienceLevel,
                  ),
                ],
              ),
              SizedBox(height: 12.h),
              Text(
                salaryRange,
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
      child: companyLogo != null
          ? ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                companyLogo!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.business_rounded),
              ),
            )
          : const Icon(Icons.business_rounded),
    );
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
