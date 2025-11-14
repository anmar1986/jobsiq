import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../config/di/injection.dart';
import '../../../config/routes/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/services/cv_pdf_generator.dart';
import '../../../domain/entities/cv_entity.dart';
import '../../bloc/cvs/cvs_bloc.dart';
import '../../bloc/cvs/cvs_event.dart';
import '../../bloc/cvs/cvs_state.dart';

class CvsPage extends StatelessWidget {
  const CvsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<CvsBloc>()..add(const LoadCvsEvent()),
      child: Scaffold(
        body: SafeArea(
          child: RefreshIndicator(
            onRefresh: () async {
              context.read<CvsBloc>().add(const LoadCvsEvent());
              await Future.delayed(const Duration(seconds: 1));
            },
            child: CustomScrollView(
              slivers: [
                SliverAppBar(
                  floating: true,
                  snap: true,
                  title: BlocBuilder<CvsBloc, CvsState>(
                    builder: (context, state) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'My CVs',
                            style: TextStyle(
                              fontSize: 24.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (state is CvsLoaded && state.cvs.isNotEmpty)
                            Text(
                              '${state.cvs.length} CV${state.cvs.length != 1 ? 's' : ''}',
                              style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.normal,
                                color: Colors.grey[600],
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.add_rounded),
                      onPressed: () {
                        context.push(AppRouter.createCv);
                      },
                    ),
                  ],
                ),
                BlocBuilder<CvsBloc, CvsState>(
                  builder: (context, state) {
                    if (state is CvsLoading) {
                      return const SliverFillRemaining(
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }

                    if (state is CvsError) {
                      return SliverFillRemaining(
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.error_outline_rounded,
                                size: 64.sp,
                                color: Colors.red,
                              ),
                              SizedBox(height: 16.h),
                              Text(
                                state.message,
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 16.sp),
                              ),
                              SizedBox(height: 16.h),
                              ElevatedButton(
                                onPressed: () {
                                  context
                                      .read<CvsBloc>()
                                      .add(const LoadCvsEvent());
                                },
                                child: const Text('Retry'),
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    if (state is CvsEmpty) {
                      return SliverFillRemaining(
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.description_outlined,
                                size: 64.sp,
                                color: Colors.grey,
                              ),
                              SizedBox(height: 16.h),
                              Text(
                                'No CVs yet',
                                style: TextStyle(fontSize: 18.sp),
                              ),
                              SizedBox(height: 8.h),
                              Text(
                                'Create your first CV to get started',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    if (state is CvsLoaded ||
                        state is CvDeleting ||
                        state is CvSettingPrimary) {
                      final cvs = state is CvsLoaded
                          ? state.cvs
                          : state is CvDeleting
                              ? state.cvs
                              : (state as CvSettingPrimary).cvs;

                      return SliverPadding(
                        padding: EdgeInsets.all(16.w),
                        sliver: SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              final cv = cvs[index];
                              final isDeleting =
                                  state is CvDeleting && state.cvId == cv.id;
                              final isSettingPrimary =
                                  state is CvSettingPrimary &&
                                      state.cvId == cv.id;

                              return _buildCvCard(
                                context,
                                cv: cv,
                                isDeleting: isDeleting,
                                isSettingPrimary: isSettingPrimary,
                              );
                            },
                            childCount: cvs.length,
                          ),
                        ),
                      );
                    }

                    return const SliverToBoxAdapter(child: SizedBox.shrink());
                  },
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            context.push(AppRouter.createCv);
          },
          icon: const Icon(Icons.add_rounded),
          label: const Text('New CV'),
        ),
      ),
    );
  }

  Widget _buildCvCard(
    BuildContext context, {
    required CvEntity cv,
    bool isDeleting = false,
    bool isSettingPrimary = false,
  }) {
    return Opacity(
      opacity: isDeleting || isSettingPrimary ? 0.5 : 1.0,
      child: Card(
        margin: EdgeInsets.only(bottom: 12.h),
        child: InkWell(
          onTap: isDeleting || isSettingPrimary
              ? null
              : () {
                  context.push(
                    AppRouter.cvDetails.replaceAll(':id', cv.id.toString()),
                    extra: cv,
                  );
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
                                  cv.title,
                                  style: TextStyle(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              if (cv.isPrimary) ...[
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
                            cv.formattedUpdatedDate,
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (isDeleting || isSettingPrimary)
                      SizedBox(
                        width: 24.w,
                        height: 24.h,
                        child: const CircularProgressIndicator(strokeWidth: 2),
                      )
                    else
                      PopupMenuButton(
                        itemBuilder: (context) => [
                          const PopupMenuItem(
                            value: 'edit',
                            child: Text('Edit'),
                          ),
                          if (!cv.isPrimary)
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
                          _handleMenuAction(context, value, cv);
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
                      label:
                          '${cv.experienceCount} Experience${cv.experienceCount != 1 ? 's' : ''}',
                    ),
                    SizedBox(width: 16.w),
                    _buildStatItem(
                      icon: Icons.school_outlined,
                      label: '${cv.educationCount} Education',
                    ),
                    SizedBox(width: 16.w),
                    _buildStatItem(
                      icon: Icons.code_rounded,
                      label:
                          '${cv.skillsCount} Skill${cv.skillsCount != 1 ? 's' : ''}',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleMenuAction(BuildContext context, String action, CvEntity cv) {
    switch (action) {
      case 'edit':
        context.push(AppRouter.editCv, extra: cv);
        break;
      case 'primary':
        context.read<CvsBloc>().add(SetPrimaryCvEvent(cv.id));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Setting "${cv.title}" as primary...')),
        );
        break;
      case 'download':
        _downloadPdf(context, cv);
        break;
      case 'share':
        _sharePdf(context, cv);
        break;
      case 'delete':
        _showDeleteConfirmation(context, cv);
        break;
    }
  }

  void _showDeleteConfirmation(BuildContext context, CvEntity cv) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete CV'),
        content: Text('Are you sure you want to delete "${cv.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              context.read<CvsBloc>().add(DeleteCvEvent(cv.id));
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Deleting "${cv.title}"...')),
              );
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
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

  Future<void> _downloadPdf(BuildContext context, CvEntity cv) async {
    try {
      // Show loading indicator
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Row(
            children: [
              SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
              SizedBox(width: 16),
              Text('Generating PDF...'),
            ],
          ),
          duration: Duration(seconds: 3),
        ),
      );

      final file = await CvPdfGenerator.downloadPdf(cv);

      if (context.mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('CV downloaded to ${file.path}'),
            backgroundColor: Colors.green,
            action: SnackBarAction(
              label: 'Open',
              textColor: Colors.white,
              onPressed: () {
                // You can add open file functionality here if needed
              },
            ),
          ),
        );
      }
    } catch (e) {
      debugPrint('❌ Error downloading PDF: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to download PDF: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _sharePdf(BuildContext context, CvEntity cv) async {
    try {
      // Show loading indicator
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Row(
            children: [
              SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
              SizedBox(width: 16),
              Text('Preparing PDF to share...'),
            ],
          ),
          duration: Duration(seconds: 2),
        ),
      );

      await CvPdfGenerator.sharePdf(cv);

      if (context.mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
      }
    } catch (e) {
      debugPrint('❌ Error sharing PDF: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to share PDF: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
