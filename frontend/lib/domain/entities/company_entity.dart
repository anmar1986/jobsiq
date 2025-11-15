import 'package:equatable/equatable.dart';
import '../../core/config/app_config.dart';

class CompanyEntity extends Equatable {
  final int id;
  final String name;
  final String slug;
  final String? logo;
  final String? cover;
  final String? description;
  final String? website;
  final String? industry;
  final String? size;
  final String? foundedYear;
  final String? email;
  final String? phone;
  final String? city;
  final String? country;
  final String? address;
  final int jobsCount;
  final DateTime createdAt;
  final DateTime updatedAt;

  const CompanyEntity({
    required this.id,
    required this.name,
    required this.slug,
    this.logo,
    this.cover,
    this.description,
    this.website,
    this.industry,
    this.size,
    this.foundedYear,
    this.email,
    this.phone,
    this.city,
    this.country,
    this.address,
    required this.jobsCount,
    required this.createdAt,
    required this.updatedAt,
  });

  String get location {
    final parts = <String>[];
    if (city != null && city!.isNotEmpty) parts.add(city!);
    if (country != null && country!.isNotEmpty) parts.add(country!);
    return parts.join(', ');
  }

  String get logoUrl {
    if (logo == null || logo!.isEmpty) return '';
    return AppConfig.getStorageUrl(logo!);
  }

  String get coverUrl {
    if (cover == null || cover!.isEmpty) return '';
    return AppConfig.getStorageUrl(cover!);
  }

  @override
  List<Object?> get props => [
        id,
        name,
        slug,
        logo,
        cover,
        description,
        website,
        industry,
        size,
        foundedYear,
        email,
        phone,
        city,
        country,
        address,
        jobsCount,
        createdAt,
        updatedAt,
      ];
}
