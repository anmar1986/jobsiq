import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';

class CvBasicInfoForm extends StatefulWidget {
  final Map<String, dynamic> initialData;
  final Function(Map<String, dynamic>) onDataChanged;

  const CvBasicInfoForm({
    super.key,
    required this.initialData,
    required this.onDataChanged,
  });

  @override
  State<CvBasicInfoForm> createState() => _CvBasicInfoFormState();
}

class _CvBasicInfoFormState extends State<CvBasicInfoForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _fullNameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;
  late TextEditingController _cityController;
  late TextEditingController _countryController;
  late TextEditingController _postalCodeController;
  late TextEditingController _websiteController;
  late TextEditingController _linkedinController;
  late TextEditingController _githubController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.initialData['title']);
    _fullNameController =
        TextEditingController(text: widget.initialData['fullName']);
    _emailController = TextEditingController(text: widget.initialData['email']);
    _phoneController = TextEditingController(text: widget.initialData['phone']);
    _addressController =
        TextEditingController(text: widget.initialData['address']);
    _cityController = TextEditingController(text: widget.initialData['city']);
    _countryController =
        TextEditingController(text: widget.initialData['country']);
    _postalCodeController =
        TextEditingController(text: widget.initialData['postalCode']);
    _websiteController =
        TextEditingController(text: widget.initialData['website']);
    _linkedinController =
        TextEditingController(text: widget.initialData['linkedin']);
    _githubController =
        TextEditingController(text: widget.initialData['github']);

    // Add listeners to update form data
    _titleController.addListener(_updateFormData);
    _fullNameController.addListener(_updateFormData);
    _emailController.addListener(_updateFormData);
    _phoneController.addListener(_updateFormData);
    _addressController.addListener(_updateFormData);
    _cityController.addListener(_updateFormData);
    _countryController.addListener(_updateFormData);
    _postalCodeController.addListener(_updateFormData);
    _websiteController.addListener(_updateFormData);
    _linkedinController.addListener(_updateFormData);
    _githubController.addListener(_updateFormData);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _countryController.dispose();
    _postalCodeController.dispose();
    _websiteController.dispose();
    _linkedinController.dispose();
    _githubController.dispose();
    super.dispose();
  }

  void _updateFormData() {
    widget.onDataChanged({
      'title': _titleController.text,
      'fullName': _fullNameController.text,
      'email': _emailController.text,
      'phone': _phoneController.text,
      'address': _addressController.text,
      'city': _cityController.text,
      'country': _countryController.text,
      'postalCode': _postalCodeController.text,
      'website': _websiteController.text,
      'linkedin': _linkedinController.text,
      'github': _githubController.text,
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Let\'s start with your basic information',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'This information will be displayed on your CV',
              style: TextStyle(
                fontSize: 13.sp,
                color: AppColors.textSecondary,
              ),
            ),
            SizedBox(height: 24.h),

            // CV Title
            _buildTextField(
              controller: _titleController,
              label: 'CV Title *',
              hint: 'e.g., Software Engineer CV',
              icon: Icons.title,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a CV title';
                }
                return null;
              },
            ),
            SizedBox(height: 16.h),

            // Profile Image Upload (Placeholder)
            _buildImageUploadSection(),
            SizedBox(height: 24.h),

            // Personal Information Section Header
            _buildSectionHeader('Personal Information'),
            SizedBox(height: 16.h),

            // Full Name
            _buildTextField(
              controller: _fullNameController,
              label: 'Full Name *',
              hint: 'John Doe',
              icon: Icons.person,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your full name';
                }
                return null;
              },
            ),
            SizedBox(height: 16.h),

            // Email
            _buildTextField(
              controller: _emailController,
              label: 'Email *',
              hint: 'john.doe@example.com',
              icon: Icons.email,
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email';
                }
                if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                    .hasMatch(value)) {
                  return 'Please enter a valid email';
                }
                return null;
              },
            ),
            SizedBox(height: 16.h),

            // Phone
            _buildTextField(
              controller: _phoneController,
              label: 'Phone',
              hint: '+1 234 567 8900',
              icon: Icons.phone,
              keyboardType: TextInputType.phone,
            ),
            SizedBox(height: 24.h),

            // Location Section Header
            _buildSectionHeader('Location'),
            SizedBox(height: 16.h),

            // Address
            _buildTextField(
              controller: _addressController,
              label: 'Address',
              hint: '123 Main Street',
              icon: Icons.home,
            ),
            SizedBox(height: 16.h),

            // City and Country (Row)
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    controller: _cityController,
                    label: 'City',
                    hint: 'New York',
                    icon: Icons.location_city,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: _buildTextField(
                    controller: _countryController,
                    label: 'Country',
                    hint: 'USA',
                    icon: Icons.flag,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),

            // Postal Code
            _buildTextField(
              controller: _postalCodeController,
              label: 'Postal Code',
              hint: '10001',
              icon: Icons.mail,
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 24.h),

            // Online Presence Section Header
            _buildSectionHeader('Online Presence'),
            SizedBox(height: 16.h),

            // Website
            _buildTextField(
              controller: _websiteController,
              label: 'Website',
              hint: 'https://www.example.com',
              icon: Icons.language,
              keyboardType: TextInputType.url,
            ),
            SizedBox(height: 16.h),

            // LinkedIn
            _buildTextField(
              controller: _linkedinController,
              label: 'LinkedIn',
              hint: 'https://www.linkedin.com/in/johndoe',
              icon: Icons.link,
              keyboardType: TextInputType.url,
            ),
            SizedBox(height: 16.h),

            // GitHub
            _buildTextField(
              controller: _githubController,
              label: 'GitHub',
              hint: 'https://github.com/johndoe',
              icon: Icons.code,
              keyboardType: TextInputType.url,
            ),
            SizedBox(height: 24.h),
          ],
        ),
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, size: 20.sp),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.withValues(alpha: 0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        filled: true,
        fillColor: Colors.grey.withValues(alpha: 0.05),
      ),
    );
  }

  Widget _buildImageUploadSection() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30.r,
              backgroundColor: AppColors.primary.withValues(alpha: 0.1),
              child: Icon(
                Icons.person,
                size: 30.sp,
                color: AppColors.primary,
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Profile Photo',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    'Add a professional photo (optional)',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            OutlinedButton.icon(
              onPressed: () {
                // TODO: Implement image picker
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Image upload coming soon')),
                );
              },
              icon: const Icon(Icons.upload),
              label: const Text('Upload'),
            ),
          ],
        ),
      ),
    );
  }
}
