import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/job_entity.dart';

part 'job_model.g.dart';

@JsonSerializable(explicitToJson: true, fieldRename: FieldRename.snake)
class JobModel extends JobEntity {
  @JsonKey(fromJson: _companyFromJson, toJson: _companyToJson)
  @override
  // ignore: overridden_fields
  final CompanyBriefModel? company;

  @JsonKey(fromJson: _salaryFromJson)
  @override
  // ignore: overridden_fields
  final double? salaryMin;

  @JsonKey(fromJson: _salaryFromJson)
  @override
  // ignore: overridden_fields
  final double? salaryMax;

  @JsonKey(fromJson: _boolFromJson)
  @override
  // ignore: overridden_fields
  final bool isActive;

  @JsonKey(fromJson: _boolFromJson)
  @override
  // ignore: overridden_fields
  final bool? isApplied;

  const JobModel({
    required super.id,
    super.companyId,
    super.userId,
    required super.title,
    required super.slug,
    required super.description,
    super.requirements,
    super.benefits,
    super.location,
    super.city,
    super.country,
    required super.employmentType,
    super.experienceLevel,
    super.category,
    super.skills,
    this.salaryMin,
    this.salaryMax,
    super.salaryCurrency,
    super.salaryPeriod,
    required super.isRemote,
    required super.isFeatured,
    this.isActive = true, // Default to true since backend filters by active
    super.isSaved,
    this.isApplied,
    super.status,
    super.jobType,
    super.salary,
    super.applicantsCount,
    super.expiresAt,
    super.publishedAt,
    required super.createdAt,
    required super.updatedAt,
    this.company,
  }) : super(
          company: company,
          salaryMin: salaryMin,
          salaryMax: salaryMax,
          isActive: isActive,
          isApplied: isApplied,
        );

  factory JobModel.fromJson(Map<String, dynamic> json) =>
      _$JobModelFromJson(json);

  Map<String, dynamic> toJson() => _$JobModelToJson(this);

  static CompanyBriefModel? _companyFromJson(Map<String, dynamic>? json) =>
      json == null ? null : CompanyBriefModel.fromJson(json);

  static Map<String, dynamic>? _companyToJson(CompanyBriefModel? company) =>
      company?.toJson();

  static double? _salaryFromJson(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) {
      final parsed = double.tryParse(value);
      return parsed;
    }
    return null;
  }

  static bool _boolFromJson(dynamic value) {
    if (value == null) return true; // Default to true for missing is_active
    if (value is bool) return value;
    if (value is int) return value == 1;
    if (value is String) return value.toLowerCase() == 'true' || value == '1';
    return true;
  }
}

@JsonSerializable(fieldRename: FieldRename.snake)
class CompanyBriefModel extends CompanyBriefEntity {
  @JsonKey(fromJson: _logoFromJson)
  @override
  // ignore: overridden_fields
  final String? logo;

  const CompanyBriefModel({
    required super.id,
    required super.name,
    required super.slug,
    this.logo,
    super.industry,
    super.companySize,
  }) : super(logo: logo);

  factory CompanyBriefModel.fromJson(Map<String, dynamic> json) =>
      _$CompanyBriefModelFromJson(json);

  Map<String, dynamic> toJson() => _$CompanyBriefModelToJson(this);

  static String? _logoFromJson(dynamic value) {
    if (value == null) return null;
    if (value is String) return value;
    if (value is Map<String, dynamic>) {
      // Try to extract URL from the logo object
      return value['url'] as String? ??
          value['path'] as String? ??
          value['logo_path'] as String?;
    }
    return null;
  }
}
