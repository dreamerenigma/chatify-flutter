import 'dart:developer';
import 'package:android_intent_plus/android_intent.dart';
import 'package:android_intent_plus/flag.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';
import '../../../generated/l10n/l10n.dart';
import '../../../utils/constants/app_colors.dart';
import '../../../utils/constants/app_sizes.dart';
import '../../personalization/controllers/colors_controller.dart';

class SendGeolocationScreen extends StatefulWidget {
  const SendGeolocationScreen({super.key});

  @override
  State<SendGeolocationScreen> createState() => _SendGeolocationScreenState();
}

class _SendGeolocationScreenState extends State<SendGeolocationScreen> {
  final ColorsController colorsController = Get.put(ColorsController());
  bool _isPermissionGranted = false;

  @override
  void initState() {
    super.initState();
    _checkPermissionStatus();
  }

  Future<void> _checkPermissionStatus() async {
    final status = await Permission.location.status;
    setState(() {
      _isPermissionGranted = status.isGranted;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Text(S.of(context).sendLocation, style: TextStyle(fontSize: ChatifySizes.fontSizeMg, fontWeight: FontWeight.w400)),
        actions: [
          if (_isPermissionGranted)
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {},
            ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {},
          ),
        ],
      ),
      body: _isPermissionGranted ? _buildContentWithPermission() : _buildContentWithoutPermission(),
    );
  }

  Widget _buildContentWithPermission() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 250,
          child: YandexMap(
            mapType: MapType.vector,
            onMapCreated: (controller) {
              controller.moveCamera(
                CameraUpdate.newCameraPosition(
                  const CameraPosition(target: Point(latitude: 37.7749, longitude: -122.4194), zoom: 12),
                ),
              );
            },
          )
        ),
        const SizedBox(height: 16),
        InkWell(
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                  child: const Icon(Icons.location_on, color: Colors.white),
                ),
                const SizedBox(width: 16),
                Text(S.of(context).shareGeodata, style: TextStyle(fontSize: ChatifySizes.fontSizeMd)),
                const Divider(height: 0, thickness: 1),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(S.of(context).nearestPlaces, style: TextStyle(fontSize: ChatifySizes.fontSizeSm, color: ChatifyColors.darkGrey)),
                ),
              ),
              const SizedBox(height: 10),
              InkWell(
                onTap: () {},
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: ChatifyColors.green, width: 1)),
                            ),
                            Container(
                              width: 25,
                              height: 25,
                              decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: ChatifyColors.green, width: 2)),
                            ),
                            Container(
                              width: 15,
                              height: 15,
                              decoration: const BoxDecoration(shape: BoxShape.circle, color: ChatifyColors.green),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(S.of(context).sendCurrentLocation, style: TextStyle(fontSize: ChatifySizes.fontSizeMd), maxLines: 1, overflow: TextOverflow.ellipsis),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildContentWithoutPermission() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 45),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 110,
            height: 110,
            decoration: BoxDecoration(
              color: colorsController.getColor(colorsController.selectedColorScheme.value),
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Icon(Icons.location_on_outlined, color: ChatifyColors.white, size: 50),
            ),
          ),
          const SizedBox(height: 45),
          Text(S.of(context).settingsSendCurrentLocation, textAlign: TextAlign.center, style: TextStyle(fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w400)),
          const SizedBox(height: 25),
          ElevatedButton(
            onPressed: () async {
              final permissionStatus = await Permission.location.status;

              if (permissionStatus.isDenied || permissionStatus.isPermanentlyDenied) {
                await _openAppSettings();
              } else {
                setState(() {
                  _isPermissionGranted = permissionStatus.isGranted;
                });
              }
            },
            style: ElevatedButton.styleFrom(
              foregroundColor: colorsController.getColor(colorsController.selectedColorScheme.value).withAlpha((0.3 * 255).toInt()),
              backgroundColor: colorsController.getColor(colorsController.selectedColorScheme.value),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              side: BorderSide.none,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: Text(S.of(context).settings, style: TextStyle(color: ChatifyColors.white)),
          ),
        ],
      ),
    );
  }

  Future<void> _openAppSettings() async {
    final packageName = await _getPackageName();
    final intent = AndroidIntent(
      action: 'android.settings.APPLICATION_DETAILS_SETTINGS',
      package: packageName,
      flags: <int>[Flag.FLAG_ACTIVITY_NEW_TASK],
    );

    try {
      await intent.launch();
    } catch (e) {
      log('${S.of(context).errorOpeningAppSettings}: $e');
    }
  }

  Future<String> _getPackageName() async {
    return 'com.inputstudios.chatify';
  }
}
