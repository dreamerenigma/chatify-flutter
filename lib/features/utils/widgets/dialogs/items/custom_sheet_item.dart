import 'package:flutter/material.dart';
import '../../../../../core/enums/custom_sheet_item_type.dart';

class CustomBottomSheetItem {
  final String title;
  final String? subtitle;
  final IconData? icon;
  final CustomSheetItemType type;
  final String value;
  final bool enabled;
  final int? excludedUsersCount;

  const CustomBottomSheetItem({
    required this.title,
    required this.value,
    this.subtitle,
    this.icon,
    this.type = CustomSheetItemType.plain,
    this.enabled = true,
    this.excludedUsersCount,
  });
}
