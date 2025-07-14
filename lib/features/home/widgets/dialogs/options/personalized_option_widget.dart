import 'package:chatify/utils/constants/app_sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:ionicons/ionicons.dart';
import '../../../../../common/widgets/bars/scrollbar/custom_scrollbar.dart';
import '../../../../../utils/constants/app_colors.dart';
import '../../../../../utils/constants/app_vectors.dart';
import '../../../../personalization/controllers/colors_controller.dart';
import '../../../../personalization/controllers/fonts_controller.dart';
import '../../../../personalization/controllers/themes_controller.dart';
import '../../../../utils/widgets/no_glow_scroll_behavior.dart';
import '../../../controllers/overlay_color_controller.dart';
import '../../checkboxes/custom_checkbox.dart';
import '../size_font_dialog.dart';
import 'overlays/colors_overlay_entry.dart';
import 'overlays/theme_overlay_entry.dart';

class PersonalizedOptionWidget extends StatefulWidget {
  final ValueNotifier<Color> overlayColorNotifier;

  const PersonalizedOptionWidget({super.key, required this.overlayColorNotifier});

  @override
  State<PersonalizedOptionWidget> createState() => _PersonalizedOptionWidgetState();
}

class _PersonalizedOptionWidgetState extends State<PersonalizedOptionWidget> {
  final GetStorage _storage = GetStorage();
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
  bool _isInside = false;
  bool isDropdownVisible = false;
  bool isColorAppDropdown = false;
  bool isFontDropdown = false;
  bool _isHoveredTheme = false;
  bool _isHoveredColor = false;
  bool _isHoveredFont = false;
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

  void _saveCheckboxState() {
    _storage.write('checkboxState', selectedOptions);
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
      isInsidePersonalizedOption: _isInside,
      onHoverChange: (bool isHovered) {
        setState(() {
          _isInside = isHovered;
        });
      },
      child: ScrollConfiguration(
        behavior: NoGlowScrollBehavior(),
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Персонализация", style: TextStyle(fontSize: ChatifySizes.fontSizeBg, fontWeight: FontWeight.w500)),
                const SizedBox(height: 25),
                const Text("Тема", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w300)),
                const SizedBox(height: 10),
                Text("Цветовая тема приложения", style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w300)),
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
                                  (selectedOption == 'dark')
                                  ? Transform.rotate(
                                    angle: 0.3,
                                    child: Icon(Icons.brightness_2_outlined, size: 17, color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black),
                                  )
                                  : Icon(
                                    selectedOption == 'system' ? Ionicons.settings_outline
                                      : selectedOption == 'light' ? Icons.wb_sunny_outlined
                                      : Icons.wb_sunny_outlined,
                                    size: 17,
                                    color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black,
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    selectedOption == 'light' ? 'Светлая' : selectedOption == 'dark' ? 'Темная' : 'Системная',
                                    style: TextStyle(fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w400),
                                  ),
                                ],
                              ),
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 50),
                                transform: Matrix4.translationValues(0, (_isTappedTheme || isDropdownVisible) ? 2.0 : 0, 0),
                                child: SvgPicture.asset(ChatifyVectors.arrowDown, color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black, width: 14, height: 14),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text("Цвет приложения", style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w300)),
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
                                child: SvgPicture.asset(ChatifyVectors.arrowDown, color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black, width: 14, height: 14),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 25),
                const Text("Обои чата", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w300)),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 5,
                      crossAxisSpacing: 9,
                      mainAxisSpacing: 9,
                      childAspectRatio: 1,
                    ),
                    itemCount: (context.isDarkMode ? ChatifyColors.containerColorsDark.length : ChatifyColors.containerColorsLight.length) + containerGradients.length,
                    itemBuilder: (context, index) {
                      final isSelected = selectedIndex == index;
                      final isHovered = hoveredIndex == index;
                      final totalSolidColors = context.isDarkMode ? ChatifyColors.containerColorsDark.length : ChatifyColors.containerColorsLight.length;
                      final isGradient = index >= totalSolidColors;
                      final borderColor = isSelected ? colorsController.getColor(colorsController.selectedColorScheme.value) : isHovered
                        ? context.isDarkMode ? ChatifyColors.white : ChatifyColors.darkGrey
                        : ChatifyColors.transparent;
                      final backgroundColor = context.isDarkMode ? ChatifyColors.containerColorsDark : ChatifyColors.containerColorsLight;

                      return MouseRegion(
                        onEnter: (_) {
                          setState(() {
                            hoveredIndex = index;
                            if (isGradient) {
                              final gradient = containerGradients[index - totalSolidColors];
                              final fadedGradient = LinearGradient(
                                colors: gradient.colors.map((c) => c.withAlpha((0.5 * 255).toInt())).toList(),
                                begin: gradient.begin,
                                end: gradient.end,
                              );
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
                                final fadedGradient = LinearGradient(
                                  colors: gradient.colors.map((c) => c.withAlpha((0.5 * 255).toInt())).toList(),
                                  begin: gradient.begin,
                                  end: gradient.end,
                                );
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
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Row(
                    children: [
                      CustomCheckbox(
                        selectedOptions: selectedOptions,
                        onChanged: (bool newValue) {
                          _saveCheckboxState();
                        },
                        index: 0,
                      ),
                      SizedBox(width: 10),
                      GestureDetector(
                        onTap: () {
                          selectedOptions[0] = !selectedOptions[0];
                          _saveCheckboxState();
                        },
                        child: Text('Рисунки Chatify', style: TextStyle(fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w300)),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: SizedBox(
                    width: 125,
                    height: 35,
                    child: ElevatedButton(
                      key: ValueKey('resetButton_${DateTime.now().millisecondsSinceEpoch}'),
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        foregroundColor: ChatifyColors.darkGrey,
                        backgroundColor: context.isDarkMode ? ChatifyColors.softNight : ChatifyColors.softGrey,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        side: BorderSide(color: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey, width: 1),
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      ).copyWith(
                        shadowColor: WidgetStateProperty.all(ChatifyColors.transparent),
                        mouseCursor: WidgetStateProperty.all(SystemMouseCursors.basic),
                      ),
                      child: Text(
                        'Сброс',
                        style: TextStyle(fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w300, color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Text("Размер шрифта", style: TextStyle(fontSize: ChatifySizes.fontSizeLg, fontWeight: FontWeight.w300)),
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
                                return Text(
                                  fontsController.getFontDescription(FontsController.instance.selectedFont.value),
                                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w300, fontFamily: 'Roboto'),
                                );
                              }),
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 50),
                                transform: Matrix4.translationValues(0, (_isTappedFont || isFontDropdown) ? 2.0 : 0, 0),
                                child: SvgPicture.asset(ChatifyVectors.arrowDown, color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black, width: 14, height: 14),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Text("Увеличить или уменьшить размер шрифта можно с помощью клавиш Ctrl +/-", style: TextStyle(fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w300)),
                SizedBox(height: 12),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
