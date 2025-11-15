import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_colors.dart';
import '../../../config/routes/app_router.dart';
import '../../../core/services/cv_pdf_generator.dart';
import '../../../core/config/app_config.dart';
import '../../../domain/entities/cv_entity.dart';

class CvDetailsPage extends StatefulWidget {
  final CvEntity cv;

  const CvDetailsPage({super.key, required this.cv});

  @override
  State<CvDetailsPage> createState() => _CvDetailsPageState();
}

class _CvDetailsPageState extends State<CvDetailsPage> {
  late CvEntity _currentCv;

  @override
  void initState() {
    super.initState();
    _currentCv = widget.cv;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200.h,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: EdgeInsets.only(left: 16.w, bottom: 16.h),
              title: Text(
                _currentCv.title,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              background: Container(
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
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (_currentCv.profileImagePath != null)
                        CircleAvatar(
                          radius: 40.r,
                          backgroundImage: NetworkImage(
                            AppConfig.getStorageUrl(
                                _currentCv.profileImagePath!),
                          ),
                        )
                      else
                        CircleAvatar(
                          radius: 40.r,
                          backgroundColor: Colors.white.withValues(alpha: 0.3),
                          child: Icon(
                            Icons.person,
                            size: 40.sp,
                            color: Colors.white,
                          ),
                        ),
                      SizedBox(height: 8.h),
                      if (_currentCv.isPrimary)
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12.w,
                            vertical: 4.h,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'PRIMARY CV',
                            style: TextStyle(
                              fontSize: 10.sp,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
            actions: [
              PopupMenuButton(
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      children: [
                        Icon(Icons.edit),
                        SizedBox(width: 8),
                        Text('Edit'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'download',
                    child: Row(
                      children: [
                        Icon(Icons.download),
                        SizedBox(width: 8),
                        Text('Download PDF'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'share',
                    child: Row(
                      children: [
                        Icon(Icons.share),
                        SizedBox(width: 8),
                        Text('Share'),
                      ],
                    ),
                  ),
                ],
                onSelected: (value) async {
                  switch (value) {
                    case 'edit':
                      context.push(AppRouter.editCv, extra: _currentCv);
                      break;
                    case 'download':
                      await _downloadPdf();
                      break;
                    case 'share':
                      await _sharePdf();
                      break;
                  }
                },
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Personal Information Section
                  _buildSectionTitle('Personal Information'),
                  SizedBox(height: 12.h),
                  _buildPersonalInfoCard(),
                  SizedBox(height: 24.h),

                  // Work Experience Section
                  if (_currentCv.workExperience != null &&
                      _currentCv.workExperience!.isNotEmpty) ...[
                    _buildSectionTitle('Work Experience'),
                    SizedBox(height: 12.h),
                    ..._currentCv.workExperience!
                        .map((exp) => _buildWorkExperienceCard(exp)),
                    SizedBox(height: 24.h),
                  ],

                  // Education Section
                  if (_currentCv.education != null &&
                      _currentCv.education!.isNotEmpty) ...[
                    _buildSectionTitle('Education'),
                    SizedBox(height: 12.h),
                    ..._currentCv.education!
                        .map((edu) => _buildEducationCard(edu)),
                    SizedBox(height: 24.h),
                  ],

                  // Skills Section
                  if (_currentCv.skills != null &&
                      _currentCv.skills!.isNotEmpty) ...[
                    _buildSectionTitle('Skills'),
                    SizedBox(height: 12.h),
                    _buildSkillsSection(),
                    SizedBox(height: 24.h),
                  ],

                  // Languages Section
                  if (_currentCv.languages != null &&
                      _currentCv.languages!.isNotEmpty) ...[
                    _buildSectionTitle('Languages'),
                    SizedBox(height: 12.h),
                    ..._currentCv.languages!
                        .map((lang) => _buildLanguageCard(lang)),
                    SizedBox(height: 24.h),
                  ],

                  // Certifications Section
                  if (_currentCv.certifications != null &&
                      _currentCv.certifications!.isNotEmpty) ...[
                    _buildSectionTitle('Certifications'),
                    SizedBox(height: 12.h),
                    ..._currentCv.certifications!
                        .map((cert) => _buildCertificationCard(cert)),
                    SizedBox(height: 24.h),
                  ],

                  // Projects Section
                  if (_currentCv.projects != null &&
                      _currentCv.projects!.isNotEmpty) ...[
                    _buildSectionTitle('Projects'),
                    SizedBox(height: 12.h),
                    ..._currentCv.projects!
                        .map((project) => _buildProjectCard(project)),
                    SizedBox(height: 24.h),
                  ],

                  // Last Updated
                  Center(
                    child: Text(
                      _currentCv.formattedUpdatedDate,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                  SizedBox(height: 24.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Row(
      children: [
        Container(
          width: 4.w,
          height: 20.h,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        SizedBox(width: 8.w),
        Text(
          title,
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildPersonalInfoCard() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoRow('Full Name', _currentCv.fullName),
            if (_currentCv.email.isNotEmpty) ...[
              SizedBox(height: 8.h),
              _buildInfoRow('Email', _currentCv.email),
            ],
            if (_currentCv.phone != null) ...[
              SizedBox(height: 8.h),
              _buildInfoRow('Phone', _currentCv.phone!),
            ],
            if (_currentCv.address != null) ...[
              SizedBox(height: 8.h),
              _buildInfoRow('Address', _currentCv.address!),
            ],
            if (_currentCv.city != null || _currentCv.country != null) ...[
              SizedBox(height: 8.h),
              _buildInfoRow(
                'Location',
                [_currentCv.city, _currentCv.country]
                    .where((e) => e != null)
                    .join(', '),
              ),
            ],
            if (_currentCv.postalCode != null) ...[
              SizedBox(height: 8.h),
              _buildInfoRow('Postal Code', _currentCv.postalCode!),
            ],
            if (_currentCv.website != null) ...[
              SizedBox(height: 8.h),
              _buildInfoRow('Website', _currentCv.website!),
            ],
            if (_currentCv.linkedin != null) ...[
              SizedBox(height: 8.h),
              _buildInfoRow('LinkedIn', _currentCv.linkedin!),
            ],
            if (_currentCv.github != null) ...[
              SizedBox(height: 8.h),
              _buildInfoRow('GitHub', _currentCv.github!),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label: ',
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 12.sp,
              color: AppColors.textSecondary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildWorkExperienceCard(WorkExperienceEntity exp) {
    return Card(
      margin: EdgeInsets.only(bottom: 12.h),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    exp.jobTitle,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                if (exp.isCurrent)
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 2.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'Current',
                      style: TextStyle(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(height: 4.h),
            Text(
              exp.company,
              style: TextStyle(
                fontSize: 14.sp,
                color: AppColors.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
            if (exp.location != null) ...[
              SizedBox(height: 4.h),
              Row(
                children: [
                  Icon(Icons.location_on, size: 14.sp, color: Colors.grey),
                  SizedBox(width: 4.w),
                  Expanded(
                    child: Text(
                      exp.location!,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: AppColors.textSecondary,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ),
                ],
              ),
            ],
            SizedBox(height: 8.h),
            Row(
              children: [
                Icon(Icons.calendar_today, size: 14.sp, color: Colors.grey),
                SizedBox(width: 4.w),
                Expanded(
                  child: Text(
                    _formatDateRange(exp.startDate, exp.endDate, exp.isCurrent),
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: AppColors.textSecondary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            if (exp.description != null) ...[
              SizedBox(height: 12.h),
              Text(
                exp.description!,
                style: TextStyle(
                  fontSize: 13.sp,
                  color: AppColors.textPrimary,
                  height: 1.5,
                ),
                textAlign: TextAlign.justify,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildEducationCard(EducationEntity edu) {
    return Card(
      margin: EdgeInsets.only(bottom: 12.h),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    edu.degree,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                if (edu.isCurrent)
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 2.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'Current',
                      style: TextStyle(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(height: 4.h),
            Text(
              edu.institution,
              style: TextStyle(
                fontSize: 14.sp,
                color: AppColors.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
            if (edu.location != null) ...[
              SizedBox(height: 4.h),
              Row(
                children: [
                  Icon(Icons.location_on, size: 14.sp, color: Colors.grey),
                  SizedBox(width: 4.w),
                  Expanded(
                    child: Text(
                      edu.location!,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: AppColors.textSecondary,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ),
                ],
              ),
            ],
            SizedBox(height: 8.h),
            Row(
              children: [
                Icon(Icons.calendar_today, size: 14.sp, color: Colors.grey),
                SizedBox(width: 4.w),
                Expanded(
                  child: Text(
                    _formatDateRange(edu.startDate, edu.endDate, edu.isCurrent),
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: AppColors.textSecondary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            if (edu.description != null) ...[
              SizedBox(height: 12.h),
              Text(
                edu.description!,
                style: TextStyle(
                  fontSize: 13.sp,
                  color: AppColors.textPrimary,
                  height: 1.5,
                ),
                textAlign: TextAlign.justify,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSkillsSection() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Wrap(
          spacing: 8.w,
          runSpacing: 8.h,
          children: _currentCv.skills!
              .map((skill) => Chip(
                    label: Text(skill),
                    backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                    labelStyle: TextStyle(
                      color: AppColors.primary,
                      fontSize: 12.sp,
                    ),
                  ))
              .toList(),
        ),
      ),
    );
  }

  Widget _buildLanguageCard(LanguageEntity lang) {
    return Card(
      margin: EdgeInsets.only(bottom: 8.h),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppColors.primary.withValues(alpha: 0.1),
          child: Icon(Icons.language, color: AppColors.primary, size: 20.sp),
        ),
        title: Text(
          lang.language,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            lang.proficiency,
            style: TextStyle(
              fontSize: 12.sp,
              color: AppColors.primary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCertificationCard(CertificationEntity cert) {
    return Card(
      margin: EdgeInsets.only(bottom: 12.h),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              cert.name,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (cert.issuingOrganization != null) ...[
              SizedBox(height: 4.h),
              Text(
                cert.issuingOrganization!,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: AppColors.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
            if (cert.issueDate != null) ...[
              SizedBox(height: 8.h),
              Row(
                children: [
                  Icon(Icons.calendar_today, size: 14.sp, color: Colors.grey),
                  SizedBox(width: 4.w),
                  Expanded(
                    child: Text(
                      'Issued: ${DateFormat('MMM yyyy').format(cert.issueDate!)}',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: AppColors.textSecondary,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (cert.expiryDate != null) ...[
                    SizedBox(width: 16.w),
                    Expanded(
                      child: Text(
                        'Expires: ${DateFormat('MMM yyyy').format(cert.expiryDate!)}',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: AppColors.textSecondary,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ],
              ),
            ],
            if (cert.credentialId != null) ...[
              SizedBox(height: 8.h),
              Row(
                children: [
                  Icon(Icons.badge, size: 14.sp, color: Colors.grey),
                  SizedBox(width: 4.w),
                  Expanded(
                    child: Text(
                      'ID: ${cert.credentialId!}',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: AppColors.textSecondary,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildProjectCard(ProjectEntity project) {
    return Card(
      margin: EdgeInsets.only(bottom: 12.h),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              project.name,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (project.url != null) ...[
              SizedBox(height: 4.h),
              Row(
                children: [
                  Icon(Icons.link, size: 14.sp, color: AppColors.primary),
                  SizedBox(width: 4.w),
                  Expanded(
                    child: Text(
                      project.url!,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: AppColors.primary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
            if (project.startDate != null) ...[
              SizedBox(height: 8.h),
              Row(
                children: [
                  Icon(Icons.calendar_today, size: 14.sp, color: Colors.grey),
                  SizedBox(width: 4.w),
                  Expanded(
                    child: Text(
                      _formatDateRange(
                        project.startDate!,
                        project.endDate,
                        false,
                      ),
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: AppColors.textSecondary,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
            if (project.description != null) ...[
              SizedBox(height: 12.h),
              Text(
                project.description!,
                style: TextStyle(
                  fontSize: 13.sp,
                  color: AppColors.textPrimary,
                  height: 1.5,
                ),
                textAlign: TextAlign.justify,
              ),
            ],
            if (project.technologies != null &&
                project.technologies!.isNotEmpty) ...[
              SizedBox(height: 12.h),
              Wrap(
                spacing: 6.w,
                runSpacing: 6.h,
                children: project.technologies!
                    .map((tech) => Chip(
                          label: Text(tech),
                          backgroundColor: Colors.grey.withValues(alpha: 0.1),
                          labelStyle: TextStyle(
                            fontSize: 11.sp,
                          ),
                          padding: EdgeInsets.zero,
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                        ))
                    .toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _formatDateRange(DateTime start, DateTime? end, bool isCurrent) {
    final startFormatted = DateFormat('MMM yyyy').format(start);
    if (isCurrent) {
      return '$startFormatted - Present';
    }
    if (end != null) {
      final endFormatted = DateFormat('MMM yyyy').format(end);
      return '$startFormatted - $endFormatted';
    }
    return startFormatted;
  }

  Future<void> _downloadPdf() async {
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

      final file = await CvPdfGenerator.downloadPdf(_currentCv);

      if (mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('CV downloaded to ${file.path}'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    } catch (e) {
      debugPrint('❌ Error downloading PDF: $e');
      if (mounted) {
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

  Future<void> _sharePdf() async {
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

      await CvPdfGenerator.sharePdf(_currentCv);

      if (mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
      }
    } catch (e) {
      debugPrint('❌ Error sharing PDF: $e');
      if (mounted) {
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
