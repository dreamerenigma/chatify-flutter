import 'package:chatify/features/personalization/screens/help/search_help_center_screen.dart';
import 'package:chatify/features/personalization/screens/help/write_to_us/write_to_us_screen.dart';
import 'package:chatify/utils/constants/app_images.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../generated/l10n/l10n.dart';
import '../../../../../utils/constants/app_colors.dart';
import '../../../../../utils/constants/app_sizes.dart';
import '../../../../common/widgets/tiles/list_tile/settings_menu_tile.dart';
import '../../../../routes/custom_page_route.dart';
import '../../../../utils/devices/device_utility.dart';
import '../../../utils/widgets/no_glow_scroll_behavior.dart';
import '../../widgets/dialogs/light_dialog.dart';

class HelpCenterScreen extends StatefulWidget {
  const HelpCenterScreen({super.key});

  @override
  HelpCenterScreenState createState() => HelpCenterScreenState();
}

class HelpCenterScreenState extends State<HelpCenterScreen> {
  late Future<void> _loadingFuture;

  @override
  void initState() {
    super.initState();
    _loadingFuture = _simulateLoading();
  }

  Future<void> _simulateLoading() async {
    await Future.delayed(const Duration(seconds: 2));
  }

  @override
  Widget build(BuildContext context) {
    final logoAsset = context.isDarkMode ? ChatifyImages.appLogoLight : ChatifyImages.appLogoDark;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: FutureBuilder<void>(
          future: _loadingFuture,
          builder: (context, snapshot) {
            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha((0.1 * 255).toInt()),
                    spreadRadius: 1,
                    blurRadius: 3,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: AppBar(
                title: Text(S.of(context).helpCenter, style: TextStyle(fontSize: ChatifySizes.fontSizeMg, fontWeight: FontWeight.w400)),
                titleSpacing: 0,
                backgroundColor: context.isDarkMode ? ChatifyColors.blackGrey : Colors.white,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                actions: snapshot.connectionState == ConnectionState.done
                  ? [
                  PopupMenuButton<int>(
                    position: PopupMenuPosition.under,
                    color: context.isDarkMode ? ChatifyColors.darkSlate : ChatifyColors.white,
                    icon: const Icon(Icons.more_vert),
                    onSelected: (value) {
                      if (value == 1) {}
                    },
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: 1,
                        padding: const EdgeInsets.only(left: 16, right: 16),
                        child: Text(
                          'Открыть в браузере',
                          style: TextStyle(fontSize: ChatifySizes.fontSizeMd),
                        ),
                      ),
                    ],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ]
                : [],
              ),
            );
          },
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
            child: FutureBuilder<void>(
              future: _loadingFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(colorsController.getColor(colorsController.selectedColorScheme.value))),
                  );
                } else if (snapshot.connectionState == ConnectionState.done) {
                  return SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            child: Center(
                              child: Image.asset(
                                logoAsset,
                                width: 100,
                                height: 100,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Text(
                              S.of(context).howCanHelpYou,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(context, createPageRoute(const SearchHelpCenterScreen()));
                            },
                            child: AbsorbPointer(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.grey,
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                    child: TextField(
                                      decoration: InputDecoration(
                                        prefixIcon: const Icon(Icons.search, color: ChatifyColors.darkGrey),
                                        hintText: S.of(context).searchHelpCenter,
                                        hintStyle: const TextStyle(color: ChatifyColors.darkGrey),
                                        border: InputBorder.none,
                                        enabledBorder: InputBorder.none,
                                        focusedBorder: InputBorder.none,
                                        contentPadding:
                                        const EdgeInsets.symmetric(vertical: 14.0),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: DeviceUtils.getScreenHeight(context) * .02),
                          Container(
                            color: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.grey,
                            width: double.infinity,
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: DeviceUtils.getScreenHeight(context) * .02),
                                  Text(S.of(context).helpTopics,
                                    style: TextStyle(
                                      fontSize: ChatifySizes.fontSizeSm,
                                      color: ChatifyColors.darkGrey,
                                    ),
                                  ),
                                  SizedBox(height: DeviceUtils.getScreenHeight(context) * .01),
                                  Column(
                                    children: [
                                      SettingsMenuTile(
                                        icon: Icons.flag,
                                        title: S.of(context).beginningWork,
                                        subTitle: '',
                                        iconColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                                        onTap: () {},
                                        contentPadding: const EdgeInsets.all(0),
                                        margin: const EdgeInsets.all(0),
                                      ),
                                      SettingsMenuTile(
                                        icon: Icons.chat_sharp,
                                        title: S.of(context).chats,
                                        subTitle: '',
                                        iconColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                                        onTap: () {},
                                        contentPadding: const EdgeInsets.all(0),
                                        margin: const EdgeInsets.all(0),
                                      ),
                                      SettingsMenuTile(
                                        icon: FluentIcons.building_shop_24_regular,
                                        title: S.of(context).communicationCompanies,
                                        subTitle: '',
                                        iconColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                                        onTap: () {},
                                        contentPadding: const EdgeInsets.all(0),
                                        margin: const EdgeInsets.all(0),
                                      ),
                                      SettingsMenuTile(
                                        icon: Icons.call,
                                        title: S.of(context).audioVideoCalls,
                                        subTitle: '',
                                        iconColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                                        onTap: () {},
                                        contentPadding: const EdgeInsets.all(0),
                                        margin: const EdgeInsets.all(0),
                                      ),
                                      SettingsMenuTile(
                                        icon: Icons.group,
                                        title: S.of(context).communities,
                                        subTitle: '',
                                        iconColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                                        onTap: () {},
                                        contentPadding: const EdgeInsets.all(0),
                                        margin: const EdgeInsets.all(0),
                                      ),
                                      SettingsMenuTile(
                                        icon: Icons.lock,
                                        title: S.of(context).privacySecurity,
                                        subTitle: '',
                                        iconColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                                        onTap: () {},
                                        contentPadding: const EdgeInsets.all(0),
                                        margin: const EdgeInsets.all(0),
                                      ),
                                      SettingsMenuTile(
                                        icon: Icons.account_circle_rounded,
                                        title: S.of(context).accountBlocking,
                                        subTitle: '',
                                        iconColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                                        onTap: () {},
                                        contentPadding: const EdgeInsets.all(0),
                                        margin: const EdgeInsets.all(0),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: DeviceUtils.getScreenHeight(context) * .03),
                                  Text(
                                    S.of(context).popularArticles,
                                    style: TextStyle(
                                      fontSize: ChatifySizes.fontSizeSm,
                                      color: ChatifyColors.darkGrey,
                                    ),
                                  ),
                                  SizedBox(height: DeviceUtils.getScreenHeight(context) * .03),
                                  SettingsMenuTile(
                                    icon: FluentIcons.document_one_page_20_regular,
                                    title: S.of(context).howManageNotifications,
                                    subTitle: '',
                                    iconColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                                    onTap: () {},
                                    contentPadding: const EdgeInsets.all(0),
                                    margin: const EdgeInsets.all(0),
                                  ),
                                  SettingsMenuTile(
                                    icon: FluentIcons.document_one_page_20_regular,
                                    title: S.of(context).howUpdateManually,
                                    subTitle: '',
                                    iconColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                                    onTap: () {},
                                    contentPadding: const EdgeInsets.all(0),
                                    margin: const EdgeInsets.all(0),
                                  ),
                                  SettingsMenuTile(
                                    icon: FluentIcons.document_one_page_20_regular,
                                    title: S.of(context).howRecoverChatHistory,
                                    subTitle: '',
                                    iconColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                                    onTap: () {},
                                    contentPadding: const EdgeInsets.all(0),
                                    margin: const EdgeInsets.all(0),
                                  ),
                                  SettingsMenuTile(
                                    icon: FluentIcons.document_one_page_20_regular,
                                    title: S.of(context).howRegisterPhoneNumber,
                                    subTitle: '',
                                    iconColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                                    onTap: () {},
                                    contentPadding: const EdgeInsets.all(0),
                                    margin: const EdgeInsets.all(0),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                } else {
                  return const Center(child: Text('Error loading content'));
                }
              },
            ),
          ),
        ),
      ),
      floatingActionButton: FutureBuilder<void>(
        future: _loadingFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return ElevatedButton.icon(
              onPressed: () {
                Navigator.push(context, createPageRoute(const WriteToUsScreen()));
              },
              icon: const Icon(Icons.question_mark, color: ChatifyColors.white),
              label: Text(S.of(context).connectWithUs),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                side: BorderSide.none,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                padding: const EdgeInsets.all(16.0),
              ),
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }
}
