import 'package:chatify/utils/constants/app_sizes.dart';
import 'package:chatify/utils/constants/app_vectors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../../generated/l10n/l10n.dart';
import '../../../../utils/constants/app_colors.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../personalization/widgets/dialogs/light_dialog.dart';
import '../dialogs/overlays/new_call_link_overlay.dart';

class CallsScreenWidget extends StatefulWidget {
  final double sidePanelWidth;
  final VoidCallback onStartCall;
  final bool isCalling;
  final ValueChanged<bool> onCallingChanged;

  const CallsScreenWidget({
    super.key,
    required this.sidePanelWidth,
    required this.onStartCall,
    required this.isCalling,
    required this.onCallingChanged,
  });

  @override
  State<CallsScreenWidget> createState() => _CallsScreenWidgetState();
}

class _CallsScreenWidgetState extends State<CallsScreenWidget> {
  final GlobalKey _newCallLink = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AnimatedPositioned(
          duration: Duration(milliseconds: 300),
          top: 0,
          left: 0,
          right: 0,
          bottom: 0,
          child: Column(
            children: [
              Expanded(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        if (constraints.maxWidth <= 450) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              _buildContainer(
                                icon: null,
                                context: context,
                                phosphorIcon: null,
                                svgPath: ChatifyVectors.video,
                                label: S.of(context).call,
                                tooltipMessage: S.of(context).call,
                                iconColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                                color: context.isDarkMode ? ChatifyColors.darkerGrey : ChatifyColors.grey,
                                onTap: () {
                                  widget.onStartCall.call();
                                  widget.onCallingChanged(true);
                                },
                              ),
                              SizedBox(height: 30),
                              _buildContainer(
                                icon: null,
                                context: context,
                                key: _newCallLink,
                                phosphorIcon: null,
                                svgPath: ChatifyVectors.cameraLink,
                                label: S.of(context).newLinkCall,
                                tooltipMessage: S.of(context).newLinkCall,
                                iconColor: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black,
                                color: context.isDarkMode ? ChatifyColors.darkerGrey : ChatifyColors.grey,
                                onTap: () {
                                  final RenderBox renderBox = _newCallLink.currentContext?.findRenderObject() as RenderBox;
                                  final position = renderBox.localToGlobal(Offset.zero);
                                  final size = renderBox.size;
                                  final adjustedOffset = Offset(position.dx + size.width - 10, position.dy - 220);

                                  showNewCallLinkOverlay(context, adjustedOffset);
                                },
                              ),
                              SizedBox(height: 30),
                              _buildContainer(
                                icon: null,
                                svgPath: null,
                                context: context,
                                phosphorIcon: PhosphorIcons.numpad(),
                                label: S.of(context).callNumber,
                                tooltipMessage: S.of(context).callNumber,
                                iconColor: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black,
                                color: context.isDarkMode ? ChatifyColors.darkerGrey : ChatifyColors.grey,
                                onTap: () {},
                              ),
                            ],
                          );
                        } else {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 12, bottom: 22),
                                child: _buildContainer(
                                  icon: null,
                                  context: context,
                                  phosphorIcon: null,
                                  svgPath: ChatifyVectors.video,
                                  label: S.of(context).call,
                                  tooltipMessage: S.of(context).call,
                                  iconColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                                  color: context.isDarkMode ? ChatifyColors.darkerGrey : ChatifyColors.grey,
                                  onTap: () {
                                    widget.onStartCall.call();
                                    widget.onCallingChanged(true);
                                  },
                                ),
                              ),
                              SizedBox(width: 16),
                              _buildContainer(
                                icon: null,
                                context: context,
                                key: _newCallLink,
                                phosphorIcon: null,
                                svgPath: ChatifyVectors.cameraLink,
                                label: S.of(context).newLinkCall,
                                tooltipMessage: S.of(context).newLinkCall,
                                iconColor: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black,
                                color: context.isDarkMode ? ChatifyColors.darkerGrey : ChatifyColors.grey,
                                onTap: () {
                                  final RenderBox renderBox = _newCallLink.currentContext?.findRenderObject() as RenderBox;
                                  final position = renderBox.localToGlobal(Offset.zero);
                                  final size = renderBox.size;
                                  final adjustedOffset = Offset(position.dx + size.width - 10, position.dy + 80);

                                  showNewCallLinkOverlay(context, adjustedOffset);
                                },
                              ),
                              SizedBox(width: 16),
                              _buildContainer(
                                icon: null,
                                svgPath: null,
                                context: context,
                                phosphorIcon: PhosphorIcons.numpad(),
                                label: S.of(context).callNumber,
                                tooltipMessage: S.of(context).callNumber,
                                iconColor: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black,
                                color: context.isDarkMode ? ChatifyColors.darkerGrey : ChatifyColors.grey,
                                onTap: () {},
                              ),
                            ],
                          );
                        }
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildContainer({
    Key? key,
    required BuildContext context,
    required IconData? icon,
    required String label,
    required Color color,
    required Color iconColor,
    required String? svgPath,
    required PhosphorIconData? phosphorIcon,
    required String tooltipMessage,
    required VoidCallback? onTap,
  }) {
    return Container(
      key: key,
      child: Material(
        color: ChatifyColors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Tooltip(
              message: tooltipMessage,
              waitDuration: Duration(milliseconds: 800),
              verticalOffset: -65,
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              textStyle: TextStyle(color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black, fontSize: ChatifySizes.fontSizeLm, fontWeight: FontWeight.w300),
              decoration: BoxDecoration(
                color: context.isDarkMode ? ChatifyColors.youngNight : ChatifyColors.grey,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: context.isDarkMode ? ChatifyColors.darkBackground.withAlpha((0.7 * 255).toInt()) : ChatifyColors.darkGrey.withAlpha((0.2 * 255).toInt()), width: 1),
                boxShadow: [
                  BoxShadow(
                    color: ChatifyColors.black.withAlpha((0.2 * 255).toInt()),
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: InkWell(
                onTap: onTap,
                mouseCursor: SystemMouseCursors.basic,
                splashColor: ChatifyColors.transparent,
                highlightColor: context.isDarkMode ? ChatifyColors.deepNight : ChatifyColors.grey,
                borderRadius: BorderRadius.circular(18),
                child: Container(
                  width: 76,
                  height: 76,
                  decoration: BoxDecoration(
                    color: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.1 * 255).toInt()) : ChatifyColors.transparent,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: color, width: 0.5),
                  ),
                  child: Center(
                    child: svgPath != null ? SvgPicture.asset(svgPath, width: 40, height: 40, color: iconColor) : phosphorIcon != null
                      ? PhosphorIcon(phosphorIcon, size: 28, color: iconColor)
                      : Icon(icon, size: 28, color: iconColor),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 120),
              child: Text(label, style: TextStyle(fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w600), textAlign: TextAlign.center, softWrap: true, overflow: TextOverflow.visible),
            ),
          ],
        ),
      ),
    );
  }
}
