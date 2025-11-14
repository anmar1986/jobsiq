import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'app_colors.dart';

class AppTextStyles {
  // Headings - Light Theme
  static TextStyle h1 = TextStyle(
    fontSize: 32.sp,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
    height: 1.2,
  );

  static TextStyle h2 = TextStyle(
    fontSize: 28.sp,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
    height: 1.2,
  );

  static TextStyle h3 = TextStyle(
    fontSize: 24.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.3,
  );

  static TextStyle h4 = TextStyle(
    fontSize: 20.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.3,
  );

  static TextStyle h5 = TextStyle(
    fontSize: 18.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.4,
  );

  static TextStyle h6 = TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.4,
  );

  // Body Text
  static TextStyle bodyLarge = TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
    height: 1.5,
  );

  static TextStyle bodyMedium = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
    height: 1.5,
  );

  static TextStyle bodySmall = TextStyle(
    fontSize: 12.sp,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
    height: 1.5,
  );

  // Button Text
  static TextStyle button = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.white,
    height: 1.2,
  );

  static TextStyle buttonLarge = TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.white,
    height: 1.2,
  );

  // Caption & Labels
  static TextStyle caption = TextStyle(
    fontSize: 12.sp,
    fontWeight: FontWeight.normal,
    color: AppColors.textTertiary,
    height: 1.3,
  );

  static TextStyle label = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
    height: 1.3,
  );

  static TextStyle labelSmall = TextStyle(
    fontSize: 12.sp,
    fontWeight: FontWeight.w500,
    color: AppColors.textTertiary,
    height: 1.3,
  );

  // Dark Theme Variants
  static TextStyle h1Dark = h1.copyWith(color: AppColors.textPrimaryDark);
  static TextStyle h2Dark = h2.copyWith(color: AppColors.textPrimaryDark);
  static TextStyle h3Dark = h3.copyWith(color: AppColors.textPrimaryDark);
  static TextStyle h4Dark = h4.copyWith(color: AppColors.textPrimaryDark);
  static TextStyle h5Dark = h5.copyWith(color: AppColors.textPrimaryDark);
  static TextStyle h6Dark = h6.copyWith(color: AppColors.textPrimaryDark);

  static TextStyle bodyLargeDark =
      bodyLarge.copyWith(color: AppColors.textPrimaryDark);
  static TextStyle bodyMediumDark =
      bodyMedium.copyWith(color: AppColors.textPrimaryDark);
  static TextStyle bodySmallDark =
      bodySmall.copyWith(color: AppColors.textSecondaryDark);

  static TextStyle captionDark =
      caption.copyWith(color: AppColors.textTertiaryDark);
  static TextStyle labelDark =
      label.copyWith(color: AppColors.textSecondaryDark);
  static TextStyle labelSmallDark =
      labelSmall.copyWith(color: AppColors.textTertiaryDark);
}
