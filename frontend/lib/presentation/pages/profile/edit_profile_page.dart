import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_colors.dart';
import '../../bloc/auth/auth_bloc.dart';
import '../../bloc/auth/auth_event.dart';
import '../../bloc/auth/auth_state.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _headlineController;
  late TextEditingController _nationalityController;
  late TextEditingController _cityController;
  late TextEditingController _countryController;
  late TextEditingController _addressController;
  late TextEditingController _phoneController;
  late TextEditingController _linkedinController;
  DateTime? _selectedDate;
  String? _selectedGender;

  @override
  void initState() {
    super.initState();
    final authState = context.read<AuthBloc>().state;
    final user = authState is Authenticated ? authState.user : null;

    _nameController = TextEditingController(text: user?.name ?? '');
    _emailController = TextEditingController(text: user?.email ?? '');
    _headlineController = TextEditingController(text: user?.headline ?? '');
    _nationalityController =
        TextEditingController(text: user?.nationality ?? '');
    _cityController = TextEditingController(text: user?.city ?? '');
    _countryController = TextEditingController(text: user?.country ?? '');
    _addressController = TextEditingController(text: user?.address ?? '');
    _phoneController = TextEditingController(text: user?.phoneNumber ?? '');
    _linkedinController = TextEditingController(text: user?.linkedinUrl ?? '');
    _selectedDate = user?.dateOfBirth;
    _selectedGender = user?.gender;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _headlineController.dispose();
    _nationalityController.dispose();
    _cityController.dispose();
    _countryController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    _linkedinController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime(2000),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _saveProfile() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
            UpdateProfileEvent(
              name: _nameController.text.trim(),
              email: _emailController.text.trim(),
              headline: _headlineController.text.trim().isEmpty
                  ? null
                  : _headlineController.text.trim(),
              gender: _selectedGender,
              dateOfBirth: _selectedDate != null
                  ? DateFormat('yyyy-MM-dd').format(_selectedDate!)
                  : null,
              nationality: _nationalityController.text.trim().isEmpty
                  ? null
                  : _nationalityController.text.trim(),
              city: _cityController.text.trim().isEmpty
                  ? null
                  : _cityController.text.trim(),
              country: _countryController.text.trim().isEmpty
                  ? null
                  : _countryController.text.trim(),
              address: _addressController.text.trim().isEmpty
                  ? null
                  : _addressController.text.trim(),
              phoneNumber: _phoneController.text.trim().isEmpty
                  ? null
                  : _phoneController.text.trim(),
              linkedinUrl: _linkedinController.text.trim().isEmpty
                  ? null
                  : _linkedinController.text.trim(),
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is ProfileUpdateSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Profile updated successfully!'),
                backgroundColor: Colors.green,
              ),
            );
            context.pop();
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.error,
              ),
            );
          }
        },
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            final isLoading = state is AuthLoading;

            return Form(
              key: _formKey,
              child: ListView(
                padding: EdgeInsets.all(16.w),
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Full Name',
                      prefixIcon: Icon(Icons.person_outline),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                    enabled: !isLoading,
                  ),
                  SizedBox(height: 16.h),
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.email_outlined),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      if (!value.contains('@')) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                    enabled: !isLoading,
                  ),
                  SizedBox(height: 16.h),
                  TextFormField(
                    controller: _headlineController,
                    decoration: const InputDecoration(
                      labelText: 'Headline (optional)',
                      prefixIcon: Icon(Icons.work_outline),
                      hintText: 'e.g., Software Engineer',
                    ),
                    enabled: !isLoading,
                  ),
                  SizedBox(height: 16.h),
                  DropdownButtonFormField<String>(
                    initialValue: _selectedGender,
                    decoration: const InputDecoration(
                      labelText: 'Gender (optional)',
                      prefixIcon: Icon(Icons.person),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'male', child: Text('Male')),
                      DropdownMenuItem(value: 'female', child: Text('Female')),
                      DropdownMenuItem(value: 'other', child: Text('Other')),
                    ],
                    onChanged: isLoading
                        ? null
                        : (value) {
                            setState(() {
                              _selectedGender = value;
                            });
                          },
                  ),
                  SizedBox(height: 16.h),
                  InkWell(
                    onTap: isLoading ? null : _selectDate,
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        labelText: 'Date of Birth (optional)',
                        prefixIcon: Icon(Icons.calendar_today),
                      ),
                      child: Text(
                        _selectedDate != null
                            ? DateFormat('MMM dd, yyyy').format(_selectedDate!)
                            : 'Select date',
                        style: TextStyle(
                          color: _selectedDate != null
                              ? null
                              : AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  TextFormField(
                    controller: _nationalityController,
                    decoration: const InputDecoration(
                      labelText: 'Nationality (optional)',
                      prefixIcon: Icon(Icons.flag_outlined),
                      hintText: 'e.g., Iraqi',
                    ),
                    enabled: !isLoading,
                  ),
                  SizedBox(height: 16.h),
                  TextFormField(
                    controller: _cityController,
                    decoration: const InputDecoration(
                      labelText: 'City (optional)',
                      prefixIcon: Icon(Icons.location_city),
                      hintText: 'e.g., Baghdad',
                    ),
                    enabled: !isLoading,
                  ),
                  SizedBox(height: 16.h),
                  TextFormField(
                    controller: _countryController,
                    decoration: const InputDecoration(
                      labelText: 'Country (optional)',
                      prefixIcon: Icon(Icons.public),
                      hintText: 'e.g., Iraq',
                    ),
                    enabled: !isLoading,
                  ),
                  SizedBox(height: 16.h),
                  TextFormField(
                    controller: _addressController,
                    decoration: const InputDecoration(
                      labelText: 'Address (optional)',
                      prefixIcon: Icon(Icons.home_outlined),
                    ),
                    maxLines: 2,
                    enabled: !isLoading,
                  ),
                  SizedBox(height: 16.h),
                  TextFormField(
                    controller: _phoneController,
                    decoration: const InputDecoration(
                      labelText: 'Phone Number (optional)',
                      prefixIcon: Icon(Icons.phone_outlined),
                      hintText: '+964 XXX XXX XXXX',
                    ),
                    keyboardType: TextInputType.phone,
                    enabled: !isLoading,
                  ),
                  SizedBox(height: 16.h),
                  TextFormField(
                    controller: _linkedinController,
                    decoration: const InputDecoration(
                      labelText: 'LinkedIn URL (optional)',
                      prefixIcon: Icon(Icons.link),
                      hintText: 'https://linkedin.com/in/username',
                    ),
                    keyboardType: TextInputType.url,
                    enabled: !isLoading,
                  ),
                  SizedBox(height: 32.h),
                  ElevatedButton(
                    onPressed: isLoading ? null : _saveProfile,
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 48.h),
                    ),
                    child: isLoading
                        ? SizedBox(
                            height: 20.h,
                            width: 20.w,
                            child: const CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : const Text('Save Changes'),
                  ),
                  SizedBox(height: 16.h),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
