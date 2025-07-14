import 'dart:async';
import 'dart:developer';
import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:camera/camera.dart';
import 'package:camera_windows/camera_windows.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:heroicons/heroicons.dart';
import 'package:icon_forest/iconoir.dart';
import '../../../../../common/widgets/bars/scrollbar/custom_scrollbar.dart';
import '../../../../../utils/constants/app_colors.dart';
import '../../../../../utils/constants/app_sizes.dart';
import '../../../../../utils/constants/app_vectors.dart';
import '../../../../../utils/formatters/formatter.dart';
import '../../../../../utils/helper/file_util.dart';
import '../../../../../utils/popups/custom_tooltip.dart';
import '../../../../personalization/widgets/dialogs/light_dialog.dart';
import '../../../../utils/widgets/no_glow_scroll_behavior.dart';
import '../confirmation_dialog.dart';
import '../select_device_dialog.dart';
import '../windows_settings_dialog.dart';

class VideoAudioOptionWidget extends StatefulWidget {
  const VideoAudioOptionWidget({super.key});

  @override
  State<VideoAudioOptionWidget> createState() => _VideoAudioOptionWidgetState();
}

class _VideoAudioOptionWidgetState extends State<VideoAudioOptionWidget> {
  bool _isTappedVideo = false;
  bool _isTappedMicrophone = false;
  bool _isTappedSpeakers = false;
  bool _isTappedTest = false;
  bool isCameraInitialized = false;
  bool isCameraAvailable = false;
  bool isRecording = false;
  bool isPaused = false;
  bool isInside = false;
  bool isHoveredVideo = false;
  bool isHoveredMicrophone = false;
  bool isHoveredSpeakers = false;
  bool firstDialogConfirmed = false;
  int _remainingTime = 3599;
  double progress = 0.0;
  final box = GetStorage();
  final int _initialRemainingTime = 3599;
  final ScrollController _scrollController = ScrollController();
  final LayerLink cameraDeviceNotifyLink = LayerLink();
  final LayerLink microphoneDeviceNotifyLink = LayerLink();
  final LayerLink speakerDeviceNotifyLink = LayerLink();
  late List<CameraDescription> cameras;
  CameraController? _controller;
  ValueNotifier<String> selectedCamera = ValueNotifier<String>("Устройство по умолчанию");
  ValueNotifier<String> selectedMicrophone = ValueNotifier<String>("Устройство по умолчанию");
  ValueNotifier<String> selectedSpeaker = ValueNotifier<String>("Устройство по умолчанию");
  Timer? _timer;
  String buttonText = 'Воспроизвести звук для проверки';

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final alreadyConfirmed = box.read('microphoneConfirmed') ?? false;

      if (!alreadyConfirmed) {
        final confirmed = await showConfirmationDialog(
          width: 555,
          context: context,
          confirmButton: false,
          title: 'Разрешить Chatify доступ к микрофону?',
          description: 'Позже вы можете изменить этот параметр, перейдя в раздел "Настройки".',
          onConfirm: () {},
          showTopTitleDuplicate: true,
        );

        if (!confirmed) {
          Navigator.of(context).pop();
          return;
        }

        box.write('microphoneConfirmed', true);

        final secondConfirmed = await showConfirmationDialog(
          width: 555,
          context: context,
          confirmButton: false,
          title: 'Разрешить Chatify доступ к камере?',
          description: 'Вы всегда можете изменить это в настройках.',
          onConfirm: () {},
          showTopTitleDuplicate: true,
        );

        if (secondConfirmed) {
          _initCamera();
        } else {
          Navigator.of(context).pop();
        }
      } else {
        _initCamera();
      }
    });

    _loadSelectedCamera();
    _loadSelectedMicrophone();
    _loadSelectedSpeaker();
  }

  @override
  void dispose() {
    _controller!.dispose();
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _initCamera() async {
    final cameraWindows = CameraWindows();

    try {
      cameras = await cameraWindows.availableCameras();

      if (cameras.isNotEmpty) {
        if (_controller != null) {
          await _controller!.dispose();
          _controller = null;
        }

        _controller = CameraController(
          cameras[0],
          ResolutionPreset.medium,
        );

        await _initializeCamera();
      } else {
        setState(() {
          isCameraAvailable = false;
        });
      }
    } catch (e) {
      log('Error initializing camera: $e');
      setState(() {
        isCameraAvailable = false;
      });

      await Future.delayed(Duration(seconds: 3));
      _initCamera();
    }
  }

  Future<void> _initializeCamera() async {
    try {
      await _controller!.initialize();
      if (mounted) {
        setState(() {
          isCameraAvailable = true;
          isCameraInitialized = true;
        });
      }
    } catch (e) {
      log('Error initializing camera: $e');
      if (mounted) {
        setState(() {
          isCameraAvailable = false;
        });
      }

      await Future.delayed(Duration(seconds: 3));
      _initCamera();
    }
  }

  void _toggleRecording() {
    if (isRecording) {
      setState(() {
        isPaused = !isPaused;
      });
    } else {
      setState(() {
        isRecording = true;
        isPaused = false;
        _remainingTime = _initialRemainingTime;
        _startRecording();
      });
    }
  }

  void _startRecording() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (isRecording && !isPaused && _remainingTime > 0) {
        setState(() {
          _remainingTime--;
        });
      } else if (_remainingTime <= 0) {
        setState(() {
          isRecording = false;
          isPaused = false;
        });
        _timer?.cancel();
      }
    });
  }

  void _stopRecording() {
    setState(() {
      isRecording = false;
      isPaused = false;
    });

    _animateProgress();
  }

  void _animateProgress() {
    const duration = Duration(seconds: 3);
    int steps = 30;
    double stepValue = 1.0 / steps;

    for (int i = 1; i <= steps; i++) {
      Future.delayed(Duration(milliseconds: i * (duration.inMilliseconds ~/ steps)), () {
        setState(() {
          progress = stepValue * i;
        });
      });
    }
  }

  void _toggleText() {
    setState(() {
      buttonText = buttonText == 'Воспроизвести звук для проверки' ? 'Прекратить воспроизведение звука' : 'Воспроизвести звук для проверки';
    });
  }

  Future<String?> _getSavedDevice(String deviceType) async {
    final storage = GetStorage();
    return storage.read('${deviceType}_selected_device');
  }

  Future<void> _loadSelectedCamera() async {
    final savedCameraDevice = await _getSavedDevice("camera");
    if (savedCameraDevice != null) {
      selectedCamera.value = savedCameraDevice;
    }
  }

  Future<void> _loadSelectedMicrophone() async {
    final savedMicrophoneDevice = await _getSavedDevice("microphone");
    if (savedMicrophoneDevice != null) {
      selectedMicrophone.value = savedMicrophoneDevice;
    }
  }

  Future<void> _loadSelectedSpeaker() async {
    final savedSpeakerDevice = await _getSavedDevice("speaker");
    if (savedSpeakerDevice != null) {
      selectedSpeaker.value = savedSpeakerDevice;
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollbar(
      scrollController: _scrollController,
      isInsidePersonalizedOption: isInside,
      onHoverChange: (bool isHovered) {
        setState(() {
          isInside = isHovered;
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
                Text("Видео и аудио", style: TextStyle(fontSize: ChatifySizes.fontSizeBg, fontWeight: FontWeight.w500)),
                const SizedBox(height: 15),
                if (!isCameraAvailable)
                  Container(
                    decoration: BoxDecoration(
                      color: context.isDarkMode ? ChatifyColors.youngNight : ChatifyColors.grey,
                      border: Border.all(color: ChatifyColors.cardColor.withAlpha((0.2 * 255).toInt()), width: 1), borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 12, top: 12),
                          child: Icon(Icons.info_rounded, size: 18, color: colorsController.getColor(colorsController.selectedColorScheme.value)),
                        ),
                        SizedBox(width: 4),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(left: 12, right: 12, top: 12),
                                child: Text("Разрешения камеры", style: TextStyle(fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w500)),
                              ),
                              SizedBox(height: 5),
                              Padding(
                                padding: EdgeInsets.only(left: 12, right: 12),
                                child: Text(
                                  "Разрешения камеры отключены в настройках Windows. Включите разрешения, чтобы участвовать в видеозвонках.",
                                  style: TextStyle(fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w300),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 12, bottom: 16),
                                child: Material(
                                  color: ChatifyColors.transparent,
                                  child: InkWell(
                                    onTap: () {
                                      showWindowsSettingsDialog(context, "ms-settings:privacy-webcam");
                                    },
                                    borderRadius: BorderRadius.circular(4),
                                    splashColor: context.isDarkMode ? ChatifyColors.darkerGrey : ChatifyColors.grey,
                                    highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey : ChatifyColors.grey,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                      child: Text(
                                        "Настройки Windows: камера",
                                        style: TextStyle(
                                          fontSize: ChatifySizes.fontSizeSm,
                                          fontWeight: FontWeight.w400,
                                          color: colorsController.getColor(colorsController.selectedColorScheme.value),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                if (!isCameraAvailable) const SizedBox(height: 10),
                const Text("Видео", style: TextStyle(fontSize: 19, fontWeight: FontWeight.w300)),
                const SizedBox(height: 10),
                CompositedTransformTarget(
                  link: cameraDeviceNotifyLink,
                  child: GestureDetector(
                    onTap: () {
                      showSelectDeviceDialog(context, selectedCamera, DeviceType.camera, showDefaultOption: false, devicesNotifyLink: cameraDeviceNotifyLink);
                      setState(() {
                        _isTappedVideo = !_isTappedVideo;
                      });
                      Future.delayed(Duration(milliseconds: 200), () {
                        setState(() {
                          _isTappedVideo = false;
                        });
                      });
                    },
                    onLongPress: () {
                      setState(() {
                        _isTappedVideo = true;
                      });
                    },
                    onLongPressEnd: (_) {
                      setState(() {
                        _isTappedVideo = false;
                      });
                    },
                    onLongPressUp: () {
                      setState(() {
                        _isTappedVideo = false;
                      });
                    },
                    child: ValueListenableBuilder<String>(
                      valueListenable: selectedMicrophone,
                      builder: (context, selectedDevice, _) {
                        return isCameraAvailable
                          ? Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: MouseRegion(
                              onEnter: (_) {
                                setState(() {
                                  isHoveredVideo = true;
                                });
                              },
                              onExit: (_) {
                                setState(() {
                                  isHoveredVideo = false;
                                });
                              },
                              child: CustomTooltip(
                                message: selectedDevice == "Устройство по умолчанию" ? "Устройство по умолчанию" : selectedDevice,
                                verticalOffset: -80,
                                disableOnTap: _isTappedTest,
                                disableTooltipOnLongPress: true,
                                child: Container(
                                  width: 250,
                                  height: 35,
                                  padding: EdgeInsets.symmetric(horizontal: 12),
                                  decoration: BoxDecoration(
                                    color: _isTappedVideo ? (context.isDarkMode ? ChatifyColors.mildNight : ChatifyColors.grey.withAlpha(100)) : isHoveredVideo
                                      ? (context.isDarkMode ? ChatifyColors.lightSoftNight.withAlpha((0.8 * 255).toInt()) : ChatifyColors.black.withAlpha((0.3 * 255).toInt()))
                                      : (context.isDarkMode ? ChatifyColors.softNight : ChatifyColors.white),
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Iconoir(Iconoir.camera, color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black, width: 20, height: 20),
                                          SizedBox(width: 8),
                                          Text(FileUtil.cleanDeviceName(_controller?.description.name ?? 'Неизвестное устройство'), style: TextStyle(fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w300)),
                                        ],
                                      ),
                                      AnimatedContainer(
                                        duration: const Duration(milliseconds: 200),
                                        transform: Matrix4.translationValues(0, _isTappedVideo ? 2.0 : 0, 0),
                                        child: SvgPicture.asset(ChatifyVectors.arrowDown, color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black, width: 15, height: 15),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.only(left: 5),
                            child: Text("Камера не найдена", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w300)),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  width: double.infinity,
                  height: 180,
                  decoration: BoxDecoration(
                    color: context.isDarkMode ? ChatifyColors.lightSlate : ChatifyColors.grey,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: isCameraAvailable && isCameraInitialized
                    ? ClipRRect(borderRadius: BorderRadius.circular(10), child: CameraPreview(_controller!))
                    : Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Container(
                          width: double.infinity,
                          height: 50,
                          decoration: BoxDecoration(color: ChatifyColors.grey, borderRadius: BorderRadius.circular(8)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.warning_amber_rounded, size: 20, color: ChatifyColors.black),
                              Text(
                                "Камера не найдена",
                                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: ChatifyColors.black),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                ),
                const SizedBox(height: 20),
                Text("Микрофон", style: TextStyle(fontSize: ChatifySizes.fontSizeLg, fontWeight: FontWeight.w300)),
                CompositedTransformTarget(
                  link: microphoneDeviceNotifyLink,
                  child: GestureDetector(
                    onTap: () {
                      showSelectDeviceDialog(
                        context,
                        selectedMicrophone,
                        DeviceType.microphone,
                        showDefaultOption: true,
                        devicesNotifyLink: microphoneDeviceNotifyLink,
                      );
                      setState(() {
                        _isTappedMicrophone = !_isTappedMicrophone;
                      });
                      Future.delayed(Duration(milliseconds: 200), () {
                        setState(() {
                          _isTappedMicrophone = false;
                        });
                      });
                    },
                    onLongPress: () {
                      setState(() {
                        _isTappedMicrophone = true;
                      });
                    },
                    onLongPressEnd: (_) {
                      setState(() {
                        _isTappedMicrophone = false;
                      });
                    },
                    onLongPressUp: () {
                      setState(() {
                        _isTappedMicrophone = false;
                      });
                    },
                    child: ValueListenableBuilder<String>(
                      valueListenable: selectedMicrophone,
                      builder: (context, selectedDevice, _) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: MouseRegion(
                            onEnter: (_) {
                              setState(() {
                                isHoveredMicrophone = true;
                              });
                            },
                            onExit: (_) {
                              setState(() {
                                isHoveredMicrophone = false;
                              });
                            },
                            child: CustomTooltip(
                              message: selectedDevice == "Устройство по умолчанию" ? "Устройство по умолчанию" : selectedDevice,
                              verticalOffset: -80,
                              disableOnTap: _isTappedTest,
                              disableTooltipOnLongPress: true,
                              child: Container(
                                width: 250,
                                height: 35,
                                padding: EdgeInsets.symmetric(horizontal: 12),
                                decoration: BoxDecoration(
                                  color: _isTappedMicrophone ? (context.isDarkMode ? ChatifyColors.mildNight : ChatifyColors.grey.withAlpha(100)) : isHoveredMicrophone
                                    ? (context.isDarkMode ? ChatifyColors.lightSoftNight.withAlpha((0.8 * 255).toInt()) : ChatifyColors.black.withAlpha((0.3 * 255).toInt()))
                                    : (context.isDarkMode ? ChatifyColors.softNight : ChatifyColors.white),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(FluentIcons.mic_28_regular, size: 19),
                                        SizedBox(width: 10),
                                        Padding(
                                          padding: const EdgeInsets.only(bottom: 2),
                                          child: SizedBox(
                                            width: 180,
                                            child: Text(
                                              selectedDevice == "Устройство по умолчанию" ? "Устройство по умолчанию" : selectedDevice,
                                              style: TextStyle(fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w300),
                                              maxLines: 1,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    AnimatedContainer(
                                      duration: const Duration(milliseconds: 200),
                                      transform: Matrix4.translationValues(0, _isTappedMicrophone ? 2.0 : 0, 0),
                                      child: SvgPicture.asset(ChatifyVectors.arrowDown, color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black, width: 15, height: 15),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                Text("Тест", style: TextStyle(fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w300)),
                const SizedBox(height: 5),
                Row(
                  children: [
                    CustomTooltip(
                      message: 'Нажмите, чтобы проверить, слышат ли вас другие.',
                      verticalOffset: -80,
                      disableOnTap: _isTappedTest,
                      disableTooltipOnLongPress: true,
                      child: Material(
                        color: ChatifyColors.transparent,
                        child: Ink(
                          decoration: BoxDecoration(
                            color: context.isDarkMode ? ChatifyColors.softNight : ChatifyColors.softGrey,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey),
                          ),
                          child: InkWell(
                            onTap: _toggleRecording,
                            mouseCursor: SystemMouseCursors.basic,
                            borderRadius: BorderRadius.circular(8),
                            splashColor: ChatifyColors.transparent,
                            highlightColor: context.isDarkMode ? ChatifyColors.mildNight : ChatifyColors.grey,
                            hoverColor: context.isDarkMode ? ChatifyColors.lightSoftNight.withAlpha((0.8 * 255).toInt()) : ChatifyColors.grey.withAlpha((0.5 * 255).toInt()),
                            child: SizedBox(
                              width: 42,
                              height: 30,
                              child: isRecording && !isPaused ? Icon(BootstrapIcons.stop_circle, size: 20) : isRecording && isPaused
                                ? Icon(Icons.play_arrow, size: 22)
                                : SvgPicture.asset(ChatifyVectors.radioButtonChecked, color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black, width: 16, height: 16),
                            ),
                          ),
                        ),
                      ),
                    ),
                    if (isRecording)
                    Row(
                      children: [
                        SizedBox(width: 8),
                        if (isPaused)
                          SizedBox(
                            width: 230,
                            child: LinearProgressIndicator(
                              value: (_initialRemainingTime - _remainingTime) / 15,
                              backgroundColor: ChatifyColors.grey,
                              valueColor: AlwaysStoppedAnimation<Color>(colorsController.getColor(colorsController.selectedColorScheme.value)),
                            ),
                          ),
                        SizedBox(width: 6),
                        if (isRecording && !isPaused)
                          Row(
                            children: [
                              Text(Formatter.formatTime(_remainingTime), style: TextStyle(fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w300)),
                              SizedBox(width: 10),
                              Text('Идет запись с микрофона', style: TextStyle(fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w300)),
                            ],
                          ),
                      ],
                    ),
                    if (!isRecording)
                    Row(
                      children: [
                        SizedBox(width: 8),
                        Text('Записать с микрофона', style: TextStyle(fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w300)),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text("Динамики", style: TextStyle(fontSize: ChatifySizes.fontSizeLg, fontWeight: FontWeight.w300)),
                CompositedTransformTarget(
                  link: speakerDeviceNotifyLink,
                  child: GestureDetector(
                    onTap: () {
                      showSelectDeviceDialog(context, selectedSpeaker, DeviceType.speaker, devicesNotifyLink: speakerDeviceNotifyLink);
                      setState(() {
                        _isTappedSpeakers = !_isTappedSpeakers;
                      });
                      Future.delayed(Duration(milliseconds: 200), () {
                        setState(() {
                          _isTappedSpeakers = false;
                        });
                      });
                    },
                    onLongPress: () {
                      setState(() {
                        _isTappedSpeakers = true;
                      });
                    },
                    onLongPressEnd: (_) {
                      setState(() {
                        _isTappedSpeakers = false;
                      });
                    },
                    onLongPressUp: () {
                      setState(() {
                        _isTappedSpeakers = false;
                      });
                    },
                    child: ValueListenableBuilder<String>(
                      valueListenable: selectedSpeaker,
                      builder: (context, selectedDevice, _) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: MouseRegion(
                            onEnter: (_) {
                              setState(() {
                                isHoveredSpeakers = true;
                              });
                            },
                            onExit: (_) {
                              setState(() {
                                isHoveredSpeakers = false;
                              });
                            },
                            child: CustomTooltip(
                              message: selectedDevice == "Устройство по умолчанию" ? "Устройство по умолчанию" : selectedDevice,
                              verticalOffset: -80,
                              disableOnTap: _isTappedTest,
                              child: Container(
                                width: 250,
                                height: 35,
                                padding: EdgeInsets.symmetric(horizontal: 12),
                                decoration: BoxDecoration(
                                  color: _isTappedSpeakers ? (context.isDarkMode ? ChatifyColors.mildNight : ChatifyColors.grey.withAlpha(100)) : isHoveredSpeakers
                                    ? (context.isDarkMode ? ChatifyColors.lightSoftNight.withAlpha((0.8 * 255).toInt()) : ChatifyColors.black.withAlpha((0.3 * 255).toInt()))
                                    : (context.isDarkMode ? ChatifyColors.softNight : ChatifyColors.white),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        HeroIcon(HeroIcons.speakerWave, size: 19),
                                        SizedBox(width: 10),
                                        Padding(
                                          padding: const EdgeInsets.only(bottom: 2),
                                          child: SizedBox(
                                            width: 180,
                                            child: Text(
                                              selectedDevice == "Устройство по умолчанию" ? "Устройство по умолчанию" : selectedDevice,
                                              style: TextStyle(fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w300),
                                              maxLines: 1,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    AnimatedContainer(
                                      duration: const Duration(milliseconds: 200),
                                      transform: Matrix4.translationValues(0, _isTappedSpeakers ? 2.0 : 0, 0),
                                      child: SvgPicture.asset(ChatifyVectors.arrowDown, color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black, width: 15, height: 15),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                Text("Тест", style: TextStyle(fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w300)),
                const SizedBox(height: 5),
                GestureDetector(
                  onLongPress: () {
                    setState(() {
                      _isTappedTest = true;
                    });
                  },
                  onLongPressEnd: (_) {
                    setState(() {
                      _isTappedTest = false;
                    });
                  },
                  onLongPressUp: () {
                    setState(() {
                      _isTappedTest = false;
                    });
                  },
                  child: CustomTooltip(
                    message: 'Нажмите, чтобы проверить, услышите ли вы других пользователей.',
                    verticalOffset: -95,
                    disableOnTap: _isTappedTest,
                    child: Container(
                      width: 250,
                      height: 35,
                      decoration: BoxDecoration(
                        color: _isTappedTest ? (context.isDarkMode ? ChatifyColors.mildNight : ChatifyColors.grey.withAlpha(100)) : isHoveredVideo
                          ? (context.isDarkMode ? ChatifyColors.lightSoftNight.withAlpha((0.8 * 255).toInt()) : ChatifyColors.black.withAlpha((0.3 * 255).toInt()))
                          : (context.isDarkMode ? ChatifyColors.softNight : ChatifyColors.white),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey),
                      ),
                      child: InkWell(
                        onTap: _toggleText,
                        mouseCursor: SystemMouseCursors.basic,
                        borderRadius: BorderRadius.circular(8),
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        child: Center(
                          child: Text(
                            buttonText,
                            style: TextStyle(fontSize: ChatifySizes.fontSizeSm, color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black, fontWeight: FontWeight.w300),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
