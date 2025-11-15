import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../config/routes/app_router.dart';
import '../../../domain/entities/company_entity.dart';

class CompanyDetailsPage extends StatelessWidget {
  final CompanyEntity company;

  const CompanyDetailsPage({super.key, required this.company});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App Bar with Cover Image
          SliverAppBar(
            expandedHeight: 200.h,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                company.name,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              background: company.cover != null && company.cover!.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: company.coverUrl,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        child: const Center(child: CircularProgressIndicator()),
                      ),
                      errorWidget: (context, url, error) => Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              AppColors.primary,
                              AppColors.primary.withValues(alpha: 0.7),
                            ],
                          ),
                        ),
                      ),
                    )
                  : Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            AppColors.primary,
                            AppColors.primary.withValues(alpha: 0.7),
                          ],
                        ),
                      ),
                    ),
            ),
          ),

          // Content
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Company Logo and Basic Info
                _buildCompanyHeader(context),

                // Quick Stats
                _buildQuickStats(),

                // About Section
                if (company.description != null &&
                    company.description!.isNotEmpty)
                  _buildSection(
                    title: 'About',
                    child: Text(
                      company.description!,
                      style: TextStyle(
                        fontSize: 14.sp,
                        height: 1.5,
                      ),
                    ),
                  ),

                // Company Info
                _buildSection(
                  title: 'Company Information',
                  child: Column(
                    children: [
                      if (company.industry != null &&
                          company.industry!.isNotEmpty)
                        _buildInfoRow(
                          icon: Icons.business_center,
                          label: 'Industry',
                          value: company.industry!,
                        ),
                      if (company.size != null && company.size!.isNotEmpty)
                        _buildInfoRow(
                          icon: Icons.people,
                          label: 'Company Size',
                          value: company.size!,
                        ),
                      if (company.foundedYear != null &&
                          company.foundedYear!.isNotEmpty)
                        _buildInfoRow(
                          icon: Icons.calendar_today,
                          label: 'Founded',
                          value: company.foundedYear!,
                        ),
                      if (company.location.isNotEmpty)
                        _buildInfoRow(
                          icon: Icons.location_on,
                          label: 'Location',
                          value: company.location,
                        ),
                    ],
                  ),
                ),

                // Contact Information
                if ((company.email != null && company.email!.isNotEmpty) ||
                    (company.phone != null && company.phone!.isNotEmpty) ||
                    (company.website != null && company.website!.isNotEmpty))
                  _buildSection(
                    title: 'Contact Information',
                    child: Column(
                      children: [
                        if (company.website != null &&
                            company.website!.isNotEmpty)
                          _buildContactRow(
                            icon: Icons.language,
                            label: 'Website',
                            value: company.website!,
                            onTap: () => _launchUrl(company.website!),
                          ),
                        if (company.email != null && company.email!.isNotEmpty)
                          _buildContactRow(
                            icon: Icons.email,
                            label: 'Email',
                            value: company.email!,
                            onTap: () => _launchUrl('mailto:${company.email!}'),
                          ),
                        if (company.phone != null && company.phone!.isNotEmpty)
                          _buildContactRow(
                            icon: Icons.phone,
                            label: 'Phone',
                            value: company.phone!,
                            onTap: () => _launchUrl('tel:${company.phone!}'),
                          ),
                      ],
                    ),
                  ),

                SizedBox(height: 80.h), // Space for FAB
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: company.jobsCount > 0
          ? FloatingActionButton.extended(
              onPressed: () {
                // Navigate to jobs page with company filter
                context
                    .go('${AppRouter.main}?tab=jobs&company=${company.slug}');
              },
              icon: const Icon(Icons.work),
              label: Text('View ${company.jobsCount} Jobs'),
            )
          : null,
    );
  }

  Widget _buildCompanyHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      child: Row(
        children: [
          // Company Logo
          Container(
            width: 80.w,
            height: 80.w,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: company.logo != null && company.logo!.isNotEmpty
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: CachedNetworkImage(
                      imageUrl: company.logoUrl,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => const Center(
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                      errorWidget: (context, url, error) => Icon(
                        Icons.business,
                        size: 40.sp,
                        color: AppColors.primary,
                      ),
                    ),
                  )
                : Icon(
                    Icons.business,
                    size: 40.sp,
                    color: AppColors.primary,
                  ),
          ),
          SizedBox(width: 16.w),

          // Company Name and Industry
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  company.name,
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (company.industry != null &&
                    company.industry!.isNotEmpty) ...[
                  SizedBox(height: 4.h),
                  Text(
                    company.industry!,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStats() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(
            icon: Icons.work_outline,
            value: '${company.jobsCount}',
            label: 'Open Positions',
          ),
          Container(
            width: 1,
            height: 40.h,
            color: Colors.grey.withValues(alpha: 0.3),
          ),
          _buildStatItem(
            icon: Icons.people_outline,
            value: company.size ?? 'N/A',
            label: 'Employees',
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String value,
    required String label,
  }) {
    return Column(
      children: [
        Icon(icon, color: AppColors.primary, size: 28.sp),
        SizedBox(height: 4.h),
        Text(
          value,
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
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

  Widget _buildSection({required String title, required Widget child}) {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 12.h),
          child,
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20.sp, color: AppColors.primary),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: AppColors.textSecondary,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactRow({
    required IconData icon,
    required String label,
    required String value,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.only(bottom: 12.h),
        child: Row(
          children: [
            Icon(icon, size: 20.sp, color: AppColors.primary),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.primary,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.open_in_new,
              size: 16.sp,
              color: AppColors.primary,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _launchUrl(String urlString) async {
    try {
      final uri = Uri.parse(urlString);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      debugPrint('Error launching URL: $e');
    }
  }
}
