import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../config/routes/app_router.dart';
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
              : 'http://10.0.2.2:8000/storage/${user.profilePhoto}';
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
                      onPressed: () {},
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
}
