import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/cv_entity.dart';

part 'cv_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class CvModel extends CvEntity {
  @JsonKey(name: 'work_experience')
  @override
  // ignore: overridden_fields
  final List<WorkExperienceModel>? workExperience;

  @override
  // ignore: overridden_fields
  final List<EducationModel>? education;

  @override
  // ignore: overridden_fields
  final List<LanguageModel>? languages;

  @override
  // ignore: overridden_fields
  final List<CertificationModel>? certifications;

  @override
  // ignore: overridden_fields
  final List<ProjectModel>? projects;

  @JsonKey(name: 'profile_image_path')
  @override
  // ignore: overridden_fields
  final String? profileImagePath;

  const CvModel({
    required super.id,
    required super.userId,
    required super.title,
    required super.slug,
    required super.fullName,
    required super.email,
    super.phone,
    super.website,
    super.linkedin,
    super.github,
    this.profileImagePath,
    super.address,
    super.city,
    super.country,
    super.postalCode,
    this.workExperience,
    this.education,
    super.skills,
    this.languages,
    this.certifications,
    this.projects,
    required super.isPublic,
    required super.isPrimary,
    super.template,
    required super.createdAt,
    required super.updatedAt,
  });

  factory CvModel.fromJson(Map<String, dynamic> json) =>
      _$CvModelFromJson(json);

  Map<String, dynamic> toJson() => _$CvModelToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class WorkExperienceModel extends WorkExperienceEntity {
  @JsonKey(name: 'position')
  @override
  // ignore: overridden_fields
  final String jobTitle;

  @override
  // ignore: overridden_fields
  final String company;

  @JsonKey(fromJson: _isCurrentFromJson)
  @override
  // ignore: overridden_fields
  final bool isCurrent;

  const WorkExperienceModel({
    required this.jobTitle,
    required this.company,
    super.location,
    required super.startDate,
    super.endDate,
    required this.isCurrent,
    super.description,
  }) : super(
          jobTitle: jobTitle,
          company: company,
          isCurrent: isCurrent,
        );

  factory WorkExperienceModel.fromJson(Map<String, dynamic> json) =>
      _$WorkExperienceModelFromJson(json);

  Map<String, dynamic> toJson() => _$WorkExperienceModelToJson(this);

  static bool _isCurrentFromJson(dynamic value) {
    if (value == null) return false;
    if (value is bool) return value;
    if (value is int) return value == 1;
    if (value is String) return value.toLowerCase() == 'true' || value == '1';
    return false;
  }
}

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class EducationModel extends EducationEntity {
  @JsonKey(fromJson: _isCurrentFromJson)
  @override
  // ignore: overridden_fields
  final bool isCurrent;

  const EducationModel({
    required super.degree,
    required super.institution,
    super.location,
    required super.startDate,
    super.endDate,
    required this.isCurrent,
    super.description,
  }) : super(
          isCurrent: isCurrent,
        );

  factory EducationModel.fromJson(Map<String, dynamic> json) =>
      _$EducationModelFromJson(json);

  Map<String, dynamic> toJson() => _$EducationModelToJson(this);

  static bool _isCurrentFromJson(dynamic value) {
    if (value == null) return false;
    if (value is bool) return value;
    if (value is int) return value == 1;
    if (value is String) return value.toLowerCase() == 'true' || value == '1';
    return false;
  }
}

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class LanguageModel extends LanguageEntity {
  const LanguageModel({
    String? language,
    String? proficiency,
  }) : super(
          language: language ?? '',
          proficiency: proficiency ?? 'Intermediate',
        );

  factory LanguageModel.fromJson(Map<String, dynamic> json) =>
      _$LanguageModelFromJson(json);

  Map<String, dynamic> toJson() => _$LanguageModelToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class CertificationModel extends CertificationEntity {
  const CertificationModel({
    required super.name,
    super.issuingOrganization,
    super.issueDate,
    super.expiryDate,
    super.credentialId,
  });

  factory CertificationModel.fromJson(Map<String, dynamic> json) =>
      _$CertificationModelFromJson(json);

  Map<String, dynamic> toJson() => _$CertificationModelToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class ProjectModel extends ProjectEntity {
  const ProjectModel({
    required super.name,
    super.description,
    super.url,
    super.startDate,
    super.endDate,
    super.technologies,
  });

  factory ProjectModel.fromJson(Map<String, dynamic> json) =>
      _$ProjectModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProjectModelToJson(this);
}
