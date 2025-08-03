import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../generated/l10n/l10n.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../personalization/widgets/dialogs/light_dialog.dart';

class NewCommunityCard extends StatelessWidget {
  final VoidCallback? onTap;

  const NewCommunityCard({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {

    return Material(
      color: ChatifyColors.transparent,
      child: InkWell(
        onTap: onTap,
        splashColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey,
        highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(color: context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.grey, borderRadius: BorderRadius.circular(12)),
                      child: const Icon(Icons.groups, size: 36, color: ChatifyColors.white),
                    ),
                    Positioned(
                      bottom: -3,
                      right: -5,
                      child: Container(
                        width: 25,
                        height: 25,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: colorsController.getColor(colorsController.selectedColorScheme.value),
                          border: Border.all(color: context.isDarkMode ? ChatifyColors.black : ChatifyColors.white, width: 1.5),
                        ),
                        child: const Center(child: Icon(Icons.add, color: ChatifyColors.black, size: 17)),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Text(S.of(context).newCommunity, style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }
}
