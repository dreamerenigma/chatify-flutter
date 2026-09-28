import 'package:chatify/utils/constants/app_vectors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../../routes/custom_page_route.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../bot/models/info_app_model.dart';
import '../../../bot/models/support_model.dart';
import '../../../bot/screens/bot_image_viewer_screen.dart';
import '../../../bot/screens/info_app_info_screen.dart';
import '../../../bot/screens/support_chat_screen.dart';
import '../../../bot/screens/support_info_screen.dart';
import '../../../personalization/widgets/dialogs/light_dialog.dart';

class BotInfoDialog extends StatefulWidget {
  final SupportAppModel? support;
  final InfoAppModel? infoApp;
  final bool isInfoApp;
  final String title;

  const BotInfoDialog({
    super.key,
    this.support,
    this.infoApp,
    this.isInfoApp = false,
    required this.title,
  });

  @override
  State<BotInfoDialog> createState() => _BotInfoDialogState();
}

class _BotInfoDialogState extends State<BotInfoDialog> {
  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final name = widget.support != null ? '${widget.support!.name} ${widget.support!.surname}' : widget.infoApp?.name ?? '';

    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      backgroundColor: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      content: SizedBox(
        width: mq.size.width * .6,
        height: mq.size.height * .35,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Stack(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(context, createPageRoute(BotImageViewerScreen(imageAsset: ChatifyVectors.appLogoLight, title: widget.title)));
                    },
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                      child: Container(
                        width: double.infinity,
                        height: double.infinity,
                        decoration: BoxDecoration(color: colorsController.getColor(colorsController.selectedColorScheme.value)),
                        child: Padding(
                          padding: const EdgeInsets.all(50),
                          child: SvgPicture.asset(ChatifyVectors.appLogoDark, width: double.infinity, height: double.infinity),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      decoration: BoxDecoration(
                        color: ChatifyColors.black.withAlpha((0.3 * 255).toInt()),
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                      ),
                      padding: EdgeInsets.symmetric(vertical: mq.size.width * .01, horizontal: mq.size.width * .05),
                      child: Text(
                        name,
                        style: TextStyle(color: ChatifyColors.white, fontSize: ChatifySizes.fontSizeLg, fontWeight: FontWeight.w500),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(width: 35),
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: IconButton(
                        onPressed: () {
                          Navigator.push(context, createPageRoute(SupportChatScreen(support: widget.support)));
                        },
                        icon: widget.isInfoApp
                          ? Icon(
                              Icons.search_rounded,
                              size: 27,
                              color: colorsController.getColor(colorsController.selectedColorScheme.value),
                            )
                          : SvgPicture.asset(
                              ChatifyVectors.messageOutline,
                              width: 30,
                              height: 30,
                              colorFilter: ColorFilter.mode(colorsController.getColor(colorsController.selectedColorScheme.value), BlendMode.srcIn),
                            ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: IconButton(
                        onPressed: () {
                          if (widget.support != null) {
                            Navigator.push(context, createPageRoute(SupportInfoScreen(support: widget.support!)));
                          } else if (widget.infoApp != null) {
                            Navigator.push(context, createPageRoute(InfoAppInfoScreen(infoApp: widget.infoApp!)));
                          }
                        },
                        icon: Icon(Icons.info_outline_rounded, size: 27, color: colorsController.getColor(colorsController.selectedColorScheme.value)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 35),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
