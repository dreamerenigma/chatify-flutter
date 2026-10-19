import 'package:chatify/features/utils/widgets/scrolls/no_glow_scroll_behavior.dart';
import 'package:flutter/material.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';

class SolidColorsScreen extends StatelessWidget {
  const SolidColorsScreen({super.key});

  static const int _colorCount = 20;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        elevation: 0,
        title: Text('Сплошные цвета', style: TextStyle(fontSize: ChatifySizes.fontSizeMg, fontWeight: FontWeight.w400)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, size: 25),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: ScrollConfiguration(
        behavior: NoGlowScrollBehavior(),
        child: GridView.builder(
          padding: const EdgeInsets.all(8),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, mainAxisSpacing: 18, crossAxisSpacing: 18, mainAxisExtent: 240),
          itemCount: _colorCount,
          itemBuilder: (context, index) {
            final imagePath = 'assets/images/solid_colors/solid_color_${index + 1}.png';

            return GestureDetector(
              onTap: () {},
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: ChatifyColors.darkerGrey.withValues(alpha: 0.15),
                      alignment: Alignment.center,
                      child: Icon(Icons.broken_image_outlined, size: 30, color: ChatifyColors.darkGrey),
                    );
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
