import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';

class CvWorkExperienceForm extends StatefulWidget {
  final Map<String, dynamic> initialData;
  final Function(Map<String, dynamic>) onDataChanged;

  const CvWorkExperienceForm({
    super.key,
    required this.initialData,
    required this.onDataChanged,
  });

  @override
  State<CvWorkExperienceForm> createState() => _CvWorkExperienceFormState();
}

class _CvWorkExperienceFormState extends State<CvWorkExperienceForm> {
  List<Map<String, dynamic>> _workExperiences = [];

  @override
  void initState() {
    super.initState();
    _workExperiences = List<Map<String, dynamic>>.from(
      widget.initialData['workExperience'] ?? [],
    );
  }

  void _addWorkExperience() {
    setState(() {
      _workExperiences.add({
        'jobTitle': '',
        'company': '',
        'location': '',
        'startDate': DateTime.now(),
        'endDate': null,
        'isCurrent': false,
        'description': '',
      });
    });
    widget.onDataChanged({'workExperience': _workExperiences});
  }

  void _removeWorkExperience(int index) {
    setState(() {
      _workExperiences.removeAt(index);
    });
    widget.onDataChanged({'workExperience': _workExperiences});
  }

  void _updateWorkExperience(int index, String key, dynamic value) {
    setState(() {
      _workExperiences[index][key] = value;
    });
    widget.onDataChanged({'workExperience': _workExperiences});
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Work Experience',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Add your work experience (optional, but recommended)',
            style: TextStyle(
              fontSize: 13.sp,
              color: AppColors.textSecondary,
            ),
          ),
          SizedBox(height: 24.h),
          if (_workExperiences.isEmpty)
            Center(
              child: Column(
                children: [
                  Icon(
                    Icons.work_outline,
                    size: 64.sp,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    'No work experience added yet',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'Add your professional experience to showcase your career',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: AppColors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 24.h),
                ],
              ),
            )
          else
            ..._workExperiences
                .asMap()
                .entries
                .map((entry) => _buildWorkExperienceCard(entry.key)),
          SizedBox(height: 16.h),
          OutlinedButton.icon(
            onPressed: _addWorkExperience,
            icon: const Icon(Icons.add),
            label: const Text('Add Work Experience'),
            style: OutlinedButton.styleFrom(
              minimumSize: Size(double.infinity, 48.h),
              side: const BorderSide(color: AppColors.primary),
              foregroundColor: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWorkExperienceCard(int index) {
    final experience = _workExperiences[index];

    return Card(
      margin: EdgeInsets.only(bottom: 16.h),
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
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
                      'Experience ${index + 1}',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () => _removeWorkExperience(index),
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  tooltip: 'Remove',
                ),
              ],
            ),
            SizedBox(height: 16.h),

            // Job Title
            TextFormField(
              initialValue: experience['jobTitle'],
              decoration: InputDecoration(
                labelText: 'Job Title *',
                hintText: 'e.g., Software Engineer',
                prefixIcon: Icon(Icons.work, size: 20.sp),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (value) =>
                  _updateWorkExperience(index, 'jobTitle', value),
            ),
            SizedBox(height: 12.h),

            // Company
            TextFormField(
              initialValue: experience['company'],
              decoration: InputDecoration(
                labelText: 'Company *',
                hintText: 'e.g., Google Inc.',
                prefixIcon: Icon(Icons.business, size: 20.sp),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (value) =>
                  _updateWorkExperience(index, 'company', value),
            ),
            SizedBox(height: 12.h),

            // Location
            TextFormField(
              initialValue: experience['location'],
              decoration: InputDecoration(
                labelText: 'Location',
                hintText: 'e.g., New York, USA',
                prefixIcon: Icon(Icons.location_on, size: 20.sp),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (value) =>
                  _updateWorkExperience(index, 'location', value),
            ),
            SizedBox(height: 12.h),

            // Start Date and End Date
            Row(
              children: [
                Expanded(
                  child: _buildDateField(
                    label: 'Start Date *',
                    date: experience['startDate'] as DateTime,
                    onDateSelected: (date) =>
                        _updateWorkExperience(index, 'startDate', date),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: experience['isCurrent']
                      ? Container(
                          height: 56.h,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.green.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.green),
                          ),
                          child: Text(
                            'Present',
                            style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.w600,
                              fontSize: 14.sp,
                            ),
                          ),
                        )
                      : _buildDateField(
                          label: 'End Date',
                          date: experience['endDate'] as DateTime?,
                          onDateSelected: (date) =>
                              _updateWorkExperience(index, 'endDate', date),
                        ),
                ),
              ],
            ),
            SizedBox(height: 12.h),

            // Current Job Checkbox
            CheckboxListTile(
              value: experience['isCurrent'] as bool,
              onChanged: (value) {
                _updateWorkExperience(index, 'isCurrent', value ?? false);
                if (value == true) {
                  _updateWorkExperience(index, 'endDate', null);
                }
              },
              title: Text(
                'I currently work here',
                style: TextStyle(fontSize: 14.sp),
              ),
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: EdgeInsets.zero,
              activeColor: AppColors.primary,
            ),
            SizedBox(height: 12.h),

            // Description
            TextFormField(
              initialValue: experience['description'],
              decoration: InputDecoration(
                labelText: 'Description',
                hintText: 'Describe your responsibilities and achievements...',
                prefixIcon: Icon(Icons.description, size: 20.sp),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                alignLabelWithHint: true,
              ),
              maxLines: 4,
              onChanged: (value) =>
                  _updateWorkExperience(index, 'description', value),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateField({
    required String label,
    required DateTime? date,
    required Function(DateTime) onDateSelected,
  }) {
    return InkWell(
      onTap: () async {
        final selectedDate = await showDatePicker(
          context: context,
          initialDate: date ?? DateTime.now(),
          firstDate: DateTime(1950),
          lastDate: DateTime.now(),
          builder: (context, child) {
            return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: const ColorScheme.light(
                  primary: AppColors.primary,
                ),
              ),
              child: child!,
            );
          },
        );
        if (selectedDate != null) {
          onDateSelected(selectedDate);
        }
      },
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(Icons.calendar_today, size: 20.sp),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          date != null ? DateFormat('MMM yyyy').format(date) : 'Select date',
          style: TextStyle(
            fontSize: 14.sp,
            color: date != null ? Colors.black : Colors.grey,
          ),
        ),
      ),
    );
  }
}
