import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../personalization/widgets/dialogs/light_dialog.dart';

class NewCommunityCard extends StatelessWidget {
  final VoidCallback? onTap;

  const NewCommunityCard({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {

    return Material(
      color: context.isDarkMode ? ChatifyColors.black : ChatifyColors.white,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(color: ChatifyColors.darkerGrey, borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.groups, size: 30, color: ChatifyColors.white),
                    ),
                    Positioned(
                      bottom: -5,
                      right: -5,
                      child: Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: colorsController.getColor(colorsController.selectedColorScheme.value),
                          border: Border.all(
                            color: context.isDarkMode ? ChatifyColors.black : ChatifyColors.white,
                            width: 2.0,
                          ),
                        ),
                        child: const Center(
                          child: Icon(Icons.add, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Text(
                'Новое сообщество',
                style: TextStyle(
                  fontSize: ChatifySizes.fontSizeMd,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
