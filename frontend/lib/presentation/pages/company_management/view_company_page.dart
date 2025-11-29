import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../config/di/injection.dart';
import '../../../core/theme/app_colors.dart';
import '../../../domain/entities/company_entity.dart';
import '../../bloc/company_management/company_management_bloc.dart';
import '../../bloc/company_management/company_management_event.dart';
import '../../bloc/company_management/company_management_state.dart';

class ViewCompanyPage extends StatelessWidget {
  final String companySlug;

  const ViewCompanyPage({
    super.key,
    required this.companySlug,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<CompanyManagementBloc>()
        ..add(LoadMyCompanyBySlugEvent(companySlug)),
      child: const _ViewCompanyView(),
    );
  }
}

class _ViewCompanyView extends StatelessWidget {
  const _ViewCompanyView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<CompanyManagementBloc, CompanyManagementState>(
        listener: (context, state) {
          if (state is CompanyManagementError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          } else if (state is CompanyDeleted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Company deleted successfully'),
                backgroundColor: Colors.green,
              ),
            );
            context.go('/main/2'); // Navigate to company tab
          }
        },
        builder: (context, state) {
          if (state is CompanyManagementLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is MyCompanyLoaded) {
            return _buildCompanyDetail(context, state.company);
          }

          return const Center(child: Text('Failed to load company'));
        },
      ),
    );
  }

  Widget _buildCompanyDetail(BuildContext context, CompanyEntity company) {
    return CustomScrollView(
      slivers: [
        // App Bar with Cover Image
        SliverAppBar(
          expandedHeight: 200.h,
          pinned: true,
          flexibleSpace: FlexibleSpaceBar(
            background: company.cover != null && company.cover!.isNotEmpty
                ? CachedNetworkImage(
                    imageUrl: company.coverUrl,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      color: Colors.grey[300],
                      child: const Center(child: CircularProgressIndicator()),
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      child: Icon(
                        Icons.business,
                        size: 60.sp,
                        color: AppColors.primary.withValues(alpha: 0.3),
                      ),
                    ),
                  )
                : Container(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    child: Icon(
                      Icons.business,
                      size: 60.sp,
                      color: AppColors.primary.withValues(alpha: 0.3),
                    ),
                  ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                context.push('/company-management/edit-company/${company.id}');
              },
            ),
            PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'delete') {
                  _showDeleteConfirmation(context, company);
                }
              },
              itemBuilder: (context) => [
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

        // Content
        SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Company Header
              Padding(
                padding: EdgeInsets.all(16.w),
                child: Row(
                  children: [
                    // Logo
                    Container(
                      width: 80.w,
                      height: 80.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.r),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: company.logo != null && company.logo!.isNotEmpty
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(12.r),
                              child: CachedNetworkImage(
                                imageUrl: company.logoUrl,
                                fit: BoxFit.cover,
                                placeholder: (context, url) => const Center(
                                  child: CircularProgressIndicator(),
                                ),
                                errorWidget: (context, url, error) => Icon(
                                  Icons.business,
                                  size: 40.sp,
                                  color: Colors.grey[400],
                                ),
                              ),
                            )
                          : Icon(
                              Icons.business,
                              size: 40.sp,
                              color: Colors.grey[400],
                            ),
                    ),
                    SizedBox(width: 16.w),
                    // Company Info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            company.name,
                            style: TextStyle(
                              fontSize: 24.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (company.industry != null) ...[
                            SizedBox(height: 4.h),
                            Text(
                              company.industry!,
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Quick Stats
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Row(
                  children: [
                    _buildStatChip(
                      Icons.work_outline,
                      '${company.jobsCount} Jobs',
                      AppColors.primary,
                    ),
                    SizedBox(width: 12.w),
                    if (company.size != null)
                      _buildStatChip(
                        Icons.people_outline,
                        company.size!,
                        Colors.blue,
                      ),
                    if (company.foundedYear != null) ...[
                      SizedBox(width: 12.w),
                      _buildStatChip(
                        Icons.calendar_today,
                        'Founded ${company.foundedYear}',
                        Colors.green,
                      ),
                    ],
                  ],
                ),
              ),

              SizedBox(height: 24.h),

              // Action Buttons
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          context.push(
                              '/company-management/create-job?company=${company.id}');
                        },
                        icon: const Icon(Icons.add),
                        label: const Text('Post Job'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          context.push(
                              '/company-management/edit-company/${company.id}');
                        },
                        icon: const Icon(Icons.edit),
                        label: const Text('Edit Profile'),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 24.h),

              // About Section
              if (company.description != null &&
                  company.description!.isNotEmpty) ...[
                _buildSection(
                  'About',
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        company.description!,
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.grey[700],
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              // Contact Information
              _buildSection(
                'Contact Information',
                Column(
                  children: [
                    if (company.location.isNotEmpty)
                      _buildContactItem(
                        Icons.location_on,
                        company.location,
                        null,
                      ),
                    if (company.email != null)
                      _buildContactItem(
                        Icons.email,
                        company.email!,
                        () => _launchUrl('mailto:${company.email}'),
                      ),
                    if (company.phone != null)
                      _buildContactItem(
                        Icons.phone,
                        company.phone!,
                        () => _launchUrl('tel:${company.phone}'),
                      ),
                    if (company.website != null)
                      _buildContactItem(
                        Icons.language,
                        company.website!,
                        () => _launchUrl(company.website!),
                      ),
                  ],
                ),
              ),

              SizedBox(height: 24.h),

              // View Jobs Button
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      // Navigate to jobs page filtered by this company
                      context.push('/main/1'); // My Jobs tab
                    },
                    icon: const Icon(Icons.work_outline),
                    label: Text('View All Jobs (${company.jobsCount})'),
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 32.h),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatChip(IconData icon, String label, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16.sp, color: color),
          SizedBox(width: 4.w),
          Text(
            label,
            style: TextStyle(
              fontSize: 12.sp,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, Widget content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(height: 12.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: content,
        ),
        SizedBox(height: 24.h),
      ],
    );
  }

  Widget _buildContactItem(IconData icon, String text, VoidCallback? onTap) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8.h),
        child: Row(
          children: [
            Icon(icon, size: 20.sp, color: Colors.grey[600]),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: onTap != null ? AppColors.primary : Colors.grey[700],
                  decoration: onTap != null ? TextDecoration.underline : null,
                ),
              ),
            ),
            if (onTap != null)
              Icon(Icons.open_in_new, size: 16.sp, color: Colors.grey[400]),
          ],
        ),
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  void _showDeleteConfirmation(BuildContext context, CompanyEntity company) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete Company'),
        content: Text(
          'Are you sure you want to delete ${company.name}? This will also delete all associated jobs. This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              context
                  .read<CompanyManagementBloc>()
                  .add(DeleteCompanyEvent(company.id));
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
