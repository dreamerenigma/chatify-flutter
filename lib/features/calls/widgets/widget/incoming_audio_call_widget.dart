import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../../generated/l10n/l10n.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_images.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../../utils/constants/app_vectors.dart';
import '../../../chat/models/user_model.dart';
import '../../../personalization/widgets/dialogs/light_dialog.dart';
import '../../controllers/call_controller.dart';

class IncomingAudioCallWidget extends StatefulWidget {
  final UserModel user;

  const IncomingAudioCallWidget({super.key, required this.user});

  @override
  State<IncomingAudioCallWidget> createState() => _IncomingAudioCallWidgetState();
}

class _IncomingAudioCallWidgetState extends State<IncomingAudioCallWidget> {
  final callController = Get.find<CallController>();
  
  @override
  Widget build(BuildContext context) {
    final backgroundImage = context.isDarkMode ? ChatifyImages.callBackgroundDark : ChatifyImages.groupBackgroundLight;

    return Obx(() {
      if (callController.isIncomingCall.value) {
        return Scaffold(
          backgroundColor: ChatifyColors.blackGrey,
          body: Padding(
            padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: ChatifyColors.black, width: 1.5),
                      image: DecorationImage(image: AssetImage(backgroundImage), fit: BoxFit.cover),
                    ),
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: context.isDarkMode ? ChatifyColors.softNight : ChatifyColors.grey, width: 1)),
                                child: CircleAvatar(
                                  radius: 43,
                                  backgroundColor: context.isDarkMode ? ChatifyColors.softNight : ChatifyColors.lightGrey,
                                  child: widget.user.image.isNotEmpty
                                    ? ClipOval(
                                        child: CachedNetworkImage(
                                          imageUrl: widget.user.image,
                                          placeholder: (context, url) => CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(colorsController.getColor(colorsController.selectedColorScheme.value))),
                                          errorWidget: (context, url, error) => Icon(Icons.error, size: 30),
                                          fit: BoxFit.cover,
                                          width: double.infinity,
                                          height: double.infinity,
                                        ),
                                      )
                                    : SvgPicture.asset(ChatifyVectors.newUser, color: context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.iconGrey, width: 42, height: 42, fit: BoxFit.cover),
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(widget.user.name, style: TextStyle(fontSize: 30, fontWeight: FontWeight.w300, color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black)),
                              const SizedBox(height: 8),
                              Text(
                                S.of(context).audioCall,
                                style: TextStyle(fontSize: ChatifySizes.fontSizeBg, color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black, fontWeight: FontWeight.w300),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ChatifyColors.green,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(FluentIcons.more_horizontal_16_regular, color: ChatifyColors.white),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ChatifyColors.red,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      ),
                      child: Text(S.of(context).accept, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ChatifyColors.green,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(ChatifyVectors.calls, color: ChatifyColors.white, width: 21, height: 21),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      } else {
        return SizedBox.shrink();
      }
    });
  }
}
