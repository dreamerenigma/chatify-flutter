import 'dart:developer';

import 'package:chatify/features/personalization/screens/chats/wallpaper_screen.dart';
import 'package:chatify/features/utils/widgets/scrolls/no_glow_scroll_behavior.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../../generated/l10n/l10n.dart';
import '../../../../routes/custom_page_route.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../../utils/constants/app_vectors.dart';
import '../../../calls/widgets/popups/items/app_popup_menu_item.dart';
import '../../../chat/models/chat_theme_target.dart';
import '../../../chat/widgets/painters/triangle_painter.dart';
import '../../widgets/dialogs/light_dialog.dart';
import 'color_scheme_chat_screen.dart';

class ThemeChatScreen extends StatefulWidget {
  final String? imagePath;
  final ChatThemeTarget target;
  final String wallpaperKey;

  const ThemeChatScreen({
    super.key,
    required this.imagePath,
    required this.target,
    required this.wallpaperKey,
  });

  @override
  State<ThemeChatScreen> createState() => _ThemeChatScreenState();
}

class _ThemeChatScreenState extends State<ThemeChatScreen> {
  final box = GetStorage();
  late String imagePath;
  double sliderValue = 0;
  String? selectedWallpaper;
  List<String> wallpaperAssets = [];

  @override
  void initState() {
    super.initState();
    imagePath = box.read<String>('backgroundImagePath') ?? widget.imagePath ?? '';
    log('Theme target ID: ${widget.target.id}');
    log('Theme target type: ${widget.target.type}');
    log('Wallpaper key: ${widget.wallpaperKey}');
    log('Loaded wallpaper: $imagePath');
    _loadWallpaperAssets();
  }

  Future<void> _loadWallpaperAssets() async {
    final manifest = await AssetManifest.loadFromAssetBundle(rootBundle);
    final assets = manifest.listAssets();

    final files = assets.where((path) {
      final fileName = path.split('/').last.toLowerCase();

      return path.startsWith('assets/images/wallpapers/') && RegExp(r'\.(jpg|jpeg|png|webp)$').hasMatch(fileName);
    }).toList();

    files.sort();

    if (!mounted) return;

    setState(() {
      wallpaperAssets = files;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        elevation: 0,
        title: Text('Тема чата', style: TextStyle(fontSize: ChatifySizes.fontSizeMg, fontWeight: FontWeight.w400)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, size: 25),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
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
                constraints: const BoxConstraints(minWidth: 0, maxWidth: 190),
                icon: const Icon(Icons.more_vert, size: 25),
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
                      icon: Transform.flip(flipX: true, child: Icon(Icons.refresh, size: 27, color: ChatifyColors.darkGrey)),
                      text: 'Сбросить тему',
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
      body: ScrollbarTheme(
        data: ScrollbarThemeData(thumbColor: WidgetStateProperty.all(ChatifyColors.darkerGrey)),
        child: Scrollbar(
          thickness: 4,
          thumbVisibility: false,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text('Темы', style: TextStyle(color: ChatifyColors.darkGrey, fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w400)),
                  ),
                  const SizedBox(height: 12),
                if (wallpaperAssets.isEmpty)
                  SizedBox(height: 250, child: Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(colorsController.getColor(colorsController.selectedColorScheme.value)), strokeWidth: 3)))
                else
                  SizedBox(
                    height: 260,
                    child: ScrollConfiguration(
                      behavior: NoGlowScrollBehavior(),
                      child: GridView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        physics: const ClampingScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, mainAxisSpacing: 14, crossAxisSpacing: 14, childAspectRatio: 1.33),
                        itemCount: wallpaperAssets.length,
                        itemBuilder: (context, index) {
                          final imagePath = wallpaperAssets[index];
                          final isSelected = selectedWallpaper == imagePath;
                          final accentColor = colorsController.getColor(colorsController.selectedColorScheme.value);

                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedWallpaper = imagePath;
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: isSelected ? accentColor : ChatifyColors.darkerGrey.withValues(alpha: 0.15), width: 2),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(2),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Stack(
                                    fit: StackFit.expand,
                                    children: [
                                      Image.asset(
                                        imagePath,
                                        fit: BoxFit.cover,
                                        cacheWidth: 220,
                                        errorBuilder: (context, error, stackTrace) {
                                          return Center(child: Icon(Icons.broken_image_outlined, size: 25, color: ChatifyColors.darkGrey));
                                        },
                                      ),
                                      Positioned(
                                        top: 14,
                                        left: 8,
                                        right: 35,
                                        child: Align(
                                          alignment: Alignment.topLeft,
                                          child: Stack(
                                            clipBehavior: Clip.none,
                                            children: [
                                              Container(
                                                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 10),
                                                decoration: BoxDecoration(
                                                  color: ChatifyColors.white,
                                                  borderRadius: const BorderRadius.only(
                                                    topLeft: Radius.zero,
                                                    topRight: Radius.circular(4),
                                                    bottomLeft: Radius.circular(4),
                                                    bottomRight: Radius.circular(4),
                                                  ),
                                                ),
                                              ),
                                              Positioned(
                                                left: -5,
                                                top: 0.5,
                                                child: _buildMessageTail(isRight: false, fillColor: ChatifyColors.white, borderColor: ChatifyColors.white),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        top: 40,
                                        left: 35,
                                        right: 8,
                                        child: Align(
                                          alignment: Alignment.topRight,
                                          child: Stack(
                                            clipBehavior: Clip.none,
                                            children: [
                                              Container(
                                                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 10),
                                                decoration: BoxDecoration(
                                                  color: ChatifyColors.ascentBlue,
                                                  borderRadius: const BorderRadius.only(
                                                    topLeft: Radius.circular(4),
                                                    topRight: Radius.zero,
                                                    bottomLeft: Radius.circular(4),
                                                    bottomRight: Radius.circular(4),
                                                  ),
                                                ),
                                              ),
                                              Positioned(
                                                right: -5,
                                                top: 0.5,
                                                child: _buildMessageTail(isRight: true, fillColor: ChatifyColors.ascentBlue, borderColor: ChatifyColors.ascentBlue),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      if (isSelected)
                                        Positioned(
                                          bottom: 10,
                                          left: 0,
                                          right: 0,
                                          child: Center(
                                            child: Container(
                                              width: 21,
                                              height: 21,
                                              decoration: BoxDecoration(color: ChatifyColors.white, shape: BoxShape.circle),
                                              alignment: Alignment.center,
                                              child: SvgPicture.asset(ChatifyVectors.check, width: 15, height: 15, colorFilter: ColorFilter.mode(ChatifyColors.black, BlendMode.srcIn)),
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                const SizedBox(height: 20),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text('Измениться и значок чата, и обои.', style: TextStyle(color: ChatifyColors.darkGrey, fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w400)),
                ),
                const SizedBox(height: 25),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text('Настроить', style: TextStyle(color: ChatifyColors.darkGrey, fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w400)),
                ),
                const SizedBox(height: 4),
                _buildOptionWallpaper(
                  context,
                  title: 'Значок чата',
                  svgIcon: ChatifyVectors.messageOutline,
                  onTap: () {
                    Navigator.push(context, createPageRoute(ColorSchemeChatScreen()));
                  },
                ),
                _buildOptionWallpaper(
                  context,
                  title: S.of(context).wallpaper,
                  icon: Icons.wallpaper,
                  onTap: () {
                    Navigator.push(context, createPageRoute(WallpaperScreen(wallpaperKey: widget.wallpaperKey)));
                  }
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOptionWallpaper(BuildContext context, {required String title, IconData? icon, String? svgIcon, required VoidCallback onTap}) {
    return Material(
      color: ChatifyColors.transparent,
      child: InkWell(
        splashFactory: NoSplash.splashFactory,
        splashColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
        highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
        hoverColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              if (svgIcon != null)
                SizedBox(width: 27, height: 27, child: SvgPicture.asset(svgIcon, width: 24, height: 24, colorFilter: ColorFilter.mode(ChatifyColors.darkGrey, BlendMode.srcIn)))
              else
                SizedBox(width: 27, height: 27, child: Icon(icon, size: 24, color: ChatifyColors.darkGrey)),
              const SizedBox(width: 20),
              Text(title, style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMessageTail({required bool isRight, required Color fillColor, required Color borderColor}) {
    return Transform(alignment: Alignment.center,
      transform: Matrix4.identity()..scaleByDouble(isRight ? 1.0 : -1.0, 1.0, 1.0, 1.0),
      child: CustomPaint(size: const Size(7, 7), painter: TrianglePainter(fillColor: fillColor, borderColor: borderColor)),
    );
  }
}
