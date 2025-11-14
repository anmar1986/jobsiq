import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';

class CvAdditionalInfoForm extends StatefulWidget {
  final Map<String, dynamic> initialData;
  final Function(Map<String, dynamic>) onDataChanged;

  const CvAdditionalInfoForm({
    super.key,
    required this.initialData,
    required this.onDataChanged,
  });

  @override
  State<CvAdditionalInfoForm> createState() => _CvAdditionalInfoFormState();
}

class _CvAdditionalInfoFormState extends State<CvAdditionalInfoForm> {
  bool _isPublic = true;
  bool _isPrimary = false;
  String _template = 'default';

  @override
  void initState() {
    super.initState();
    _isPublic = widget.initialData['isPublic'] ?? true;
    _isPrimary = widget.initialData['isPrimary'] ?? false;
    _template = widget.initialData['template'] ?? 'default';
  }

  void _updateSettings() {
    widget.onDataChanged({
      'isPublic': _isPublic,
      'isPrimary': _isPrimary,
      'template': _template,
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Final Settings',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Configure your CV visibility and preferences',
            style: TextStyle(
              fontSize: 13.sp,
              color: AppColors.textSecondary,
            ),
          ),
          SizedBox(height: 24.h),

          // CV Template Selection
          _buildSectionHeader('Template'),
          SizedBox(height: 12.h),
          Card(
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Choose a template for your CV',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Row(
                    children: [
                      Expanded(
                        child: _buildTemplateOption(
                          'default',
                          'Default',
                          'Clean and professional',
                          Icons.description,
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: _buildTemplateOption(
                          'modern',
                          'Modern',
                          'Contemporary design',
                          Icons.auto_awesome,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),
                  Row(
                    children: [
                      Expanded(
                        child: _buildTemplateOption(
                          'classic',
                          'Classic',
                          'Traditional style',
                          Icons.article,
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: _buildTemplateOption(
                          'minimal',
                          'Minimal',
                          'Simple and elegant',
                          Icons.style,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 24.h),

          // CV Visibility Settings
          _buildSectionHeader('Visibility'),
          SizedBox(height: 12.h),
          Card(
            child: Column(
              children: [
                SwitchListTile(
                  value: _isPublic,
                  onChanged: (value) {
                    setState(() {
                      _isPublic = value;
                    });
                    _updateSettings();
                  },
                  title: Text(
                    'Public CV',
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  subtitle: Text(
                    _isPublic
                        ? 'Your CV is visible to everyone with the link'
                        : 'Your CV is only visible to you',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  secondary: Icon(
                    _isPublic ? Icons.public : Icons.lock,
                    color: _isPublic ? AppColors.primary : Colors.grey,
                  ),
                ),
                Divider(height: 1.h),
                SwitchListTile(
                  value: _isPrimary,
                  onChanged: (value) {
                    setState(() {
                      _isPrimary = value;
                    });
                    _updateSettings();
                  },
                  title: Text(
                    'Set as Primary CV',
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  subtitle: Text(
                    _isPrimary
                        ? 'This will be your main CV'
                        : 'This won\'t be your primary CV',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  secondary: Icon(
                    _isPrimary ? Icons.star : Icons.star_border,
                    color: _isPrimary ? AppColors.primary : Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 24.h),

          // Summary Card
          _buildSectionHeader('Summary'),
          SizedBox(height: 12.h),
          Card(
            color: AppColors.primary.withValues(alpha: 0.05),
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.check_circle,
                        color: AppColors.primary,
                        size: 24.sp,
                      ),
                      SizedBox(width: 12.w),
                      Text(
                        'You\'re all set!',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  _buildSummaryRow(
                    Icons.badge,
                    'Title',
                    widget.initialData['title']?.toString() ?? 'Not set',
                  ),
                  SizedBox(height: 8.h),
                  _buildSummaryRow(
                    Icons.work,
                    'Work Experience',
                    '${(widget.initialData['workExperience'] as List?)?.length ?? 0} entries',
                  ),
                  SizedBox(height: 8.h),
                  _buildSummaryRow(
                    Icons.school,
                    'Education',
                    '${(widget.initialData['education'] as List?)?.length ?? 0} entries',
                  ),
                  SizedBox(height: 8.h),
                  _buildSummaryRow(
                    Icons.code,
                    'Skills',
                    '${(widget.initialData['skills'] as List?)?.length ?? 0} skills',
                  ),
                  SizedBox(height: 8.h),
                  _buildSummaryRow(
                    Icons.language,
                    'Languages',
                    '${(widget.initialData['languages'] as List?)?.length ?? 0} languages',
                  ),
                  SizedBox(height: 16.h),
                  Container(
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          size: 20.sp,
                          color: AppColors.primary,
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Text(
                            'Click "Create CV" to save your CV',
                            style: TextStyle(
                              fontSize: 13.sp,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Row(
      children: [
        Container(
          width: 4.w,
          height: 18.h,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        SizedBox(width: 8.w),
        Text(
          title,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildTemplateOption(
    String value,
    String title,
    String description,
    IconData icon,
  ) {
    final isSelected = _template == value;

    return InkWell(
      onTap: () {
        setState(() {
          _template = value;
        });
        _updateSettings();
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.1)
              : Colors.grey.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? AppColors.primary
                : Colors.grey.withValues(alpha: 0.3),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 32.sp,
              color: isSelected ? AppColors.primary : Colors.grey,
            ),
            SizedBox(height: 8.h),
            Text(
              title,
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
                color: isSelected ? AppColors.primary : Colors.black,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              description,
              style: TextStyle(
                fontSize: 10.sp,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 16.sp, color: AppColors.primary),
        SizedBox(width: 8.w),
        Text(
          '$label: ',
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 13.sp,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
