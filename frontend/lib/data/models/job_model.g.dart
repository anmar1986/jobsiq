// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'job_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JobModel _$JobModelFromJson(Map<String, dynamic> json) => JobModel(
      id: (json['id'] as num).toInt(),
      companyId: (json['company_id'] as num?)?.toInt(),
      userId: (json['user_id'] as num?)?.toInt(),
      title: json['title'] as String,
      slug: json['slug'] as String,
      description: json['description'] as String,
      requirements: json['requirements'] as String?,
      benefits: json['benefits'] as String?,
      location: json['location'] as String?,
      city: json['city'] as String?,
      country: json['country'] as String?,
      employmentType: json['employment_type'] as String,
      experienceLevel: json['experience_level'] as String?,
      category: json['category'] as String?,
      skills:
          (json['skills'] as List<dynamic>?)?.map((e) => e as String).toList(),
      salaryMin: JobModel._salaryFromJson(json['salary_min']),
      salaryMax: JobModel._salaryFromJson(json['salary_max']),
      salaryCurrency: json['salary_currency'] as String?,
      salaryPeriod: json['salary_period'] as String?,
      isRemote: json['is_remote'] as bool,
      isFeatured: json['is_featured'] as bool,
      isActive: json['is_active'] == null
          ? true
          : JobModel._boolFromJson(json['is_active']),
      isSaved: json['is_saved'] as bool?,
      isApplied: json['is_applied'] == null
          ? null
          : JobModel._boolFromJson(json['is_applied']),
      expiresAt: json['expires_at'] == null
          ? null
          : DateTime.parse(json['expires_at'] as String),
      publishedAt: json['published_at'] == null
          ? null
          : DateTime.parse(json['published_at'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      company:
          JobModel._companyFromJson(json['company'] as Map<String, dynamic>?),
    );

Map<String, dynamic> _$JobModelToJson(JobModel instance) => <String, dynamic>{
      'id': instance.id,
      'company_id': instance.companyId,
      'user_id': instance.userId,
      'title': instance.title,
      'slug': instance.slug,
      'description': instance.description,
      'requirements': instance.requirements,
      'benefits': instance.benefits,
      'location': instance.location,
      'city': instance.city,
      'country': instance.country,
      'employment_type': instance.employmentType,
      'experience_level': instance.experienceLevel,
      'category': instance.category,
      'skills': instance.skills,
      'salary_currency': instance.salaryCurrency,
      'salary_period': instance.salaryPeriod,
      'is_remote': instance.isRemote,
      'is_featured': instance.isFeatured,
      'is_saved': instance.isSaved,
      'is_applied': instance.isApplied,
      'expires_at': instance.expiresAt?.toIso8601String(),
      'published_at': instance.publishedAt?.toIso8601String(),
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
      'company': JobModel._companyToJson(instance.company),
      'salary_min': instance.salaryMin,
      'salary_max': instance.salaryMax,
      'is_active': instance.isActive,
    };

CompanyBriefModel _$CompanyBriefModelFromJson(Map<String, dynamic> json) =>
    CompanyBriefModel(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      slug: json['slug'] as String,
      logo: CompanyBriefModel._logoFromJson(json['logo']),
      industry: json['industry'] as String?,
      companySize: json['company_size'] as String?,
    );

Map<String, dynamic> _$CompanyBriefModelToJson(CompanyBriefModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'slug': instance.slug,
      'industry': instance.industry,
      'company_size': instance.companySize,
      'logo': instance.logo,
    };
