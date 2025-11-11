import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/user_entity.dart';

part 'user_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.name,
    required super.email,
    required super.userType,
    required super.isAdmin,
    super.profilePhoto,
    super.headline,
    super.gender,
    super.dateOfBirth,
    super.nationality,
    super.city,
    super.country,
    super.address,
    super.phoneNumber,
    super.linkedinUrl,
    required super.createdAt,
    required super.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(
      id: entity.id,
      name: entity.name,
      email: entity.email,
      userType: entity.userType,
      isAdmin: entity.isAdmin,
      profilePhoto: entity.profilePhoto,
      headline: entity.headline,
      gender: entity.gender,
      dateOfBirth: entity.dateOfBirth,
      nationality: entity.nationality,
      city: entity.city,
      country: entity.country,
      address: entity.address,
      phoneNumber: entity.phoneNumber,
      linkedinUrl: entity.linkedinUrl,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }
}
