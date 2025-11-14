import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../config/di/injection.dart';
import '../../../data/datasources/cv_remote_data_source.dart';
import 'forms/cv_basic_info_form.dart';
import 'forms/cv_work_experience_form.dart';
import 'forms/cv_education_form.dart';
import 'forms/cv_skills_languages_form.dart';
import 'forms/cv_additional_info_form.dart';

class CreateCvPage extends StatefulWidget {
  const CreateCvPage({super.key});

  @override
  State<CreateCvPage> createState() => _CreateCvPageState();
}

class _CreateCvPageState extends State<CreateCvPage> {
  final PageController _pageController = PageController();
  int _currentStep = 0;
  final int _totalSteps = 5;
  bool _isSubmitting = false;

  // Form data storage
  final Map<String, dynamic> _formData = {
    // Step 1: Basic Info
    'title': '',
    'fullName': '',
    'email': '',
    'phone': '',
    'address': '',
    'city': '',
    'country': '',
    'postalCode': '',
    'website': '',
    'linkedin': '',
    'github': '',
    'profileImage': null,

    // Step 2: Work Experience
    'workExperience': <Map<String, dynamic>>[],

    // Step 3: Education
    'education': <Map<String, dynamic>>[],

    // Step 4: Skills & Languages
    'skills': <String>[],
    'languages': <Map<String, dynamic>>[],

    // Step 5: Additional Info
    'certifications': <Map<String, dynamic>>[],
    'projects': <Map<String, dynamic>>[],
    'template': 'default',
    'isPublic': true,
    'isPrimary': false,
  };

  final List<String> _stepTitles = [
    'Basic Information',
    'Work Experience',
    'Education',
    'Skills & Languages',
    'Additional Info',
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_currentStep < _totalSteps - 1) {
      setState(() {
        _currentStep++;
      });
      _pageController.animateToPage(
        _currentStep,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _submitForm();
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
      _pageController.animateToPage(
        _currentStep,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> _submitForm() async {
    // Validate required fields
    if (_formData['title']?.toString().trim().isEmpty ?? true) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a CV title')),
      );
      setState(() => _currentStep = 0);
      _pageController.jumpToPage(0);
      return;
    }

    if (_formData['fullName']?.toString().trim().isEmpty ?? true) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your full name')),
      );
      setState(() => _currentStep = 0);
      _pageController.jumpToPage(0);
      return;
    }

    if (_formData['email']?.toString().trim().isEmpty ?? true) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your email')),
      );
      setState(() => _currentStep = 0);
      _pageController.jumpToPage(0);
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      // Prepare data for API
      final cvData = Map<String, dynamic>.from(_formData);

      // Format work experience dates
      if (cvData['workExperience'] != null) {
        cvData['workExperience'] =
            (cvData['workExperience'] as List).map((exp) {
          return {
            ...exp,
            'start_date': (exp['startDate'] as DateTime).toIso8601String(),
            'end_date': exp['endDate'] != null
                ? (exp['endDate'] as DateTime).toIso8601String()
                : null,
            'is_current': exp['isCurrent'],
            'job_title': exp['jobTitle'],
          }
            ..remove('startDate')
            ..remove('endDate')
            ..remove('isCurrent')
            ..remove('jobTitle');
        }).toList();
      }

      // Format education dates
      if (cvData['education'] != null) {
        cvData['education'] = (cvData['education'] as List).map((edu) {
          return {
            ...edu,
            'start_date': (edu['startDate'] as DateTime).toIso8601String(),
            'end_date': edu['endDate'] != null
                ? (edu['endDate'] as DateTime).toIso8601String()
                : null,
            'is_current': edu['isCurrent'],
          }
            ..remove('startDate')
            ..remove('endDate')
            ..remove('isCurrent');
        }).toList();
      }

      // Convert camelCase to snake_case for API
      final apiData = {
        'title': cvData['title'],
        'full_name': cvData['fullName'],
        'email': cvData['email'],
        'phone': cvData['phone'],
        'address': cvData['address'],
        'city': cvData['city'],
        'country': cvData['country'],
        'postal_code': cvData['postalCode'],
        'website': cvData['website'],
        'linkedin': cvData['linkedin'],
        'github': cvData['github'],
        'work_experience': cvData['workExperience'],
        'education': cvData['education'],
        'skills': cvData['skills'],
        'languages': cvData['languages'],
        'certifications': cvData['certifications'],
        'projects': cvData['projects'],
        'is_public': cvData['isPublic'],
        'is_primary': cvData['isPrimary'],
        'template': cvData['template'],
      };

      debugPrint('📝 Submitting CV data: $apiData');

      final cvDataSource = sl<CvRemoteDataSource>();
      await cvDataSource.createCv(apiData);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('CV created successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        context.pop(); // Navigate back to CVs page
      }
    } catch (e) {
      debugPrint('❌ Error creating CV: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to create CV: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  void _updateFormData(Map<String, dynamic> data) {
    setState(() {
      _formData.addAll(data);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create CV'),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(80.h),
          child: Column(
            children: [
              // Step Indicator
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(_totalSteps, (index) {
                    final isCompleted = index < _currentStep;
                    final isCurrent = index == _currentStep;

                    return Expanded(
                      child: Column(
                        children: [
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 4.w),
                            height: 4.h,
                            decoration: BoxDecoration(
                              color: isCompleted || isCurrent
                                  ? AppColors.primary
                                  : Colors.grey.withValues(alpha: 0.3),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          SizedBox(height: 8.h),
                          if (isCurrent)
                            Text(
                              _stepTitles[index],
                              style: TextStyle(
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primary,
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                        ],
                      ),
                    );
                  }),
                ),
              ),
              SizedBox(height: 12.h),
              // Step counter
              Text(
                'Step ${_currentStep + 1} of $_totalSteps',
                style: TextStyle(
                  fontSize: 13.sp,
                  color: AppColors.textSecondary,
                ),
              ),
              SizedBox(height: 12.h),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                CvBasicInfoForm(
                  initialData: _formData,
                  onDataChanged: _updateFormData,
                ),
                CvWorkExperienceForm(
                  initialData: _formData,
                  onDataChanged: _updateFormData,
                ),
                CvEducationForm(
                  initialData: _formData,
                  onDataChanged: _updateFormData,
                ),
                CvSkillsLanguagesForm(
                  initialData: _formData,
                  onDataChanged: _updateFormData,
                ),
                CvAdditionalInfoForm(
                  initialData: _formData,
                  onDataChanged: _updateFormData,
                ),
              ],
            ),
          ),
          // Navigation Buttons
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
            child: Row(
              children: [
                if (_currentStep > 0)
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _previousStep,
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 14.h),
                      ),
                      child: const Text('Back'),
                    ),
                  ),
                if (_currentStep > 0) SizedBox(width: 12.w),
                Expanded(
                  flex: _currentStep == 0 ? 1 : 2,
                  child: ElevatedButton(
                    onPressed: _isSubmitting ? null : _nextStep,
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                      backgroundColor: AppColors.primary,
                      disabledBackgroundColor:
                          AppColors.primary.withValues(alpha: 0.5),
                    ),
                    child: _isSubmitting
                        ? SizedBox(
                            height: 20.h,
                            width: 20.w,
                            child: const CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : Text(
                            _currentStep == _totalSteps - 1
                                ? 'Create CV'
                                : 'Next',
                            style: const TextStyle(color: Colors.white),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
