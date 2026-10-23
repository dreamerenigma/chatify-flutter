import 'dart:convert';
import '../../../core/enums/mini_app_aunch_mode_type.dart';
import '../../../core/enums/mini_app_status_type.dart';

class MiniAppsModel {
  final String id;
  final String slug;
  final String name;
  final String description;
  final String? shortDescription;
  final String? iconUrl;
  final String? coverUrl;
  final String? previewUrl;
  final String developerId;
  final String? developerName;
  final String? developerWebsite;
  final String category;
  final List<String> tags;
  final String? appUrl;
  final String? entrypoint;
  final String version;
  final MiniAppLaunchModeType launchMode;
  final MiniAppStatusType status;
  final List<String> permissions;
  final List<String> capabilities;
  final List<String> platforms;
  final bool isFeatured;
  final bool isVerified;
  final bool isPublic;
  final double? rating;
  final int ratingsCount;
  final int launchCount;
  final int sortOrder;
  final Map<String, dynamic> config;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? publishedAt;

  const MiniAppsModel({
    required this.id,
    required this.slug,
    required this.name,
    required this.description,
    required this.developerId,
    required this.category,
    this.shortDescription,
    this.iconUrl,
    this.coverUrl,
    this.previewUrl,
    this.developerName,
    this.developerWebsite,
    this.appUrl,
    this.entrypoint,
    this.version = '1.0.0',
    this.launchMode = MiniAppLaunchModeType.fullscreen,
    this.status = MiniAppStatusType.draft,
    this.tags = const [],
    this.permissions = const [],
    this.capabilities = const [],
    this.platforms = const ['web'],
    this.isFeatured = false,
    this.isVerified = false,
    this.isPublic = true,
    this.rating,
    this.ratingsCount = 0,
    this.launchCount = 0,
    this.sortOrder = 0,
    this.config = const {},
    required this.createdAt,
    required this.updatedAt,
    this.publishedAt,
  });

  factory MiniAppsModel.fromJson(Map<String, dynamic> json) {
    return MiniAppsModel(
      id: json['id'] as String,
      slug: json['slug'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      shortDescription: json['shortDescription'] as String?,
      iconUrl: json['iconUrl'] as String?,
      coverUrl: json['coverUrl'] as String?,
      previewUrl: json['previewUrl'] as String?,
      developerId: json['developerId'] as String,
      developerName: json['developerName'] as String?,
      developerWebsite: json['developerWebsite'] as String?,
      category: json['category'] as String,
      tags: _stringList(json['tags']),
      appUrl: json['appUrl'] as String?,
      entrypoint: json['entrypoint'] as String?,
      version: json['version'] as String? ?? '1.0.0',
      launchMode: _enumByName(MiniAppLaunchModeType.values, json['launchMode'], MiniAppLaunchModeType.fullscreen),
      status: _enumByName(MiniAppStatusType.values, json['status'], MiniAppStatusType.draft),
      permissions: _stringList(json['permissions']),
      capabilities: _stringList(json['capabilities']),
      platforms: _stringList(json['platforms']),
      isFeatured: json['isFeatured'] as bool? ?? false,
      isVerified: json['isVerified'] as bool? ?? false,
      isPublic: json['isPublic'] as bool? ?? true,
      rating: (json['rating'] as num?)?.toDouble(),
      ratingsCount: (json['ratingsCount'] as num?)?.toInt() ?? 0,
      launchCount: (json['launchCount'] as num?)?.toInt() ?? 0,
      sortOrder: (json['sortOrder'] as num?)?.toInt() ?? 0,
      config: _map(json['config']),
      createdAt: _date(json['createdAt']),
      updatedAt: _date(json['updatedAt']),
      publishedAt: _optionalDate(json['publishedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'slug': slug,
      'name': name,
      'description': description,
      'shortDescription': shortDescription,
      'iconUrl': iconUrl,
      'coverUrl': coverUrl,
      'previewUrl': previewUrl,
      'developerId': developerId,
      'developerName': developerName,
      'developerWebsite': developerWebsite,
      'category': category,
      'tags': tags,
      'appUrl': appUrl,
      'entrypoint': entrypoint,
      'version': version,
      'launchMode': launchMode.name,
      'status': status.name,
      'permissions': permissions,
      'capabilities': capabilities,
      'platforms': platforms,
      'isFeatured': isFeatured,
      'isVerified': isVerified,
      'isPublic': isPublic,
      'rating': rating,
      'ratingsCount': ratingsCount,
      'launchCount': launchCount,
      'sortOrder': sortOrder,
      'config': config,
      'createdAt': createdAt.toUtc().toIso8601String(),
      'updatedAt': updatedAt.toUtc().toIso8601String(),
      'publishedAt': publishedAt?.toUtc().toIso8601String(),
    };
  }

  String toJsonString() => jsonEncode(toJson());

  factory MiniAppsModel.fromJsonString(String source) {
    return MiniAppsModel.fromJson(jsonDecode(source) as Map<String, dynamic>);
  }

  MiniAppsModel copyWith({
    String? name,
    String? description,
    String? shortDescription,
    String? iconUrl,
    String? coverUrl,
    String? appUrl,
    MiniAppStatusType? status,
    DateTime? updatedAt,
    DateTime? publishedAt,
  }) {
    return MiniAppsModel(
      id: id,
      slug: slug,
      name: name ?? this.name,
      description: description ?? this.description,
      shortDescription: shortDescription ?? this.shortDescription,
      iconUrl: iconUrl ?? this.iconUrl,
      coverUrl: coverUrl ?? this.coverUrl,
      previewUrl: previewUrl,
      developerId: developerId,
      developerName: developerName,
      developerWebsite: developerWebsite,
      category: category,
      tags: tags,
      appUrl: appUrl ?? this.appUrl,
      entrypoint: entrypoint,
      version: version,
      launchMode: launchMode,
      status: status ?? this.status,
      permissions: permissions,
      capabilities: capabilities,
      platforms: platforms,
      isFeatured: isFeatured,
      isVerified: isVerified,
      isPublic: isPublic,
      rating: rating,
      ratingsCount: ratingsCount,
      launchCount: launchCount,
      sortOrder: sortOrder,
      config: config,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      publishedAt: publishedAt ?? this.publishedAt,
    );
  }

  static List<String> _stringList(dynamic value) {
    if (value is! List) return const [];
    return value.whereType<String>().toList();
  }

  static Map<String, dynamic> _map(dynamic value) {
    if (value is! Map) return const {};
    return Map<String, dynamic>.from(value);
  }

  static DateTime _date(dynamic value) {
    if (value is String) {
      return DateTime.parse(value).toUtc();
    }
    throw FormatException('Invalid or missing date: $value');
  }

  static DateTime? _optionalDate(dynamic value) {
    if (value == null) return null;
    return _date(value);
  }

  static T _enumByName<T extends Enum>(List<T> values, dynamic name, T fallback) {
    return values.firstWhere((item) => item.name == name, orElse: () => fallback);
  }
}
