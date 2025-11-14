import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../config/di/injection.dart';
import '../../../core/theme/app_colors.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _isDarkMode = false;
  bool _notificationsEnabled = true;
  bool _emailNotifications = true;
  String _language = 'English';

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = sl<SharedPreferences>();
    setState(() {
      _isDarkMode = prefs.getBool('dark_mode') ?? false;
      _notificationsEnabled = prefs.getBool('notifications_enabled') ?? true;
      _emailNotifications = prefs.getBool('email_notifications') ?? true;
      _language = prefs.getString('language') ?? 'English';
    });
  }

  Future<void> _saveSetting(String key, dynamic value) async {
    final prefs = sl<SharedPreferences>();
    if (value is bool) {
      await prefs.setBool(key, value);
    } else if (value is String) {
      await prefs.setString(key, value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          // Appearance Section
          _buildSectionHeader('Appearance'),
          _buildSwitchTile(
            icon: Icons.dark_mode,
            title: 'Dark Mode',
            subtitle: 'Switch between light and dark theme',
            value: _isDarkMode,
            onChanged: (value) {
              setState(() => _isDarkMode = value);
              _saveSetting('dark_mode', value);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Dark mode ${value ? 'enabled' : 'disabled'}. Please restart the app to apply changes.',
                  ),
                  duration: const Duration(seconds: 3),
                ),
              );
            },
          ),

          // Notifications Section
          _buildSectionHeader('Notifications'),
          _buildSwitchTile(
            icon: Icons.notifications,
            title: 'Push Notifications',
            subtitle: 'Receive notifications about jobs and applications',
            value: _notificationsEnabled,
            onChanged: (value) {
              setState(() => _notificationsEnabled = value);
              _saveSetting('notifications_enabled', value);
            },
          ),
          _buildSwitchTile(
            icon: Icons.email,
            title: 'Email Notifications',
            subtitle: 'Receive email updates',
            value: _emailNotifications,
            onChanged: (value) {
              setState(() => _emailNotifications = value);
              _saveSetting('email_notifications', value);
            },
          ),

          // Language & Region Section
          _buildSectionHeader('Language & Region'),
          _buildTile(
            icon: Icons.language,
            title: 'Language',
            subtitle: _language,
            onTap: () => _showLanguageDialog(),
          ),

          // Privacy & Security Section
          _buildSectionHeader('Privacy & Security'),
          _buildTile(
            icon: Icons.lock,
            title: 'Change Password',
            subtitle: 'Update your account password',
            onTap: () {
              // Navigate to change password page
              Navigator.pushNamed(context, '/profile/change-password');
            },
          ),
          _buildTile(
            icon: Icons.privacy_tip,
            title: 'Privacy Policy',
            subtitle: 'Read our privacy policy',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Opening privacy policy...')),
              );
            },
          ),
          _buildTile(
            icon: Icons.description,
            title: 'Terms of Service',
            subtitle: 'Read our terms of service',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Opening terms of service...')),
              );
            },
          ),

          // About Section
          _buildSectionHeader('About'),
          _buildTile(
            icon: Icons.info,
            title: 'App Version',
            subtitle: '1.0.0',
            onTap: null,
          ),
          _buildTile(
            icon: Icons.help,
            title: 'Help & Support',
            subtitle: 'Get help with using the app',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Opening help center...')),
              );
            },
          ),
          _buildTile(
            icon: Icons.bug_report,
            title: 'Report a Bug',
            subtitle: 'Help us improve the app',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Opening bug report form...')),
              );
            },
          ),

          // Account Section
          _buildSectionHeader('Account'),
          _buildTile(
            icon: Icons.delete_forever,
            title: 'Delete Account',
            subtitle: 'Permanently delete your account',
            titleColor: Colors.red,
            onTap: () => _showDeleteAccountDialog(),
          ),

          SizedBox(height: 24.h),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Container(
      padding: EdgeInsets.fromLTRB(16.w, 24.h, 16.w, 8.h),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.w600,
          color: AppColors.primary,
        ),
      ),
    );
  }

  Widget _buildTile({
    required IconData icon,
    required String title,
    required String subtitle,
    VoidCallback? onTap,
    Color? titleColor,
  }) {
    return ListTile(
      leading: Container(
        padding: EdgeInsets.all(8.w),
        decoration: BoxDecoration(
          color: (titleColor ?? AppColors.primary).withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: titleColor ?? AppColors.primary,
          size: 24.sp,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 15.sp,
          fontWeight: FontWeight.w500,
          color: titleColor,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 13.sp,
          color: AppColors.textSecondary,
        ),
      ),
      trailing: onTap != null
          ? Icon(
              Icons.chevron_right,
              color: Colors.grey,
              size: 24.sp,
            )
          : null,
      onTap: onTap,
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return ListTile(
      leading: Container(
        padding: EdgeInsets.all(8.w),
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: AppColors.primary,
          size: 24.sp,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 15.sp,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 13.sp,
          color: AppColors.textSecondary,
        ),
      ),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
      ),
    );
  }

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Language'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildLanguageOption('English'),
            _buildLanguageOption('Arabic'),
            _buildLanguageOption('French'),
            _buildLanguageOption('Spanish'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageOption(String language) {
    return ListTile(
      title: Text(language),
      leading: Radio<String>(
        value: language,
        groupValue: _language,
        onChanged: (value) {
          if (value != null) {
            setState(() => _language = value);
            _saveSetting('language', value);
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Language changed to $value'),
              ),
            );
          }
        },
      ),
      onTap: () {
        setState(() => _language = language);
        _saveSetting('language', language);
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Language changed to $language'),
          ),
        );
      },
    );
  }

  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Account'),
        content: const Text(
          'Are you sure you want to delete your account? This action cannot be undone and all your data will be permanently deleted.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content:
                      Text('Account deletion is not available in this demo'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
