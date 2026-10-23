import 'package:chatify/features/utils/widgets/scrolls/no_glow_scroll_behavior.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/context_extensions.dart';
import 'package:provider/provider.dart';
import '../../../core/enums/custom_scale_button_type.dart';
import '../../../provider/wallpaper_provider.dart';
import '../../../utils/constants/app_colors.dart';
import '../../../utils/constants/app_images.dart';
import '../../../utils/constants/app_sizes.dart';
import '../../chat/models/user_model.dart';
import '../../utils/widgets/buttons/custom_scale_button.dart';
import '../models/bot_model.dart';
import '../widgets/bars/bot_app_bar.dart';

class BotScreen extends StatefulWidget {
  final BotModel bot;
  final UserModel user;

  const BotScreen({
    super.key,
    required this.bot,
    required this.user,
  });

  @override
  State<BotScreen> createState() => _BotScreenState();
}

class _BotScreenState extends State<BotScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BotAppBar(bot: widget.bot, user: widget.user),
      body: ScrollConfiguration(
        behavior: NoGlowScrollBehavior(),
        child: Stack(
          children: [
            Consumer<WallpaperProvider>(
              builder: (context, wallpaperProvider, child) {
                final backgroundImage = wallpaperProvider.getBackgroundImage(widget.bot.id, defaultImage: context.isDarkMode ? ChatifyImages.wallpaperDarkV3 : ChatifyImages.chatBackgroundLight);

                return Positioned.fill(child: Container(decoration: BoxDecoration(image: DecorationImage(image: AssetImage(backgroundImage), fit: BoxFit.cover))));
              },
            ),
            Positioned(
              left: 16,
              right: 16,
              bottom: 16,
              child: SafeArea(
                top: false,
                child: CustomScaleButton(
                  onPressed: () async {
                    Navigator.pop(context);
                  },
                  type: CustomScaleButtonType.filled,
                  label: Text('Начать чат', style: TextStyle(color: ChatifyColors.black, fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
