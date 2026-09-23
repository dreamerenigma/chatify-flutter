import 'package:chatify/features/personalization/screens/help/search_help_center_screen.dart';
import 'package:chatify/features/personalization/screens/help/write_to_us/write_to_us_screen.dart';
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
import '../../../calls/widgets/popups/items/app_popup_menu_item.dart';
import '../../../utils/widgets/scrolls/no_glow_scroll_behavior.dart';
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
    final logoAsset = context.isDarkMode ? ChatifyVectors.appLogoLight : ChatifyVectors.appLogoDark;

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
      appBar: AppBar(
        titleSpacing: 0,
        title: Text(S.of(context).helpCenter, style: TextStyle(fontSize: ChatifySizes.fontSizeMg, fontWeight: FontWeight.w400)),
        actions: [
          TooltipTheme(
            data: TooltipThemeData(decoration: BoxDecoration(color: context.isDarkMode ? ChatifyColors.black : ChatifyColors.white, borderRadius: BorderRadius.circular(8))),
            child: Theme(
              data: Theme.of(context).copyWith(splashColor: ChatifyColors.darkerGrey, highlightColor: ChatifyColors.darkerGrey, hoverColor: ChatifyColors.darkerGrey),
              child: PopupMenuButton<int>(
                tooltip: S.of(context).more,
                position: PopupMenuPosition.under,
                offset: const Offset(-8, 0),
                menuPadding: EdgeInsets.symmetric(vertical: 4),
                constraints: const BoxConstraints(minWidth: 0, maxWidth: 200),
                icon: const Icon(Icons.more_vert),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.resolveWith((states) {
                    if (states.contains(WidgetState.pressed)) {
                      return context.isDarkMode ? ChatifyColors.softNight : ChatifyColors.lightGrey;
                    }
                    return ChatifyColors.transparent;
                  }),
                  shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                  overlayColor: WidgetStateProperty.all(ChatifyColors.softNight.withAlpha((0.1 * 255).toInt())),
                ),
                color: context.isDarkMode ? ChatifyColors.darkSlate : ChatifyColors.white,
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 1,
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: AppPopupMenuItem(
                      text: S.of(context).openInBrowser,
                      onTap: () {
                        UrlUtils.launchURL(AppLinks.helpCenter);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
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
                        child: Text(S.of(context).howCanHelp, style: TextStyle(fontSize: ChatifySizes.fontSizeBg, fontWeight: FontWeight.w600)),
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
              icon: SvgPicture.asset(ChatifyVectors.questionSupport, width: 22, height: 22, colorFilter: ColorFilter.mode(ChatifyColors.black, BlendMode.srcIn)),
              label: Text(S.of(context).connectWithUs, style: TextStyle(color: ChatifyColors.black, fontSize: 15, fontWeight: FontWeight.w400)),
              style: ElevatedButton.styleFrom(
                foregroundColor: ChatifyColors.white,
                backgroundColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                side: BorderSide.none,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
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
      noRoundedCorners: true,
      backgroundColor: isMobile ? ChatifyColors.transparent : (context.isDarkMode ? ChatifyColors.darkBackground : ChatifyColors.grey),
    );
  }

  Widget _buildArticleTile(String title, VoidCallback? onTap) {
    return _buildSettingsTile(icon: FluentIcons.document_one_page_20_regular, title: title, onTap: onTap);
  }

  Widget _buildLogo(String logoAsset) {
    return Padding(padding: const EdgeInsets.symmetric(vertical: 16), child: Center(child: SvgPicture.asset(logoAsset, width: 80, height: 80)));
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
                      borderRadius: BorderRadius.circular(35),
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
                            prefixIcon: const Icon(Icons.search, color: ChatifyColors.darkGrey, fontWeight: FontWeight.w400),
                            hintText: S.of(context).searchHelpCenter,
                            hintStyle: TextStyle(color: ChatifyColors.darkGrey, fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400),
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(vertical: 13),
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
              Divider(height: 10, thickness: 10, color: context.isDarkMode ? ChatifyColors.darkBackground : ChatifyColors.lightGrey),
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
          child: Text(S.of(context).helpTopics, style: TextStyle(fontSize: ChatifySizes.fontSizeSm, color: ChatifyColors.darkGrey, fontWeight: FontWeight.w400)),
        ),
        SizedBox(height: DeviceUtils.getScreenHeight(context) * .01),
        Column(
          children: helpTopics.map((item) {
            return _buildSettingsTile(icon: item['icon'] as IconData, title: item['title'] as String, onTap: () {});
          }).toList(),
        ),
        const SizedBox(height: 8),
        Material(
          color: ChatifyColors.transparent,
          child: InkWell(
            mouseCursor: SystemMouseCursors.basic,
            splashFactory: NoSplash.splashFactory,
            borderRadius: BorderRadius.circular(8),
            splashColor: context.isDarkMode ? ChatifyColors.steelGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
            highlightColor: context.isDarkMode ? ChatifyColors.steelGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
            hoverColor: context.isDarkMode ? ChatifyColors.lightSoftNight.withAlpha((0.15 * 255).toInt()) : ChatifyColors.steelGrey,
            onTap: () {
              Navigator.of(context).push(PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) => const AllReferenceSectionsScreen(),
                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                  return FadeTransition(opacity: animation, child: child);
                },
              ));
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 45),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(0), color: ChatifyColors.transparent),
              child: Text(S.of(context).more, style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400)),
            ),
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
          child: Text(S.of(context).popularArticles, style: TextStyle(fontSize: ChatifySizes.fontSizeSm, color: ChatifyColors.darkGrey, fontWeight: FontWeight.w400)),
        ),
        SizedBox(height: DeviceUtils.getScreenHeight(context) * .01),
        Column(
          children: articles.map((title) {
            return _buildArticleTile(title, () {});
          }).toList(),
        ),
        const SizedBox(height: 8),
        Material(
          color: ChatifyColors.transparent,
          child: InkWell(
            splashFactory: NoSplash.splashFactory,
            mouseCursor: SystemMouseCursors.basic,
            borderRadius: BorderRadius.circular(8),
            splashColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
            highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
            hoverColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
            onTap: () {
              Navigator.of(context).push(PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) => const AllPopularArticlesScreen(),
                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                  return FadeTransition(opacity: animation, child: child);
                },
              ));
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 45),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(0), color: ChatifyColors.transparent),
              child: Text(S.of(context).more, style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400)),
            ),
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
