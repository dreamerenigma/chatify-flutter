import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/context_extensions.dart';
import 'package:provider/provider.dart';
import '../../../provider/wallpaper_provider.dart';
import '../../../utils/constants/app_colors.dart';
import '../../../utils/constants/app_images.dart';
import '../../utils/widgets/scrolls/no_glow_scroll_behavior.dart';
import '../models/info_app_model.dart';
import '../widgets/bars/support_app_bar.dart';
import '../widgets/widget/chat_date_bage_widget.dart';

class InfoAppChatScreen extends StatelessWidget {
  final InfoAppModel infoApp;

  const InfoAppChatScreen({
    super.key,
    required this.infoApp,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SupportAppBar(infoApp: infoApp),
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
          SingleChildScrollView(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 53),
                  Material(
                    color: ChatifyColors.transparent,
                    child: InkWell(
                      splashFactory: NoSplash.splashFactory,
                      splashColor: context.isDarkMode ? ChatifyColors.steelGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
                      highlightColor: context.isDarkMode ? ChatifyColors.steelGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
                      hoverColor: context.isDarkMode ? ChatifyColors.lightSoftNight.withAlpha((0.15 * 255).toInt()) : ChatifyColors.steelGrey,
                      onTap: () {},
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 6),
                        decoration: BoxDecoration(
                          color: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.white,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [BoxShadow(color: ChatifyColors.black.withAlpha((0.1 * 255).toInt()), blurRadius: 3, spreadRadius: 1)],
                        ),
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'Это официальный аккаунт Chatify.\n',
                                style: TextStyle(color: ChatifyColors.primary, fontSize: 13, fontWeight: FontWeight.w400, height: 1.3,),
                              ),
                              TextSpan(
                                text: 'Нажмите, чтобы узнать подробнее.',
                                style: TextStyle(color: ChatifyColors.primary, fontSize: 13, fontWeight: FontWeight.w400, height: 1.3),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 2,
            left: 0,
            right: 0,
            child: ChatDateBadgeWidget(date: infoApp.createdAt),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: context.isDarkMode ? ChatifyColors.nightGrey : ChatifyColors.lightGrey,
                border: Border(top: BorderSide(color: context.isDarkMode ? ChatifyColors.darkBackground : ChatifyColors.grey)),
              ),
              child: Center(
                child: Text('Отправлять сообщения может только Chatify', textAlign: TextAlign.center, style: TextStyle(color: ChatifyColors.darkGrey, fontSize: 15, fontWeight: FontWeight.w400)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
