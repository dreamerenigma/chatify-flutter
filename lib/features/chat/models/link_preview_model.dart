class LinkPreviewModel {
  final String url;
  final String title;
  final String? description;
  final String? imageUrl;
  final String? faviconUrl;

  const LinkPreviewModel({
    required this.url,
    required this.title,
    this.description,
    this.imageUrl,
    this.faviconUrl,
  });
}
