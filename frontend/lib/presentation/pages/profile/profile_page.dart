import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../config/routes/app_router.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

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
                'Profile',
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.settings_rounded),
                  onPressed: () {
                    // TODO: Navigate to settings
                  },
                ),
              ],
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 48.r,
                      backgroundColor: AppColors.primary,
                      child: Text(
                        'JD',
                        style: TextStyle(
                          fontSize: 32.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      'John Doe',
                      style: TextStyle(
                        fontSize: 22.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      'john.doe@example.com',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'Job Seeker',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    SizedBox(height: 24.h),
                    OutlinedButton.icon(
                      onPressed: () {
                        // TODO: Navigate to edit profile
                      },
                      icon: const Icon(Icons.edit_rounded),
                      label: const Text('Edit Profile'),
                      style: OutlinedButton.styleFrom(
                        minimumSize: Size(double.infinity, 44.h),
                      ),
                    ),
                    SizedBox(height: 24.h),
                    _buildSection(
                      context,
                      title: 'Account',
                      items: [
                        _MenuItem(
                          icon: Icons.person_outline_rounded,
                          title: 'Personal Information',
                          onTap: () {},
                        ),
                        _MenuItem(
                          icon: Icons.lock_outline_rounded,
                          title: 'Change Password',
                          onTap: () {},
                        ),
                        _MenuItem(
                          icon: Icons.notifications_outlined,
                          title: 'Notifications',
                          onTap: () {},
                        ),
                      ],
                    ),
                    SizedBox(height: 16.h),
                    _buildSection(
                      context,
                      title: 'Application',
                      items: [
                        _MenuItem(
                          icon: Icons.article_outlined,
                          title: 'My Applications',
                          trailing: '12',
                          onTap: () {},
                        ),
                        _MenuItem(
                          icon: Icons.dark_mode_outlined,
                          title: 'Dark Mode',
                          trailing: Switch(
                            value: false,
                            onChanged: (value) {
                              // TODO: Toggle theme
                            },
                          ),
                          onTap: null,
                        ),
                        _MenuItem(
                          icon: Icons.language_rounded,
                          title: 'Language',
                          trailing: 'English',
                          onTap: () {},
                        ),
                      ],
                    ),
                    SizedBox(height: 16.h),
                    _buildSection(
                      context,
                      title: 'Support',
                      items: [
                        _MenuItem(
                          icon: Icons.help_outline_rounded,
                          title: 'Help Center',
                          onTap: () {},
                        ),
                        _MenuItem(
                          icon: Icons.privacy_tip_outlined,
                          title: 'Privacy Policy',
                          onTap: () {},
                        ),
                        _MenuItem(
                          icon: Icons.info_outline_rounded,
                          title: 'About',
                          onTap: () {},
                        ),
                      ],
                    ),
                    SizedBox(height: 24.h),
                    OutlinedButton.icon(
                      onPressed: () {
                        // TODO: Implement logout
                        context.go(AppRouter.login);
                      },
                      icon: const Icon(Icons.logout_rounded),
                      label: const Text('Logout'),
                      style: OutlinedButton.styleFrom(
                        minimumSize: Size(double.infinity, 44.h),
                        foregroundColor: AppColors.error,
                        side: const BorderSide(color: AppColors.error),
                      ),
                    ),
                    SizedBox(height: 24.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required List<_MenuItem> items,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
        ),
        Card(
          margin: EdgeInsets.zero,
          child: Column(
            children: items
                .map((item) => _buildMenuItem(context, item))
                .toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildMenuItem(BuildContext context, _MenuItem item) {
    return ListTile(
      leading: Icon(item.icon),
      title: Text(item.title),
      trailing: item.trailing != null
          ? (item.trailing is String
              ? Text(
                  item.trailing as String,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: AppColors.textSecondary,
                  ),
                )
              : item.trailing as Widget)
          : const Icon(Icons.chevron_right_rounded),
      onTap: item.onTap,
      enabled: item.onTap != null,
    );
  }
}

class _MenuItem {
  final IconData icon;
  final String title;
  final dynamic trailing;
  final VoidCallback? onTap;

  _MenuItem({
    required this.icon,
    required this.title,
    this.trailing,
    required this.onTap,
  });
}
