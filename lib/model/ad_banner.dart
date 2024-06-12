import 'dart:convert';
import 'package:hive/hive.dart';

part 'ad_banner.g.dart';

// ad_banner.dart
@HiveType(typeId: 1)
class AdBanner {
  @HiveField(0)
  final int id;
  @HiveField(1)
  final String image;

  AdBanner({
    required this.id,
    required this.image,
  });

  factory AdBanner.fromJson(Map<String, dynamic> data) {
    // Ensure the 'image' field contains the full URL
    return AdBanner(
      id: data['id'],
      image: data['attributes']['image']['data']['attributes']['url'],
    );
  }
}

List<AdBanner> adBannerListFromJson(String val) => List<AdBanner>.from(
  json.decode(val)['data'].map((banner) => AdBanner.fromJson(banner))
);
