// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      email: json['email'] as String,
      userType: json['user_type'] as String,
      isAdmin: json['is_admin'] as bool,
      profilePhoto: json['profile_photo'] as String?,
      headline: json['headline'] as String?,
      gender: json['gender'] as String?,
      dateOfBirth: json['date_of_birth'] == null
          ? null
          : DateTime.parse(json['date_of_birth'] as String),
      nationality: json['nationality'] as String?,
      city: json['city'] as String?,
      country: json['country'] as String?,
      address: json['address'] as String?,
      phoneNumber: json['phone_number'] as String?,
      linkedinUrl: json['linkedin_url'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'user_type': instance.userType,
      'is_admin': instance.isAdmin,
      'profile_photo': instance.profilePhoto,
      'headline': instance.headline,
      'gender': instance.gender,
      'date_of_birth': instance.dateOfBirth?.toIso8601String(),
      'nationality': instance.nationality,
      'city': instance.city,
      'country': instance.country,
      'address': instance.address,
      'phone_number': instance.phoneNumber,
      'linkedin_url': instance.linkedinUrl,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };
