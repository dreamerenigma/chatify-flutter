import 'package:audio_session/audio_session.dart';
import 'package:camera/camera.dart';
import 'package:chatify/utils/constants/app_sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide navigator;
import 'package:get_storage/get_storage.dart';
import '../../../../generated/l10n/l10n.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/helper/file_util.dart';
import '../../../personalization/widgets/dialogs/light_dialog.dart';
import '../../../utils/widgets/no_glow_scroll_behavior.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

enum DeviceType { camera, microphone, speaker }

void showSelectDeviceDialog(
  BuildContext context,
  ValueNotifier<String> selectedDevice,
  DeviceType deviceType, {
  bool showDefaultOption = true,
  required LayerLink devicesNotifyLink,
}) async {
  final overlay = Overlay.of(context);
  late OverlayEntry deviceMenuOverlayEntry;
  final ScrollController scrollController = ScrollController();
  List<String> availableDevices = [];

  Future<List<String>> getMicrophones() async {
    final devices = await navigator.mediaDevices.enumerateDevices();
    return devices.where((d) => d.kind == 'audioinput').map((d) => d.label.isNotEmpty ? d.label : '${S.of(context).microphone} (${d.deviceId})').toList();
  }

  Future<void> saveSelectedDevice(String device, DeviceType deviceType) async {
    final storage = GetStorage();
    String deviceTypeString = deviceType.toString().split('.').last;
    await storage.write('${deviceTypeString}_selected_device', device);
  }

  if (deviceType == DeviceType.camera) {
    final cameras = await availableCameras();
    availableDevices = cameras.map((camera) => FileUtil.cleanDeviceName(camera.name)).toList();
    showDefaultOption = false;
  } else if (deviceType == DeviceType.microphone) {
    final session = await AudioSession.instance;
    final sessionDevices = await session.getDevices();

    List<String> sessionDeviceNames = sessionDevices.map((d) => FileUtil.cleanDeviceName(d.name)).toList();

    try {
      await navigator.mediaDevices.getUserMedia({'audio': true});
      final webrtcDevices = await getMicrophones();

      availableDevices = {
        ...sessionDeviceNames,
        ...webrtcDevices,
      }.toList();
    } catch (e) {
      availableDevices = sessionDeviceNames;
    }

    showDefaultOption = true;
  } else if (deviceType == DeviceType.speaker) {
    try {
      final devices = await navigator.mediaDevices.enumerateDevices();
      availableDevices = devices.where((d) => d.kind == 'audiooutput').map((d) => d.label.isNotEmpty ? d.label : '${S.of(context).speaker} (${d.deviceId})').toList();
    } catch (e) {
      availableDevices = [];
    }

    showDefaultOption = true;
  }

  final itemHeight = 38.0;
  final totalItems = showDefaultOption ? availableDevices.length + 1 : availableDevices.length;
  final maxItemsToShow = 8;
  final calculatedHeight = (totalItems > maxItemsToShow ? maxItemsToShow : totalItems) * itemHeight;

  deviceMenuOverlayEntry = OverlayEntry(
    builder: (context) {
      return Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              onTap: () {
                deviceMenuOverlayEntry.remove();
              },
              child: Container(color: ChatifyColors.transparent),
            ),
          ),
          Positioned(
            width: 290,
            child: CompositedTransformFollower(
              link: devicesNotifyLink,
              offset: deviceType == DeviceType.speaker ? const Offset(0, -110) : const Offset(0, 0),
              showWhenUnlinked: false,
              child: Material(
                color: ChatifyColors.transparent,
                child: SizedBox(
                  width: 250,
                  child: Container(
                    decoration: BoxDecoration(
                      color: context.isDarkMode ? ChatifyColors.youngNight : ChatifyColors.grey,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: context.isDarkMode ? ChatifyColors.black.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey),
                      boxShadow: [
                        BoxShadow(
                          color: ChatifyColors.black.withAlpha((0.2 * 255).toInt()),
                          spreadRadius: 1,
                          blurRadius: 3,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(right: 2, top: 5, bottom: 5),
                      child: ScrollbarTheme(
                        data: ScrollbarThemeData(thumbColor: WidgetStateProperty.all(ChatifyColors.darkerGrey)),
                        child: Scrollbar(
                          controller: scrollController,
                          thickness: 2,
                          thumbVisibility: true,
                          radius: Radius.circular(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: calculatedHeight,
                                child: ScrollConfiguration(
                                  behavior: NoGlowScrollBehavior(),
                                  child: SingleChildScrollView(
                                    controller: scrollController,
                                    child: Column(
                                      children: [
                                        if (showDefaultOption) Padding(
                                          padding: const EdgeInsets.only(left: 5, right: 5, bottom: 5),
                                          child: Material(
                                            color: ChatifyColors.transparent,
                                            child: InkWell(
                                              onTap: () {
                                                selectedDevice.value = S.of(context).defaultDevice;
                                                deviceMenuOverlayEntry.remove();
                                              },
                                              splashColor: context.isDarkMode ? ChatifyColors.darkerGrey : ChatifyColors.grey,
                                              highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey : ChatifyColors.grey,
                                              borderRadius: BorderRadius.circular(8),
                                              child: Stack(
                                                children: [
                                                  Container(
                                                    width: double.infinity,
                                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                                    decoration: BoxDecoration(
                                                      color: selectedDevice.value == S.of(context).defaultDevice ? context.isDarkMode ? ChatifyColors.textPrimary : ChatifyColors.textPrimary : ChatifyColors.transparent,
                                                      borderRadius: BorderRadius.circular(8),
                                                    ),
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Text(S.of(context).defaultDevice),
                                                      ],
                                                    ),
                                                  ),
                                                  if (selectedDevice.value == S.of(context).defaultDevice)
                                                  Positioned(
                                                    left: 0,
                                                    top: 8,
                                                    bottom: 8,
                                                    child: Container(
                                                      width: 2.5,
                                                      decoration: BoxDecoration(
                                                        color: colorsController.getColor(colorsController.selectedColorScheme.value),
                                                        borderRadius: BorderRadius.circular(2),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        ...availableDevices.map((device) {
                                          return Padding(
                                            padding: const EdgeInsets.only(left: 5, right: 5),
                                            child: Material(
                                              color: ChatifyColors.transparent,
                                              child: InkWell(
                                                onTap: () {
                                                  selectedDevice.value = device;
                                                  deviceMenuOverlayEntry.remove();
                                                  saveSelectedDevice(device, deviceType);
                                                },
                                                splashColor: context.isDarkMode ? ChatifyColors.darkerGrey : ChatifyColors.grey,
                                                highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey : ChatifyColors.grey,
                                                borderRadius: BorderRadius.circular(8),
                                                child: Stack(
                                                  children: [
                                                    Container(
                                                      width: double.infinity,
                                                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                                      decoration: BoxDecoration(
                                                        color: selectedDevice.value == device ? ChatifyColors.textPrimary : ChatifyColors.transparent,
                                                        borderRadius: BorderRadius.circular(8),
                                                      ),
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          Expanded(child: Text(device, style: TextStyle(fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w400), overflow: TextOverflow.ellipsis, maxLines: 1)),
                                                        ],
                                                      ),
                                                    ),
                                                    if (selectedDevice.value == device)
                                                    Positioned(
                                                      left: 0,
                                                      top: 8,
                                                      bottom: 8,
                                                      child: Container(
                                                        width: 2.5,
                                                        decoration: BoxDecoration(
                                                          color: colorsController.getColor(colorsController.selectedColorScheme.value),
                                                          borderRadius: BorderRadius.circular(2),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        }),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    }
  );

  overlay.insert(deviceMenuOverlayEntry);
}
