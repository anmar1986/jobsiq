import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../config/routes/app_router.dart';
import '../../../config/di/injection.dart';
import '../../../core/network/dio_client.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/config/app_config.dart';
import '../../bloc/auth/auth_bloc.dart';
import '../../bloc/auth/auth_event.dart';
import '../../bloc/auth/auth_state.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

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
        final initials = user.name.isNotEmpty
            ? user.name.split(' ').take(2).map((n) => n[0]).join().toUpperCase()
            : 'U';

        // Build profile image provider
        ImageProvider? profileImageProvider;
        if (user.profilePhoto != null && user.profilePhoto!.isNotEmpty) {
          final imageUrl = user.profilePhoto!.startsWith('http')
              ? user.profilePhoto!
              : AppConfig.getStorageUrl(user.profilePhoto!);
          profileImageProvider = NetworkImage(imageUrl);
        }

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
                        context.push(AppRouter.settings);
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
                          backgroundImage: profileImageProvider,
                          child: profileImageProvider == null
                              ? Text(
                                  initials,
                                  style: TextStyle(
                                    fontSize: 32.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                )
                              : null,
                        ),
                        SizedBox(height: 16.h),
                        Text(
                          user.name,
                          style: TextStyle(
                            fontSize: 22.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          user.email,
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        SizedBox(height: 24.h),
                        ListTile(
                          leading: const Icon(Icons.person_outline_rounded),
                          title: const Text('Personal Information'),
                          trailing: const Icon(Icons.chevron_right_rounded),
                          onTap: () =>
                              context.push(AppRouter.personalInformation),
                        ),
                        ListTile(
                          leading: const Icon(Icons.lock_outline_rounded),
                          title: const Text('Change Password'),
                          trailing: const Icon(Icons.chevron_right_rounded),
                          onTap: () => context.push(AppRouter.changePassword),
                        ),
                        ListTile(
                          leading: const Icon(Icons.work_history_rounded),
                          title: const Text('My Applications'),
                          trailing: const Icon(Icons.chevron_right_rounded),
                          onTap: () => context.push(AppRouter.myApplications),
                        ),
                        ListTile(
                          leading:
                              const Icon(Icons.notifications_active_outlined),
                          title: const Text('Job Alerts'),
                          trailing: const Icon(Icons.chevron_right_rounded),
                          onTap: () => context.push(AppRouter.jobAlerts),
                        ),
                        SizedBox(height: 24.h),
                        OutlinedButton.icon(
                          onPressed: () {
                            context.read<AuthBloc>().add(LogoutEvent());
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
                        SizedBox(height: 12.h),
                        OutlinedButton.icon(
                          onPressed: () => _showDeleteAccountDialog(context),
                          icon: const Icon(Icons.delete_forever_rounded),
                          label: const Text('Delete Account'),
                          style: OutlinedButton.styleFrom(
                            minimumSize: Size(double.infinity, 44.h),
                            foregroundColor: Colors.red.shade700,
                            side: BorderSide(color: Colors.red.shade700),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showDeleteAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.red.shade700),
            SizedBox(width: 12.w),
            const Text('Delete Account'),
          ],
        ),
        content: const Text(
          'Are you sure you want to delete your account? This action cannot be undone and all your data will be permanently deleted including:\n\n• Your profile\n• All CVs\n• Saved jobs\n• Job applications\n• Personal information\n\nThis action is irreversible.',
          style: TextStyle(height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(dialogContext);
              await _deleteAccount(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade700,
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteAccount(BuildContext context) async {
    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Deleting account...'),
              ],
            ),
          ),
        ),
      ),
    );

    try {
      final dioClient = sl<DioClient>();
      final response = await dioClient.delete(ApiConstants.deleteProfile);

      if (context.mounted) {
        Navigator.pop(context); // Close loading dialog

        if (response.statusCode == 200) {
          // Logout and redirect to login
          context.read<AuthBloc>().add(LogoutEvent());
          context.go(AppRouter.login);

          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Account deleted successfully'),
              backgroundColor: Colors.green,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to delete account: ${response.data}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.pop(context); // Close loading dialog
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
