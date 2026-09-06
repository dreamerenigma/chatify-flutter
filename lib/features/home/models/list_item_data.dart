class ListItemData {
  final String title;
  final String? subtitle;
  final bool canDelete;

  const ListItemData({
    required this.title,
    this.subtitle,
    required this.canDelete,
  });
}
