import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/theme/app_colors.dart';

class JobFilterBottomSheet extends StatefulWidget {
  final Map<String, dynamic> currentFilters;

  const JobFilterBottomSheet({
    super.key,
    required this.currentFilters,
  });

  @override
  State<JobFilterBottomSheet> createState() => _JobFilterBottomSheetState();
}

class _JobFilterBottomSheetState extends State<JobFilterBottomSheet> {
  late String? location;
  late List<String> employmentTypes;
  late List<String> experienceLevels;
  late bool? isRemote;
  late String? category;
  late double? salaryMin;
  late String? sortBy;

  final List<String> _employmentTypeOptions = [
    'Full-time',
    'Part-time',
    'Contract',
    'Temporary',
    'Internship',
    'Freelance',
  ];

  final List<String> _experienceLevelOptions = [
    'Entry Level',
    'Mid Level',
    'Senior Level',
    'Lead',
    'Manager',
    'Director',
  ];

  final List<String> _categoryOptions = [
    'Technology',
    'Marketing',
    'Sales',
    'Design',
    'Finance',
    'Human Resources',
    'Customer Service',
    'Operations',
    'Legal',
    'Education',
    'Healthcare',
    'Engineering',
    'Other',
  ];

  final List<String> _sortOptions = [
    'Random',
    'Newest First',
    'Oldest First',
  ];

  @override
  void initState() {
    super.initState();
    location = widget.currentFilters['location'];
    employmentTypes =
        List<String>.from(widget.currentFilters['employmentTypes'] ?? []);
    experienceLevels =
        List<String>.from(widget.currentFilters['experienceLevels'] ?? []);
    isRemote = widget.currentFilters['isRemote'];
    category = widget.currentFilters['category'];
    salaryMin = widget.currentFilters['salaryMin'];
    sortBy = widget.currentFilters['sort'] ?? 'Random';
  }

  void _clearFilters() {
    setState(() {
      location = null;
      employmentTypes.clear();
      experienceLevels.clear();
      isRemote = null;
      category = null;
      salaryMin = null;
      sortBy = 'Random';
    });
  }

  void _applyFilters() {
    Navigator.pop(context, {
      'location': location,
      'employmentTypes': employmentTypes.isEmpty ? null : employmentTypes,
      'experienceLevels': experienceLevels.isEmpty ? null : experienceLevels,
      'isRemote': isRemote,
      'category': category,
      'salaryMin': salaryMin,
      'sort': sortBy == 'Random'
          ? null
          : (sortBy == 'Newest First' ? 'newest' : 'oldest'),
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.grey.shade200),
              ),
            ),
            child: Row(
              children: [
                Text(
                  'Filters',
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: _clearFilters,
                  child: Text(
                    'Clear All',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 14.sp,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
          ),

          // Filters Content
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Sort By
                  _buildSectionTitle('Sort By'),
                  SizedBox(height: 8.h),
                  Wrap(
                    spacing: 8.w,
                    runSpacing: 8.h,
                    children: _sortOptions.map((option) {
                      final isSelected = sortBy == option;
                      return ChoiceChip(
                        label: Text(option),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() {
                            sortBy = selected ? option : 'Random';
                          });
                        },
                        selectedColor: AppColors.primary.withValues(alpha: 0.2),
                        labelStyle: TextStyle(
                          color:
                              isSelected ? AppColors.primary : Colors.black87,
                          fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.normal,
                        ),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 24.h),

                  // Remote Work
                  _buildSectionTitle('Work Location'),
                  SizedBox(height: 8.h),
                  Row(
                    children: [
                      Expanded(
                        child: FilterChip(
                          label: const Text('Remote'),
                          selected: isRemote == true,
                          onSelected: (selected) {
                            setState(() {
                              isRemote = selected ? true : null;
                            });
                          },
                          selectedColor:
                              AppColors.primary.withValues(alpha: 0.2),
                          labelStyle: TextStyle(
                            color: isRemote == true
                                ? AppColors.primary
                                : Colors.black87,
                          ),
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: FilterChip(
                          label: const Text('On-site'),
                          selected: isRemote == false,
                          onSelected: (selected) {
                            setState(() {
                              isRemote = selected ? false : null;
                            });
                          },
                          selectedColor:
                              AppColors.primary.withValues(alpha: 0.2),
                          labelStyle: TextStyle(
                            color: isRemote == false
                                ? AppColors.primary
                                : Colors.black87,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 24.h),

                  // Employment Type
                  _buildSectionTitle('Employment Type'),
                  SizedBox(height: 8.h),
                  Wrap(
                    spacing: 8.w,
                    runSpacing: 8.h,
                    children: _employmentTypeOptions.map((type) {
                      final isSelected = employmentTypes.contains(type);
                      return FilterChip(
                        label: Text(type),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() {
                            if (selected) {
                              employmentTypes.add(type);
                            } else {
                              employmentTypes.remove(type);
                            }
                          });
                        },
                        selectedColor: AppColors.primary.withValues(alpha: 0.2),
                        labelStyle: TextStyle(
                          color:
                              isSelected ? AppColors.primary : Colors.black87,
                        ),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 24.h),

                  // Experience Level
                  _buildSectionTitle('Experience Level'),
                  SizedBox(height: 8.h),
                  Wrap(
                    spacing: 8.w,
                    runSpacing: 8.h,
                    children: _experienceLevelOptions.map((level) {
                      final isSelected = experienceLevels.contains(level);
                      return FilterChip(
                        label: Text(level),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() {
                            if (selected) {
                              experienceLevels.add(level);
                            } else {
                              experienceLevels.remove(level);
                            }
                          });
                        },
                        selectedColor: AppColors.primary.withValues(alpha: 0.2),
                        labelStyle: TextStyle(
                          color:
                              isSelected ? AppColors.primary : Colors.black87,
                        ),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 24.h),

                  // Category
                  _buildSectionTitle('Category'),
                  SizedBox(height: 8.h),
                  Wrap(
                    spacing: 8.w,
                    runSpacing: 8.h,
                    children: _categoryOptions.map((cat) {
                      final isSelected = category == cat;
                      return ChoiceChip(
                        label: Text(cat),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() {
                            category = selected ? cat : null;
                          });
                        },
                        selectedColor: AppColors.primary.withValues(alpha: 0.2),
                        labelStyle: TextStyle(
                          color:
                              isSelected ? AppColors.primary : Colors.black87,
                        ),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 24.h),

                  // Minimum Salary
                  _buildSectionTitle('Minimum Salary'),
                  SizedBox(height: 8.h),
                  TextField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: 'Enter minimum salary',
                      prefixText: '\$ ',
                      suffixIcon: salaryMin != null
                          ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                setState(() {
                                  salaryMin = null;
                                });
                              },
                            )
                          : null,
                    ),
                    controller: TextEditingController(
                      text: salaryMin?.toStringAsFixed(0) ?? '',
                    ),
                    onChanged: (value) {
                      setState(() {
                        salaryMin = double.tryParse(value);
                      });
                    },
                  ),
                  SizedBox(height: 80.h), // Space for button
                ],
              ),
            ),
          ),

          // Apply Button
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: SafeArea(
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _applyFilters,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                  ),
                  child: const Text('Apply Filters'),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 16.sp,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
