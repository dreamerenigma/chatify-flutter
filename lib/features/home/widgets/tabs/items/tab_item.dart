class TabItem {
  final String title;
  final bool canDelete;

  const TabItem({
    required this.title,
    this.canDelete = true,
  });
}
