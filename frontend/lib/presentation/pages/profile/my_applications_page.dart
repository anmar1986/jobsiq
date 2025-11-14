import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/datasources/job_application_remote_data_source.dart';
import '../../../config/di/injection.dart' as di;
import '../../../domain/entities/job_entity.dart';
import '../../../config/routes/app_router.dart';

class MyApplicationsPage extends StatefulWidget {
  const MyApplicationsPage({super.key});

  @override
  State<MyApplicationsPage> createState() => _MyApplicationsPageState();
}

class _MyApplicationsPageState extends State<MyApplicationsPage> {
  final _dataSource = di.sl<JobApplicationRemoteDataSource>();
  bool _isLoading = true;
  List<dynamic> _applications = [];
  String? _errorMessage;
  String? _selectedStatus;

  final List<Map<String, String>> _statusOptions = [
    {'value': '', 'label': 'All Status'},
    {'value': 'pending', 'label': 'Pending'},
    {'value': 'reviewed', 'label': 'Reviewed'},
    {'value': 'accepted', 'label': 'Accepted'},
    {'value': 'rejected', 'label': 'Rejected'},
  ];

  @override
  void initState() {
    super.initState();
    _loadApplications();
  }

  Future<void> _loadApplications() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final response = await _dataSource.getMyApplications(
        status: _selectedStatus,
      );

      setState(() {
        _applications = response['data'] ?? [];
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'reviewed':
        return Colors.blue;
      case 'accepted':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      default:
        return AppColors.textSecondary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Applications'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Status Filter
            Container(
              padding: EdgeInsets.all(16.w),
              color: Colors.grey.shade50,
              child: DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Filter by Status',
                  prefixIcon: Icon(Icons.filter_list_rounded),
                ),
                items: _statusOptions.map((option) {
                  return DropdownMenuItem<String>(
                    value: option['value'],
                    child: Text(option['label']!),
                  );
                }).toList(),
                selectedItemBuilder: (BuildContext context) {
                  return _statusOptions.map<Widget>((option) {
                    return Text(option['label']!);
                  }).toList();
                },
                hint: Text(
                  _statusOptions.firstWhere(
                    (opt) => opt['value'] == (_selectedStatus ?? ''),
                    orElse: () => _statusOptions.first,
                  )['label']!,
                ),
                onChanged: (value) {
                  setState(() {
                    _selectedStatus = value == '' ? null : value;
                  });
                  _loadApplications();
                },
              ),
            ),

            // Applications List
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _errorMessage != null
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.error_outline_rounded,
                                size: 64.sp,
                                color: AppColors.error,
                              ),
                              SizedBox(height: 16.h),
                              Text(
                                'Error loading applications',
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 8.h),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 32.w),
                                child: Text(
                                  _errorMessage!,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ),
                              SizedBox(height: 24.h),
                              ElevatedButton.icon(
                                onPressed: _loadApplications,
                                icon: const Icon(Icons.refresh_rounded),
                                label: const Text('Retry'),
                              ),
                            ],
                          ),
                        )
                      : _applications.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.inbox_outlined,
                                    size: 64.sp,
                                    color: AppColors.textSecondary,
                                  ),
                                  SizedBox(height: 16.h),
                                  Text(
                                    'No Applications Yet',
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 8.h),
                                  Text(
                                    'Start applying to jobs to see your applications here',
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                  SizedBox(height: 24.h),
                                  ElevatedButton(
                                    onPressed: () => context.pop(),
                                    child: const Text('Browse Jobs'),
                                  ),
                                ],
                              ),
                            )
                          : RefreshIndicator(
                              onRefresh: _loadApplications,
                              child: ListView.builder(
                                padding: EdgeInsets.all(16.w),
                                itemCount: _applications.length,
                                itemBuilder: (context, index) {
                                  final application = _applications[index];
                                  final job = application['job'];
                                  final company = job?['company'];

                                  return Card(
                                    margin: EdgeInsets.only(bottom: 16.h),
                                    child: InkWell(
                                      onTap: () {
                                        if (job != null) {
                                          _navigateToJobDetails(job);
                                        }
                                      },
                                      borderRadius: BorderRadius.circular(8.r),
                                      child: Padding(
                                        padding: EdgeInsets.all(16.w),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            // Job Title
                                            Text(
                                              job?['title'] ?? 'N/A',
                                              style: TextStyle(
                                                fontSize: 16.sp,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            SizedBox(height: 4.h),

                                            // Company Name
                                            if (company != null)
                                              Text(
                                                company['name'] ?? '',
                                                style: TextStyle(
                                                  fontSize: 14.sp,
                                                  color:
                                                      AppColors.textSecondary,
                                                ),
                                              ),

                                            SizedBox(height: 12.h),

                                            // Status Badge
                                            Container(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 12.w,
                                                vertical: 4.h,
                                              ),
                                              decoration: BoxDecoration(
                                                color: _getStatusColor(
                                                        application['status'] ??
                                                            '')
                                                    .withValues(alpha: 0.1),
                                                borderRadius:
                                                    BorderRadius.circular(12.r),
                                              ),
                                              child: Text(
                                                application['status']
                                                        ?.toString()
                                                        .toUpperCase() ??
                                                    'UNKNOWN',
                                                style: TextStyle(
                                                  fontSize: 12.sp,
                                                  fontWeight: FontWeight.bold,
                                                  color: _getStatusColor(
                                                      application['status'] ??
                                                          ''),
                                                ),
                                              ),
                                            ),

                                            SizedBox(height: 12.h),

                                            // Applied Date
                                            Row(
                                              children: [
                                                Icon(
                                                  Icons.calendar_today_outlined,
                                                  size: 14.sp,
                                                  color:
                                                      AppColors.textSecondary,
                                                ),
                                                SizedBox(width: 4.w),
                                                Text(
                                                  'Applied: ${_formatDate(application['applied_at'])}',
                                                  style: TextStyle(
                                                    fontSize: 12.sp,
                                                    color:
                                                        AppColors.textSecondary,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(dynamic date) {
    if (date == null) return 'N/A';

    try {
      final dateTime = DateTime.parse(date.toString());
      final now = DateTime.now();
      final difference = now.difference(dateTime);

      if (difference.inDays == 0) {
        if (difference.inHours == 0) {
          return '${difference.inMinutes} minutes ago';
        }
        return '${difference.inHours} hours ago';
      } else if (difference.inDays < 7) {
        return '${difference.inDays} days ago';
      } else {
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
        return '${months[dateTime.month - 1]} ${dateTime.day}, ${dateTime.year}';
      }
    } catch (e) {
      return date.toString();
    }
  }

  void _navigateToJobDetails(Map<String, dynamic> jobData) {
    try {
      // Parse company data
      final company = jobData['company'] != null
          ? CompanyBriefEntity(
              id: int.parse(jobData['company']['id'].toString()),
              name: jobData['company']['name']?.toString() ?? '',
              slug: jobData['company']['slug']?.toString() ?? '',
              logo: jobData['company']['logo']?.toString(),
              industry: jobData['company']['industry']?.toString(),
              companySize: jobData['company']['company_size']?.toString(),
            )
          : null;

      // Parse job entity with safe type conversions
      final jobEntity = JobEntity(
        id: int.parse(jobData['id'].toString()),
        companyId: jobData['company_id'] != null
            ? int.parse(jobData['company_id'].toString())
            : null,
        userId: jobData['user_id'] != null
            ? int.parse(jobData['user_id'].toString())
            : null,
        title: jobData['title']?.toString() ?? '',
        slug: jobData['slug']?.toString() ?? '',
        description: jobData['description']?.toString() ?? '',
        requirements: jobData['requirements']?.toString(),
        benefits: jobData['benefits']?.toString(),
        location: jobData['location']?.toString(),
        city: jobData['city']?.toString(),
        country: jobData['country']?.toString(),
        employmentType: jobData['employment_type']?.toString() ?? 'full_time',
        experienceLevel: jobData['experience_level']?.toString(),
        category: jobData['category']?.toString(),
        skills: jobData['skills'] != null
            ? List<String>.from(jobData['skills'])
            : null,
        salaryMin: jobData['salary_min'] != null
            ? double.tryParse(jobData['salary_min'].toString())
            : null,
        salaryMax: jobData['salary_max'] != null
            ? double.tryParse(jobData['salary_max'].toString())
            : null,
        salaryCurrency: jobData['salary_currency']?.toString(),
        salaryPeriod: jobData['salary_period']?.toString(),
        isRemote: jobData['is_remote'] == 1 || jobData['is_remote'] == true,
        isFeatured:
            jobData['is_featured'] == 1 || jobData['is_featured'] == true,
        isActive: jobData['is_active'] == 1 || jobData['is_active'] == true,
        isSaved: jobData['is_saved'] == 1 || jobData['is_saved'] == true,
        isApplied: true, // Already applied
        expiresAt: jobData['expires_at'] != null
            ? DateTime.tryParse(jobData['expires_at'].toString())
            : null,
        publishedAt: jobData['published_at'] != null
            ? DateTime.tryParse(jobData['published_at'].toString())
            : null,
        createdAt: DateTime.parse(jobData['created_at'].toString()),
        updatedAt: DateTime.parse(jobData['updated_at'].toString()),
        company: company,
      );

      context.push(AppRouter.jobDetails, extra: jobEntity);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error loading job details: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
