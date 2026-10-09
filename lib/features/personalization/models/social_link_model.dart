class SocialLinkModel {
  final String type;
  final String username;
  final String url;

  SocialLinkModel({
    required this.type,
    required this.username,
    required this.url,
  });

  Map<String, dynamic> toJson() => {
    'type': type,
    'username': username,
    'url': url,
  };

  factory SocialLinkModel.fromJson(Map<String, dynamic> json) {
    return SocialLinkModel(
      type: json['type'] ?? '',
      username: json['username'] ?? '',
      url: json['url'] ?? '',
    );
  }
}
