import 'dart:developer';
import 'package:chatify/features/personalization/screens/chats/solid_colors_screen.dart';
import 'package:chatify/features/personalization/screens/chats/view_wallpaper_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_utils/src/extensions/context_extensions.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../../generated/l10n/l10n.dart';
import '../../../../routes/custom_page_route.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../../utils/constants/app_vectors.dart';
import '../../../calls/widgets/popups/items/app_popup_menu_item.dart';
import '../../../utils/widgets/scrolls/no_glow_scroll_behavior.dart';
import '../../widgets/dialogs/light_dialog.dart';

class WallpaperScreen extends StatefulWidget {
  final String wallpaperKey;

  const WallpaperScreen({
    super.key,
    required this.wallpaperKey,
  });

  @override
  State<WallpaperScreen> createState() => _WallpaperScreenState();
}

class _WallpaperScreenState extends State<WallpaperScreen> {
  List<String> wallpapers = [];
  String? selectedWallpaper;

  @override
  void initState() {
    super.initState();
    _loadWallpapers();
  }

  Future<void> _loadWallpapers() async {
    try {
      final manifest = await AssetManifest.loadFromAssetBundle(rootBundle);
      final assets = manifest.listAssets();
      final wallpaperAssets = assets.where((path) => path.toLowerCase().contains('wallpapers')).toList();

      for (final path in wallpaperAssets) {
        log('   📄 $path');
      }

      final files = wallpaperAssets.where((path) {
        final fileName = path.split('/').last;
        final matches = path.startsWith('assets/images/wallpapers/') && RegExp(r'^(light|dark)_\d+\.jpe?g$', caseSensitive: false).hasMatch(fileName);

        return matches;
      }).toList();

      int groupOrder(String path) {
        final fileName = path.split('/').last.toLowerCase();

        return fileName.startsWith('light_') ? 0 : 1;
      }

      int fileNumber(String path) {
        final fileName = path.split('/').last;
        final match = RegExp(r'_(\d+)\.').firstMatch(fileName);

        return int.tryParse(match?.group(1) ?? '') ?? 0;
      }

      files.sort((a, b) {
        final groupComparison = groupOrder(a).compareTo(groupOrder(b));

        if (groupComparison != 0) {
          return groupComparison;
        }

        return fileNumber(a).compareTo(fileNumber(b));
      });

      for (final path in files) {
        log('   🖼️ $path');
      }

      if (!mounted) return;

      setState(() {
        wallpapers = files;
      });
    } catch (error, stackTrace) {
      log('❌ Ошибка загрузки обоев: $error');
      debugPrintStack(stackTrace: stackTrace);

      if (!mounted) return;

      setState(() {
        wallpapers = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        elevation: 0,
        title: Text(S.of(context).wallpapers, style: TextStyle(fontSize: ChatifySizes.fontSizeMg, fontWeight: FontWeight.w400)),
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
                constraints: const BoxConstraints(minWidth: 0, maxWidth: 340),
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
                      icon: Transform.flip(flipX: true, child: Icon(Icons.refresh, size: 27, color: ChatifyColors.darkGrey)),
                      text: 'Установить обои по умолчанию',
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
      body: Column(
        children: [
          _buildOptionWallpaper(
            context,
            icon: Icons.collections_outlined,
            title: 'Выбрать из галереи',
            onTap: () {},
          ),
          _buildOptionWallpaper(
            context,
            icon: LucideIcons.pipette,
            title: 'Установить цвет',
            onTap: () {
              Navigator.push(context, createPageRoute(SolidColorsScreen()));
            },
          ),
          Expanded(
            child: wallpapers.isEmpty
              ? Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(colorsController.getColor(colorsController.selectedColorScheme.value)), strokeWidth: 3))
              : ScrollConfiguration(
                behavior: NoGlowScrollBehavior(),
                child: GridView.builder(
                  padding: const EdgeInsets.all(14),
                  itemCount: wallpapers.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 22, mainAxisSpacing: 22, childAspectRatio: 0.64),
                  itemBuilder: (context, index) {
                    final path = wallpapers[index];
                    final isSelected = selectedWallpaper == path;

                    return GestureDetector(
                      key: ValueKey(path),
                      onTap: () {
                        setState(() {
                          selectedWallpaper = path;
                        });

                        Navigator.push(context, MaterialPageRoute(builder: (_) => ViewWallpaperScreen(imagePath: path, wallpaperKey: widget.wallpaperKey, isDefaultWallpaper: false)));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18),
                          border: isSelected ? Border.all(color: ChatifyColors.white, width: 3) : Border.all(color: ChatifyColors.transparent, width: 3),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(3),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                Image.asset(
                                  path,
                                  fit: BoxFit.cover,
                                  cacheWidth: 300,
                                  cacheHeight: 420,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Center(child: Icon(Icons.broken_image_outlined, size: 25));
                                  },
                                ),
                                if (isSelected)
                                  ColoredBox(color: Colors.black.withAlpha(35)),
                                if (isSelected)
                                  Positioned(
                                    bottom: 10,
                                    left: 0,
                                    right: 0,
                                    child: Center(
                                      child: Container(
                                        width: 21,
                                        height: 21,
                                        decoration: BoxDecoration(
                                          color: ChatifyColors.black,
                                          shape: BoxShape.circle,
                                          boxShadow: [BoxShadow(color: ChatifyColors.black.withAlpha(45), blurRadius: 5, offset: const Offset(0, 2))],
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(4),
                                          child: SvgPicture.asset(ChatifyVectors.check, width: 15, height: 15, colorFilter: ColorFilter.mode(ChatifyColors.white, BlendMode.srcIn)),
                                        ),
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
        ],
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
                SizedBox(width: 22, height: 22, child: SvgPicture.asset(svgIcon, width: 22, height: 22, colorFilter: ColorFilter.mode(ChatifyColors.darkGrey, BlendMode.srcIn)))
              else
                SizedBox(width: 22, height: 22, child: Icon(icon, size: 22, color: ChatifyColors.darkGrey)),
              const SizedBox(width: 20),
              Text(title, style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400)),
            ],
          ),
        ),
      ),
    );
  }
}
