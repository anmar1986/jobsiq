import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';

class CvEducationForm extends StatefulWidget {
  final Map<String, dynamic> initialData;
  final Function(Map<String, dynamic>) onDataChanged;

  const CvEducationForm({
    super.key,
    required this.initialData,
    required this.onDataChanged,
  });

  @override
  State<CvEducationForm> createState() => _CvEducationFormState();
}

class _CvEducationFormState extends State<CvEducationForm> {
  List<Map<String, dynamic>> _education = [];

  @override
  void initState() {
    super.initState();
    _education = List<Map<String, dynamic>>.from(
      widget.initialData['education'] ?? [],
    );
  }

  void _addEducation() {
    setState(() {
      _education.add({
        'degree': '',
        'institution': '',
        'location': '',
        'startDate': DateTime.now(),
        'endDate': null,
        'isCurrent': false,
        'description': '',
      });
    });
    widget.onDataChanged({'education': _education});
  }

  void _removeEducation(int index) {
    setState(() {
      _education.removeAt(index);
    });
    widget.onDataChanged({'education': _education});
  }

  void _updateEducation(int index, String key, dynamic value) {
    setState(() {
      _education[index][key] = value;
    });
    widget.onDataChanged({'education': _education});
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Education',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Add your educational background (optional)',
            style: TextStyle(
              fontSize: 13.sp,
              color: AppColors.textSecondary,
            ),
          ),
          SizedBox(height: 24.h),
          if (_education.isEmpty)
            Center(
              child: Column(
                children: [
                  Icon(
                    Icons.school_outlined,
                    size: 64.sp,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    'No education added yet',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'Add your academic qualifications',
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
            ..._education
                .asMap()
                .entries
                .map((entry) => _buildEducationCard(entry.key)),
          SizedBox(height: 16.h),
          OutlinedButton.icon(
            onPressed: _addEducation,
            icon: const Icon(Icons.add),
            label: const Text('Add Education'),
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

  Widget _buildEducationCard(int index) {
    final edu = _education[index];

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
                      'Education ${index + 1}',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () => _removeEducation(index),
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  tooltip: 'Remove',
                ),
              ],
            ),
            SizedBox(height: 16.h),

            // Degree
            TextFormField(
              initialValue: edu['degree'],
              decoration: InputDecoration(
                labelText: 'Degree *',
                hintText: 'e.g., Bachelor of Science in Computer Science',
                prefixIcon: Icon(Icons.school, size: 20.sp),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (value) => _updateEducation(index, 'degree', value),
            ),
            SizedBox(height: 12.h),

            // Institution
            TextFormField(
              initialValue: edu['institution'],
              decoration: InputDecoration(
                labelText: 'Institution *',
                hintText: 'e.g., Stanford University',
                prefixIcon: Icon(Icons.account_balance, size: 20.sp),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (value) =>
                  _updateEducation(index, 'institution', value),
            ),
            SizedBox(height: 12.h),

            // Location
            TextFormField(
              initialValue: edu['location'],
              decoration: InputDecoration(
                labelText: 'Location',
                hintText: 'e.g., Stanford, CA, USA',
                prefixIcon: Icon(Icons.location_on, size: 20.sp),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (value) => _updateEducation(index, 'location', value),
            ),
            SizedBox(height: 12.h),

            // Start Date and End Date
            Row(
              children: [
                Expanded(
                  child: _buildDateField(
                    label: 'Start Date *',
                    date: edu['startDate'] as DateTime,
                    onDateSelected: (date) =>
                        _updateEducation(index, 'startDate', date),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: edu['isCurrent']
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
                          date: edu['endDate'] as DateTime?,
                          onDateSelected: (date) =>
                              _updateEducation(index, 'endDate', date),
                        ),
                ),
              ],
            ),
            SizedBox(height: 12.h),

            // Current Education Checkbox
            CheckboxListTile(
              value: edu['isCurrent'] as bool,
              onChanged: (value) {
                _updateEducation(index, 'isCurrent', value ?? false);
                if (value == true) {
                  _updateEducation(index, 'endDate', null);
                }
              },
              title: Text(
                'I currently study here',
                style: TextStyle(fontSize: 14.sp),
              ),
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: EdgeInsets.zero,
              activeColor: AppColors.primary,
            ),
            SizedBox(height: 12.h),

            // Description
            TextFormField(
              initialValue: edu['description'],
              decoration: InputDecoration(
                labelText: 'Description',
                hintText: 'Describe your studies, achievements, GPA...',
                prefixIcon: Icon(Icons.description, size: 20.sp),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                alignLabelWithHint: true,
              ),
              maxLines: 4,
              onChanged: (value) =>
                  _updateEducation(index, 'description', value),
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
          lastDate: DateTime(2100),
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
