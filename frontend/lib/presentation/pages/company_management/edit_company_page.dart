import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../../config/di/injection.dart';
import '../../../core/theme/app_colors.dart';
import '../../bloc/company_management/company_management_bloc.dart';
import '../../bloc/company_management/company_management_event.dart';
import '../../bloc/company_management/company_management_state.dart';

class EditCompanyPage extends StatelessWidget {
  final int companyId;

  const EditCompanyPage({
    super.key,
    required this.companyId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          getIt<CompanyManagementBloc>()..add(LoadMyCompanyEvent(companyId)),
      child: const _EditCompanyView(),
    );
  }
}

class _EditCompanyView extends StatefulWidget {
  const _EditCompanyView();

  @override
  State<_EditCompanyView> createState() => _EditCompanyViewState();
}

class _EditCompanyViewState extends State<_EditCompanyView> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _websiteController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _cityController = TextEditingController();
  final _countryController = TextEditingController();
  final _industryController = TextEditingController();
  final _companySizeController = TextEditingController();

  File? _logoFile;
  File? _coverFile;
  int? _companyId;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _websiteController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _cityController.dispose();
    _countryController.dispose();
    _industryController.dispose();
    _companySizeController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(bool isLogo) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: isLogo ? 500 : 1200,
      maxHeight: isLogo ? 500 : 600,
      imageQuality: 85,
    );

    if (image != null) {
      setState(() {
        if (isLogo) {
          _logoFile = File(image.path);
        } else {
          _coverFile = File(image.path);
        }
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate() && _companyId != null) {
      setState(() => _isLoading = true);

      final data = <String, dynamic>{
        'name': _nameController.text.trim(),
        'description': _descriptionController.text.trim(),
        'website': _websiteController.text.trim(),
        'email': _emailController.text.trim(),
        'phone': _phoneController.text.trim(),
        'city': _cityController.text.trim(),
        'country': _countryController.text.trim(),
        'industry': _industryController.text.trim(),
        'company_size': _companySizeController.text.trim(),
      };

      if (_logoFile != null) {
        data['logo'] = _logoFile;
      }
      if (_coverFile != null) {
        data['cover'] = _coverFile;
      }

      context.read<CompanyManagementBloc>().add(
            UpdateCompanyEvent(_companyId!, data),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Company'),
        backgroundColor: AppColors.backgroundLight,
        elevation: 0,
      ),
      body: BlocConsumer<CompanyManagementBloc, CompanyManagementState>(
        listener: (context, state) {
          if (state is CompanyManagementError) {
            setState(() => _isLoading = false);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          } else if (state is CompanyUpdated) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Company updated successfully'),
                backgroundColor: Colors.green,
              ),
            );
            context.pop();
          }
        },
        builder: (context, state) {
          if (state is MyCompanyLoaded && _companyId == null) {
            // Initialize form with company data
            _companyId = state.company.id;
            _nameController.text = state.company.name;
            _descriptionController.text = state.company.description ?? '';
            _websiteController.text = state.company.website ?? '';
            _emailController.text = state.company.email ?? '';
            _phoneController.text = state.company.phone ?? '';
            _cityController.text = state.company.city ?? '';
            _countryController.text = state.company.country ?? '';
            _industryController.text = state.company.industry ?? '';
            _companySizeController.text = state.company.size ?? '';
          }

          if (state is CompanyManagementLoading && _companyId == null) {
            return const Center(child: CircularProgressIndicator());
          }

          return Form(
            key: _formKey,
            child: ListView(
              padding: EdgeInsets.all(16.w),
              children: [
                // Logo Section
                Center(
                  child: Column(
                    children: [
                      Text(
                        'Company Logo',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 12.h),
                      GestureDetector(
                        onTap: () => _pickImage(true),
                        child: Container(
                          width: 120.w,
                          height: 120.w,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(12.r),
                            border: Border.all(color: Colors.grey[400]!),
                          ),
                          child: _logoFile != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(12.r),
                                  child: Image.file(
                                    _logoFile!,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : Icon(
                                  Icons.add_photo_alternate,
                                  size: 40.sp,
                                  color: Colors.grey[600],
                                ),
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        'Tap to change logo',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 24.h),

                // Cover Image Section
                Text(
                  'Cover Image',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 12.h),
                GestureDetector(
                  onTap: () => _pickImage(false),
                  child: Container(
                    width: double.infinity,
                    height: 150.h,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(color: Colors.grey[400]!),
                    ),
                    child: _coverFile != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(12.r),
                            child: Image.file(
                              _coverFile!,
                              fit: BoxFit.cover,
                            ),
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add_photo_alternate,
                                size: 40.sp,
                                color: Colors.grey[600],
                              ),
                              SizedBox(height: 8.h),
                              Text(
                                'Tap to change cover image',
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                  ),
                ),

                SizedBox(height: 24.h),

                // Company Name
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Company Name *',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter company name';
                    }
                    return null;
                  },
                ),

                SizedBox(height: 16.h),

                // Description
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                    alignLabelWithHint: true,
                  ),
                  maxLines: 5,
                ),

                SizedBox(height: 16.h),

                // Industry
                TextFormField(
                  controller: _industryController,
                  decoration: const InputDecoration(
                    labelText: 'Industry',
                    border: OutlineInputBorder(),
                  ),
                ),

                SizedBox(height: 16.h),

                // Company Size
                TextFormField(
                  controller: _companySizeController,
                  decoration: const InputDecoration(
                    labelText: 'Company Size (e.g., 10-50, 50-200)',
                    border: OutlineInputBorder(),
                  ),
                ),

                SizedBox(height: 16.h),

                // Email
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value != null &&
                        value.isNotEmpty &&
                        !value.contains('@')) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),

                SizedBox(height: 16.h),

                // Phone
                TextFormField(
                  controller: _phoneController,
                  decoration: const InputDecoration(
                    labelText: 'Phone',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.phone,
                ),

                SizedBox(height: 16.h),

                // Website
                TextFormField(
                  controller: _websiteController,
                  decoration: const InputDecoration(
                    labelText: 'Website',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.url,
                ),

                SizedBox(height: 16.h),

                // City
                TextFormField(
                  controller: _cityController,
                  decoration: const InputDecoration(
                    labelText: 'City',
                    border: OutlineInputBorder(),
                  ),
                ),

                SizedBox(height: 16.h),

                // Country
                TextFormField(
                  controller: _countryController,
                  decoration: const InputDecoration(
                    labelText: 'Country',
                    border: OutlineInputBorder(),
                  ),
                ),

                SizedBox(height: 32.h),

                // Submit Button
                ElevatedButton(
                  onPressed: _isLoading ? null : _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                  child: _isLoading
                      ? SizedBox(
                          height: 20.h,
                          width: 20.w,
                          child: const CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : Text(
                          'Update Company',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),

                SizedBox(height: 32.h),
              ],
            ),
          );
        },
      ),
    );
  }
}
