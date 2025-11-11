import 'package:equatable/equatable.dart';

class JobEntity extends Equatable {
  final int id;
  final int companyId;
  final int userId;
  final String title;
  final String slug;
  final String description;
  final String? requirements;
  final String? benefits;
  final String? location;
  final String? city;
  final String? country;
  final String employmentType;
  final String experienceLevel;
  final String? category;
  final List<String>? skills;
  final double? salaryMin;
  final double? salaryMax;
  final String? salaryCurrency;
  final String? salaryPeriod;
  final bool isRemote;
  final bool isFeatured;
  final bool isActive;
  final bool? isSaved;
  final DateTime? expiresAt;
  final DateTime? publishedAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  final CompanyBriefEntity? company;

  const JobEntity({
    required this.id,
    required this.companyId,
    required this.userId,
    required this.title,
    required this.slug,
    required this.description,
    this.requirements,
    this.benefits,
    this.location,
    this.city,
    this.country,
    required this.employmentType,
    required this.experienceLevel,
    this.category,
    this.skills,
    this.salaryMin,
    this.salaryMax,
    this.salaryCurrency,
    this.salaryPeriod,
    required this.isRemote,
    required this.isFeatured,
    required this.isActive,
    this.isSaved,
    this.expiresAt,
    this.publishedAt,
    required this.createdAt,
    required this.updatedAt,
    this.company,
  });

  String get salaryRange {
    if (salaryMin == null && salaryMax == null) return 'Negotiable';
    final currency = salaryCurrency ?? 'USD';
    if (salaryMin != null && salaryMax != null) {
      return '$currency ${salaryMin!.toStringAsFixed(0)} - ${salaryMax!.toStringAsFixed(0)}';
    } else if (salaryMin != null) {
      return 'From $currency ${salaryMin!.toStringAsFixed(0)}';
    } else {
      return 'Up to $currency ${salaryMax!.toStringAsFixed(0)}';
    }
  }

  @override
  List<Object?> get props => [
        id,
        companyId,
        userId,
        title,
        slug,
        description,
        requirements,
        benefits,
        location,
        city,
        country,
        employmentType,
        experienceLevel,
        category,
        skills,
        salaryMin,
        salaryMax,
        salaryCurrency,
        salaryPeriod,
        isRemote,
        isFeatured,
        isActive,
        isSaved,
        expiresAt,
        publishedAt,
        createdAt,
        updatedAt,
        company,
      ];
}

class CompanyBriefEntity extends Equatable {
  final int id;
  final String name;
  final String slug;
  final String? logo;
  final String? industry;
  final String? companySize;

  const CompanyBriefEntity({
    required this.id,
    required this.name,
    required this.slug,
    this.logo,
    this.industry,
    this.companySize,
  });

  @override
  List<Object?> get props => [id, name, slug, logo, industry, companySize];
}
