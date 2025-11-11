import 'package:json_annotation/json_annotation.dart';
import 'user_model.dart';

part 'auth_response_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class AuthResponseModel {
  final bool success;
  final String message;
  final AuthDataModel data;

  AuthResponseModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) =>
      _$AuthResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$AuthResponseModelToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class AuthDataModel {
  final UserModel user;
  final String token;
  final String? redirectTo;

  AuthDataModel({
    required this.user,
    required this.token,
    this.redirectTo,
  });

  factory AuthDataModel.fromJson(Map<String, dynamic> json) =>
      _$AuthDataModelFromJson(json);

  Map<String, dynamic> toJson() => _$AuthDataModelToJson(this);
}
