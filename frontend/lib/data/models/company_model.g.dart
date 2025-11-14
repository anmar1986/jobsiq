// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'company_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CompanyModel _$CompanyModelFromJson(Map<String, dynamic> json) => CompanyModel(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      slug: json['slug'] as String,
      logo: json['logo'] as String?,
      cover: json['cover'] as String?,
      description: json['description'] as String?,
      website: json['website'] as String?,
      industry: json['industry'] as String?,
      size: json['size'] as String?,
      foundedYear: json['founded_year'] as String?,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      city: json['city'] as String?,
      country: json['country'] as String?,
      address: json['address'] as String?,
      jobsCount: (json['jobs_count'] as num).toInt(),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$CompanyModelToJson(CompanyModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'slug': instance.slug,
      'logo': instance.logo,
      'cover': instance.cover,
      'description': instance.description,
      'website': instance.website,
      'industry': instance.industry,
      'size': instance.size,
      'founded_year': instance.foundedYear,
      'email': instance.email,
      'phone': instance.phone,
      'city': instance.city,
      'country': instance.country,
      'address': instance.address,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
      'jobs_count': instance.jobsCount,
    };
