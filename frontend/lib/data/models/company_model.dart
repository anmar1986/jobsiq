import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/company_entity.dart';

part 'company_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class CompanyModel extends CompanyEntity {
  @JsonKey(name: 'jobs_count')
  @override
  // ignore: overridden_fields
  final int jobsCount;

  const CompanyModel({
    required super.id,
    required super.name,
    required super.slug,
    super.logo,
    super.cover,
    super.description,
    super.website,
    super.industry,
    super.size,
    super.foundedYear,
    super.email,
    super.phone,
    super.city,
    super.country,
    super.address,
    required this.jobsCount,
    required super.createdAt,
    required super.updatedAt,
  }) : super(jobsCount: jobsCount);

  factory CompanyModel.fromJson(Map<String, dynamic> json) =>
      _$CompanyModelFromJson(json);

  Map<String, dynamic> toJson() => _$CompanyModelToJson(this);
}
