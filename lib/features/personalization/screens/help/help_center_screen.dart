import 'package:chatify/features/personalization/screens/help/search_help_center_screen.dart';
import 'package:chatify/features/personalization/screens/help/write_to_us/write_to_us_screen.dart';
import 'package:chatify/utils/constants/app_images.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../../../generated/l10n/l10n.dart';
import '../../../../../utils/constants/app_colors.dart';
import '../../../../../utils/constants/app_sizes.dart';
import '../../../../common/widgets/tiles/list_tile/settings_menu_tile.dart';
import '../../../../routes/custom_page_route.dart';
import '../../../../utils/constants/app_links.dart';
import '../../../../utils/constants/app_vectors.dart';
import '../../../../utils/devices/device_utility.dart';
import '../../../../utils/platforms/platform_utils.dart';
import '../../../../utils/urls/url_utils.dart';
import '../../../authentication/widgets/bars/auth_app_bar.dart';
import '../../../utils/widgets/no_glow_scroll_behavior.dart';
import '../../widgets/dialogs/light_dialog.dart';
import 'all_popular_articles_screen.dart';
import 'all_reference_sections_screen.dart';

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

    final helpTopics = [
      {'icon': Icons.flag, 'title': S.of(context).beginningWork},
      {'icon': Icons.chat_sharp, 'title': S.of(context).chats},
      {'icon': FluentIcons.building_shop_24_regular, 'title': S.of(context).communicationCompanies},
      {'icon': Icons.call, 'title': S.of(context).audioVideoCalls},
      {'icon': Icons.group, 'title': S.of(context).communities},
      {'icon': Icons.lock, 'title': S.of(context).privacySecurity},
      {'icon': Icons.account_circle_rounded, 'title': S.of(context).accountBlocking},
    ];

    final articles = [
      S.of(context).howManageNotifications,
      S.of(context).howUpdateManually,
      S.of(context).howRecoverChatHistory,
      S.of(context).howRegisterPhoneNumber,
      S.of(context).howMakeVideoCalls,
      S.of(context).temporaryAccountBlocking,
      S.of(context).adStatusAndChannels,
    ];

    return Scaffold(
      backgroundColor: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.grey.withAlpha((0.7 * 255).toInt()),
      body: Column(
        children: [
          AuthAppBar(
            title: S.of(context).helpCenter,
            onMenuItemIndex1: () => UrlUtils.launchURL(AppLinks.helpCenter),
            menuItem1Text: '',
          ),
          Expanded(
            child: ScrollConfiguration(
              behavior: NoGlowScrollBehavior(),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Column(
                    children: [
                      _buildLogo(logoAsset),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Text(S.of(context).howCanHelp, style: TextStyle(fontSize: ChatifySizes.fontSizeBg, fontWeight: FontWeight.bold)),
                      ),
                      _buildSearchBar(context),
                      SizedBox(height: DeviceUtils.getScreenHeight(context) * .02),
                      _buildAdaptiveLayout(
                        first: _buildHelpTopicsSection(context, helpTopics),
                        second: _buildPopularArticlesSection(context, articles),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FutureBuilder<void>(
        future: _loadingFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return ElevatedButton.icon(
              onPressed: () {
                if (isMobile) {
                  Navigator.push(context, createPageRoute(const WriteToUsScreen()));
                } else {
                  Navigator.of(context).push(PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) => const WriteToUsScreen(),
                    transitionsBuilder: (context, animation, secondaryAnimation, child) {
                      return FadeTransition(opacity: animation, child: child);
                    },
                  ));
                }
              },
              icon: SvgPicture.asset(ChatifyVectors.questionSupport, width: 20, height: 20, color: ChatifyColors.black),
              label: Text(S.of(context).connectWithUs, style: TextStyle(color: ChatifyColors.black, fontWeight: FontWeight.w300)),
              style: ElevatedButton.styleFrom(
                foregroundColor: ChatifyColors.white,
                backgroundColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                side: BorderSide.none,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                padding: const EdgeInsets.all(16),
              ),
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }

  Widget _buildSettingsTile({required IconData icon, required String title, VoidCallback? onTap}) {
    return SettingsMenuTile(
      icon: icon,
      title: title,
      subTitle: '',
      iconColor: colorsController.getColor(colorsController.selectedColorScheme.value),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      margin: const EdgeInsets.all(0),
      backgroundColor: isMobile ? ChatifyColors.transparent : (context.isDarkMode ? ChatifyColors.darkBackground : ChatifyColors.grey),
    );
  }

  Widget _buildArticleTile(String title, VoidCallback? onTap) {
    return _buildSettingsTile(
      icon: FluentIcons.document_one_page_20_regular,
      title: title,
      onTap: onTap,
    );
  }

  Widget _buildLogo(String logoAsset) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Center(child: Image.asset(logoAsset, width: 100, height: 100)),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobiles = !isWebOrWindows && isMobile;
        final double maxWidth = isMobiles ? constraints.maxWidth : 500;

        return Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxWidth),
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).push(PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) => const SearchHelpCenterScreen(),
                  transitionsBuilder: (context, animation, secondaryAnimation, child) {
                    return FadeTransition(opacity: animation, child: child);
                  },
                ));
              },
              child: AbsorbPointer(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Container(
                    decoration: BoxDecoration(
                      color: context.isDarkMode ? ChatifyColors.darkBackground : ChatifyColors.grey,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: context.isDarkMode ? ChatifyColors.darkerGrey : ChatifyColors.youngNight, width: 0.5),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      child: TextSelectionTheme(
                        data: TextSelectionThemeData(
                          cursorColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                          selectionColor: colorsController.getColor(colorsController.selectedColorScheme.value).withAlpha((0.3 * 255).toInt()),
                          selectionHandleColor: Colors.blue,
                        ),
                        child: TextField(
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.search, color: ChatifyColors.darkGrey),
                            hintText: S.of(context).searchHelpCenter,
                            hintStyle: TextStyle(color: ChatifyColors.darkGrey, fontSize: ChatifySizes.fontSizeMd),
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAdaptiveLayout({required Widget first, required Widget second, double spacing = 16}) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 1000;

        if (isWide) {
          final containerMaxWidth = isWide && constraints.maxWidth >= (600 * 2 + spacing) ? 600.0 : ((constraints.maxWidth - spacing) / 2).toDouble();

          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ConstrainedBox(constraints: BoxConstraints(maxWidth: containerMaxWidth), child: first),
              SizedBox(width: spacing),
              ConstrainedBox(constraints: BoxConstraints(maxWidth: containerMaxWidth), child: second),
            ],
          );
        } else {
          return Column(
            children: [
              first,
              SizedBox(height: spacing / 2),
              Divider(height: 10, thickness: 10, color: context.isDarkMode ? ChatifyColors.softNight : ChatifyColors.lightGrey),
              SizedBox(height: spacing / 2),
              second,
            ],
          );
        }
      },
    );
  }

  Widget _buildHelpTopicsSection(BuildContext context, List<Map<String, dynamic>> helpTopics) {
    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: DeviceUtils.getScreenHeight(context) * .02),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(S.of(context).helpTopics, style: TextStyle(fontSize: ChatifySizes.fontSizeSm, color: ChatifyColors.darkGrey)),
        ),
        SizedBox(height: DeviceUtils.getScreenHeight(context) * .01),
        Column(
          children: helpTopics.map((item) {
            return _buildSettingsTile(
              icon: item['icon'] as IconData,
              title: item['title'] as String,
              onTap: () {},
            );
          }).toList(),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: () {
            Navigator.of(context).push(PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) => const AllReferenceSectionsScreen(),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                return FadeTransition(opacity: animation, child: child);
              },
            ));
          },
          mouseCursor: SystemMouseCursors.basic,
          borderRadius: BorderRadius.circular(12),
          splashColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey,
          highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 40),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: ChatifyColors.transparent),
            child: Text(S.of(context).more, style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400)),
          ),
        ),
      ],
    );

    if (isMobile) {
      return content;
    }

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(color: context.isDarkMode ? ChatifyColors.darkBackground : ChatifyColors.grey, borderRadius: BorderRadius.circular(16)),
      padding: const EdgeInsets.only(left: 10, right: 10, bottom: 16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: context.isDarkMode ? ChatifyColors.darkBackground : ChatifyColors.white, borderRadius: BorderRadius.circular(16)),
        constraints: BoxConstraints(maxWidth: isWindows ? 500 : 600),
        child: content,
      )
    );
  }

  Widget _buildPopularArticlesSection(BuildContext context, List<String> articles) {
    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: DeviceUtils.getScreenHeight(context) * .02),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(S.of(context).popularArticles, style: TextStyle(fontSize: ChatifySizes.fontSizeSm, color: ChatifyColors.darkGrey)),
        ),
        SizedBox(height: DeviceUtils.getScreenHeight(context) * .01),
        Column(
          children: articles.map((title) {
            return _buildArticleTile(title, () {});
          }).toList(),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: () {
            Navigator.of(context).push(PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) => const AllPopularArticlesScreen(),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                return FadeTransition(opacity: animation, child: child);
              },
            ));
          },
          mouseCursor: SystemMouseCursors.basic,
          borderRadius: BorderRadius.circular(12),
          splashColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey,
          highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 40),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: ChatifyColors.transparent),
            child: Text(S.of(context).more, style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400)),
          ),
        ),
      ],
    );

    if (isMobile) {
      return content;
    }

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(color: context.isDarkMode ? ChatifyColors.darkBackground : ChatifyColors.grey, borderRadius: BorderRadius.circular(16)),
      padding: const EdgeInsets.only(left: 10, right: 10, bottom: 16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: context.isDarkMode ? ChatifyColors.darkBackground : ChatifyColors.white, borderRadius: BorderRadius.circular(16)),
        constraints: BoxConstraints(maxWidth: isWindows ? 500 : 600),
        child: content,
      ),
    );
  }
}
