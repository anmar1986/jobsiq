import 'package:equatable/equatable.dart';

class CvEntity extends Equatable {
  final int id;
  final int userId;
  final String title;
  final String slug;
  final String fullName;
  final String email;
  final String? phone;
  final String? website;
  final String? linkedin;
  final String? github;
  final String? profileImagePath;
  final String? address;
  final String? city;
  final String? country;
  final String? postalCode;
  final List<WorkExperienceEntity>? workExperience;
  final List<EducationEntity>? education;
  final List<String>? skills;
  final List<LanguageEntity>? languages;
  final List<CertificationEntity>? certifications;
  final List<ProjectEntity>? projects;
  final bool isPublic;
  final bool isPrimary;
  final String? template;
  final DateTime createdAt;
  final DateTime updatedAt;

  const CvEntity({
    required this.id,
    required this.userId,
    required this.title,
    required this.slug,
    required this.fullName,
    required this.email,
    this.phone,
    this.website,
    this.linkedin,
    this.github,
    this.profileImagePath,
    this.address,
    this.city,
    this.country,
    this.postalCode,
    this.workExperience,
    this.education,
    this.skills,
    this.languages,
    this.certifications,
    this.projects,
    required this.isPublic,
    required this.isPrimary,
    this.template,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        userId,
        title,
        slug,
        fullName,
        email,
        phone,
        website,
        linkedin,
        github,
        profileImagePath,
        address,
        city,
        country,
        postalCode,
        workExperience,
        education,
        skills,
        languages,
        certifications,
        projects,
        isPublic,
        isPrimary,
        template,
        createdAt,
        updatedAt,
      ];
}

class WorkExperienceEntity extends Equatable {
  final String jobTitle;
  final String company;
  final String? location;
  final DateTime startDate;
  final DateTime? endDate;
  final bool isCurrent;
  final String? description;

  const WorkExperienceEntity({
    required this.jobTitle,
    required this.company,
    this.location,
    required this.startDate,
    this.endDate,
    required this.isCurrent,
    this.description,
  });

  @override
  List<Object?> get props => [
        jobTitle,
        company,
        location,
        startDate,
        endDate,
        isCurrent,
        description,
      ];
}

class EducationEntity extends Equatable {
  final String degree;
  final String institution;
  final String? location;
  final DateTime startDate;
  final DateTime? endDate;
  final bool isCurrent;
  final String? description;

  const EducationEntity({
    required this.degree,
    required this.institution,
    this.location,
    required this.startDate,
    this.endDate,
    required this.isCurrent,
    this.description,
  });

  @override
  List<Object?> get props => [
        degree,
        institution,
        location,
        startDate,
        endDate,
        isCurrent,
        description,
      ];
}

class LanguageEntity extends Equatable {
  final String language;
  final String proficiency;

  const LanguageEntity({
    required this.language,
    required this.proficiency,
  });

  @override
  List<Object?> get props => [language, proficiency];
}

class CertificationEntity extends Equatable {
  final String name;
  final String? issuingOrganization;
  final DateTime? issueDate;
  final DateTime? expiryDate;
  final String? credentialId;

  const CertificationEntity({
    required this.name,
    this.issuingOrganization,
    this.issueDate,
    this.expiryDate,
    this.credentialId,
  });

  @override
  List<Object?> get props => [
        name,
        issuingOrganization,
        issueDate,
        expiryDate,
        credentialId,
      ];
}

class ProjectEntity extends Equatable {
  final String name;
  final String? description;
  final String? url;
  final DateTime? startDate;
  final DateTime? endDate;
  final List<String>? technologies;

  const ProjectEntity({
    required this.name,
    this.description,
    this.url,
    this.startDate,
    this.endDate,
    this.technologies,
  });

  @override
  List<Object?> get props => [
        name,
        description,
        url,
        startDate,
        endDate,
        technologies,
      ];
}
