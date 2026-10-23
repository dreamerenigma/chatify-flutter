import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_utils/src/extensions/context_extensions.dart';
import '../../../../generated/l10n/l10n.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../../utils/constants/app_vectors.dart';
import '../../../../utils/devices/device_utility.dart';
import '../../../personalization/controllers/colors_controller.dart';
import '../../controllers/expanded_controller.dart';

class ViewedStatusWidget extends StatefulWidget {
  final ExpandController expandController;
  final ColorsController colorsController;

  const ViewedStatusWidget({
    super.key,
    required this.expandController,
    required this.colorsController,
  });

  @override
  State<ViewedStatusWidget> createState() => _ViewedStatusWidgetState();
}

class _ViewedStatusWidgetState extends State<ViewedStatusWidget> {
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isExpanded = widget.expandController.isExpanded.value;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 12),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  widget.expandController.isExpanded.value = !widget.expandController.isExpanded.value;
                });
              },
              child: Row(
                children: [
                  Text(S.of(context).viewed, style: TextStyle(color: context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.darkerGrey, fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w400)),
                  const Spacer(),
                  AnimatedRotation(
                    duration: const Duration(milliseconds: 200),
                    turns: widget.expandController.isExpanded.value ? 0.5 : 0.0,
                    child: Icon(Icons.keyboard_arrow_down_rounded, size: 24, color: context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.darkerGrey),
                  ),
                ],
              ),
            ),
          ),
          if (isExpanded)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Row(
                children: [
                  Stack(
                    alignment: Alignment.centerRight,
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.darkerGrey, width: 2.2)),
                        child: Container(
                          width: DeviceUtils.getScreenHeight(context) * .07,
                          height: DeviceUtils.getScreenHeight(context) * .07,
                          decoration: BoxDecoration(color: widget.colorsController.getColor(widget.colorsController.selectedColorScheme.value), shape: BoxShape.circle),
                          child: Center(child: SvgPicture.asset(ChatifyVectors.appLogoLight, width: 34, height: 34, fit: BoxFit.contain)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(S.of(context).appName, style: TextStyle(color: widget.colorsController.getColor(widget.colorsController.selectedColorScheme.value), fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w500)),
                            const SizedBox(width: 4),
                            Stack(
                              clipBehavior: Clip.none,
                              children: [
                                Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    SvgPicture.asset(ChatifyVectors.starburst, width: 16, height: 16, colorFilter: ColorFilter.mode(widget.colorsController.getColor(widget.colorsController.selectedColorScheme.value), BlendMode.srcIn)),
                                    SvgPicture.asset(ChatifyVectors.check, width: 10, height: 10, colorFilter: ColorFilter.mode(context.isDarkMode ? ChatifyColors.white : ChatifyColors.black, BlendMode.srcIn)),
                                  ],
                                ),
                                const Positioned(
                                  top: 3,
                                  right: 3,
                                  child: Icon(BootstrapIcons.check, size: 13, color: ChatifyColors.white),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Text(
                          'Сегодня, 14:56',
                          style: TextStyle(fontSize: 15, color: context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.darkerGrey, height: 1.5),
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
      );
    });
  }
}
