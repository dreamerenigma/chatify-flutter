import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatify/utils/constants/app_sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_utils/src/extensions/context_extensions.dart';
import '../../../generated/l10n/l10n.dart';
import '../../../utils/constants/app_colors.dart';
import '../../../utils/constants/app_vectors.dart';
import '../../../utils/helper/date_util.dart';
import '../../calls/widgets/popups/items/app_popup_menu_item.dart';
import '../../chat/models/user_model.dart';
import '../../chat/models/user_status_model.dart';
import '../../personalization/widgets/dialogs/light_dialog.dart';

class ViewStatusScreen extends StatefulWidget {
  final String imageUrl;
  final UserModel user;
  final UserStatusModel status;
  final int views;

  const ViewStatusScreen({
    super.key,
    required this.imageUrl,
    required this.user,
    required this.status,
    this.views = 0,
  });

  @override
  State<ViewStatusScreen> createState() => _ViewStatusScreenState();
}

class _ViewStatusScreenState extends State<ViewStatusScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _progressController;
  bool _showViewsMenu = false;

  @override
  void initState() {
    super.initState();
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    _progressController = AnimationController(vsync: this, duration: const Duration(seconds: 6));
    _progressController.forward();
    _progressController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        if (mounted) {
          Navigator.pop(context);
        }
      }
    });
  }

  @override
  void dispose() {
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: ChatifyColors.black,
      body: SafeArea(
        top: false,
        bottom: false,
        child: Stack(
          children: [
            Positioned.fill(
              child: Center(
                child: CachedNetworkImage(
                  imageUrl: widget.imageUrl,
                  fit: BoxFit.contain,
                  width: double.infinity,
                  height: double.infinity,
                  placeholder: (context, url) {
                    return const Center(child: CircularProgressIndicator());
                  },
                  errorWidget: (context, url, error) {
                    return Center(child: SvgPicture.asset(ChatifyVectors.person, width: 50, height: 50, colorFilter: const ColorFilter.mode(ChatifyColors.darkGrey, BlendMode.srcIn)));
                  },
                ),
              ),
            ),
            Positioned(
              top: topPadding,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  AnimatedBuilder(
                    animation: _progressController,
                    builder: (context, child) {
                      return SizedBox(
                        height: 3,
                        width: double.infinity,
                        child: LinearProgressIndicator(
                          value: _progressController.value,
                          backgroundColor: ChatifyColors.white.withAlpha(80),
                          valueColor: const AlwaysStoppedAnimation<Color>(ChatifyColors.white),
                        ),
                      );
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 12),
                    child: Row(
                      children: [
                        Material(
                          color: ChatifyColors.transparent,
                          shape: const CircleBorder(),
                          child: InkWell(
                            splashFactory: NoSplash.splashFactory,
                            customBorder: const CircleBorder(),
                            splashColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
                            highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
                            hoverColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: const SizedBox(width: 42, height: 42, child: Icon(Icons.arrow_back, color: ChatifyColors.white, size: 24)),
                          ),
                        ),
                        const SizedBox(width: 2),
                        Material(
                          color: ChatifyColors.transparent,
                          child: InkWell(
                            splashFactory: NoSplash.splashFactory,
                            splashColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
                            highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
                            hoverColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
                            onTap: () {},
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: [
                                ClipOval(
                                  child: CachedNetworkImage(
                                    width: 42,
                                    height: 42,
                                    imageUrl: widget.user.image,
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) {
                                      return Container(width: 42, height: 42, color: ChatifyColors.blackGrey);
                                    },
                                    errorWidget: (context, url, error) {
                                      return Container(
                                        width: 42,
                                        height: 42,
                                        color: ChatifyColors.softNight,
                                        alignment: Alignment.center,
                                        child: SvgPicture.asset(ChatifyVectors.profile, width: 42, height: 42),
                                      );
                                    },
                                  ),
                                ),
                                Positioned(
                                  right: -3,
                                  bottom: -2,
                                  child: Material(
                                    color: ChatifyColors.transparent,
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(30),
                                      splashFactory: NoSplash.splashFactory,
                                      splashColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
                                      highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
                                      hoverColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
                                      onTap: () {},
                                      child: Container(
                                        width: 19,
                                        height: 19,
                                        decoration: BoxDecoration(shape: BoxShape.circle, color: colorsController.getColor(colorsController.selectedColorScheme.value)),
                                        child: const Icon(Icons.add, color: ChatifyColors.black, size: 18),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Статус', style: TextStyle(color: ChatifyColors.white, fontSize: 17, fontWeight: FontWeight.w400, height: 1.4)),
                              Text(
                                DateUtil.formatStatusTime(widget.status.createdAt),
                                style: TextStyle(color: context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.darkerGrey, fontSize: 15, height: 1.2),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            AnimatedPositioned(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOutCubic,
              left: 0,
              right: 0,
              bottom: _showViewsMenu ? -20 : 8,
              child: SafeArea(
                top: false,
                child: Center(
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeInOut,
                    opacity: _showViewsMenu ? 0.0 : 1.0,
                    child: IgnorePointer(
                      ignoring: _showViewsMenu,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _showViewsMenu = true;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.only(left: 22, right: 24, top: 16, bottom: 16),
                          decoration: BoxDecoration(color: ChatifyColors.blackGrey, borderRadius: BorderRadius.circular(30)),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.visibility_outlined, color: ChatifyColors.white, size: 20),
                              const SizedBox(width: 14),
                              Text('${widget.views}', style: TextStyle(color: ChatifyColors.white, fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            if (_showViewsMenu)
              Positioned.fill(
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    setState(() {
                      _showViewsMenu = false;
                    });
                  },
                  child: Container(color: ChatifyColors.transparent),
                ),
              ),
            AnimatedPositioned(
              duration: const Duration(milliseconds: 350),
              curve: Curves.easeOutCubic,
              left: 0,
              right: 0,
              bottom: _showViewsMenu ? 0 : -400,
              child: GestureDetector(
                onVerticalDragUpdate: (details) {
                  if (details.delta.dy > 0) {
                    setState(() {
                      _showViewsMenu = false;
                    });
                  }
                },
                onVerticalDragEnd: (details) {
                  if (details.primaryVelocity != null && details.primaryVelocity! > 300) {
                    setState(() {
                      _showViewsMenu = false;
                    });
                  }
                },
                child: _buildViewsMenu(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildViewsMenu() {
    return SafeArea(
      top: false,
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: double.infinity,
              color: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.blackGrey,
              padding: const EdgeInsets.only(left: 20, right: 2, top: 6, bottom: 6),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 6),
                  Container(width: 36, height: 4, decoration: BoxDecoration(color: ChatifyColors.steelGrey, borderRadius: BorderRadius.circular(2))),
                  const SizedBox(height: 14),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('Просмотрено:', style: TextStyle(color: ChatifyColors.white, fontSize: ChatifySizes.fontSizeLg, fontWeight: FontWeight.w400)),
                          const SizedBox(width: 6),
                          Text('${widget.views}', style: TextStyle(color: ChatifyColors.white, fontSize: ChatifySizes.fontSizeLg, fontWeight: FontWeight.w400)),
                        ],
                      ),
                      TooltipTheme(
                        data: TooltipThemeData(decoration: BoxDecoration(color: context.isDarkMode ? ChatifyColors.black : ChatifyColors.white, borderRadius: BorderRadius.circular(8))),
                        child: Theme(
                          data: Theme.of(context).copyWith(splashColor: ChatifyColors.darkerGrey, highlightColor: ChatifyColors.darkerGrey, hoverColor: ChatifyColors.darkerGrey),
                          child: PopupMenuButton<int>(
                            tooltip: S.of(context).more,
                            position: PopupMenuPosition.under,
                            offset: const Offset(-6, -200),
                            menuPadding: EdgeInsets.symmetric(vertical: 4),
                            constraints: const BoxConstraints(minWidth: 0, maxWidth: 210),
                            icon: const Icon(Icons.more_vert),
                            color: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.white,
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
                            itemBuilder: (context) => [
                              PopupMenuItem(
                                value: 1,
                                padding: const EdgeInsets.symmetric(horizontal: 4),
                                child: AppPopupMenuItem(
                                  text: 'Переслать',
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                ),
                              ),
                              PopupMenuItem(
                                value: 2,
                                padding: const EdgeInsets.symmetric(horizontal: 4),
                                child: AppPopupMenuItem(
                                  text: 'Смотреть аудиторию',
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                ),
                              ),
                              PopupMenuItem(
                                value: 3,
                                padding: const EdgeInsets.symmetric(horizontal: 4),
                                child: AppPopupMenuItem(
                                  text: 'Удалить',
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              color: context.isDarkMode ? ChatifyColors.cardColor : ChatifyColors.softGrey,
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
              child: InkWell(
                splashFactory: NoSplash.splashFactory,
                splashColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
                highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
                hoverColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
                onTap: () {
                  setState(() {
                    _showViewsMenu = false;
                  });
                },
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 14),
                  child: Center(child: Text('Нет просмотров', style: TextStyle(color: ChatifyColors.darkGrey, fontSize: 13, fontWeight: FontWeight.w400))),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
