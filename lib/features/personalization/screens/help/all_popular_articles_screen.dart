import 'package:chatify/features/personalization/screens/help/write_to_us/write_to_us_screen.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../../common/widgets/tiles/list_tile/settings_menu_tile.dart';
import '../../../../generated/l10n/l10n.dart';
import '../../../../routes/custom_page_route.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../../utils/constants/app_vectors.dart';
import '../../../../utils/devices/device_utility.dart';
import '../../../../utils/platforms/platform_utils.dart';
import '../../../authentication/widgets/bars/auth_app_bar.dart';
import '../../widgets/dialogs/light_dialog.dart';

class AllPopularArticlesScreen extends StatefulWidget {
  const AllPopularArticlesScreen({super.key});

  @override
  State<AllPopularArticlesScreen> createState() => _AllPopularArticlesScreenState();
}

class _AllPopularArticlesScreenState extends State<AllPopularArticlesScreen> {
  late Future<void> _loadingFuture;

  @override
  void initState() {
    super.initState();
    _loadingFuture = _simulateLoading();
  }

  Future<void> _simulateLoading() async {
    await Future.delayed(const Duration(seconds: 2));
  }

  List<Widget> _buildArticleListWithDividers(BuildContext context, List<String> articles) {
    final widgets = <Widget>[];

    for (var i = 0; i < articles.length; i++) {
      widgets.add(_buildArticleTile(context, articles[i], () {}));
      if (i != articles.length - 1) {
        widgets.add(
          Container(
            margin: const EdgeInsets.only(left: 55),
            child: Divider(height: 1, thickness: 1, color: context.isDarkMode ? ChatifyColors.softNight : ChatifyColors.lightGrey),
          ),
        );
      }
    }

    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    final articles = [
      S.of(context).howMakeVideoCalls,
      'Как оставаться в безопасности в Chatify',
      'Временная блокировка аккаунта',
      S.of(context).adStatusAndChannels,
      'Двухшаговая проверка',
      'Как восстановить историю чатов',
      'Вы получили код подтверждения хотя не запрашивали его',
      'Как изменить номер телефона',
      'Как заблокировать пользователя и пожаловаться на него',
    ];

    return Scaffold(
      backgroundColor: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.grey.withAlpha((0.7 * 255).toInt()),
      body: Column(
        children: [
          AuthAppBar(
            title: S.of(context).helpCenter,
            onMenuItemIndex1: () => DeviceUtils.launchUrl('https://faq.chatify.com'),
            menuItem1Text: 'Открыть в браузере',
            leftIcon: Icons.search,
          ),
          SizedBox(height: 12),
          _buildAllPopularArticlesSection(context, articles),
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

  Widget _buildSettingsTile({required BuildContext context, required IconData icon, required String title, VoidCallback? onTap}) {
    return SettingsMenuTile(
      icon: icon,
      title: title,
      subTitle: '',
      iconColor: colorsController.getColor(colorsController.selectedColorScheme.value),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      margin: const EdgeInsets.all(0),
      backgroundColor: isMobile ? ChatifyColors.transparent : (context.isDarkMode ? ChatifyColors.darkBackground : ChatifyColors.grey),
      noRoundedCorners: true,
    );
  }

  Widget _buildArticleTile(BuildContext context, String title, VoidCallback? onTap) {
    return _buildSettingsTile(
      context: context,
      icon: FluentIcons.document_one_page_20_regular,
      title: title,
      onTap: onTap,
    );
  }

  Widget _buildAllPopularArticlesSection(BuildContext context, List<String> articles) {
    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: DeviceUtils.getScreenHeight(context) * .02),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text('Все популярные статьи', style: TextStyle(fontSize: ChatifySizes.fontSizeSm, color: ChatifyColors.darkGrey)),
        ),
        SizedBox(height: DeviceUtils.getScreenHeight(context) * .01),
        Column(
          children: _buildArticleListWithDividers(context, articles),
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
