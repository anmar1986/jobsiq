import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../config/di/injection.dart';
import '../../../core/theme/app_colors.dart';

class JobAlertsPage extends StatefulWidget {
  const JobAlertsPage({super.key});

  @override
  State<JobAlertsPage> createState() => _JobAlertsPageState();
}

class _JobAlertsPageState extends State<JobAlertsPage> {
  List<Map<String, dynamic>> _alerts = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAlerts();
  }

  Future<void> _loadAlerts() async {
    setState(() => _isLoading = true);

    final prefs = sl<SharedPreferences>();
    final alertsJson = prefs.getString('job_alerts') ?? '[]';
    final List<dynamic> alertsList = jsonDecode(alertsJson);

    setState(() {
      _alerts = alertsList.cast<Map<String, dynamic>>();
      _isLoading = false;
    });
  }

  Future<void> _saveAlerts() async {
    final prefs = sl<SharedPreferences>();
    await prefs.setString('job_alerts', jsonEncode(_alerts));
  }

  Future<void> _addAlert() async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => const AddAlertDialog(),
    );

    if (result != null) {
      setState(() {
        _alerts.add({
          ...result,
          'id': DateTime.now().millisecondsSinceEpoch.toString(),
          'created_at': DateTime.now().toIso8601String(),
          'is_active': true,
        });
      });
      await _saveAlerts();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
                'Job alert created! You\'ll be notified when matching jobs are posted.'),
            backgroundColor: Colors.green,
          ),
        );
      }
    }
  }

  Future<void> _deleteAlert(int index) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Alert'),
        content: const Text('Are you sure you want to delete this job alert?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      setState(() {
        _alerts.removeAt(index);
      });
      await _saveAlerts();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Alert deleted')),
        );
      }
    }
  }

  Future<void> _toggleAlert(int index) async {
    setState(() {
      _alerts[index]['is_active'] = !(_alerts[index]['is_active'] ?? true);
    });
    await _saveAlerts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Job Alerts'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _alerts.isEmpty
              ? _buildEmptyState()
              : RefreshIndicator(
                  onRefresh: _loadAlerts,
                  child: ListView.builder(
                    padding: EdgeInsets.all(16.w),
                    itemCount: _alerts.length,
                    itemBuilder: (context, index) {
                      return _buildAlertCard(_alerts[index], index);
                    },
                  ),
                ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addAlert,
        icon: const Icon(Icons.add_alert),
        label: const Text('New Alert'),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.notifications_none,
              size: 80.sp,
              color: Colors.grey,
            ),
            SizedBox(height: 24.h),
            Text(
              'No Job Alerts Yet',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 12.h),
            Text(
              'Create job alerts to get notified when new jobs matching your criteria are posted',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14.sp,
                color: AppColors.textSecondary,
              ),
            ),
            SizedBox(height: 24.h),
            ElevatedButton.icon(
              onPressed: _addAlert,
              icon: const Icon(Icons.add_alert),
              label: const Text('Create Your First Alert'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAlertCard(Map<String, dynamic> alert, int index) {
    final isActive = alert['is_active'] ?? true;

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
                    alert['name'] ?? 'Job Alert',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Switch(
                  value: isActive,
                  onChanged: (value) => _toggleAlert(index),
                  thumbColor: WidgetStateProperty.resolveWith((states) {
                    if (states.contains(WidgetState.selected)) {
                      return AppColors.primary;
                    }
                    return null;
                  }),
                  trackColor: WidgetStateProperty.resolveWith((states) {
                    if (states.contains(WidgetState.selected)) {
                      return AppColors.primary.withValues(alpha: 0.5);
                    }
                    return null;
                  }),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline),
                  color: Colors.red,
                  onPressed: () => _deleteAlert(index),
                ),
              ],
            ),
            SizedBox(height: 12.h),

            // Search criteria
            if (alert['keywords'] != null &&
                alert['keywords'].toString().isNotEmpty)
              _buildCriteriaChip(
                  Icons.search, 'Keywords: ${alert['keywords']}'),

            if (alert['location'] != null &&
                alert['location'].toString().isNotEmpty)
              _buildCriteriaChip(Icons.location_on, alert['location']),

            if (alert['employment_type'] != null &&
                alert['employment_type'].toString().isNotEmpty)
              _buildCriteriaChip(Icons.work, alert['employment_type']),

            if (alert['experience_level'] != null &&
                alert['experience_level'].toString().isNotEmpty)
              _buildCriteriaChip(Icons.star, alert['experience_level']),

            SizedBox(height: 12.h),
            Row(
              children: [
                Icon(
                  isActive
                      ? Icons.notifications_active
                      : Icons.notifications_off,
                  size: 14.sp,
                  color: isActive ? Colors.green : Colors.grey,
                ),
                SizedBox(width: 4.w),
                Text(
                  isActive ? 'Active' : 'Paused',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: isActive ? Colors.green : Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Spacer(),
                Text(
                  'Created ${_formatDate(alert['created_at'])}',
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCriteriaChip(IconData icon, String label) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        children: [
          Icon(icon, size: 16.sp, color: AppColors.primary),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 13.sp,
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(String? dateString) {
    if (dateString == null) return 'recently';
    try {
      final date = DateTime.parse(dateString);
      final now = DateTime.now();
      final difference = now.difference(date);

      if (difference.inDays == 0) {
        return 'today';
      } else if (difference.inDays == 1) {
        return 'yesterday';
      } else if (difference.inDays < 7) {
        return '${difference.inDays} days ago';
      } else {
        return '${(difference.inDays / 7).floor()} weeks ago';
      }
    } catch (e) {
      return 'recently';
    }
  }
}

class AddAlertDialog extends StatefulWidget {
  const AddAlertDialog({super.key});

  @override
  State<AddAlertDialog> createState() => _AddAlertDialogState();
}

class _AddAlertDialogState extends State<AddAlertDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _keywordsController = TextEditingController();
  final _locationController = TextEditingController();
  String? _selectedEmploymentType;
  String? _selectedExperienceLevel;

  final List<String> _employmentTypes = [
    'Full-Time',
    'Part-Time',
    'Contract',
    'Freelance',
    'Internship',
  ];

  final List<String> _experienceLevels = [
    'Entry Level',
    'Mid Level',
    'Senior Level',
    'Executive',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _keywordsController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Create Job Alert'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Alert Name *',
                  hintText: 'e.g., Senior Developer Jobs',
                  prefixIcon: Icon(Icons.label),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an alert name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.h),
              TextFormField(
                controller: _keywordsController,
                decoration: const InputDecoration(
                  labelText: 'Keywords',
                  hintText: 'e.g., Flutter, React, Python',
                  prefixIcon: Icon(Icons.search),
                ),
              ),
              SizedBox(height: 16.h),
              TextFormField(
                controller: _locationController,
                decoration: const InputDecoration(
                  labelText: 'Location',
                  hintText: 'e.g., New York, Remote',
                  prefixIcon: Icon(Icons.location_on),
                ),
              ),
              SizedBox(height: 16.h),
              DropdownButtonFormField<String>(
                initialValue: _selectedEmploymentType,
                decoration: const InputDecoration(
                  labelText: 'Employment Type',
                  prefixIcon: Icon(Icons.work),
                ),
                items: _employmentTypes.map((type) {
                  return DropdownMenuItem(value: type, child: Text(type));
                }).toList(),
                onChanged: (value) {
                  setState(() => _selectedEmploymentType = value);
                },
              ),
              SizedBox(height: 16.h),
              DropdownButtonFormField<String>(
                initialValue: _selectedExperienceLevel,
                decoration: const InputDecoration(
                  labelText: 'Experience Level',
                  prefixIcon: Icon(Icons.star),
                ),
                items: _experienceLevels.map((level) {
                  return DropdownMenuItem(value: level, child: Text(level));
                }).toList(),
                onChanged: (value) {
                  setState(() => _selectedExperienceLevel = value);
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              final alert = {
                'name': _nameController.text,
                'keywords': _keywordsController.text,
                'location': _locationController.text,
                'employment_type': _selectedEmploymentType,
                'experience_level': _selectedExperienceLevel,
              };
              Navigator.pop(context, alert);
            }
          },
          child: const Text('Create Alert'),
        ),
      ],
    );
  }
}
