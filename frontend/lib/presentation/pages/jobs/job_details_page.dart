import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../config/di/injection.dart';
import '../../../domain/entities/job_entity.dart';
import '../../../data/datasources/cv_remote_data_source.dart';
import '../../../data/models/cv_model.dart';
import '../../bloc/jobs/jobs_bloc.dart';
import '../../bloc/jobs/jobs_event.dart';
import '../../bloc/jobs/jobs_state.dart';

class JobDetailsPage extends StatefulWidget {
  final JobEntity job;

  const JobDetailsPage({
    super.key,
    required this.job,
  });

  @override
  State<JobDetailsPage> createState() => _JobDetailsPageState();
}

class _JobDetailsPageState extends State<JobDetailsPage> {
  late JobEntity _currentJob;

  @override
  void initState() {
    super.initState();
    _currentJob = widget.job;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<JobsBloc>(),
      child: BlocListener<JobsBloc, JobsState>(
        listener: (context, state) {
          if (state is JobSaveToggled) {
            setState(() {
              _currentJob = _currentJob.copyWith(isSaved: state.isSaved);
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.isSaved ? 'Job saved!' : 'Job unsaved'),
                duration: const Duration(seconds: 2),
              ),
            );
          } else if (state is JobSaveError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          } else if (state is JobApplicationSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
              ),
            );
          } else if (state is JobApplicationError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: Scaffold(
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 200.h,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(
                    _currentJob.title,
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  background: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Theme.of(context).primaryColor,
                          Theme.of(context).primaryColor.withValues(alpha: 0.7),
                        ],
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (_currentJob.company?.logo != null)
                          Container(
                            width: 80.w,
                            height: 80.h,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12.r),
                              child: Image.network(
                                _currentJob.company!.logo!,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Icon(
                                    Icons.business,
                                    size: 40.sp,
                                    color: Colors.grey,
                                  );
                                },
                              ),
                            ),
                          )
                        else
                          Container(
                            width: 80.w,
                            height: 80.h,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Icon(
                              Icons.business,
                              size: 40.sp,
                              color: Colors.grey,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Company name
                      if (_currentJob.company != null)
                        Text(
                          _currentJob.company!.name,
                          style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      SizedBox(height: 8.h),

                      // Location
                      if (_currentJob.location != null)
                        Row(
                          children: [
                            Icon(Icons.location_on,
                                size: 16.sp, color: Colors.grey),
                            SizedBox(width: 4.w),
                            Text(
                              _currentJob.location!,
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      SizedBox(height: 16.h),

                      // Job info chips
                      Wrap(
                        spacing: 8.w,
                        runSpacing: 8.h,
                        children: [
                          _buildInfoChip(
                            context,
                            icon: Icons.work_outline,
                            label: _currentJob.employmentType.toUpperCase(),
                          ),
                          if (_currentJob.experienceLevel != null)
                            _buildInfoChip(
                              context,
                              icon: Icons.trending_up,
                              label: _currentJob.experienceLevel!.toUpperCase(),
                            ),
                          if (_currentJob.isRemote)
                            _buildInfoChip(
                              context,
                              icon: Icons.home_work,
                              label: 'REMOTE',
                            ),
                          if (_currentJob.category != null)
                            _buildInfoChip(
                              context,
                              icon: Icons.category,
                              label: _currentJob.category!,
                            ),
                        ],
                      ),
                      SizedBox(height: 24.h),

                      // Salary
                      if (_currentJob.salaryMin != null ||
                          _currentJob.salaryMax != null)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Salary',
                              style: TextStyle(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8.h),
                            Text(
                              _formatSalary(_currentJob),
                              style: TextStyle(
                                fontSize: 16.sp,
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 24.h),
                          ],
                        ),

                      // Description
                      Text(
                        'Description',
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        _currentJob.description,
                        style: TextStyle(
                          fontSize: 14.sp,
                          height: 1.5,
                          color: Colors.grey[700],
                        ),
                      ),
                      SizedBox(height: 24.h),

                      // Requirements
                      if (_currentJob.requirements != null) ...[
                        Text(
                          'Requirements',
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          _currentJob.requirements!,
                          style: TextStyle(
                            fontSize: 14.sp,
                            height: 1.5,
                            color: Colors.grey[700],
                          ),
                        ),
                        SizedBox(height: 24.h),
                      ],

                      // Benefits
                      if (_currentJob.benefits != null) ...[
                        Text(
                          'Benefits',
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          _currentJob.benefits!,
                          style: TextStyle(
                            fontSize: 14.sp,
                            height: 1.5,
                            color: Colors.grey[700],
                          ),
                        ),
                        SizedBox(height: 24.h),
                      ],

                      // Skills
                      if (_currentJob.skills != null &&
                          _currentJob.skills!.isNotEmpty) ...[
                        Text(
                          'Required Skills',
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Wrap(
                          spacing: 8.w,
                          runSpacing: 8.h,
                          children: _currentJob.skills!
                              .map((skill) => Chip(
                                    label: Text(
                                      skill,
                                      style: TextStyle(fontSize: 12.sp),
                                    ),
                                    backgroundColor: Theme.of(context)
                                        .primaryColor
                                        .withValues(alpha: 0.1),
                                  ))
                              .toList(),
                        ),
                        SizedBox(height: 24.h),
                      ],

                      // Published date
                      if (_currentJob.publishedAt != null)
                        Text(
                          'Published: ${_formatDate(_currentJob.publishedAt!)}',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.grey[600],
                          ),
                        ),
                      SizedBox(height: 100.h), // Space for bottom button
                    ],
                  ),
                ),
              ),
            ],
          ),
          bottomSheet: Builder(
            builder: (bottomContext) => Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      bottomContext
                          .read<JobsBloc>()
                          .add(ToggleSaveJobEvent(_currentJob.id));
                    },
                    icon: Icon(
                      _currentJob.isSaved == true
                          ? Icons.bookmark
                          : Icons.bookmark_border,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _currentJob.isApplied == true
                          ? null
                          : () {
                              _showApplyDialog(bottomContext);
                            },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 16.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        backgroundColor: _currentJob.isApplied == true
                            ? Colors.grey.shade300
                            : null,
                      ),
                      child: Text(
                        _currentJob.isApplied == true
                            ? 'Already Applied'
                            : 'Apply Now',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: _currentJob.isApplied == true
                              ? Colors.grey.shade600
                              : null,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showApplyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => _ApplyJobDialog(job: _currentJob),
    );
  }

  Widget _buildInfoChip(BuildContext context,
      {required IconData icon, required String label}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14.sp, color: Theme.of(context).primaryColor),
          SizedBox(width: 4.w),
          Text(
            label,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  String _formatSalary(JobEntity job) {
    final currency = job.salaryCurrency ?? 'USD';
    final period = job.salaryPeriod ?? 'yearly';

    if (job.salaryMin != null && job.salaryMax != null) {
      return '$currency ${_formatNumber(job.salaryMin!)} - ${_formatNumber(job.salaryMax!)} / $period';
    } else if (job.salaryMin != null) {
      return 'From $currency ${_formatNumber(job.salaryMin!)} / $period';
    } else if (job.salaryMax != null) {
      return 'Up to $currency ${_formatNumber(job.salaryMax!)} / $period';
    }
    return 'Salary not specified';
  }

  String _formatNumber(double number) {
    if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(0)}K';
    }
    return number.toStringAsFixed(0);
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else if (difference.inDays < 30) {
      return '${(difference.inDays / 7).floor()} weeks ago';
    } else if (difference.inDays < 365) {
      return '${(difference.inDays / 30).floor()} months ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}

class _ApplyJobDialog extends StatefulWidget {
  final JobEntity job;

  const _ApplyJobDialog({required this.job});

  @override
  State<_ApplyJobDialog> createState() => _ApplyJobDialogState();
}

class _ApplyJobDialogState extends State<_ApplyJobDialog> {
  final coverLetterController = TextEditingController();
  final cvDataSource = sl<CvRemoteDataSource>();

  List<CvModel>? cvs;
  bool isLoadingCvs = true;
  int? selectedCvId;

  @override
  void initState() {
    super.initState();
    _loadCvs();
  }

  Future<void> _loadCvs() async {
    try {
      final loadedCvs = await cvDataSource.getMyCvs();
      if (mounted) {
        setState(() {
          cvs = loadedCvs;
          isLoadingCvs = false;
          // Auto-select primary CV if available
          if (loadedCvs.isNotEmpty) {
            final primaryCv = loadedCvs.firstWhere(
              (cv) => cv.isPrimary,
              orElse: () => loadedCvs.first,
            );
            selectedCvId = primaryCv.id;
          }
        });
      }
    } catch (error) {
      if (mounted) {
        setState(() {
          isLoadingCvs = false;
        });
      }
    }
  }

  @override
  void dispose() {
    coverLetterController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Apply for ${widget.job.title}',
        style: TextStyle(fontSize: 18.sp),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // CV Selection
            Text(
              'Select CV',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 8.h),
            if (isLoadingCvs)
              const Center(child: CircularProgressIndicator())
            else if (cvs == null || cvs!.isEmpty)
              Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(color: Colors.orange.shade200),
                ),
                child: Row(
                  children: [
                    Icon(Icons.warning_amber_rounded,
                        color: Colors.orange.shade700),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: Text(
                        'You need to create a CV first',
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: Colors.orange.shade900,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            else
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<int>(
                    isExpanded: true,
                    value: selectedCvId,
                    hint: const Text('Select a CV'),
                    items: cvs!.map((cv) {
                      return DropdownMenuItem<int>(
                        value: cv.id,
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                cv.title,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (cv.isPrimary)
                              Container(
                                margin: EdgeInsets.only(left: 8.w),
                                padding: EdgeInsets.symmetric(
                                  horizontal: 6.w,
                                  vertical: 2.h,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.blue.shade100,
                                  borderRadius: BorderRadius.circular(4.r),
                                ),
                                child: Text(
                                  'Primary',
                                  style: TextStyle(
                                    fontSize: 10.sp,
                                    color: Colors.blue.shade700,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedCvId = value;
                      });
                    },
                  ),
                ),
              ),

            SizedBox(height: 16.h),

            // Cover Letter
            Text(
              'Cover Letter (Optional)',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 8.h),
            TextField(
              controller: coverLetterController,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: 'Tell the employer why you\'re a great fit...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: (cvs == null || cvs!.isEmpty || selectedCvId == null)
              ? null
              : () {
                  Navigator.pop(context);
                  context.read<JobsBloc>().add(
                        ApplyForJobEvent(
                          jobSlug: widget.job.slug,
                          cvId: selectedCvId,
                          coverLetter: coverLetterController.text.isEmpty
                              ? null
                              : coverLetterController.text,
                        ),
                      );
                },
          child: const Text('Submit Application'),
        ),
      ],
    );
  }
}
