import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../../common/widgets/switches/custom_switch.dart';
import '../../../../generated/l10n/l10n.dart';
import '../../../../routes/custom_page_route.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../utils/widgets/scrolls/no_glow_scroll_behavior.dart';
import 'animation_screen.dart';

class SpecialFeaturesScreen extends StatefulWidget {
  const SpecialFeaturesScreen({super.key});

  @override
  State<SpecialFeaturesScreen> createState() => _SpecialFeaturesScreenState();
}

class _SpecialFeaturesScreenState extends State<SpecialFeaturesScreen> {
  final storage = GetStorage();
  bool increaseContrastEnabled = false;
  bool isPressed = false;

  void _toggleSwitch(bool value) async {
    setState(() {
      increaseContrastEnabled = value;
    });

    storage.write('increaseContrastEnabled', value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration: BoxDecoration(
            color: ChatifyColors.white,
            boxShadow: [BoxShadow(color: ChatifyColors.black.withAlpha((0.1 * 255).toInt()), spreadRadius: 1, blurRadius: 3, offset: const Offset(0, 1))],
          ),
          child: AppBar(
            title: Text(S.of(context).specialFeatures, style: TextStyle(fontSize: ChatifySizes.fontSizeMg, fontWeight: FontWeight.w400)),
            titleSpacing: 5,
            backgroundColor: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.white,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_rounded, size: 25),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ),
      ),
      body: ScrollConfiguration(
        behavior: NoGlowScrollBehavior(),
        child: ScrollbarTheme(
          data: ScrollbarThemeData(thumbColor: WidgetStateProperty.all(ChatifyColors.darkerGrey)),
          child: Scrollbar(
            thickness: 4,
            thumbVisibility: false,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 6),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Material(
                        color: ChatifyColors.transparent,
                        child: InkWell(
                          splashFactory: NoSplash.splashFactory,
                          splashColor: context.isDarkMode ? ChatifyColors.steelGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
                          highlightColor: context.isDarkMode ? ChatifyColors.steelGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
                          hoverColor: context.isDarkMode ? ChatifyColors.lightSoftNight.withAlpha((0.15 * 255).toInt()) : ChatifyColors.steelGrey,
                          onTapDown: (_) {
                            setState(() {
                              isPressed = true;
                            });
                          },
                          onTapUp: (_) {
                            setState(() {
                              isPressed = false;
                            });

                            _toggleSwitch(!increaseContrastEnabled);
                          },
                          onTapCancel: () {
                            setState(() {
                              isPressed = false;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Повысить контрастность', style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400, height: 1.4)),
                                      SizedBox(height: 2),
                                      Text('Затемнить основные цвета, чтобы улучшить видимость в дневном режиме.', style: TextStyle(color: ChatifyColors.darkGrey, fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w400, height: 1.4)),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 40),
                                  CustomSwitch(
                                    value: increaseContrastEnabled,
                                    onChanged: _toggleSwitch,
                                    isPressed: isPressed,
                                    switchWidth: 55,
                                    switchHeight: 34,
                                    thumbSize: 25,
                                    thumbPadding: 3
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 8),
                      _buildSpecialOption(context),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSpecialOption(BuildContext context) {
    return Material(
      color: ChatifyColors.transparent,
      child: InkWell(
        splashFactory: NoSplash.splashFactory,
        splashColor: context.isDarkMode ? ChatifyColors.steelGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
        highlightColor: context.isDarkMode ? ChatifyColors.steelGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
        hoverColor: context.isDarkMode ? ChatifyColors.lightSoftNight.withAlpha((0.15 * 255).toInt()) : ChatifyColors.steelGrey,
        onTap: () {
          Navigator.push(context, createPageRoute(AnimationScreen()));
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(S.of(context).subtitleSpecialFeatures, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400, height: 1.4)),
              SizedBox(height: 2),
              Text(S.of(context).chooseStickersGifsMoveAuto, style: TextStyle(fontSize: 13, color: context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.grey, height: 1.5)),
            ],
          ),
        ),
      ),
    );
  }
}
