import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';

class CvSkillsLanguagesForm extends StatefulWidget {
  final Map<String, dynamic> initialData;
  final Function(Map<String, dynamic>) onDataChanged;

  const CvSkillsLanguagesForm({
    super.key,
    required this.initialData,
    required this.onDataChanged,
  });

  @override
  State<CvSkillsLanguagesForm> createState() => _CvSkillsLanguagesFormState();
}

class _CvSkillsLanguagesFormState extends State<CvSkillsLanguagesForm> {
  List<String> _skills = [];
  List<Map<String, dynamic>> _languages = [];
  final TextEditingController _skillController = TextEditingController();

  final List<String> _proficiencyLevels = [
    'Native',
    'Fluent',
    'Advanced',
    'Intermediate',
    'Basic',
  ];

  @override
  void initState() {
    super.initState();
    _skills = List<String>.from(widget.initialData['skills'] ?? []);
    _languages =
        List<Map<String, dynamic>>.from(widget.initialData['languages'] ?? []);
  }

  @override
  void dispose() {
    _skillController.dispose();
    super.dispose();
  }

  void _addSkill() {
    final skill = _skillController.text.trim();
    if (skill.isNotEmpty && !_skills.contains(skill)) {
      setState(() {
        _skills.add(skill);
        _skillController.clear();
      });
      widget.onDataChanged({'skills': _skills});
    }
  }

  void _removeSkill(int index) {
    setState(() {
      _skills.removeAt(index);
    });
    widget.onDataChanged({'skills': _skills});
  }

  void _addLanguage() {
    setState(() {
      _languages.add({
        'language': '',
        'proficiency': 'Intermediate',
      });
    });
    widget.onDataChanged({'languages': _languages});
  }

  void _removeLanguage(int index) {
    setState(() {
      _languages.removeAt(index);
    });
    widget.onDataChanged({'languages': _languages});
  }

  void _updateLanguage(int index, String key, String value) {
    setState(() {
      _languages[index][key] = value;
    });
    widget.onDataChanged({'languages': _languages});
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Skills & Languages',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Showcase your technical and language skills',
            style: TextStyle(
              fontSize: 13.sp,
              color: AppColors.textSecondary,
            ),
          ),
          SizedBox(height: 24.h),

          // Skills Section
          _buildSectionHeader('Skills'),
          SizedBox(height: 12.h),
          Text(
            'Add skills relevant to your profession',
            style: TextStyle(
              fontSize: 12.sp,
              color: AppColors.textSecondary,
            ),
          ),
          SizedBox(height: 12.h),

          // Skills Input
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _skillController,
                  decoration: InputDecoration(
                    labelText: 'Add Skill',
                    hintText: 'e.g., Flutter, Python, Leadership',
                    prefixIcon: Icon(Icons.code, size: 20.sp),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onFieldSubmitted: (_) => _addSkill(),
                ),
              ),
              SizedBox(width: 8.w),
              IconButton(
                onPressed: _addSkill,
                icon: Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.add, color: Colors.white, size: 20.sp),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),

          // Skills Chips
          if (_skills.isNotEmpty)
            Wrap(
              spacing: 8.w,
              runSpacing: 8.h,
              children: _skills
                  .asMap()
                  .entries
                  .map(
                    (entry) => Chip(
                      label: Text(entry.value),
                      backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                      labelStyle: TextStyle(
                        color: AppColors.primary,
                        fontSize: 13.sp,
                      ),
                      deleteIcon: Icon(
                        Icons.close,
                        size: 18.sp,
                        color: AppColors.primary,
                      ),
                      onDeleted: () => _removeSkill(entry.key),
                    ),
                  )
                  .toList(),
            )
          else
            Container(
              padding: EdgeInsets.all(24.w),
              decoration: BoxDecoration(
                color: Colors.grey.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
              ),
              child: Center(
                child: Text(
                  'No skills added yet. Type a skill and press enter or click +',
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          SizedBox(height: 32.h),

          // Languages Section
          _buildSectionHeader('Languages'),
          SizedBox(height: 12.h),
          Text(
            'Add languages you can speak',
            style: TextStyle(
              fontSize: 12.sp,
              color: AppColors.textSecondary,
            ),
          ),
          SizedBox(height: 16.h),

          if (_languages.isEmpty)
            Container(
              padding: EdgeInsets.all(24.w),
              decoration: BoxDecoration(
                color: Colors.grey.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
              ),
              child: Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.language,
                      size: 48.sp,
                      color: Colors.grey,
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'No languages added yet',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: AppColors.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            )
          else
            ..._languages
                .asMap()
                .entries
                .map((entry) => _buildLanguageCard(entry.key)),

          SizedBox(height: 16.h),
          OutlinedButton.icon(
            onPressed: _addLanguage,
            icon: const Icon(Icons.add),
            label: const Text('Add Language'),
            style: OutlinedButton.styleFrom(
              minimumSize: Size(double.infinity, 48.h),
              side: BorderSide(color: AppColors.primary),
              foregroundColor: AppColors.primary,
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

  Widget _buildLanguageCard(int index) {
    final language = _languages[index];

    return Card(
      margin: EdgeInsets.only(bottom: 12.h),
      elevation: 1,
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  TextFormField(
                    initialValue: language['language'],
                    decoration: InputDecoration(
                      labelText: 'Language *',
                      hintText: 'e.g., English',
                      prefixIcon: Icon(Icons.language, size: 20.sp),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 12.h,
                      ),
                    ),
                    onChanged: (value) =>
                        _updateLanguage(index, 'language', value),
                  ),
                  SizedBox(height: 12.h),
                  DropdownButtonFormField<String>(
                    initialValue: language['proficiency'],
                    decoration: InputDecoration(
                      labelText: 'Proficiency Level',
                      prefixIcon: Icon(Icons.bar_chart, size: 20.sp),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 12.h,
                      ),
                    ),
                    items: _proficiencyLevels
                        .map((level) => DropdownMenuItem(
                              value: level,
                              child: Text(level),
                            ))
                        .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        _updateLanguage(index, 'proficiency', value);
                      }
                    },
                  ),
                ],
              ),
            ),
            SizedBox(width: 8.w),
            IconButton(
              onPressed: () => _removeLanguage(index),
              icon: const Icon(Icons.delete_outline, color: Colors.red),
              tooltip: 'Remove',
            ),
          ],
        ),
      ),
    );
  }
}
