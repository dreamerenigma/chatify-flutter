import 'dart:developer';
import 'dart:ui' as ui;
import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:chatify/features/utils/widgets/scrolls/no_glow_scroll_behavior.dart';
import 'package:chatify/utils/constants/app_keys.dart';
import 'package:chatify/utils/constants/app_vectors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../../../core/enums/snack_bar_position_type.dart';
import '../../../../generated/l10n/l10n.dart';
import '../../../../provider/wallpaper_provider.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../../utils/popups/dialogs.dart';
import '../../../chat/widgets/painters/triangle_painter.dart';
import '../../widgets/dialogs/color_scheme_bottom_sheet_dialog.dart';
import '../../widgets/dialogs/light_dialog.dart';
import '../../widgets/sliders/custom_slider.dart';

class ViewWallpaperScreen extends StatefulWidget {
  final String imagePath;
  final String wallpaperKey;
  final bool isDefaultWallpaper;

  const ViewWallpaperScreen({
    super.key,
    required this.imagePath,
    required this.wallpaperKey,
    required this.isDefaultWallpaper,
  });

  @override
  State<ViewWallpaperScreen> createState() => _ViewWallpaperScreenState();
}

class _ViewWallpaperScreenState extends State<ViewWallpaperScreen> {
  final List<String> solidColorAssets = List.generate(20, (index) => 'assets/images/solid_colors/solid_color_${index + 1}.png');
  final GetStorage storage = GetStorage();
  late final PageController _pageController;
  late double textTopPosition;
  late Future<ui.Image> selectedTailImageFuture;
  late int currentPageIndex;
  bool isBrightnessEnabled = true;
  double brightnessValue = 0.5;
  int selectedColorIndex = 0;
  List<String> wallpaperAssets = [];

  String get selectedChatColorAsset => solidColorAssets[selectedColorIndex];

  @override
  void initState() {
    super.initState();
    currentPageIndex = wallpaperAssets.indexOf(widget.imagePath);
    if (currentPageIndex < 0) currentPageIndex = 0;
    _pageController = PageController(initialPage: currentPageIndex);
    textTopPosition = widget.isDefaultWallpaper ? 100 : 115;
    selectedColorIndex = storage.read<int>(AppKeys.selectedColorIndexKey) ?? 0;
    selectedColorIndex = selectedColorIndex.clamp(0, solidColorAssets.length - 1);
    selectedTailImageFuture = _loadAssetImage(solidColorAssets[selectedColorIndex]);
    _loadWallpapers();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void saveImagePath(String imagePath) {
    storage.write(AppKeys.storageKey, imagePath);
  }

  Future<ui.Image> _loadAssetImage(String assetPath) async {
    final data = await rootBundle.load(assetPath);
    final codec = await ui.instantiateImageCodec(data.buffer.asUint8List());
    final frame = await codec.getNextFrame();

    return frame.image;
  }

  Future<void> _loadWallpapers() async {
    try {
      final manifest = await AssetManifest.loadFromAssetBundle(rootBundle);
      final assets = manifest.listAssets();
      final wallpaperPaths = assets.where((path) => path.toLowerCase().contains('wallpapers')).toList();

      for (final path in wallpaperPaths) {
        log('   📄 $path');
      }

      final files = wallpaperPaths.where((path) {
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
        wallpaperAssets = files;

        currentPageIndex = wallpaperAssets.indexOf(widget.imagePath);

        if (currentPageIndex < 0) {
          currentPageIndex = 0;
        }
      });

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted || !_pageController.hasClients) return;
        if (wallpaperAssets.isEmpty) return;

        _pageController.jumpToPage(currentPageIndex);
      });
    } catch (error, stackTrace) {
      log('❌ Ошибка загрузки обоев: $error');
      debugPrintStack(stackTrace: stackTrace);

      if (!mounted) return;

      setState(() {
        wallpaperAssets = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final displayText = widget.isDefaultWallpaper ? S.of(context).defaultAppWallpaper : S.of(context).swipeLeftViewMoreWallpapers;

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        elevation: 0,
        title: Text(S.of(context).view, style: TextStyle(fontSize: ChatifySizes.fontSizeMg, fontWeight: FontWeight.w400)),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: GestureDetector(
              onTap: () async {
                if (wallpaperAssets.isEmpty) return;

                final selectedWallpaper = wallpaperAssets[currentPageIndex];

                await context.read<WallpaperProvider>().setBackgroundImage(wallpaperKey: widget.wallpaperKey, imagePath: selectedWallpaper);

                if (!context.mounted) return;
                Navigator.pop(context);

                CustomIconSnackBar.showAnimatedSnackBar(
                  context,
                  'Картинка фона установлена',
                  icon: const Icon(BootstrapIcons.check_circle),
                  iconColor: ChatifyColors.success,
                  position: SnackBarPositionType.bottom,
                  offset: 20,
                );
              },
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(shape: BoxShape.circle, color: colorsController.getColor(colorsController.selectedColorScheme.value)),
                child: Center(child: Icon(Icons.check_rounded, size: 25, color: ChatifyColors.black)),
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          /// -- Фоновая картинка
          ScrollConfiguration(
            behavior: NoGlowScrollBehavior(),
            child: PageView.builder(
              controller: _pageController,
              itemCount: wallpaperAssets.length,
              onPageChanged: (index) {
                setState(() {
                  currentPageIndex = index;
                });
              },
              itemBuilder: (context, index) {
                return Container(
                  color: ChatifyColors.black,
                  child: SizedBox.expand(child: Image.asset(wallpaperAssets[index], fit: BoxFit.cover, width: double.infinity, height: double.infinity)),
                );
              },
            ),
          ),
          /// -- Слой регулировки яркости
          Positioned.fill(child: IgnorePointer(child: Container(color: Colors.black.withValues(alpha: isBrightnessEnabled ? 1.0 - brightnessValue : 0.0)))),
          Positioned(
            top: 5,
            left: 0,
            right: 0,
            child: Align(
              alignment: Alignment.topCenter,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                margin: const EdgeInsets.only(top: 4),
                decoration: BoxDecoration(
                  color: context.isDarkMode ? ChatifyColors.popupColorDark : ChatifyColors.white,
                  borderRadius: BorderRadius.circular(9),
                  boxShadow: [BoxShadow(color: ChatifyColors.black.withAlpha((0.1 * 255).toInt()), blurRadius: 3, spreadRadius: 1)],
                ),
                child: Text(S.of(context).today, style: TextStyle(color: context.isDarkMode ? ChatifyColors.borderPrimary : ChatifyColors.textSecondary, fontSize: ChatifySizes.fontSizeLm)),
              ),
            ),
          ),
          Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                top: 45,
                left: 0,
                right: 0,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    width: 280,
                    padding: const EdgeInsets.only(left: 10, right: 10, top: 6, bottom: 6),
                    margin: const EdgeInsets.only(left: 16, right: 16, top: 4),
                    decoration: BoxDecoration(
                      color: context.isDarkMode ? ChatifyColors.popupColorDark : ChatifyColors.white,
                      borderRadius: const BorderRadius.only(topRight: Radius.circular(12), bottomLeft: Radius.circular(12), bottomRight: Radius.circular(12)),
                      boxShadow: [BoxShadow(color: ChatifyColors.black.withAlpha((0.1 * 255).toInt()), blurRadius: 3, spreadRadius: 1)],
                    ),
                    child: IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            child: Text(
                              displayText,
                              style: TextStyle(fontSize: ChatifySizes.fontSizeMd, color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                DateFormat('HH:mm').format(DateTime.now()),
                                style: TextStyle(color: ChatifyColors.borderPrimary, fontSize: 13, fontWeight: FontWeight.w400),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 49,
                left: 7,
                child: _buildMessageTail(
                  isRight: false,
                  fillColor: context.isDarkMode ? ChatifyColors.popupColorDark : ChatifyColors.white,
                  borderColor: ChatifyColors.transparent,
                ),
              ),
              Positioned(
                top: textTopPosition + 25,
                left: 0,
                right: 0,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    width: 280,
                    padding: const EdgeInsets.only(left: 10, right: 10, top: 6, bottom: 6),
                    margin: const EdgeInsets.only(left: 16, right: 16, top: 4),
                    decoration: BoxDecoration(
                      image: DecorationImage(image: AssetImage(solidColorAssets[selectedColorIndex]), fit: BoxFit.cover),
                      borderRadius: const BorderRadius.only(topLeft: Radius.circular(12), bottomLeft: Radius.circular(12), bottomRight: Radius.circular(12)),
                      boxShadow: [BoxShadow(color: ChatifyColors.black.withAlpha((0.1 * 255).toInt()), blurRadius: 3, spreadRadius: 1)],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          child: Text('Ваша тема чата по умолчанию будет заменена. Только вы видите свои темы чатов.',
                            style: TextStyle(fontSize: ChatifySizes.fontSizeMd, color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              DateFormat('HH:mm').format(DateTime.now()),
                              style: TextStyle(color: ChatifyColors.borderPrimary, fontSize: 13, fontWeight: FontWeight.w400),
                            ),
                            const SizedBox(width: 4),
                            SvgPicture.asset(ChatifyVectors.doubleCheck, width: 18, height: 18, colorFilter: ColorFilter.mode(ChatifyColors.lightBlue, BlendMode.srcIn)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                top: textTopPosition + 29,
                right: 7,
                child: _buildMessageTail(
                  isRight: true,
                  imageFuture: selectedTailImageFuture,
                  borderColor: ChatifyColors.transparent,
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Align(alignment: Alignment.bottomCenter, child: _buildColorChatTheme()),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: ChatifyColors.white,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: SmoothPageIndicator(
                        controller: _pageController,
                        count: wallpaperAssets.length,
                        effect: ScrollingDotsEffect(
                          maxVisibleDots: 7,
                          dotWidth: 6,
                          dotHeight: 6,
                          spacing: 10,
                          activeDotColor: ChatifyColors.black,
                          dotColor: ChatifyColors.borderSecondary,
                        ),
                      ),
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (isBrightnessEnabled) ...[
                        _buildVerticalSlider(),
                        const SizedBox(height: 12),
                      ],
                      const SizedBox(height: 12),
                      _buildRoundButton(
                        child: SvgPicture.asset(isBrightnessEnabled ? ChatifyVectors.brightness : ChatifyVectors.moon, width: 29, height: 29, colorFilter: const ColorFilter.mode(ChatifyColors.black, BlendMode.srcIn)),
                        onTap: () {
                          setState(() {
                            isBrightnessEnabled = !isBrightnessEnabled;
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageTail({required bool isRight, Future<ui.Image>? imageFuture, Color? fillColor, required Color borderColor}) {
    Widget buildTail({ui.Image? image}) {
      return CustomPaint(
        size: const Size(10, 10),
        painter: TrianglePainter(image: image, fillColor: fillColor ?? ChatifyColors.transparent, borderColor: borderColor),
      );
    }

    return Transform(
      alignment: Alignment.center,
      transform: Matrix4.identity()..scaleByDouble(isRight ? 1.0 : -1.0, 1.0, 1.0, 1.0),
      child: imageFuture != null
        ? FutureBuilder<ui.Image>(
            future: imageFuture,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return buildTail(image: snapshot.data!);
              }

              return buildTail();
            },
          )
        : buildTail(),
    );
  }

  Widget _buildColorChatTheme() {
    final selectedColorAsset = solidColorAssets[selectedColorIndex];

    return GestureDetector(
      onTap: () {
        showColorSchemeBottomSheetDialog(
          context,
          colorAssets: solidColorAssets,
          selectedColorIndex: selectedColorIndex,
          onColorSelected: (index) async {
            final imageFuture = _loadAssetImage(solidColorAssets[index]);
            final image = await imageFuture;

            if (!mounted) return;

            setState(() {
              selectedColorIndex = index;
              selectedTailImageFuture = Future.value(image);
            });

            await storage.write(AppKeys.selectedColorIndexKey, index);
          },
        );
      },
      child: Container(
        width: 52,
        height: 52,
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: ChatifyColors.white, width: 2)),
        child: ClipOval(child: Image.asset(selectedColorAsset, fit: BoxFit.cover)),
      ),
    );
  }

  Widget _buildRoundButton({required Widget child, required VoidCallback onTap}) {
    return Material(
      color: ChatifyColors.transparent,
      shape: const CircleBorder(),
      child: InkWell(
        splashFactory: NoSplash.splashFactory,
        customBorder: const CircleBorder(),
        splashColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
        highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
        hoverColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
        onTap: onTap,
        child: Container(
          width: 54,
          height: 54,
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(color: ChatifyColors.white, shape: BoxShape.circle),
          child: Center(child: child),
        ),
      ),
    );
  }

  Widget _buildVerticalSlider() {
    return Container(
      width: 54,
      height: 230,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: ChatifyColors.white, borderRadius: BorderRadius.circular(30)),
      child: RotatedBox(
        quarterTurns: 3,
        child: CustomSlider(
          value: brightnessValue,
          onChanged: (value) {
            setState(() {
              brightnessValue = value;
            });
          },
        ),
      ),
    );
  }
}
