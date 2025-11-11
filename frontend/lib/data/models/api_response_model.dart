import 'package:json_annotation/json_annotation.dart';

part 'api_response_model.g.dart';

@JsonSerializable(genericArgumentFactories: true)
class ApiResponse<T> {
  final bool success;
  final String? message;
  final T? data;
  final Map<String, List<String>>? errors;

  ApiResponse({
    required this.success,
    this.message,
    this.data,
    this.errors,
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) =>
      _$ApiResponseFromJson(json, fromJsonT);

  Map<String, dynamic> toJson(Object Function(T value) toJsonT) =>
      _$ApiResponseToJson(this, toJsonT);
}

@JsonSerializable(genericArgumentFactories: true)
class PaginatedResponse<T> {
  final bool success;
  final PaginatedData<T> data;

  PaginatedResponse({
    required this.success,
    required this.data,
  });

  factory PaginatedResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) =>
      _$PaginatedResponseFromJson(json, fromJsonT);

  Map<String, dynamic> toJson(Object Function(T value) toJsonT) =>
      _$PaginatedResponseToJson(this, toJsonT);
}

@JsonSerializable(genericArgumentFactories: true)
class PaginatedData<T> {
  final List<T> data;
  final PaginationMeta meta;

  PaginatedData({
    required this.data,
    required this.meta,
  });

  factory PaginatedData.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) =>
      _$PaginatedDataFromJson(json, (obj) => fromJsonT(obj)!);

  Map<String, dynamic> toJson(Object? Function(T value) toJsonT) =>
      _$PaginatedDataToJson(this, toJsonT);
}

@JsonSerializable()
class PaginationMeta {
  @JsonKey(name: 'current_page')
  final int currentPage;
  final int total;
  @JsonKey(name: 'per_page')
  final int perPage;
  @JsonKey(name: 'last_page')
  final int lastPage;

  PaginationMeta({
    required this.currentPage,
    required this.total,
    required this.perPage,
    required this.lastPage,
  });

  factory PaginationMeta.fromJson(Map<String, dynamic> json) =>
      _$PaginationMetaFromJson(json);

  Map<String, dynamic> toJson() => _$PaginationMetaToJson(this);
}
