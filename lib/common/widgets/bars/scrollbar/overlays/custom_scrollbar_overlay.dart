import 'package:flutter/material.dart';
import '../../../../../utils/constants/app_colors.dart';

class CustomScrollbarOverlay extends StatelessWidget {
  final ScrollController scrollController;
  final VoidCallback onScrollUp;
  final VoidCallback onScrollDown;

  const CustomScrollbarOverlay({
    super.key,
    required this.scrollController,
    required this.onScrollUp,
    required this.onScrollDown,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_drop_up_rounded),
          color: ChatifyColors.darkGrey,
          onPressed: onScrollUp,
        ),
        Expanded(
          child: Scrollbar(
            controller: scrollController,
            thumbVisibility: true,
            radius: const Radius.circular(12),
            thickness: 6,
            child: Container(),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.arrow_drop_down_rounded),
          color: ChatifyColors.darkGrey,
          onPressed: onScrollDown,
        ),
      ],
    );
  }
}
