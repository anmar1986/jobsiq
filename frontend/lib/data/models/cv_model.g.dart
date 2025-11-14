// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cv_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CvModel _$CvModelFromJson(Map<String, dynamic> json) => CvModel(
      id: (json['id'] as num).toInt(),
      userId: (json['user_id'] as num).toInt(),
      title: json['title'] as String,
      slug: json['slug'] as String,
      fullName: json['full_name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String?,
      website: json['website'] as String?,
      linkedin: json['linkedin'] as String?,
      github: json['github'] as String?,
      profileImagePath: json['profile_image_path'] as String?,
      address: json['address'] as String?,
      city: json['city'] as String?,
      country: json['country'] as String?,
      postalCode: json['postal_code'] as String?,
      workExperience: (json['work_experience'] as List<dynamic>?)
          ?.map((e) => WorkExperienceModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      education: (json['education'] as List<dynamic>?)
          ?.map((e) => EducationModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      skills:
          (json['skills'] as List<dynamic>?)?.map((e) => e as String).toList(),
      languages: (json['languages'] as List<dynamic>?)
          ?.map((e) => LanguageModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      certifications: (json['certifications'] as List<dynamic>?)
          ?.map((e) => CertificationModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      projects: (json['projects'] as List<dynamic>?)
          ?.map((e) => ProjectModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      isPublic: json['is_public'] as bool,
      isPrimary: json['is_primary'] as bool,
      template: json['template'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$CvModelToJson(CvModel instance) => <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'title': instance.title,
      'slug': instance.slug,
      'full_name': instance.fullName,
      'email': instance.email,
      'phone': instance.phone,
      'website': instance.website,
      'linkedin': instance.linkedin,
      'github': instance.github,
      'address': instance.address,
      'city': instance.city,
      'country': instance.country,
      'postal_code': instance.postalCode,
      'skills': instance.skills,
      'is_public': instance.isPublic,
      'is_primary': instance.isPrimary,
      'template': instance.template,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
      'work_experience':
          instance.workExperience?.map((e) => e.toJson()).toList(),
      'education': instance.education?.map((e) => e.toJson()).toList(),
      'languages': instance.languages?.map((e) => e.toJson()).toList(),
      'certifications':
          instance.certifications?.map((e) => e.toJson()).toList(),
      'projects': instance.projects?.map((e) => e.toJson()).toList(),
      'profile_image_path': instance.profileImagePath,
    };

WorkExperienceModel _$WorkExperienceModelFromJson(Map<String, dynamic> json) =>
    WorkExperienceModel(
      jobTitle: json['position'] as String,
      company: json['company'] as String,
      location: json['location'] as String?,
      startDate: DateTime.parse(json['start_date'] as String),
      endDate: json['end_date'] == null
          ? null
          : DateTime.parse(json['end_date'] as String),
      isCurrent: WorkExperienceModel._isCurrentFromJson(json['is_current']),
      description: json['description'] as String?,
    );

Map<String, dynamic> _$WorkExperienceModelToJson(
        WorkExperienceModel instance) =>
    <String, dynamic>{
      'location': instance.location,
      'start_date': instance.startDate.toIso8601String(),
      'end_date': instance.endDate?.toIso8601String(),
      'description': instance.description,
      'position': instance.jobTitle,
      'company': instance.company,
      'is_current': instance.isCurrent,
    };

EducationModel _$EducationModelFromJson(Map<String, dynamic> json) =>
    EducationModel(
      degree: json['degree'] as String,
      institution: json['institution'] as String,
      location: json['location'] as String?,
      startDate: DateTime.parse(json['start_date'] as String),
      endDate: json['end_date'] == null
          ? null
          : DateTime.parse(json['end_date'] as String),
      isCurrent: EducationModel._isCurrentFromJson(json['is_current']),
      description: json['description'] as String?,
    );

Map<String, dynamic> _$EducationModelToJson(EducationModel instance) =>
    <String, dynamic>{
      'degree': instance.degree,
      'institution': instance.institution,
      'location': instance.location,
      'start_date': instance.startDate.toIso8601String(),
      'end_date': instance.endDate?.toIso8601String(),
      'description': instance.description,
      'is_current': instance.isCurrent,
    };

LanguageModel _$LanguageModelFromJson(Map<String, dynamic> json) =>
    LanguageModel(
      language: json['language'] as String?,
      proficiency: json['proficiency'] as String?,
    );

Map<String, dynamic> _$LanguageModelToJson(LanguageModel instance) =>
    <String, dynamic>{
      'language': instance.language,
      'proficiency': instance.proficiency,
    };

CertificationModel _$CertificationModelFromJson(Map<String, dynamic> json) =>
    CertificationModel(
      name: json['name'] as String,
      issuingOrganization: json['issuing_organization'] as String?,
      issueDate: json['issue_date'] == null
          ? null
          : DateTime.parse(json['issue_date'] as String),
      expiryDate: json['expiry_date'] == null
          ? null
          : DateTime.parse(json['expiry_date'] as String),
      credentialId: json['credential_id'] as String?,
    );

Map<String, dynamic> _$CertificationModelToJson(CertificationModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'issuing_organization': instance.issuingOrganization,
      'issue_date': instance.issueDate?.toIso8601String(),
      'expiry_date': instance.expiryDate?.toIso8601String(),
      'credential_id': instance.credentialId,
    };

ProjectModel _$ProjectModelFromJson(Map<String, dynamic> json) => ProjectModel(
      name: json['name'] as String,
      description: json['description'] as String?,
      url: json['url'] as String?,
      startDate: json['start_date'] == null
          ? null
          : DateTime.parse(json['start_date'] as String),
      endDate: json['end_date'] == null
          ? null
          : DateTime.parse(json['end_date'] as String),
      technologies: (json['technologies'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$ProjectModelToJson(ProjectModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'description': instance.description,
      'url': instance.url,
      'start_date': instance.startDate?.toIso8601String(),
      'end_date': instance.endDate?.toIso8601String(),
      'technologies': instance.technologies,
    };
