// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'job_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JobModel _$JobModelFromJson(Map<String, dynamic> json) => JobModel(
      id: (json['id'] as num).toInt(),
      companyId: (json['companyId'] as num).toInt(),
      userId: (json['userId'] as num).toInt(),
      title: json['title'] as String,
      slug: json['slug'] as String,
      description: json['description'] as String,
      requirements: json['requirements'] as String?,
      benefits: json['benefits'] as String?,
      location: json['location'] as String?,
      city: json['city'] as String?,
      country: json['country'] as String?,
      employmentType: json['employmentType'] as String,
      experienceLevel: json['experienceLevel'] as String,
      category: json['category'] as String?,
      skills:
          (json['skills'] as List<dynamic>?)?.map((e) => e as String).toList(),
      salaryMin: (json['salaryMin'] as num?)?.toDouble(),
      salaryMax: (json['salaryMax'] as num?)?.toDouble(),
      salaryCurrency: json['salaryCurrency'] as String?,
      salaryPeriod: json['salaryPeriod'] as String?,
      isRemote: json['isRemote'] as bool,
      isFeatured: json['isFeatured'] as bool,
      isActive: json['isActive'] as bool,
      isSaved: json['isSaved'] as bool?,
      expiresAt: json['expiresAt'] == null
          ? null
          : DateTime.parse(json['expiresAt'] as String),
      publishedAt: json['publishedAt'] == null
          ? null
          : DateTime.parse(json['publishedAt'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      company:
          JobModel._companyFromJson(json['company'] as Map<String, dynamic>?),
    );

Map<String, dynamic> _$JobModelToJson(JobModel instance) => <String, dynamic>{
      'id': instance.id,
      'companyId': instance.companyId,
      'userId': instance.userId,
      'title': instance.title,
      'slug': instance.slug,
      'description': instance.description,
      'requirements': instance.requirements,
      'benefits': instance.benefits,
      'location': instance.location,
      'city': instance.city,
      'country': instance.country,
      'employmentType': instance.employmentType,
      'experienceLevel': instance.experienceLevel,
      'category': instance.category,
      'skills': instance.skills,
      'salaryMin': instance.salaryMin,
      'salaryMax': instance.salaryMax,
      'salaryCurrency': instance.salaryCurrency,
      'salaryPeriod': instance.salaryPeriod,
      'isRemote': instance.isRemote,
      'isFeatured': instance.isFeatured,
      'isActive': instance.isActive,
      'isSaved': instance.isSaved,
      'expiresAt': instance.expiresAt?.toIso8601String(),
      'publishedAt': instance.publishedAt?.toIso8601String(),
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'company': JobModel._companyToJson(instance.company),
    };

CompanyBriefModel _$CompanyBriefModelFromJson(Map<String, dynamic> json) =>
    CompanyBriefModel(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      slug: json['slug'] as String,
      logo: json['logo'] as String?,
      industry: json['industry'] as String?,
      companySize: json['companySize'] as String?,
    );

Map<String, dynamic> _$CompanyBriefModelToJson(CompanyBriefModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'slug': instance.slug,
      'logo': instance.logo,
      'industry': instance.industry,
      'companySize': instance.companySize,
    };
