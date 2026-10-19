import 'dart:async';
import 'dart:developer';
import 'dart:ui' as ui;
import 'package:android_intent_plus/android_intent.dart';
import 'package:android_intent_plus/flag.dart';
import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:chatify/features/utils/widgets/scrolls/no_glow_scroll_behavior.dart';
import 'package:chatify/utils/constants/app_vectors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';
import '../../../api/apis.dart';
import '../../../api/chat_api.dart';
import '../../../core/enums/geolocation_step_type.dart';
import '../../../core/enums/snack_bar_position_type.dart';
import '../../../data/attraction_data.dart';
import '../../../generated/l10n/l10n.dart';
import '../../../utils/constants/app_colors.dart';
import '../../../utils/constants/app_sizes.dart';
import '../../../utils/popups/dialogs.dart';
import '../../personalization/controllers/colors_controller.dart';
import '../../utils/widgets/dividers/custom_divider.dart';
import '../models/user_model.dart';
import '../widgets/dialogs/geolocation_dialog.dart';

class SendGeolocationScreen extends StatefulWidget {
  final UserModel user;

  const SendGeolocationScreen({
    super.key,
    required this.user,
  });

  @override
  State<SendGeolocationScreen> createState() => _SendGeolocationScreenState();
}

class _SendGeolocationScreenState extends State<SendGeolocationScreen> {
  final TextEditingController controller = TextEditingController();
  final FocusNode focusNode = FocusNode();
  final ColorsController colorsController = Get.put(ColorsController());
  bool _isPermissionGranted = false;
  bool _isMapZoomedIn = false;
  bool _isLoadingLocation = false;
  bool _isLoadingProfileImage = false;
  int _selectedDurationIndex = 0;
  String? _locationError;
  String? _profileImageUrl;
  YandexMapController? _mapController;
  Position? _currentPosition;
  List<MapObject> _mapObjects = [];
  GeolocationStep _currentStep = GeolocationStep.location;

  final List<String> _durations = ['15 мин.', '1 час', '8 ч.'];

  @override
  void initState() {
    super.initState();
    _checkPermissionStatus();
    _loadProfileImage();
  }

  @override
  void dispose() {
    controller.dispose();
    focusNode.dispose();
    super.dispose();
  }

  Future<void> _goToNextStep() async {
    setState(() {
      _currentStep = GeolocationStep.next;
    });

    if (_currentPosition != null) {
      await _updateCurrentLocationMarker(_currentPosition!);
    }
  }

  Future<BitmapDescriptor> _createRoundMarker() async {
    const size = 96.0;
    const centerX = size / 2;

    final recorder = ui.PictureRecorder();
    final canvas = ui.Canvas(recorder, const ui.Rect.fromLTWH(0, 0, size, size));

    final pinPath = ui.Path()
      ..moveTo(centerX, size - 5)
      ..cubicTo(centerX + 2, size - 15, 73, 58, 79, 44)
      ..cubicTo(88, 32, 81, 13, 65, 7)
      ..cubicTo(56, 2, 44, 2, 35, 7)
      ..cubicTo(19, 13, 8, 28, 17, 44)
      ..cubicTo(23, 58, centerX - 2, size - 15, centerX, size - 9)
      ..quadraticBezierTo(centerX + 1, size - 5, centerX + 4, size - 9)
      ..quadraticBezierTo(centerX + 1, size - 7, centerX, size - 9)
      ..close();

    canvas.drawPath(pinPath, ui.Paint()..color = const ui.Color(0xFFFFFFFF)..style = ui.PaintingStyle.fill..isAntiAlias = true);
    canvas.drawCircle(const ui.Offset(centerX, 34), 13, ui.Paint()..blendMode = ui.BlendMode.clear..style = ui.PaintingStyle.fill..isAntiAlias = true);

    canvas.drawCircle(const ui.Offset(centerX, 34), 26, ui.Paint()..color = const ui.Color(0xFF21C063)..style = ui.PaintingStyle.fill..isAntiAlias = true);
    canvas.drawCircle(const ui.Offset(centerX, 34), 9, ui.Paint()..blendMode = ui.BlendMode.clear..style = ui.PaintingStyle.fill..isAntiAlias = true);

    final picture = recorder.endRecording();
    final image = await picture.toImage(size.toInt(), size.toInt());
    final data = await image.toByteData(format: ui.ImageByteFormat.png);

    image.dispose();
    picture.dispose();

    if (data == null) {
      throw Exception('Не удалось создать маркер');
    }

    return BitmapDescriptor.fromBytes(data.buffer.asUint8List());
  }

  Future<BitmapDescriptor> _createUserMarker() async {
    const double avatarRadius = 150;
    const double padding = 12;
    const double dotRadius = 25;

    const double size = (avatarRadius + padding) * 2;
    const double centerX = size / 2;
    const double avatarCenterY = avatarRadius + padding;

    final recorder = ui.PictureRecorder();
    final canvas = ui.Canvas(recorder, const ui.Rect.fromLTWH(0, 0, size, size));

    final avatarRect = Rect.fromCircle(center: const Offset(centerX, avatarCenterY), radius: avatarRadius);

    canvas.drawCircle(const ui.Offset(centerX, avatarCenterY), avatarRadius + 3, ui.Paint()..color = const ui.Color(0xFFFFFFFF)..isAntiAlias = true);
    canvas.drawCircle(ui.Offset(centerX, avatarCenterY + avatarRadius + dotRadius + 8), dotRadius, ui.Paint()..color = const ui.Color(0xFF000000)..isAntiAlias = true);

    final avatarProvider = NetworkImage(_profileImageUrl ?? '');
    final stream = avatarProvider.resolve(const ImageConfiguration());
    final completer = Completer<ui.Image>();
    late final ImageStreamListener listener;

    listener = ImageStreamListener((info, synchronousCall) {
        completer.complete(info.image);
        stream.removeListener(listener);
      },
      onError: (exception, stackTrace) {
        completer.completeError(exception, stackTrace ?? StackTrace.current);
        stream.removeListener(listener);
      },
    );

    stream.addListener(listener);

    final avatarImage = await completer.future;

    canvas.save();
    canvas.clipPath(Path()..addOval(avatarRect));

    canvas.drawImageRect(
      avatarImage,
      Rect.fromLTWH(0, 0, avatarImage.width.toDouble(), avatarImage.height.toDouble()),
      avatarRect,
      Paint()..isAntiAlias = true..filterQuality = FilterQuality.high..blendMode = BlendMode.srcOver,
    );

    canvas.restore();

    final picture = recorder.endRecording();
    final image = await picture.toImage(size.toInt(), size.toInt());
    final data = await image.toByteData(format: ui.ImageByteFormat.png);

    image.dispose();
    picture.dispose();

    if (data == null) {
      throw Exception('Не удалось создать маркер пользователя');
    }

    return BitmapDescriptor.fromBytes(data.buffer.asUint8List());
  }

  Future<void> _addAttractionMarkers() async {
    final markers = <MapObject>[];

    for (final attraction in attractions) {
      final icon = await _createRoundMarker();

      markers.add(
        PlacemarkMapObject(
          mapId: MapObjectId(attraction['id'] as String),
          point: Point(latitude: attraction['latitude'] as double, longitude: attraction['longitude'] as double),
          icon: PlacemarkIcon.single(PlacemarkIconStyle(image: icon, scale: 0.8)),
          consumeTapEvents: true,
          onTap: (mapObject, point) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(attraction['name'] as String)));
          },
        ),
      );
    }

    if (!mounted) return;

    setState(() {
      final currentLocationMarkers = _mapObjects.where((object) => object.mapId.value == 'current_location').toList();

      _mapObjects = [...markers, ...currentLocationMarkers];
    });
  }

  Future<void> _checkPermissionStatus() async {
    final status = await Permission.location.status;

    if (!mounted) return;

    setState(() {
      _isPermissionGranted = status.isGranted;
    });

    if (status.isGranted) {
      await _loadCurrentLocation();
    }
  }

  Future<void> _loadCurrentLocation() async {
    if (_isLoadingLocation) return;

    setState(() {
      _isLoadingLocation = true;
      _locationError = null;
    });

    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();

      if (!serviceEnabled) {
        throw Exception('Location services are disabled');
      }

      var permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
        throw Exception('Location permission denied');
      }

      final position = await Geolocator.getCurrentPosition(locationSettings: const LocationSettings(accuracy: LocationAccuracy.high));

      if (!mounted) return;

      setState(() {
        _currentPosition = position;
      });

      await _updateCurrentLocationMarker(position);

      final controller = _mapController;

      if (controller != null) {
        await controller.moveCamera(
          CameraUpdate.newCameraPosition(CameraPosition(target: Point(latitude: position.latitude, longitude: position.longitude), zoom: 16)),
          animation: const MapAnimation(type: MapAnimationType.smooth, duration: 0.5),
        );
      }
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _locationError = e.toString();
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingLocation = false;
        });
      }
    }
  }

  Future<void> _openAppSettings() async {
    final packageName = await _getPackageName();
    final intent = AndroidIntent(action: 'android.settings.APPLICATION_DETAILS_SETTINGS', package: packageName, flags: <int>[Flag.FLAG_ACTIVITY_NEW_TASK]);

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

    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
      return;
    }

    final position = await Geolocator.getCurrentPosition(locationSettings: const LocationSettings(accuracy: LocationAccuracy.high));

    final point = Point(latitude: position.latitude, longitude: position.longitude);

    await _mapController?.moveCamera(
      CameraUpdate.newCameraPosition(CameraPosition(target: point, zoom: 16)),
      animation: const MapAnimation(type: MapAnimationType.smooth, duration: 0.5),
    );
  }

  Future<void> _updateCurrentLocationMarker(Position position) async {
    final point = Point(latitude: position.latitude, longitude: position.longitude);

    final BitmapDescriptor marker = _currentStep == GeolocationStep.next ? await _createUserMarker() : await _createRoundMarker();

    if (!mounted) return;


    setState(() {
      _mapObjects.removeWhere((object) => object.mapId.value == 'current_location');
      _mapObjects.add(
        PlacemarkMapObject(
          mapId: const MapObjectId('current_location'),
          point: point,
          icon: PlacemarkIcon.single(PlacemarkIconStyle(image: marker, scale: 0.8)),
          zIndex: 10,
        ),
      );
    });
  }

  Future<void> _loadProfileImage() async {
    final imagePath = APIs.me.image.trim();

    if (imagePath.isEmpty) {
      return;
    }

    if (mounted) {
      setState(() {
        _isLoadingProfileImage = true;
      });
    }

    try {
      final url = await APIs.getMediaUrl(imagePath);

      if (!mounted) return;

      setState(() {
        _profileImageUrl = url;
        _isLoadingProfileImage = false;
      });
    } catch (e, stackTrace) {
      log('PROFILE IMAGE URL ERROR: $e', stackTrace: stackTrace);

      if (!mounted) return;

      setState(() {
        _profileImageUrl = null;
        _isLoadingProfileImage = false;
      });
    }
  }

  Future<void> _sendCurrentLocation() async {
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();

      if (!serviceEnabled) {
        if (!mounted) return;

        CustomIconSnackBar.showAnimatedSnackBar(
          context,
          'Включите геолокацию на устройстве',
          icon: const Icon(Icons.warning_amber_rounded, size: 26),
          iconColor: ChatifyColors.yellow,
          offset: 20,
        );

        return;
      }

      var permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
        if (!mounted) return;

        CustomIconSnackBar.showAnimatedSnackBar(
          context,
          'Нет разрешения на определение местоположения',
          icon: const Icon(Icons.warning_amber_rounded, size: 26),
          iconColor: ChatifyColors.yellow,
          offset: 20,
        );
        return;
      }

      final position = await Geolocator.getCurrentPosition(locationSettings: const LocationSettings(accuracy: LocationAccuracy.high));

      if (!mounted) return;

      await ChatApi.sendChatGeolocation(widget.user, latitude: position.latitude, longitude: position.longitude);

      if (!mounted) return;

      CustomIconSnackBar.showAnimatedSnackBar(
        context,
        'Местоположение отправлено',
        icon: const Icon(BootstrapIcons.check_circle),
        iconColor: ChatifyColors.success,
        position: SnackBarPositionType.bottom,
        offset: 20,
      );

      Navigator.of(context).pop();
    } catch (e, stackTrace) {
      log('Ошибка отправки геолокации: $e', stackTrace: stackTrace);

      if (!mounted) return;

      CustomIconSnackBar.showAnimatedSnackBar(
        context,
        'Не удалось отправить местоположение',
        icon: const Icon(BootstrapIcons.exclamation_circle),
        iconColor: ChatifyColors.danger,
        position: SnackBarPositionType.bottom,
        offset: 20,
      );
    }
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
            IconButton(icon: const Icon(Icons.search, size: 25), onPressed: () {}),
          IconButton(
            icon: const Icon(Icons.refresh, size: 25),
            onPressed: _isLoadingLocation
              ? null
              : () async {
                  if (!_isPermissionGranted) {
                    await _checkPermissionStatus();
                    return;
                  }

                  await _loadCurrentLocation();
                  await _addAttractionMarkers();
                },
          ),
        ],
      ),
      body: _isPermissionGranted ? _buildContentWithPermission() : _buildContentWithoutPermission(),
    );
  }

  Widget _buildContentWithPermission() {
    return Column(
      children: [
        Expanded(
          child: Stack(
            children: [
              SizedBox(
                width: double.infinity,
                child: YandexMap(
                  mapType: MapType.vector,
                  nightModeEnabled: context.isDarkMode,
                  mapObjects: _mapObjects,
                  logoAlignment: const MapAlignment(horizontal: HorizontalAlignment.right, vertical: VerticalAlignment.bottom),
                  onMapCreated: (controller) {
                    _mapController = controller;
                    _addAttractionMarkers();

                    final position = _currentPosition;

                    if (position != null) {
                      controller.moveCamera(CameraUpdate.newCameraPosition(const CameraPosition(target: Point(latitude: 37.7749, longitude: -122.4194), zoom: 12)));
                    }
                  },
                ),
              ),
              Positioned(
                left: 12,
                top: 12,
                child: Material(
                  color: ChatifyColors.transparent,
                  child: InkWell(
                    splashFactory: NoSplash.splashFactory,
                    borderRadius: BorderRadius.circular(50),
                    splashColor: context.isDarkMode ? ChatifyColors.steelGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
                    highlightColor: context.isDarkMode ? ChatifyColors.steelGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
                    hoverColor: context.isDarkMode ? ChatifyColors.lightSoftNight.withAlpha((0.15 * 255).toInt()) : ChatifyColors.steelGrey,
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
        ),
        Expanded(
          child: switch (_currentStep) {
            GeolocationStep.location => _buildLocationContent(),
            GeolocationStep.next => _buildNextStepContent(),
          },
        ),
      ],
    );
  }

  Widget _buildLocationContent() {
    return Column(
      children: [
        Material(
          color: ChatifyColors.transparent,
          child: InkWell(
            splashFactory: NoSplash.splashFactory,
            splashColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
            highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
            hoverColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
            onTap: () {
              showGeolocationDialog(context, onNext: _goToNextStep);
            },
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 23,
                        backgroundColor: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black,
                        child: SvgPicture.asset(ChatifyVectors.location, width: 25, height: 25, colorFilter: ColorFilter.mode(ChatifyColors.black, BlendMode.srcIn)),
                      ),
                      const SizedBox(width: 16),
                      Text(S.of(context).shareGeodata, style: TextStyle(fontSize: 17, fontWeight: FontWeight.w400)),
                    ],
                  ),
                ),
                CustomDivider(indent: 0, endIndent: 0, left: 0, right: 0, top: 0, bottom: 0),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: ScrollConfiguration(
            behavior: NoGlowScrollBehavior(),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                      onTap: _sendCurrentLocation,
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
                                    width: 43,
                                    height: 43,
                                    decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: ChatifyColors.green, width: 1)),
                                  ),
                                  Container(
                                    width: 19,
                                    height: 19,
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
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    S.of(context).sendCurrentLocation,
                                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w400), maxLines: 1, overflow: TextOverflow.ellipsis
                                  ),
                                  Text(
                                    'С точностью до 4 метров',
                                    style: TextStyle(color: ChatifyColors.darkGrey, fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w400), maxLines: 1, overflow: TextOverflow.ellipsis
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  if (_isLoadingLocation)
                    _buildLocationLoading()
                  else if (_locationError != null)
                    _buildLocationError()
                  else
                    _buildNearestPlacesList(),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLocationLoading() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black),
          const SizedBox(height: 16),
          Text(S.of(context).sendCurrentLocation, textAlign: TextAlign.center, style: TextStyle(fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w400)),
          const SizedBox(height: 4),
          Text(
            'Определяем местоположение...',
            textAlign: TextAlign.center,
            style: TextStyle(color: ChatifyColors.darkGrey, fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w400),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationError() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(S.of(context).error, textAlign: TextAlign.center),
            const SizedBox(height: 12),
            TextButton(
              onPressed: _loadCurrentLocation,
              child: Text('Повторить попытку', style: TextStyle(color: ChatifyColors.darkGrey, fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w400)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNextStepContent() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Делится геоданными',
            style: TextStyle(color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black, fontSize: ChatifySizes.fontSizeBg, fontWeight: FontWeight.w400),
          ),
          const SizedBox(height: 16),
          Row(
            children: List.generate(_durations.length, (index) {
              final isSelected = _selectedDurationIndex == index;

              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(right: index < _durations.length - 1 ? 6 : 0),
                  child: Material(
                    color: ChatifyColors.transparent,
                    borderRadius: BorderRadius.circular(4),
                    child: InkWell(
                      splashFactory: NoSplash.splashFactory,
                      borderRadius: BorderRadius.circular(4),
                      splashColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
                      highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
                      hoverColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
                      onTap: () {
                        setState(() {
                          _selectedDurationIndex = index;
                        });
                      },
                      child: Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: isSelected
                            ? colorsController.getColor(colorsController.selectedColorScheme.value).withAlpha((0.15 * 255).toInt())
                            : context.isDarkMode ? ChatifyColors.youngNight : ChatifyColors.lightGrey,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          _durations[index],
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: isSelected
                              ? colorsController.getColor(colorsController.selectedColorScheme.value)
                              : context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.black,
                            fontSize: ChatifySizes.fontSizeSm,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
          _buildBottomPanelSend(),
        ],
      ),
    );
  }

  Widget _buildNearestPlacesList() {
    if (attractions.isEmpty) {
      return Center(
        child: Text('Поблизости ничего не найдено', style: TextStyle(color: ChatifyColors.darkGrey, fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w400)),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: attractions.length,
      padding: EdgeInsets.zero,
      itemBuilder: (context, index) {
        final place = attractions[index];
        final title = place['name'] as String;
        final address = place['address'] as String? ?? '';
        final district = place['district'] as String? ?? '';

        return Material(
          color: ChatifyColors.transparent,
          child: InkWell(
            splashFactory: NoSplash.splashFactory,
            splashColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
            highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
            hoverColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
            onTap: () {},
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(color: context.isDarkMode ? ChatifyColors.youngNight : ChatifyColors.lightGrey, borderRadius: BorderRadius.circular(35)),
                    child: const Icon(Icons.location_on_outlined, size: 25, color: ChatifyColors.white,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black, fontSize: 17, fontWeight: FontWeight.w400),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          '$address, $district',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: ChatifyColors.darkGrey, fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
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
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(S.of(context).settingsSendCurrentLocation, textAlign: TextAlign.center, style: TextStyle(fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w400)),
                const SizedBox(height: 4),
                Text(
                  _isLoadingLocation ? 'С точностью до 16 метров' : _currentPosition != null ? 'С точностью до ''${_currentPosition!.accuracy.round()} метров' : 'Местоположение недоступно',
                  style: TextStyle(color: ChatifyColors.darkGrey, fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w400),
                ),
              ],
            ),
          ),
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
              splashFactory: NoSplash.splashFactory,
              foregroundColor: colorsController.getColor(colorsController.selectedColorScheme.value).withAlpha((0.3 * 255).toInt()),
              backgroundColor: colorsController.getColor(colorsController.selectedColorScheme.value),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              side: BorderSide.none,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            ),
            child: Text(S.of(context).settings, style: TextStyle(color: ChatifyColors.black, fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400)),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomPanelSend() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Container(
              constraints: const BoxConstraints(minHeight: 48, maxHeight: 120),
              decoration: BoxDecoration(color: context.isDarkMode ? ChatifyColors.youngNight : ChatifyColors.white, borderRadius: BorderRadius.circular(22)),
              child: TextSelectionTheme(
                data: TextSelectionThemeData(
                  cursorColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                  selectionColor: colorsController.getColor(colorsController.selectedColorScheme.value).withAlpha((0.3 * 255).toInt()),
                  selectionHandleColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                ),
                child: TextField(
                  controller: controller,
                  focusNode: focusNode,
                  minLines: 1,
                  maxLines: 5,
                  textInputAction: TextInputAction.newline,
                  textCapitalization: TextCapitalization.sentences,
                  style: TextStyle(color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black, fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400),
                  decoration: InputDecoration(
                    hintText: 'Добавить комментарий',
                    hintStyle: TextStyle(color: ChatifyColors.darkGrey, fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400),
                    border: InputBorder.none,
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(45), borderSide: BorderSide.none),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(45), borderSide: BorderSide.none),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(color: colorsController.getColor(colorsController.selectedColorScheme.value), shape: BoxShape.circle),
            child: IconButton(
              onPressed: () {},
              icon: Padding(padding: const EdgeInsets.only(left: 5), child: const Icon(Icons.send, size: 21, color: ChatifyColors.black)),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints.expand(),
              splashRadius: 24,
            ),
          ),
        ],
      ),
    );
  }
}
