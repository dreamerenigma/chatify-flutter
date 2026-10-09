import 'dart:developer';
import 'package:android_intent_plus/android_intent.dart';
import 'package:android_intent_plus/flag.dart';
import 'package:chatify/utils/constants/app_vectors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';
import '../../../generated/l10n/l10n.dart';
import '../../../utils/constants/app_colors.dart';
import '../../../utils/constants/app_sizes.dart';
import '../../personalization/controllers/colors_controller.dart';
import '../../utils/widgets/dividers/custom_divider.dart';

class SendGeolocationScreen extends StatefulWidget {
  const SendGeolocationScreen({super.key});

  @override
  State<SendGeolocationScreen> createState() => _SendGeolocationScreenState();
}

class _SendGeolocationScreenState extends State<SendGeolocationScreen> {
  final ColorsController colorsController = Get.put(ColorsController());
  bool _isPermissionGranted = false;
  bool _isMapZoomedIn = false;
  YandexMapController? _mapController;

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

  Future<void> _showMyLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return;
    }

    LocationPermission permission =
    await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
      return;
    }

    final position = await Geolocator.getCurrentPosition(locationSettings: const LocationSettings(accuracy: LocationAccuracy.high));

    final point = Point(latitude: position.latitude, longitude: position.longitude);

    await _mapController?.moveCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: point,
          zoom: 16,
        ),
      ),
      animation: const MapAnimation(
        type: MapAnimationType.smooth,
        duration: 0.5,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        elevation: 0,
        title: Text(S.of(context).sendLocation, style: TextStyle(fontSize: ChatifySizes.fontSizeMg, fontWeight: FontWeight.w400)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, size: 25),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          if (_isPermissionGranted)
            IconButton(icon: const Icon(Icons.search), onPressed: () {}),
          IconButton(icon: const Icon(Icons.refresh), onPressed: () {}),
        ],
      ),
      body: _isPermissionGranted ? _buildContentWithPermission() : _buildContentWithoutPermission(),
    );
  }

  Widget _buildContentWithPermission() {
    return Column(
      children: [
        Stack(
          children: [
            SizedBox(
              width: double.infinity,
              height: 250,
              child: YandexMap(
                mapType: MapType.vector,
                onMapCreated: (controller) {
                  _mapController = controller;
                  controller.moveCamera(CameraUpdate.newCameraPosition(const CameraPosition(target: Point(latitude: 37.7749, longitude: -122.4194), zoom: 12)));
                },
              ),
            ),
            Positioned(
              left: 12,
              top: 12,
              child: Material(
                color: ChatifyColors.transparent,
                child: InkWell(
                  onTap: () async {
                    if (_mapController == null) return;

                    if (_isMapZoomedIn) {
                      await _mapController!.moveCamera(CameraUpdate.zoomOut(), animation: const MapAnimation(type: MapAnimationType.smooth, duration: 0.2));
                    } else {
                      await _mapController!.moveCamera(CameraUpdate.zoomIn(), animation: const MapAnimation(type: MapAnimationType.smooth, duration: 0.2));
                    }

                    setState(() {
                      _isMapZoomedIn = !_isMapZoomedIn;
                    });
                  },
                  borderRadius: BorderRadius.circular(50),
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: context.isDarkMode ? ChatifyColors.white.withValues(alpha: 0.8) : ChatifyColors.white,
                      borderRadius: BorderRadius.circular(50),
                      boxShadow: [BoxShadow(color: ChatifyColors.black.withValues(alpha: 0.12), blurRadius: 8, offset: const Offset(0, 2))],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(11),
                      child: SvgPicture.asset(_isMapZoomedIn ? ChatifyVectors.resizeMap : ChatifyVectors.minimizeMap, width: 15, height: 15),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              right: 12,
              top: 12,
              child: Material(
                color: ChatifyColors.transparent,
                child: InkWell(
                  onTap: _showMyLocation,
                  borderRadius: BorderRadius.circular(50),
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: context.isDarkMode ? ChatifyColors.white.withValues(alpha: 0.8) : ChatifyColors.black,
                      shape: BoxShape.circle,
                      boxShadow: [BoxShadow(color: ChatifyColors.black.withValues(alpha: 0.12), blurRadius: 8, offset: const Offset(0, 2))],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: SvgPicture.asset(ChatifyVectors.myLocation, width: 15, height: 15),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Material(
          color: ChatifyColors.transparent,
          child: InkWell(
            splashFactory: NoSplash.splashFactory,
            splashColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
            highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
            hoverColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
            onTap: () {},
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 25,
                    backgroundColor: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black,
                    child: const Icon(Icons.location_on, color: ChatifyColors.black),
                  ),
                  const SizedBox(width: 16),
                  Text(S.of(context).shareGeodata, style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400)),
                  CustomDivider(indent: 0, endIndent: 0, left: 0, right: 0, top: 0, bottom: 0),
                ],
              ),
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
                  child: Text(S.of(context).nearestPlaces, style: TextStyle(color: ChatifyColors.darkGrey, fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w400)),
                ),
              ),
              const SizedBox(height: 5),
              Material(
                color: ChatifyColors.transparent,
                child: InkWell(
                  splashFactory: NoSplash.splashFactory,
                  splashColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
                  highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
                  hoverColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
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
                                width: 42,
                                height: 42,
                                decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: ChatifyColors.green, width: 1)),
                              ),
                              Container(
                                width: 18,
                                height: 18,
                                decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: ChatifyColors.green, width: 2)),
                              ),
                              Container(
                                width: 11,
                                height: 11,
                                decoration: const BoxDecoration(shape: BoxShape.circle, color: ChatifyColors.green),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            S.of(context).sendCurrentLocation,
                            style: TextStyle(fontSize: ChatifySizes.fontSizeMd,fontWeight: FontWeight.w400), maxLines: 1, overflow: TextOverflow.ellipsis
                          ),
                        ),
                      ],
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

  Widget _buildContentWithoutPermission() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 45),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 110,
            height: 110,
            decoration: BoxDecoration(color: colorsController.getColor(colorsController.selectedColorScheme.value), shape: BoxShape.circle),
            child: const Center(child: Icon(Icons.location_on_outlined, size: 50, color: ChatifyColors.black)),
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
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            ),
            child: Text(S.of(context).settings, style: TextStyle(color: ChatifyColors.white, fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400)),
          ),
        ],
      ),
    );
  }
}
