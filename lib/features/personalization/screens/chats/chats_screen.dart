import 'package:chatify/features/personalization/controllers/fonts_controller.dart';
import 'package:chatify/features/personalization/screens/chats/transferring_chats_screen.dart';
import 'package:chatify/features/personalization/screens/chats/wallpaper_screen.dart';
import 'package:chatify/routes/custom_page_route.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../../../generated/l10n/l10n.dart';
import '../../../../common/widgets/switches/custom_switch.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../../utils/constants/app_vectors.dart';
import '../../../utils/widgets/scrolls/no_glow_scroll_behavior.dart';
import '../../controllers/seasons_controller.dart';
import '../../controllers/settings_controller.dart';
import '../../controllers/themes_controller.dart';
import '../../widgets/dialogs/color_scheme_selection_dialog.dart';
import '../../widgets/dialogs/light_dialog.dart';
import 'chat_backup_screen.dart';
import 'chats_history_screen.dart';

class ChatsScreen extends StatefulWidget {
  const ChatsScreen({super.key});

  @override
  ChatSettingsScreenState createState() => ChatSettingsScreenState();
}

class ChatSettingsScreenState extends State<ChatsScreen> {
  bool sendWithEnter = false;
  bool isVisibilityMedia = false;
  bool isTranscriptVoiceMsg = false;
  bool isArchiveChats = false;

  @override
  Widget build(BuildContext context) {
    final themesController = Get.put(ThemesController());
    final seasonsController = Get.put(SeasonsController());
    final fontsController = Get.put(FontsController());
    final SettingsController settingsController = Get.put(SettingsController());

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration: BoxDecoration(
            color: ChatifyColors.white,
            boxShadow: [BoxShadow(color: ChatifyColors.black.withAlpha((0.1 * 255).toInt()), spreadRadius: 1, blurRadius: 3, offset: const Offset(0, 1))],
          ),
          child: AppBar(
            automaticallyImplyLeading: false,
            title: Text(S.of(context).chats, style: TextStyle(fontSize: ChatifySizes.fontSizeMg, fontWeight: FontWeight.w400, color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black)),
            titleSpacing: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_rounded, size: 25),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ),
      ),
      body: ScrollConfiguration(
        behavior: NoGlowScrollBehavior(),
        child: ScrollbarTheme(
          data: ScrollbarThemeData(thumbColor: WidgetStateProperty.all(ChatifyColors.darkerGrey)),
          child: Scrollbar(
            thickness: 4,
            thumbVisibility: false,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20, top: 16, bottom: 8),
                    child: Text(S.of(context).screen, style: TextStyle(color: ChatifyColors.darkGrey, fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w400)),
                  ),
                  InkWell(
                    splashFactory: NoSplash.splashFactory,
                    splashColor: context.isDarkMode ? ChatifyColors.darkGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.darkerGrey.withAlpha((0.4 * 255).toInt()),
                    highlightColor: context.isDarkMode ? ChatifyColors.darkGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey.withAlpha((0.4 * 255).toInt()),
                    hoverColor: context.isDarkMode ? ChatifyColors.darkGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey.withAlpha((0.4 * 255).toInt()),
                    onTap: () {
                      themesController.showThemeSelectionDialog(context);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                      child: Row(
                        children: [
                          Obx(() {
                            return Icon(Icons.brightness_6, color: colorsController.getColor(colorsController.selectedColorScheme.value));
                          }),
                          const SizedBox(width: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(S.of(context).themes, style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.bold)),
                              Obx(() {
                                return Text(themesController.getThemeDescription(), style: const TextStyle(color: ChatifyColors.darkGrey));
                              }),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    splashFactory: NoSplash.splashFactory,
                    splashColor: context.isDarkMode ? ChatifyColors.darkGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.darkerGrey.withAlpha((0.4 * 255).toInt()),
                    highlightColor: context.isDarkMode ? ChatifyColors.darkGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey.withAlpha((0.4 * 255).toInt()),
                    hoverColor: context.isDarkMode ? ChatifyColors.darkGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey.withAlpha((0.4 * 255).toInt()),
                    onTap: () {
                      seasonsController.showSeasonSelectionDialog(context);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                      child: Row(
                        children: [
                          Obx(() {
                            return SvgPicture.asset(ChatifyVectors.seasons, width: 30, height: 30, colorFilter: ColorFilter.mode(colorsController.getColor(colorsController.selectedColorScheme.value), BlendMode.srcIn));
                          }),
                          const SizedBox(width: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(S.of(context).seasons, style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.bold)),
                              Obx(() {
                                return Text(seasonsController.getSeasonDescription(), style: const TextStyle(color: ChatifyColors.darkGrey));
                              }),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    splashFactory: NoSplash.splashFactory,
                    splashColor: context.isDarkMode ? ChatifyColors.darkGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.darkerGrey.withAlpha((0.4 * 255).toInt()),
                    highlightColor: context.isDarkMode ? ChatifyColors.darkGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey.withAlpha((0.4 * 255).toInt()),
                    hoverColor: context.isDarkMode ? ChatifyColors.darkGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey.withAlpha((0.4 * 255).toInt()),
                    onTap: () {
                      showColorSchemeSelectionDialog(context);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 18),
                      child: Row(
                        children: [
                          Obx(() {
                            return Icon(Icons.color_lens, size: 30, color: colorsController.getColor(colorsController.selectedColorScheme.value));
                          }),
                          const SizedBox(width: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(S.of(context).appColor, style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.bold)),
                              Obx(() {
                                return Text(colorsController.getColorName(), style: const TextStyle(color: ChatifyColors.darkGrey));
                              }),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    splashFactory: NoSplash.splashFactory,
                    splashColor: context.isDarkMode ? ChatifyColors.darkGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.darkerGrey.withAlpha((0.4 * 255).toInt()),
                    highlightColor: context.isDarkMode ? ChatifyColors.darkGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey.withAlpha((0.4 * 255).toInt()),
                    hoverColor: context.isDarkMode ? ChatifyColors.darkGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey.withAlpha((0.4 * 255).toInt()),
                    onTap: () async {
                      final selectedWallpaper = await Navigator.push(context, createPageRoute(const WallpaperScreen(imagePath: '')));

                      if (selectedWallpaper != null) {
                        setState(() {});
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Row(
                        children: [
                          Obx(() {
                            return Icon(Icons.wallpaper, color: colorsController.getColor(colorsController.selectedColorScheme.value));
                          }),
                          const SizedBox(width: 16),
                          Text(S.of(context).wallpapers, style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Divider(height: 0, thickness: 1),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 16, top: 16, bottom: 8, right: 12),
                        child: Text(S.of(context).chatSettings, style: TextStyle(color: ChatifyColors.darkGrey, fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w400)),
                      ),
                      Obx(() {
                        return InkWell(
                          splashFactory: NoSplash.splashFactory,
                          splashColor: context.isDarkMode ? ChatifyColors.darkGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.darkerGrey.withAlpha((0.4 * 255).toInt()),
                          highlightColor: context.isDarkMode ? ChatifyColors.darkGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey.withAlpha((0.4 * 255).toInt()),
                          hoverColor: context.isDarkMode ? ChatifyColors.darkGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey.withAlpha((0.4 * 255).toInt()),
                          onTap: () {
                            settingsController.toggleSendWithEnter(!settingsController.sendWithEnter.value);
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(left: 55, right: 12, top: 12, bottom: 12),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(S.of(context).sendEnterKey, style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400)),
                                      Text(S.of(context).subtitleSendEnterKey, style: const TextStyle(color: ChatifyColors.darkGrey, fontWeight: FontWeight.w400)),
                                    ],
                                  ),
                                ),
                                CustomSwitch(
                                  value: settingsController.sendWithEnter.value,
                                  onChanged: (bool value) {
                                    settingsController.toggleSendWithEnter(value);
                                  },
                                  switchWidth: 58,
                                  switchHeight: 35,
                                  thumbSize: 27,
                                  thumbPadding: 3,
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                        splashFactory: NoSplash.splashFactory,
                        splashColor: context.isDarkMode ? ChatifyColors.darkGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.darkerGrey.withAlpha((0.4 * 255).toInt()),
                        highlightColor: context.isDarkMode ? ChatifyColors.darkGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey.withAlpha((0.4 * 255).toInt()),
                        hoverColor: context.isDarkMode ? ChatifyColors.darkGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey.withAlpha((0.4 * 255).toInt()),
                        onTap: () {
                          setState(() {
                            isVisibilityMedia = !isVisibilityMedia;
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(left: 55, right: 12, top: 12, bottom: 12),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(S.of(context).mediaVisibility, style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400)),
                                    Text(S.of(context).subtitleMediaVisibility, style: const TextStyle(color: ChatifyColors.darkGrey, fontWeight: FontWeight.w400)),
                                  ],
                                ),
                              ),
                              CustomSwitch(
                                value: isVisibilityMedia,
                                onChanged: (bool value) {
                                  setState(() {
                                    isVisibilityMedia = value;
                                  });
                                },
                                switchWidth: 58,
                                switchHeight: 35,
                                thumbSize: 27,
                                thumbPadding: 3,
                              ),
                            ],
                          ),
                        ),
                      ),
                      InkWell(
                        splashFactory: NoSplash.splashFactory,
                        splashColor: context.isDarkMode ? ChatifyColors.darkGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.darkerGrey.withAlpha((0.4 * 255).toInt()),
                        highlightColor: context.isDarkMode ? ChatifyColors.darkGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey.withAlpha((0.4 * 255).toInt()),
                        hoverColor: context.isDarkMode ? ChatifyColors.darkGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey.withAlpha((0.4 * 255).toInt()),
                        onTap: () {
                          fontsController.showFontSelectionDialog(context);
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(left: 55, right: 12, top: 12, bottom: 12),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(S.of(context).fontSize, style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400)),
                                    Obx(() {
                                      return Text(
                                        fontsController.getFontDescription(context, FontsController.instance.selectedFont.value),
                                        style: const TextStyle(color: ChatifyColors.darkGrey, fontWeight: FontWeight.w400),
                                      );
                                    }),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      InkWell(
                        splashFactory: NoSplash.splashFactory,
                        splashColor: context.isDarkMode ? ChatifyColors.darkGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.darkerGrey.withAlpha((0.4 * 255).toInt()),
                        highlightColor: context.isDarkMode ? ChatifyColors.darkGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey.withAlpha((0.4 * 255).toInt()),
                        hoverColor: context.isDarkMode ? ChatifyColors.darkGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey.withAlpha((0.4 * 255).toInt()),
                        onTap: () {
                          setState(() {
                            isTranscriptVoiceMsg = !isTranscriptVoiceMsg;
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(left: 55, right: 12, top: 12, bottom: 12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      S.of(context).decodingVoiceMessages,
                                      style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(S.of(context).readNewVoiceMessages, style: TextStyle(color: ChatifyColors.darkGrey, fontWeight: FontWeight.w400)),
                                  ],
                                ),
                              ),
                              Container(
                                alignment: Alignment.centerRight,
                                child: CustomSwitch(
                                  value: isTranscriptVoiceMsg,
                                  onChanged: (bool value) {
                                    setState(() {
                                      isTranscriptVoiceMsg = value;
                                    });
                                  },
                                  switchWidth: 58,
                                  switchHeight: 35,
                                  thumbSize: 27,
                                  thumbPadding: 3,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Divider(height: 0, thickness: 1),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 16, top: 16, bottom: 8, right: 12),
                        child: Text(S.of(context).archivedChats, style: TextStyle(color: ChatifyColors.darkGrey, fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w400)),
                      ),
                      InkWell(
                        splashFactory: NoSplash.splashFactory,
                        splashColor: context.isDarkMode ? ChatifyColors.darkGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.darkerGrey.withAlpha((0.4 * 255).toInt()),
                        highlightColor: context.isDarkMode ? ChatifyColors.darkGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey.withAlpha((0.4 * 255).toInt()),
                        hoverColor: context.isDarkMode ? ChatifyColors.darkGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey.withAlpha((0.4 * 255).toInt()),
                        onTap: () {
                          setState(() {
                            isArchiveChats = !isArchiveChats;
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(left: 55, right: 12, top: 12, bottom: 12),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(S.of(context).subtitleArchivedChats, style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.bold)),
                                    Text(S.of(context).archivedChatsUnarchived, style: const TextStyle(color: ChatifyColors.grey)),
                                  ],
                                ),
                              ),
                              CustomSwitch(
                                value: isArchiveChats,
                                onChanged: (bool value) {
                                  setState(() {
                                    isArchiveChats = value;
                                  });
                                },
                                switchWidth: 58,
                                switchHeight: 35,
                                thumbSize: 27,
                                thumbPadding: 3,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Divider(height: 0, thickness: 1),
                  InkWell(
                    splashFactory: NoSplash.splashFactory,
                    splashColor: context.isDarkMode ? ChatifyColors.darkGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.darkerGrey.withAlpha((0.4 * 255).toInt()),
                    highlightColor: context.isDarkMode ? ChatifyColors.darkGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey.withAlpha((0.4 * 255).toInt()),
                    hoverColor: context.isDarkMode ? ChatifyColors.darkGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey.withAlpha((0.4 * 255).toInt()),
                    onTap: () {
                      Navigator.push(context, createPageRoute(const ChatBackupScreen()));
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Row(
                        children: [
                          Obx(() {
                            return Icon(Icons.cloud_upload_outlined, color: colorsController.getColor(colorsController.selectedColorScheme.value));
                          }),
                          const SizedBox(width: 16),
                          Text(S.of(context).chatsBackup, style: const TextStyle(fontSize: 16)),
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    splashFactory: NoSplash.splashFactory,
                    splashColor: context.isDarkMode ? ChatifyColors.darkGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.darkerGrey.withAlpha((0.4 * 255).toInt()),
                    highlightColor: context.isDarkMode ? ChatifyColors.darkGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey.withAlpha((0.4 * 255).toInt()),
                    hoverColor: context.isDarkMode ? ChatifyColors.darkGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey.withAlpha((0.4 * 255).toInt()),
                    onTap: () {
                      Navigator.push(context, createPageRoute(const TransferringChatsScreen()));
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Row(
                        children: [
                          Obx(() {
                            return Icon(FluentIcons.phone_arrow_right_24_regular, color: colorsController.getColor(colorsController.selectedColorScheme.value));
                          }),
                          const SizedBox(width: 16),
                          Text(S.of(context).transferChats, style: const TextStyle(fontSize: 16)),
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    splashFactory: NoSplash.splashFactory,
                    splashColor: context.isDarkMode ? ChatifyColors.darkGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.darkerGrey.withAlpha((0.4 * 255).toInt()),
                    highlightColor: context.isDarkMode ? ChatifyColors.darkGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey.withAlpha((0.4 * 255).toInt()),
                    hoverColor: context.isDarkMode ? ChatifyColors.darkGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey.withAlpha((0.4 * 255).toInt()),
                    onTap: () {
                      Navigator.push(context, createPageRoute(const ChatsHistoryScreen()));
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(18),
                      child: Row(
                        children: [
                          Obx(() {
                            return Icon(Icons.home, color: colorsController.getColor(colorsController.selectedColorScheme.value));
                          }),
                          const SizedBox(width: 16),
                          Text(S.of(context).historiesChats, style: TextStyle(fontSize: ChatifySizes.fontSizeMd)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
