class GifModel {
  final String url;
  final String id;
  final String? previewUrl;

  GifModel({required this.url, required this.id, this.previewUrl});

  factory GifModel.fromJson(Map<String, dynamic> json) {
    final formats = json['media_formats'] ?? {};
    final String? safeUrl = formats['gif']?['url'] ?? formats['mediumgif']?['url'] ?? formats['loopedmp4']?['url'];

    if (safeUrl == null) {
      throw ArgumentError('No usable gif URL found for GifModel');
    }

    return GifModel(
      url: safeUrl,
      id: json['id'],
      previewUrl: formats['tinygif']?['preview'] ?? formats['tinygifpreview']?['url'] ?? formats['gif']?['preview'],
    );
  }
}
