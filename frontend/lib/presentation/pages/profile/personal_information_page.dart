import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../config/routes/app_router.dart';
import '../../bloc/auth/auth_bloc.dart';
import '../../bloc/auth/auth_state.dart';

class PersonalInformationPage extends StatelessWidget {
  const PersonalInformationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is! Authenticated) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        final user = state.user;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Personal Information'),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Edit Button
                  OutlinedButton.icon(
                    onPressed: () => context.push(AppRouter.editProfile),
                    icon: const Icon(Icons.edit_rounded),
                    label: const Text('Edit Personal Information'),
                    style: OutlinedButton.styleFrom(
                      minimumSize: Size(double.infinity, 44.h),
                    ),
                  ),
                  SizedBox(height: 24.h),

                  // Basic Information Section
                  _buildSectionTitle('Basic Information'),
                  SizedBox(height: 12.h),
                  _buildInfoRow('Full Name', user.name),
                  _buildInfoRow('Email', user.email),
                  if (user.headline != null && user.headline!.isNotEmpty)
                    _buildInfoRow('Headline', user.headline!),
                  if (user.phoneNumber != null && user.phoneNumber!.isNotEmpty)
                    _buildInfoRow('Phone', user.phoneNumber!),

                  SizedBox(height: 24.h),

                  // Personal Details Section
                  _buildSectionTitle('Personal Details'),
                  SizedBox(height: 12.h),
                  if (user.dateOfBirth != null)
                    _buildInfoRow(
                        'Date of Birth', _formatDate(user.dateOfBirth!)),
                  if (user.gender != null && user.gender!.isNotEmpty)
                    _buildInfoRow('Gender', _capitalizeFirst(user.gender!)),
                  if (user.nationality != null && user.nationality!.isNotEmpty)
                    _buildInfoRow('Nationality', user.nationality!),

                  SizedBox(height: 24.h),

                  // Location Section
                  if (user.city != null ||
                      user.country != null ||
                      user.address != null) ...[
                    _buildSectionTitle('Location'),
                    SizedBox(height: 12.h),
                    if (user.city != null && user.city!.isNotEmpty)
                      _buildInfoRow('City', user.city!),
                    if (user.country != null && user.country!.isNotEmpty)
                      _buildInfoRow('Country', user.country!),
                    if (user.address != null && user.address!.isNotEmpty)
                      _buildInfoRow('Address', user.address!),
                    SizedBox(height: 24.h),
                  ],

                  // Social Links Section
                  if (user.linkedinUrl != null &&
                      user.linkedinUrl!.isNotEmpty) ...[
                    _buildSectionTitle('Social Links'),
                    SizedBox(height: 12.h),
                    _buildInfoRow('LinkedIn', user.linkedinUrl!),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(left: 4.w, bottom: 8.h),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 4.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              '$label:',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14.sp,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  String _capitalizeFirst(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }
}
