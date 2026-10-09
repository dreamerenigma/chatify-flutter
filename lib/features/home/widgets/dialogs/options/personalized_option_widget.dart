import 'dart:developer';
import 'package:chatify/utils/constants/app_sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';
import '../../../../../api/chat_api.dart';
import '../../../../../common/widgets/bars/scrollbar/custom_scrollbar.dart';
import '../../../../../common/widgets/switches/custom_switch.dart';
import '../../../../../core/enums/custom_scrollbar_direction.dart';
import '../../../../../generated/l10n/l10n.dart';
import '../../../../../provider/wallpaper_provider.dart';
import '../../../../../utils/constants/app_colors.dart';
import '../../../../../utils/constants/app_images.dart';
import '../../../../../utils/constants/app_vectors.dart';
import '../../../../chat/models/user_model.dart';
import '../../../../personalization/controllers/colors_controller.dart';
import '../../../../personalization/controllers/fonts_controller.dart';
import '../../../../personalization/controllers/themes_controller.dart';
import '../../../../utils/widgets/dividers/custom_divider.dart';
import '../../../../utils/widgets/scrolls/no_glow_scroll_behavior.dart';
import '../../../controllers/overlay_color_controller.dart';
import '../size_font_dialog.dart';
import 'overlays/colors_overlay_entry.dart';
import 'overlays/theme_overlay_entry.dart';

class PersonalizedOptionWidget extends StatefulWidget {
  final UserModel user;
  final ValueNotifier<Color> overlayColorNotifier;

  const PersonalizedOptionWidget({
    super.key,
    required this.user,
    required this.overlayColorNotifier,
  });

  @override
  State<PersonalizedOptionWidget> createState() => _PersonalizedOptionWidgetState();
}

class _PersonalizedOptionWidgetState extends State<PersonalizedOptionWidget> {
  final ScrollController _wallpaperScrollController = ScrollController();
  final ScrollController _scrollController = ScrollController();
  final themesController = Get.put(ThemesController());
  final colorsController = Get.put(ColorsController());
  final fontsController = Get.put(FontsController());
  final overlayController = Get.put(OverlayColorController());
  final RxList<bool> selectedOptions = <bool>[false].obs;
  final LayerLink _layerThemeLink = LayerLink();
  final LayerLink _layerColorAppLink = LayerLink();
  final LayerLink _layerFontLink = LayerLink();
  bool _isTappedTheme = false;
  bool _isTappedColor = false;
  bool _isTappedFont = false;
  bool _isHovered = false;
  bool _isChatThemePage = false;
  bool isDropdownVisible = false;
  bool isColorAppDropdown = false;
  bool isFontDropdown = false;
  bool _isHoveredTheme = false;
  bool _isHoveredColor = false;
  bool _isHoveredFont = false;
  bool isPressedReset = false;
  bool _isHoveredReset = false;
  bool _useChatBackground = false;
  bool isInside = false;
  int selectedIndex = -1;
  int hoveredIndex = -1;
  String selectedOption = 'light';
  String selectedColor = 'blue';
  double selectedFont = 1.0;
  OverlayEntry? _themeOverlayEntry;
  OverlayEntry? _colorOverlayEntry;
  OverlayEntry? _fontOverlayEntry;

  final List<LinearGradient> containerGradients = [
    LinearGradient(
      colors: [Color.fromARGB(255, 131, 224, 202), Color.fromARGB(255, 102, 185, 227)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    LinearGradient(
      colors: [Color.fromARGB(255, 181, 236, 223), Color.fromARGB(255, 212, 135, 218)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    LinearGradient(
      colors: [Color.fromARGB(255, 152, 220, 181), Color.fromARGB(255, 212, 218, 133)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    LinearGradient(
      colors: [Color.fromARGB(255, 213, 141, 209), Color.fromARGB(255, 203, 109, 119)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    LinearGradient(
      colors: [Colors.red, Colors.orange, Colors.yellow, Colors.green, Colors.blue, Colors.indigo, Colors.purple],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
  ];

  List<List<String>> _getWallpaperCategories() {
    return [
      [
        ChatifyImages.wallpaperLightV1,
        ChatifyImages.wallpaperLightV2,
        ChatifyImages.wallpaperLightV3,
        ChatifyImages.wallpaperLightV4,
        ChatifyImages.wallpaperLightV5,
        ChatifyImages.wallpaperLightV6,
        ChatifyImages.wallpaperLightV7,
        ChatifyImages.wallpaperLightV8,
        ChatifyImages.wallpaperLightV9,
        ChatifyImages.wallpaperLightV10,
        ChatifyImages.wallpaperLightV11,
        ChatifyImages.wallpaperLightV12,
        ChatifyImages.wallpaperLightV13,
      ],
      [
        ChatifyImages.wallpaperDarkV1,
        ChatifyImages.wallpaperDarkV2,
        ChatifyImages.wallpaperDarkV3,
        ChatifyImages.wallpaperDarkV4,
        ChatifyImages.wallpaperDarkV5,
        ChatifyImages.wallpaperDarkV6,
        ChatifyImages.wallpaperDarkV7,
        ChatifyImages.wallpaperDarkV8,
        ChatifyImages.wallpaperDarkV9,
        ChatifyImages.wallpaperDarkV10,
        ChatifyImages.wallpaperDarkV11,
        ChatifyImages.wallpaperDarkV12,
        ChatifyImages.wallpaperDarkV13,
        ChatifyImages.wallpaperDarkV14,
      ],
      [
        ChatifyImages.wallpaperSolidV1,
        ChatifyImages.wallpaperSolidV2,
        ChatifyImages.wallpaperSolidV3,
        ChatifyImages.wallpaperSolidV4,
        ChatifyImages.wallpaperSolidV5,
        ChatifyImages.wallpaperSolidV6,
        ChatifyImages.wallpaperSolidV7,
        ChatifyImages.wallpaperSolidV8,
        ChatifyImages.wallpaperSolidV9,
        ChatifyImages.wallpaperSolidV10,
        ChatifyImages.wallpaperSolidV11,
        ChatifyImages.wallpaperSolidV12,
        ChatifyImages.wallpaperSolidV13,
        ChatifyImages.wallpaperSolidV14,
        ChatifyImages.wallpaperSolidV15,
        ChatifyImages.wallpaperSolidV16,
        ChatifyImages.wallpaperSolidV17,
        ChatifyImages.wallpaperSolidV18,
        ChatifyImages.wallpaperSolidV19,
        ChatifyImages.wallpaperSolidV20,
        ChatifyImages.wallpaperSolidV21,
        ChatifyImages.wallpaperSolidV22,
        ChatifyImages.wallpaperSolidV23,
        ChatifyImages.wallpaperSolidV24,
        ChatifyImages.wallpaperSolidV25,
        ChatifyImages.wallpaperSolidV26,
        ChatifyImages.wallpaperSolidV27,
      ],
    ];
  }

  @override
  void initState() {
    super.initState();
    final box = GetStorage();
    String? savedTheme = box.read('selectedTheme');
    if (savedTheme != null) {
      setState(() {
        selectedOption = savedTheme;
      });
    }
    String? savedColor = box.read('selectedColor');
    if (savedColor != null) {
      setState(() {
        selectedColor = savedColor;
      });
    }
    int? savedIndex = box.read('selected_index');
    if (savedIndex != null) {
      setState(() {
        selectedIndex = savedIndex;
      });
    }
    double? savedFont = FontsController.instance.loadSavedFont();
    if (savedFont != null) {
      fontsController.setFont(savedFont);
    }
    List<dynamic>? savedCheckboxState = box.read('checkboxState');
    if (savedCheckboxState != null) {
      setState(() {
        selectedOptions.assignAll(List<bool>.from(savedCheckboxState));
      });
    }
  }

  @override
  void dispose() {
    _hideThemeOverlay();
    _hideColorOverlay();
    _hideFontOverlay();
    super.dispose();
  }

  void _showThemeOverlay() {
    _hideThemeOverlay();
    _themeOverlayEntry = createThemeOverlayEntry(
      context: context,
      layerLink: _layerThemeLink,
      selectedOption: selectedOption,
      onThemeSelected: (theme) {
        setState(() => selectedOption = theme);
        _saveSelectedTheme(theme);
        themesController.setTheme(theme);
      },
      hideOverlay: _hideThemeOverlay,
    );
    Overlay.of(context).insert(_themeOverlayEntry!);
    isDropdownVisible = true;
  }

  void _hideThemeOverlay() {
    _themeOverlayEntry?.remove();
    _themeOverlayEntry = null;
    isDropdownVisible = false;
  }

  void _showColorOverlay() {
    _hideColorOverlay();
    _colorOverlayEntry = createColorOverlayEntry(
      context: context,
      layerLink: _layerColorAppLink,
      selectedOption: selectedColor,
      onThemeSelected: (color) {
        setState(() => selectedColor = color);
        _saveSelectedColor(color);
        colorsController.setColorScheme(color);
      },
      hideOverlay: _hideColorOverlay,
    );
    Overlay.of(context).insert(_colorOverlayEntry!);
    isColorAppDropdown = true;
  }

  void _hideColorOverlay() {
    _colorOverlayEntry?.remove();
    _colorOverlayEntry = null;
    isColorAppDropdown = false;
  }

  void _showFontOverlay() {
    _hideFontOverlay();
    _fontOverlayEntry = createFontOverlayEntry(
      context: context,
      layerLink: _layerFontLink,
      selectedOption: selectedFont,
      onThemeSelected: (font) {
        setState(() => selectedFont = font);
        fontsController.saveSelectedFont(font);
        fontsController.setFont(font);
      },
      hideOverlay: _hideFontOverlay,
    );
    Overlay.of(context).insert(_fontOverlayEntry!);
    isFontDropdown = true;
  }

  void _hideFontOverlay() {
    _fontOverlayEntry?.remove();
    _fontOverlayEntry = null;
    isFontDropdown = false;
  }

  void _toggleDropdown() {
    if (isDropdownVisible) {
      _hideThemeOverlay();
    } else {
      _showThemeOverlay();
    }
  }

  void _toggleColorAppDropdown() {
    if (isColorAppDropdown) {
      _hideColorOverlay();
    } else {
      _showColorOverlay();
    }
  }

  void _toggleFontDropdown() {
    if (isFontDropdown) {
      _hideFontOverlay();
    } else {
      _showFontOverlay();
    }
  }

  void _saveSelectedTheme(String theme) {
    final box = GetStorage();
    box.write('selectedTheme', theme);
  }

  void _saveSelectedColor(String color) {
    final box = GetStorage();
    box.write('selectedColor', color);
  }

  void updateSelectedIndex(int index) {
    setState(() {
      selectedIndex = index;
    });
    final box = GetStorage();
    box.write('selected_index', index);
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollbar(
      scrollController: _scrollController,
      isInsidePersonalizedOption: _isHovered,
      onHoverChange: (bool isHovered) {
        setState(() {
          _isHovered = isHovered;
        });
      },
      child: ScrollConfiguration(
        behavior: NoGlowScrollBehavior(),
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _isChatThemePage ? _buildChatTheme() : _buildPersonalization(),
          ),
        ),
      ),
    );
  }

  Widget _buildPersonalization() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(S.of(context).personalization, style: TextStyle(fontSize: ChatifySizes.fontSizeBg, fontWeight: FontWeight.w500)),
        const SizedBox(height: 25),
        Text(S.of(context).theme, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w300)),
        const SizedBox(height: 10),
        Text(S.of(context).appColorTheme, style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w300)),
        const SizedBox(height: 10),
        CompositedTransformTarget(
          link: _layerThemeLink,
          child: GestureDetector(
            onTap: _toggleDropdown,
            onLongPress: () {
              setState(() {
                _isTappedTheme = true;
              });
            },
            onLongPressEnd: (_) {
              setState(() {
                _isTappedTheme = false;
              });
            },
            onLongPressUp: () {
              setState(() {
                _isTappedTheme = false;
              });
            },
            child: MouseRegion(
              onEnter: (_) {
                setState(() {
                  _isHoveredTheme = true;
                });
              },
              onExit: (_) {
                setState(() {
                  _isHoveredTheme = false;
                });
              },
              child: Container(
                width: 200,
                height: 33,
                decoration: BoxDecoration(
                  color: _isTappedTheme ? (context.isDarkMode ? ChatifyColors.mildNight : ChatifyColors.grey.withAlpha(100)) : _isHoveredTheme
                      ? (context.isDarkMode ? ChatifyColors.lightSoftNight.withAlpha((0.8 * 255).toInt()) : ChatifyColors.black.withAlpha((0.3 * 255).toInt()))
                      : (context.isDarkMode ? ChatifyColors.softNight : ChatifyColors.white),
                  borderRadius: isDropdownVisible ? BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8)) : BorderRadius.circular(6),
                  border: Border.all(color: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 16, right: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          if (selectedOption == 'dark')
                            Transform.rotate(angle: 0.3, child: Icon(Icons.brightness_2_outlined, size: 17, color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black))
                          else if (selectedOption == 'system')
                            SvgPicture.asset(ChatifyVectors.settingsOutline, width: 17, height: 17, colorFilter: ColorFilter.mode(context.isDarkMode ? ChatifyColors.white : ChatifyColors.black, BlendMode.srcIn))
                          else
                            Icon(Icons.wb_sunny_outlined, size: 17, color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black),
                          const SizedBox(width: 10),
                          Text(
                            selectedOption == 'light' ? S.of(context).light : selectedOption == 'dark' ? S.of(context).dark : S.of(context).systemTheme,
                            style: TextStyle(fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w400),
                          ),
                        ],
                      ),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 50),
                        transform: Matrix4.translationValues(0, (_isTappedTheme || isDropdownVisible) ? 2.0 : 0, 0),
                        child: SvgPicture.asset(ChatifyVectors.arrowDown, width: 14, height: 14, colorFilter: ColorFilter.mode(context.isDarkMode ? ChatifyColors.white : ChatifyColors.black, BlendMode.srcIn)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        Text(S.of(context).appColor, style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w300)),
        const SizedBox(height: 10),
        CompositedTransformTarget(
          link: _layerColorAppLink,
          child: GestureDetector(
            onTap: _toggleColorAppDropdown,
            onLongPress: () {
              setState(() {
                _isTappedColor = true;
              });
            },
            onLongPressEnd: (_) {
              setState(() {
                _isTappedColor = false;
              });
            },
            onLongPressUp: () {
              setState(() {
                _isTappedColor = false;
              });
            },
            child: MouseRegion(
              onEnter: (_) {
                setState(() {
                  _isHoveredColor = true;
                });
              },
              onExit: (_) {
                setState(() {
                  _isHoveredColor = false;
                });
              },
              child: Container(
                width: 200,
                height: 33,
                decoration: BoxDecoration(
                  color: _isTappedColor ? (context.isDarkMode ? ChatifyColors.mildNight : ChatifyColors.grey.withAlpha(100)) : _isHoveredColor
                      ? (context.isDarkMode ? ChatifyColors.lightSoftNight.withAlpha((0.8 * 255).toInt()) : ChatifyColors.black.withAlpha((0.3 * 255).toInt()))
                      : (context.isDarkMode ? ChatifyColors.softNight : ChatifyColors.white),
                  borderRadius: isColorAppDropdown ? BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8)) : BorderRadius.circular(6),
                  border: Border.all(color: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 16, right: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.color_lens, size: 17, color: ColorsController.instance.getColor(ColorsController.instance.selectedColorScheme.value)),
                          const SizedBox(width: 10),
                          Text(ColorsController.instance.getColorName(), style: TextStyle(fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w400)),
                        ],
                      ),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 50),
                        transform: Matrix4.translationValues(0, (_isTappedColor || isColorAppDropdown) ? 2.0 : 0, 0),
                        child: SvgPicture.asset(ChatifyVectors.arrowDown, width: 14, height: 14, colorFilter: ColorFilter.mode(context.isDarkMode ? ChatifyColors.white : ChatifyColors.black, BlendMode.srcIn)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 25),
        Material(
          color: ChatifyColors.transparent,
          child: GestureDetector(
              onTap: () {
                setState(() {
                  _isChatThemePage = true;
                });
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(child: Text('Тема чата по умолчанию', style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400))),
                  Transform.translate(offset: const Offset(0, 1), child: const Icon(Icons.arrow_forward_ios, size: 13)),
                ],
              )
          ),
        ),
        const SizedBox(height: 25),
        Text(S.of(context).chatWallpaper, style: TextStyle(fontSize: ChatifySizes.fontSizeLg, fontWeight: FontWeight.w400)),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 5, crossAxisSpacing: 9, mainAxisSpacing: 9, childAspectRatio: 1),
            itemCount: (context.isDarkMode ? ChatifyColors.containerColorsDark.length : ChatifyColors.containerColorsLight.length) + containerGradients.length,
            itemBuilder: (context, index) {
              final isSelected = selectedIndex == index;
              final isHovered = hoveredIndex == index;
              final totalSolidColors = context.isDarkMode ? ChatifyColors.containerColorsDark.length : ChatifyColors.containerColorsLight.length;
              final isGradient = index >= totalSolidColors;
              final borderColor = isSelected ? colorsController.getColor(colorsController.selectedColorScheme.value) : isHovered ? context.isDarkMode ? ChatifyColors.white : ChatifyColors.darkGrey : ChatifyColors.transparent;
              final backgroundColor = context.isDarkMode ? ChatifyColors.containerColorsDark : ChatifyColors.containerColorsLight;

              return MouseRegion(
                onEnter: (_) {
                  setState(() {
                    hoveredIndex = index;
                    if (isGradient) {
                      final gradient = containerGradients[index - totalSolidColors];
                      final fadedGradient = LinearGradient(colors: gradient.colors.map((c) => c.withAlpha((0.5 * 255).toInt())).toList(), begin: gradient.begin, end: gradient.end);

                      overlayController.updateOverlayGradient(fadedGradient);
                    } else {
                      overlayController.updateOverlayColor(backgroundColor[index].withAlpha((0.5 * 255).toInt()));
                    }
                  });
                },
                onExit: (_) {
                  setState(() {
                    hoveredIndex = -1;
                    if (selectedIndex != -1) {
                      final isSelectedGradient = selectedIndex >= totalSolidColors;
                      if (isSelectedGradient) {
                        final gradient = containerGradients[selectedIndex - totalSolidColors];
                        final fadedGradient = LinearGradient(colors: gradient.colors.map((c) => c.withAlpha((0.5 * 255).toInt())).toList(), begin: gradient.begin, end: gradient.end);

                        overlayController.updateOverlayGradient(fadedGradient);
                      } else {
                        overlayController.updateOverlayColor(backgroundColor[selectedIndex].withAlpha((0.5 * 255).toInt()));
                      }
                    } else {
                      overlayController.resetOverlayColor(isDarkMode: context.isDarkMode);
                    }
                  });
                },
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      updateSelectedIndex(index);
                      if (isGradient) {
                        final gradient = containerGradients[index - totalSolidColors];
                        final fadedGradient = LinearGradient(colors: gradient.colors.map((c) => c.withAlpha((0.5 * 255).toInt())).toList(), begin: gradient.begin, end: gradient.end);

                        overlayController.updateOverlayGradient(fadedGradient);
                      } else {
                        overlayController.updateOverlayColor(backgroundColor[index].withAlpha((0.5 * 255).toInt()));
                      }
                    });
                  },
                  child: Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: borderColor, width: 2.5),
                          color: isGradient ? null : backgroundColor[index],
                          gradient: isGradient ? containerGradients[index - totalSolidColors] : null,
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          color: context.isDarkMode ? ChatifyColors.black.withAlpha((0.08 * 255).toInt()) : ChatifyColors.white.withAlpha((0.3 * 255).toInt()),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: SizedBox(
            width: 125,
            height: 35,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  isPressedReset = !isPressedReset;
                });
              },
              onLongPress: () {
                setState(() {
                  isPressedReset = true;
                });
              },
              onLongPressEnd: (_) {
                setState(() {
                  isPressedReset = false;
                });
              },
              onLongPressUp: () {
                setState(() {
                  isPressedReset = false;
                });
              },
              child: MouseRegion(
                onEnter: (_) {
                  setState(() {
                    _isHoveredReset = true;
                  });
                },
                onExit: (_) {
                  setState(() {
                    _isHoveredReset = false;
                  });
                },
                child: ElevatedButton(
                  key: ValueKey('resetButton_${DateTime.now().millisecondsSinceEpoch}'),
                  onPressed: () {
                    setState(() {
                      isPressedReset = !isPressedReset;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    splashFactory: NoSplash.splashFactory,
                    foregroundColor: context.isDarkMode ? ChatifyColors.mildNight : ChatifyColors.grey.withAlpha(100),
                    backgroundColor: isPressedReset ? (context.isDarkMode ? ChatifyColors.mildNight : ChatifyColors.grey.withAlpha(100)) : _isHoveredReset
                      ? (context.isDarkMode ? ChatifyColors.lightSoftNight.withAlpha((0.8 * 255).toInt()) : ChatifyColors.black.withAlpha((0.3 * 255).toInt()))
                      : (context.isDarkMode ? ChatifyColors.softNight : ChatifyColors.white),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    side: BorderSide(color: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey, width: 1),
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  ).copyWith(
                    shadowColor: WidgetStateProperty.all(ChatifyColors.transparent),
                    mouseCursor: WidgetStateProperty.all(SystemMouseCursors.basic),
                  ),
                  child: Text(
                    S.of(context).reset,
                    style: TextStyle(color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black, fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w400),
                  ),
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 16),
        Text(S.of(context).fontSize, style: TextStyle(fontSize: ChatifySizes.fontSizeLg, fontWeight: FontWeight.w400)),
        CompositedTransformTarget(
          link: _layerFontLink,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: GestureDetector(
              onTap: () => _toggleFontDropdown(),
              onLongPress: () {
                setState(() {
                  _isTappedFont = true;
                });
              },
              onLongPressEnd: (_) {
                setState(() {
                  _isTappedFont = false;
                });
              },
              onLongPressUp: () {
                setState(() {
                  _isTappedFont = false;
                });
              },
              child: MouseRegion(
                onEnter: (_) {
                  setState(() {
                    _isHoveredFont = true;
                  });
                },
                onExit: (_) {
                  setState(() {
                    _isHoveredFont = false;
                  });
                },
                child: Container(
                  width: 200,
                  height: 35,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: _isTappedFont ? (context.isDarkMode ? ChatifyColors.mildNight : ChatifyColors.grey.withAlpha(100)) : _isHoveredFont
                      ? (context.isDarkMode ? ChatifyColors.lightSoftNight.withAlpha((0.8 * 255).toInt()) : ChatifyColors.black.withAlpha((0.3 * 255).toInt()))
                      : (context.isDarkMode ? ChatifyColors.softNight : ChatifyColors.white),
                    borderRadius: isFontDropdown ? BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8)) : BorderRadius.circular(6),
                    border: Border.all(color: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Obx(() {
                        return Text(fontsController.getFontDescription(context, FontsController.instance.selectedFont.value), style: TextStyle(fontSize: 15, fontWeight: FontWeight.w300, fontFamily: 'Roboto'));
                      }),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 50),
                        transform: Matrix4.translationValues(0, (_isTappedFont || isFontDropdown) ? 2.0 : 0, 0),
                        child: SvgPicture.asset(ChatifyVectors.arrowDown, width: 14, height: 14, colorFilter: ColorFilter.mode(context.isDarkMode ? ChatifyColors.white : ChatifyColors.black, BlendMode.srcIn)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        Text(S.of(context).increaseOrDecreaseFontSize, style: TextStyle(fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w400)),
        SizedBox(height: 12),
      ],
    );
  }

  Widget _buildChatTheme() {
    final wallpapers = _getWallpaperCategories().expand<String>((category) => category).toList();

    return Align(
      alignment: Alignment.topLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    _isChatThemePage = false;
                  });
                },
                child: const Icon(Icons.arrow_back, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(child: Text('Тема чата', style: TextStyle(fontSize: ChatifySizes.fontSizeBg, fontWeight: FontWeight.w400))),
              GestureDetector(
                child: const Icon(Icons.refresh, size: 22),
                onTap: () {},
              ),
            ],
          ),
          const SizedBox(height: 25),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Темы', style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400)),
                    const SizedBox(height: 4),
                    Text(
                      'Цвет чата и обои изменятся.',
                      style: TextStyle(color: context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.darkGrey, fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Material(
                color: ChatifyColors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(35),
                  onTap: () {},
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(35), border: Border.all(color: context.isDarkMode ? ChatifyColors.darkerGrey : ChatifyColors.grey)),
                    child: Text('Смотреть все', style: TextStyle(color: colorsController.getColor(colorsController.selectedColorScheme.value), fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w400)),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          CustomScrollbar(
            scrollController: _wallpaperScrollController, isInsidePersonalizedOption: false, onHoverChange: (bool value) {},
            direction: CustomScrollbarDirectionType.horizontal,
            child: ScrollConfiguration(
              behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
              child: SizedBox(
                height: 200,
                child: GridView.builder(
                  controller: _wallpaperScrollController,
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.only(left: 4, right: 4, top: 4, bottom: 20),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, mainAxisSpacing: 8, crossAxisSpacing: 8, mainAxisExtent: 120),
                  itemCount: wallpapers.length,
                  itemBuilder: (context, index) {
                    return _buildThemePreview(wallpapers[index]);
                  },
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          _buildSwitchOption(
            icon: Icons.wallpaper_outlined,
            text: 'Использовать фон чата',
            value: _useChatBackground,
            onChanged: (value) {
              setState(() {
                _useChatBackground = value;
              });
            },
          ),
          CustomDivider(indent: 0, endIndent: 0, left: 0, right: 0, top: 20, bottom: 20, color: ChatifyColors.darkerGrey),
          _buildChatSettings(),
        ],
      ),
    );
  }

  Widget _buildThemePreview(String imagePath) {
    final wallpaperProvider = context.watch<WallpaperProvider>();
    final wallpaperKey = ChatApi.getConversationId(widget.user.id);
    final currentWallpaper = wallpaperProvider.getBackgroundImage(wallpaperKey,);
    final isSelected = currentWallpaper == imagePath;
    final themeColor = colorsController.getColor(colorsController.selectedColorScheme.value);

    log('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    log('🖼️ WALLPAPER PREVIEW');
    log('User ID: ${widget.user.id}');
    log('Wallpaper key: $wallpaperKey');
    log('Image path: $imagePath');
    log('Current wallpaper: $currentWallpaper');
    log('Is selected: $isSelected');
    log('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');

    return GestureDetector(
      onTap: () async {
        log('👉 Wallpaper tapped');
        log('👉 Key: $wallpaperKey');
        log('👉 Image: $imagePath');
        await context.read<WallpaperProvider>().setBackgroundImage(imagePath: imagePath, wallpaperKey: wallpaperKey);
        log('✅ Wallpaper saved');
        final savedWallpaper = context.read<WallpaperProvider>().getBackgroundImage(wallpaperKey);
        log('🔎 Wallpaper after save: $savedWallpaper');
        log('🔎 Match: ${savedWallpaper == imagePath}');
      },
      child: SizedBox(
        width: 120,
        height: 150,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(imagePath, fit: BoxFit.cover),
              if (isSelected)
                IgnorePointer(child: DecoratedBox(decoration: BoxDecoration(borderRadius: BorderRadius.circular(16),border: Border.all(color: themeColor, width: 2.5)))),
              if (isSelected)
                Positioned(
                  bottom: 8,
                  left: 0,
                  right: 0,
                  child: Center(child: Icon(Icons.check_circle_rounded, size: 20, color: themeColor)),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSwitchOption({required IconData icon, required String text, required bool value, required ValueChanged<bool> onChanged}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(icon, size: 20, color: ChatifyColors.darkGrey),
        const SizedBox(width: 16),
        Expanded(child: Text(text, style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400))),
        CustomSwitch(
          value: value,
          onChanged: onChanged,
          switchWidth: 55,
          switchHeight: 33,
          thumbSize: 25,
          thumbPadding: 3,
        ),
      ],
    );
  }

  Widget _buildChatSettings() {
    final wallpaperProvider = context.watch<WallpaperProvider>();
    final wallpaperKey = ChatApi.getConversationId(widget.user.id);
    final selectedWallpaper = wallpaperProvider.getBackgroundImage(wallpaperKey);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Настройки', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
        const SizedBox(height: 20),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(ChatifyVectors.messageOutline, width: 22, height: 22, colorFilter: ColorFilter.mode(ChatifyColors.darkGrey, BlendMode.srcIn)),
            const SizedBox(width: 10),
            Expanded(child: Text('Значок чата', style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400))),
            Container(
              width: 25,
              height: 25,
              decoration: BoxDecoration(shape: BoxShape.circle, color: ChatifyColors.blue, border: Border.all(color: ChatifyColors.blue, width: 2)),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(ChatifyVectors.imageOutline, width: 22, height: 22, colorFilter: ColorFilter.mode(ChatifyColors.darkGrey, BlendMode.srcIn)),
            const SizedBox(width: 10),
            Expanded(child: Text('Обои', style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400))),
            SizedBox(
              width: 44,
              height: 28,
              child: selectedWallpaper.isNotEmpty
                ? ClipRRect(borderRadius: BorderRadius.circular(7), child: Image.asset(selectedWallpaper, fit: BoxFit.cover))
                : null,
            ),
          ],
        ),
      ],
    );
  }
}
