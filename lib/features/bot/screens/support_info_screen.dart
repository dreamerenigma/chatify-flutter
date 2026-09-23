import 'package:chatify/features/bot/widgets/bars/support_app_bar.dart';
import 'package:chatify/features/utils/widgets/scrolls/no_glow_scroll_behavior.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/context_extensions.dart';
import 'package:provider/provider.dart';
import '../../../provider/wallpaper_provider.dart';
import '../../../utils/constants/app_images.dart';
import '../models/info_app_model.dart';
import '../models/support_model.dart';

class SupportInfoScreen extends StatelessWidget {
  final SupportAppModel? support;
  final InfoAppModel? infoApp;

  const SupportInfoScreen({
    super.key,
    this.support,
    this.infoApp,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SupportAppBar(support: support, infoApp: infoApp),
      body: _buildBodySection(context),
    );
  }

  Widget _buildBodySection(BuildContext context) {
    return ScrollConfiguration(
      behavior: NoGlowScrollBehavior(),
      child: Stack(
        children: [
          Consumer<WallpaperProvider>(
            builder: (context, wallpaperProvider, child) {
              final backgroundImage = wallpaperProvider.backgroundImage.isNotEmpty ? wallpaperProvider.backgroundImage : (context.isDarkMode ? ChatifyImages.wallpaperDarkV3 : ChatifyImages.chatBackgroundLight);

              return Container(decoration: BoxDecoration(image: DecorationImage(image: AssetImage(backgroundImage), fit: BoxFit.cover)));
            },
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(width: double.infinity, padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14)),
          ),
        ],
      ),
    );
  }
}
