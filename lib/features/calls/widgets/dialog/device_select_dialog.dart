import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../generated/l10n/l10n.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';

Future<void> showDeviceSelectDialog({
  required BuildContext context,
  required Offset position,
  required String title,
  required List<String> devices,
  List<String>? speakerDevices,
  required String Function(String) nameFormatter,
  required String selectedDevice,
  required void Function(String) onDeviceSelected,
  String? selectedSpeakerDevice,
  void Function(String)? onSpeakerSelected,
  bool showSpeakerSection = true,
  bool showDefaultDeviceText = true,
  double dialogWidth = 240,
}) async {
  final overlay = Overlay.of(context);
  late OverlayEntry overlayEntry;
  late Animation<double> animation;
  final AnimationController animationController = AnimationController(vsync: Navigator.of(context), duration: Duration(milliseconds: 300));
  animation = Tween<double>(begin: position.dy - 50, end: position.dy).animate(CurvedAnimation(parent: animationController, curve: Curves.easeOutQuad));
  final Animation<Offset> slideAnimation = Tween<Offset>(begin: Offset(0, 0.1), end: Offset(0, 0)).animate(CurvedAnimation(parent: animationController, curve: Curves.easeOutCubic));

  overlayEntry = OverlayEntry(
    builder: (context) {
      return Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                animationController.reverse().then((_) => overlayEntry.remove());
              },
            ),
          ),
          AnimatedBuilder(
            animation: animationController,
            builder: (context, child) {
              return Positioned(
                left: position.dx + 2,
                bottom: position.dy + 15,
                child: SlideTransition(
                  position: slideAnimation,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                      child: Container(
                        width: dialogWidth,
                        decoration: BoxDecoration(
                          color: context.isDarkMode ? ChatifyColors.youngNight : ChatifyColors.lightGrey,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: context.isDarkMode ? ChatifyColors.cardColor.withAlpha((0.4 * 255).toInt()) : ChatifyColors.grey),
                          boxShadow: [
                            BoxShadow(
                              color: ChatifyColors.black.withAlpha((0.1 * 255).toInt()),
                              spreadRadius: 1,
                              blurRadius: 2,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 4),
                              child: Text(title, style: TextStyle(color: ChatifyColors.steelGrey, fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w500)),
                            ),
                            SizedBox(height: 5),
                            if (showDefaultDeviceText)
                            _buildDefaultDeviceItem(context, selectedDevice, (device) {
                              onDeviceSelected(device);
                              animationController.reverse().then((_) => overlayEntry.remove());
                            }),
                            ...devices.map((device) => _buildDeviceItem(
                              context: context,
                              device: device,
                              text: nameFormatter(device),
                              isSelected: device == selectedDevice,
                              onDeviceSelected: (selected) {
                                onDeviceSelected(selected);
                                animationController.reverse().then((_) => overlayEntry.remove());
                              },
                            )),
                            if (showSpeakerSection && speakerDevices != null && speakerDevices.isNotEmpty) ...[
                              Divider(height: 10, thickness: 1, color: context.isDarkMode ? ChatifyColors.softNight : ChatifyColors.lightGrey),
                              Padding(
                                padding: EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 4),
                                child: Text(S.of(context).speakers, style: TextStyle(color: ChatifyColors.steelGrey, fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w500)),
                              ),
                              SizedBox(height: 5),
                              if (showDefaultDeviceText)
                              _buildDefaultDeviceItem(context, selectedSpeakerDevice ?? 'default', (device) {
                                onSpeakerSelected?.call(device);
                                animationController.reverse().then((_) => overlayEntry.remove());
                              }),
                              ...speakerDevices.map((device) => _buildDeviceItem(
                                context: context,
                                device: device,
                                text: nameFormatter(device),
                                isSelected: device == selectedSpeakerDevice,
                                onDeviceSelected: (selected) {
                                  if (onSpeakerSelected != null) {
                                    onSpeakerSelected(selected);
                                  }
                                  animationController.reverse().then((_) => overlayEntry.remove());
                                },
                              )),
                            ],
                            SizedBox(height: 4),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }
          ),
        ],
      );
    }
  );

  overlay.insert(overlayEntry);
  animationController.forward();
}

Widget _buildDefaultDeviceItem(BuildContext context, String selectedDevice, void Function(String) onDeviceSelected) {
  final isSelected = selectedDevice == "default";

  return Material(
    color: ChatifyColors.transparent,
    child: InkWell(
      onTap: () => onDeviceSelected('default'),
      mouseCursor: SystemMouseCursors.basic,
      splashFactory: NoSplash.splashFactory,
      splashColor: ChatifyColors.grey.withAlpha((0.2 * 255).toInt()),
      highlightColor: ChatifyColors.grey.withAlpha((0.2 * 255).toInt()),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            if (isSelected)
              Icon(Icons.check, size: 18, color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black)
            else
              SizedBox(width: 19),
            SizedBox(width: 10),
            Expanded(
              child: Text(S.of(context).defaultCommunicationDevice, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w300)),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget _buildDeviceItem({
  required BuildContext context,
  required String device,
  required String text,
  required bool isSelected,
  required void Function(String) onDeviceSelected,
}) {
  return Material(
    color: ChatifyColors.transparent,
    child: InkWell(
      onTap: () => onDeviceSelected(device),
      mouseCursor: SystemMouseCursors.basic,
      splashFactory: NoSplash.splashFactory,
      splashColor: ChatifyColors.grey.withAlpha((0.2 * 255).toInt()),
      highlightColor: ChatifyColors.grey.withAlpha((0.2 * 255).toInt()),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        child: Row(
          children: [
            if (isSelected)
              Icon(Icons.check, size: 18, color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black)
            else
              SizedBox(width: 19),
            SizedBox(width: 10),
            Expanded(
              child: Text(text, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w300), maxLines: 1, overflow: TextOverflow.ellipsis),
            ),
          ],
        ),
      ),
    ),
  );
}
