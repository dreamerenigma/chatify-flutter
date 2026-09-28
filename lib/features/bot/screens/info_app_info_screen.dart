import 'package:chatify/features/utils/widgets/dividers/custom_divider.dart';
import 'package:chatify/utils/constants/app_sizes.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_utils/src/extensions/context_extensions.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../common/widgets/switches/custom_switch.dart';
import '../../../generated/l10n/l10n.dart';
import '../../../routes/custom_page_route.dart';
import '../../../utils/constants/app_colors.dart';
import '../../../utils/constants/app_vectors.dart';
import '../../personalization/widgets/dialogs/add_list_bottom_sheet_dialog.dart';
import '../../personalization/widgets/dialogs/light_dialog.dart';
import '../../personalization/widgets/items/profile_settings_item.dart';
import '../../status/widgets/options/action_option.dart';
import '../../utils/widgets/scrolls/no_glow_scroll_behavior.dart';
import '../models/info_app_model.dart';
import '../widgets/dialogs/support_chat_bottom_sheet_dialog.dart';
import '../widgets/widget/expandable_description_widget.dart';
import 'bot_image_viewer_screen.dart';

class InfoAppInfoScreen extends StatefulWidget {
  final InfoAppModel infoApp;

  const InfoAppInfoScreen({
    super.key,
    required this.infoApp,
  });

  @override
  State<InfoAppInfoScreen> createState() => _InfoAppInfoScreenState();
}

class _InfoAppInfoScreenState extends State<InfoAppInfoScreen> {
  final ValueNotifier<double> _scrollOffset = ValueNotifier(0);
  final ScrollController _scrollController = ScrollController();
  bool isCloseChatEnabled = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      setState(() {
        _scrollOffset.value = _scrollController.offset;
      });
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _scrollOffset.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(width: MediaQuery.of(context).size.width, height: MediaQuery.of(context).size.height * .03 + 56),
                Expanded(
                  child: ScrollConfiguration(
                    behavior: NoGlowScrollBehavior(),
                    child: ScrollbarTheme(
                      data: ScrollbarThemeData(thumbColor: WidgetStateProperty.all(ChatifyColors.darkerGrey)),
                      child: Scrollbar(
                        thickness: 4,
                        thumbVisibility: false,
                        child: SingleChildScrollView(
                          controller: _scrollController,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildInfoDetails(context),
                              _buildInfo(),
                              SizedBox(height: 10),
                              _buildModerationUser(),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            _buildAnimatedHeader(),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoDetails(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 10),
        GestureDetector(
          onTap: () {
            Navigator.push(context, createPageRoute(BotImageViewerScreen(imageAsset: ChatifyVectors.appLogoLight, title: 'Chatify')));
          },
          child: Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(color: colorsController.getColor(colorsController.selectedColorScheme.value), shape: BoxShape.circle),
            alignment: Alignment.center,
            child: SvgPicture.asset(ChatifyVectors.appLogoDark, width: 70, height: 70),
          ),
        ),
        const SizedBox(height: 14),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.infoApp.name,
              textAlign: TextAlign.center,
              style: TextStyle(color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black, fontSize: 23, fontWeight: FontWeight.w400),
            ),
            const SizedBox(width: 5),
            SvgPicture.asset(ChatifyVectors.starburstCheck, width: 18, height: 18, colorFilter: ColorFilter.mode(ChatifyColors.blue, BlendMode.srcIn)),
          ],
        ),
        const SizedBox(height: 2),
        Text(
          widget.infoApp.description,
          textAlign: TextAlign.center,
          style: TextStyle(color: ChatifyColors.darkGrey, fontSize: ChatifySizes.fontSizeLg, fontWeight: FontWeight.w400, height: 1.4),
        ),
        const SizedBox(height: 15),
        ActionOption(
          icon: Icons.search,
          label: S.of(context).search,
          onTap: () {},
        ),
        const SizedBox(height: 5),
        CustomDivider(indent: 0, endIndent: 0, left: 0, right: 0, top: 20, bottom: 10),
      ],
    );
  }

  Widget _buildAnimatedHeader() {
    return ValueListenableBuilder<double>(
      valueListenable: _scrollOffset,
      builder: (context, scrollOffset, child) {
        final double progress = ((scrollOffset - 80) / 70).clamp(0.0, 1.0);
        final double borderOpacity = ((progress - 0.9) / 0.1).clamp(0.0, 1.0);

        return Positioned(
          top: 25,
          left: 0,
          right: 0,
          child: SizedBox(
            height: 54,
            child: Stack(
              children: [
                Positioned.fill(
                  child: Opacity(
                    opacity: progress,
                    child: Container(
                      decoration: BoxDecoration(color: context.isDarkMode ? ChatifyColors.darkBackground : ChatifyColors.lightGrey),
                      child: Row(
                        children: [
                          const SizedBox(width: 60),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(context, createPageRoute(BotImageViewerScreen(imageAsset: ChatifyVectors.appLogoLight, title: 'Chatify')));
                            },
                            child: Container(
                              width: 42,
                              height: 42,
                              decoration: BoxDecoration(color: colorsController.getColor(colorsController.selectedColorScheme.value), shape: BoxShape.circle),
                              alignment: Alignment.center,
                              child: SvgPicture.asset(ChatifyVectors.appLogoDark, width: 25, height: 25),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Row(
                              children: [
                                Flexible(
                                  child: Text(
                                    widget.infoApp.name,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black, fontSize: ChatifySizes.fontSizeXl, fontWeight: FontWeight.w400),
                                  ),
                                ),
                                const SizedBox(width: 5),
                                SvgPicture.asset(ChatifyVectors.starburstCheck, width: 14, height: 14, colorFilter: const ColorFilter.mode(ChatifyColors.blue, BlendMode.srcIn)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 4,
                  top: 6,
                  child: IconButton(icon: Icon(Icons.arrow_back_rounded, size: 25, color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black), onPressed: () => Navigator.pop(context)),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: IgnorePointer(
                    child: Opacity(opacity: borderOpacity, child: Container(height: 1, color: context.isDarkMode ? ChatifyColors.youngNight : ChatifyColors.buttonDisabled)),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDescriptionItem(),
        SizedBox(height: 6),
        ProfileSettingsItem(
          icon: SvgPicture.asset(ChatifyVectors.earth, width: 23, height: 23, colorFilter: ColorFilter.mode(ChatifyColors.darkGrey, BlendMode.srcIn)),
          title: 'https://chatify.ru',
          isLink: true,
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          onTap: () async {
            final uri = Uri.parse('https://chatify.ru');

            if (await canLaunchUrl(uri)) {
              await launchUrl(uri, mode: LaunchMode.externalApplication);
            }
          },
        ),
        SizedBox(height: 15),
        ProfileSettingsItem(
          icon: const Icon(Icons.notifications_none, size: 27, color: ChatifyColors.darkGrey),
          title: S.of(context).notifications,
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          onTap: () {},
        ),
        SizedBox(height: 20),
        ProfileSettingsItem(
          icon: SvgPicture.asset(ChatifyVectors.messageLock, width: 25, height: 25, colorFilter: ColorFilter.mode(ChatifyColors.darkGrey, BlendMode.srcIn)),
          title: S.of(context).closingChat,
          subtitle: S.of(context).closeHideChatDevice,
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          trailing: CustomSwitch(
            value: isCloseChatEnabled,
            onChanged: (value) {
              setState(() {
                isCloseChatEnabled = value;
              });
            },
            switchWidth: 55,
            switchHeight: 33,
            thumbSize: 25,
            thumbPadding: 3,
          ),
          onTap: () {
            setState(() {
              isCloseChatEnabled = !isCloseChatEnabled;
            });
          },
        ),
        SizedBox(height: 20),
        ProfileSettingsItem(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          icon: const Icon(Icons.info_outline_rounded, size: 27, color: ChatifyColors.darkGrey),
          title: 'Безопасность',
          subtitleWidget: Text.rich(
            TextSpan(
              children: [
                TextSpan(text: 'Это официальный аккаунт Chatify. ', style: TextStyle(color: ChatifyColors.darkGrey, fontSize: 15, fontWeight: FontWeight.w400)),
                TextSpan(
                  text: 'Подробнее',
                  style: TextStyle(color: ChatifyColors.blue, decoration: TextDecoration.none, fontSize: 15, fontWeight: FontWeight.w400),
                  recognizer: TapGestureRecognizer()..onTap = () {
                    showSupportChatBottomSheetDialog(context);
                  },
                ),
              ],
              style: TextStyle(color: context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.grey, fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w400, height: 1.3),
            ),
          ),
          onTap: () {
            showSupportChatBottomSheetDialog(context);
          },
        ),
        SizedBox(height: 20),
        ProfileSettingsItem(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          icon: SvgPicture.asset(ChatifyVectors.addToList, width: 25, height: 25, colorFilter: ColorFilter.mode(ChatifyColors.darkGrey, BlendMode.srcIn)),
          title: 'Добавить в список',
          onTap: () {
            showAddListBottomSheetDialog(context);
          },
        ),
      ],
    );
  }

  Widget _buildDescriptionItem() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 25,
            child: Center(child: SvgPicture.asset(ChatifyVectors.shop, width: 22, height: 22, colorFilter: ColorFilter.mode(ChatifyColors.darkGrey, BlendMode.srcIn))),
          ),
          const SizedBox(width: 25),
          Expanded(
            child: ExpandableDescriptionWidget(
              text: 'Это официальный чат службы поддержки Chatify. Более двух миллиардов человек в более чем 180 странах используют Chatify, чтобы всегда оставаться на связи с друзьями и близкими. Chatify - это бесплатное приложение, обеспечивающее простой, безопасный и надежный обмен сообщениями и звонками, доступное на мобильных устройствах по всеми миру.',
              maxLines: 7,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModerationUser() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ProfileSettingsItem(
          icon: const Icon(Icons.not_interested, size: 25),
          title: '${S.of(context).block} ${widget.infoApp.name}',
          titleColor: ChatifyColors.danger,
          iconColor: ChatifyColors.danger,
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          onTap: () {},
        ),
      ],
    );
  }
}
