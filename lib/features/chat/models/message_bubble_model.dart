import 'package:flutter/material.dart';

class MessageBubbleModel {
  final String title;
  final VoidCallback onTap;
  final Color? color;

  const MessageBubbleModel({
    required this.title,
    required this.onTap,
    this.color,
  });
}
