import 'package:chatify/features/personalization/controllers/fonts_controller.dart';
import 'package:chatify/features/personalization/screens/chats/transferring_chats_screen.dart';
import 'package:chatify/features/personalization/screens/chats/wallpaper_screen.dart';
import 'package:chatify/routes/custom_page_route.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../../../generated/l10n/l10n.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../../utils/constants/app_vectors.dart';
import '../../../utils/widgets/no_glow_scroll_behavior.dart';
import '../../controllers/seasons_controller.dart';
import '../../controllers/settings_controller.dart';
import '../../controllers/themes_controller.dart';
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
            boxShadow: [
              BoxShadow(
                color: ChatifyColors.black.withAlpha((0.1 * 255).toInt()),
                spreadRadius: 1,
                blurRadius: 3,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: AppBar(
            automaticallyImplyLeading: false,
            title: Text(S.of(context).chats, style: TextStyle(fontSize: ChatifySizes.fontSizeMg, fontWeight: FontWeight.w400,
              color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black),
            ),
            titleSpacing: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
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
          data: ScrollbarThemeData(
            thumbColor: WidgetStateProperty.resolveWith<Color>((Set<WidgetState> states) {
                if (states.contains(WidgetState.dragged)) {
                  return ChatifyColors.darkerGrey;
                }
                return ChatifyColors.darkerGrey;
              },
            ),
          ),
          child: Scrollbar(
            thickness: 4,
            thumbVisibility: false,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20, top: 16, bottom: 16),
                    child: Text(S.of(context).screen, style: const TextStyle(fontSize: 14)),
                  ),
                  InkWell(
                    onTap: () {
                      themesController.showThemeSelectionDialog(context);
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 18, right: 18, top: 6, bottom: 18),
                      child: Row(
                        children: [
                          Obx(() {
                            return Icon(
                              Icons.brightness_6,
                              color: colorsController.getColor(colorsController.selectedColorScheme.value),
                            );
                          }),
                          const SizedBox(width: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(S.of(context).themes, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                              Obx(() {
                                return Text(
                                  themesController.getThemeDescription(),
                                  style: const TextStyle(color: ChatifyColors.darkGrey),
                                );
                              }),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      seasonsController.showSeasonSelectionDialog(context);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 18),
                      child: Row(
                        children: [
                          Obx(() {
                            return SvgPicture.asset(ChatifyVectors.seasons, color: colorsController.getColor(colorsController.selectedColorScheme.value), width: 32);
                          }),
                          const SizedBox(width: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Сезоны', style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.bold)),
                              Obx(() {
                                return Text(
                                  seasonsController.getSeasonDescription(),
                                  style: const TextStyle(color: ChatifyColors.darkGrey),
                                );
                              }),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      colorsController.showColorSchemeSelectionDialog(context);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 18),
                      child: Row(
                        children: [
                          Obx(() {
                            return Icon(
                              Icons.color_lens,
                              color: colorsController.getColor(colorsController.selectedColorScheme.value),
                            );
                          }),
                          const SizedBox(width: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Цвет приложения', style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.bold)),
                              Obx(() {
                                return Text(
                                  colorsController.getColorName(),
                                  style: const TextStyle(color: ChatifyColors.darkGrey),
                                );
                              }),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () async {
                      final selectedWallpaper = await Navigator.push(
                        context,
                        createPageRoute(const WallpaperScreen(imagePath: '')),
                      );

                      if (selectedWallpaper != null) {
                        setState(() {});
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Row(
                        children: [
                          Obx(() {
                            return Icon(
                              Icons.wallpaper,
                              color: colorsController.getColor(colorsController.selectedColorScheme.value),
                            );
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
                        padding: const EdgeInsets.only(left: 16.0, top: 16, bottom: 8, right: 12),
                        child: Text(S.of(context).chatSettings, style: const TextStyle(fontSize: 14)),
                      ),
                      Obx(() {
                        return InkWell(
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
                                      Text(S.of(context).sendEnterKey, style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.bold)),
                                      Text(S.of(context).subtitleSendEnterKey, style: const TextStyle(color: ChatifyColors.darkGrey)),
                                    ],
                                  ),
                                ),
                                Switch(
                                  value: settingsController.sendWithEnter.value,
                                  onChanged: (bool value) {
                                    settingsController.toggleSendWithEnter(value);
                                  },
                                  activeColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                                  activeTrackColor: colorsController.getColor(colorsController.selectedColorScheme.value).withAlpha((0.3 * 255).toInt()),
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
                                    Text(S.of(context).mediaVisibility, style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.bold)),
                                    Text(S.of(context).subtitleMediaVisibility, style: const TextStyle(color: ChatifyColors.darkGrey)),
                                  ],
                                ),
                              ),
                              Switch(
                                value: isVisibilityMedia,
                                onChanged: (bool value) {
                                  setState(() {
                                    isVisibilityMedia = value;
                                  });
                                },
                                activeColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                                activeTrackColor: colorsController.getColor(colorsController.selectedColorScheme.value).withAlpha((0.3 * 255).toInt()),
                              ),
                            ],
                          ),
                        ),
                      ),
                      InkWell(
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
                                    Text(
                                      S.of(context).fontSize,
                                      style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.bold),
                                    ),
                                    Obx(() {
                                      return Text(
                                        fontsController.getFontDescription(FontsController.instance.selectedFont.value),
                                        style: const TextStyle(color: ChatifyColors.darkGrey),
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
                                      'Расшифровка гол. сообщений',
                                      style: TextStyle(
                                        fontSize: ChatifySizes.fontSizeMd,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const Text(
                                      'Читайте новые голосовые сообщения',
                                      style: TextStyle(color: ChatifyColors.darkGrey),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                alignment: Alignment.centerRight,
                                child: Switch(
                                  value: isTranscriptVoiceMsg,
                                  onChanged: (bool value) {
                                    setState(() {
                                      isTranscriptVoiceMsg = value;
                                    });
                                  },
                                  activeColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                                  activeTrackColor: colorsController.getColor(colorsController.selectedColorScheme.value).withAlpha((0.3 * 255).toInt()),
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
                        padding: const EdgeInsets.only(left: 16.0, top: 16, bottom: 8, right: 12),
                        child: Text(S.of(context).archivedChats, style: const TextStyle(fontSize: 14)),
                      ),
                      InkWell(
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
                                    Text(S.of(context).archivedChatsUnarchived, style: const TextStyle(color: Colors.grey)),
                                  ],
                                ),
                              ),
                              Switch(
                                value: isArchiveChats,
                                onChanged: (bool value) {
                                  setState(() {
                                    isArchiveChats = value;
                                  });
                                },
                                activeColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                                activeTrackColor: colorsController.getColor(colorsController.selectedColorScheme.value).withAlpha((0.3 * 255).toInt()),
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
                    onTap: () {
                      Navigator.push(
                        context,
                        createPageRoute(const ChatBackupScreen()),
                      );
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
                    onTap: () {
                      Navigator.push(
                        context,
                        createPageRoute(const TransferringChatsScreen()),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Row(
                        children: [
                          Obx(() {
                            return Icon(
                              FluentIcons.phone_arrow_right_24_regular,
                              color: colorsController.getColor(colorsController.selectedColorScheme.value),
                            );
                          }),
                          const SizedBox(width: 16),
                          Text(S.of(context).transferChats, style: const TextStyle(fontSize: 16)),
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        createPageRoute(const ChatsHistoryScreen()),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Row(
                        children: [
                          Obx(() {
                            return Icon(
                              Icons.home,
                              color: colorsController.getColor(colorsController.selectedColorScheme.value),
                            );
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
