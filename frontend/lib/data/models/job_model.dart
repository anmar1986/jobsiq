import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/job_entity.dart';

part 'job_model.g.dart';

@JsonSerializable(explicitToJson: true, fieldRename: FieldRename.snake)
class JobModel extends JobEntity {
  @JsonKey(fromJson: _companyFromJson, toJson: _companyToJson)
  @override
  // ignore: overridden_fields
  final CompanyBriefModel? company;

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
    @JsonKey(fromJson: _salaryFromJson) super.salaryMin,
    @JsonKey(fromJson: _salaryFromJson) super.salaryMax,
    super.salaryCurrency,
    super.salaryPeriod,
    required super.isRemote,
    required super.isFeatured,
    required super.isActive,
    super.isSaved,
    super.expiresAt,
    super.publishedAt,
    required super.createdAt,
    required super.updatedAt,
    this.company,
  }) : super(company: company);

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
}

@JsonSerializable(fieldRename: FieldRename.snake)
class CompanyBriefModel extends CompanyBriefEntity {
  const CompanyBriefModel({
    required super.id,
    required super.name,
    required super.slug,
    super.logo,
    super.industry,
    super.companySize,
  });

  factory CompanyBriefModel.fromJson(Map<String, dynamic> json) =>
      _$CompanyBriefModelFromJson(json);

  Map<String, dynamic> toJson() => _$CompanyBriefModelToJson(this);
}
