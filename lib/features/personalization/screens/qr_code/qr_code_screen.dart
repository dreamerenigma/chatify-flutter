import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:camera/camera.dart';
import 'package:chatify/routes/custom_page_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:math';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../../utils/constants/app_vectors.dart';
import '../../../../utils/popups/dialogs.dart';
import '../../../chat/models/user_model.dart';
import '../../widgets/dialogs/light_dialog.dart';
import 'gallery_screen.dart';

class QrCodeScreen extends StatefulWidget {
  final UserModel user;
  final int initialIndex;

  const QrCodeScreen({super.key, required this.user, this.initialIndex = 0});

  @override
  State<QrCodeScreen> createState() => _QrCodeScreenState();
}

class _QrCodeScreenState extends State<QrCodeScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late String shareId;
  late String shareLink;
  CameraController? _cameraController;
  bool _isFlashOn = false;

  @override
  void initState() {
    super.initState();
    _generateQrCode();
    _initializeCamera();
    _tabController = TabController(length: 2, vsync: this, initialIndex: widget.initialIndex);
    _tabController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    _tabController.dispose();
    super.dispose();
  }

  void _generateQrCode() {
    shareId = _generateUniqueId();
    shareLink = 'Добавьте меня в список контактов Chatify. https://chat.chatify.ru/qr/$shareId';
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    _cameraController = CameraController(cameras.first, ResolutionPreset.high);
    await _cameraController!.initialize();
    setState(() {});
  }

  void _toggleFlash() {
    setState(() {
      _isFlashOn = !_isFlashOn;
    });
    _cameraController?.setFlashMode(_isFlashOn ? FlashMode.torch : FlashMode.off);
  }

  void _switchToTab(int index) {
    if (_tabController.index != index) {
      _tabController.animateTo(index);
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          titleSpacing: 0,
          title: Text(
            'QR-код',
            style: TextStyle(
              fontSize: ChatifySizes.fontSizeMg,
              fontWeight: FontWeight.w400,
            ),
          ),
          actions: _tabController.index == 0
          ? <Widget>[
            IconButton(
              icon: const Icon(Icons.share_outlined),
              onPressed: () {
                Dialogs.showCustomDialog(context: context, message: 'Пожалуйста, подождите', duration: const Duration(seconds: 1));
                Future.delayed(const Duration(milliseconds: 200), () {
                  Navigator.pop(context);
                  Share.share(shareLink);
                });
              },
            ),
            PopupMenuButton<int>(
              position: PopupMenuPosition.under,
              color: context.isDarkMode ? ChatifyColors.darkSlate : ChatifyColors.white,
              icon: const Icon(Icons.more_vert),
              onSelected: (value) {
                if (value == 1) {
                  _showResetDialog();
                }
              },
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 1,

                  child: Text(
                    'Сбросить QR-код',
                    style: TextStyle(fontSize: ChatifySizes.fontSizeMd),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ]
          : null,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(48.0),
            child: TabBar(
              controller: _tabController,
              indicatorColor: colorsController.getColor(colorsController.selectedColorScheme.value),
              labelColor: ChatifyColors.white,
              unselectedLabelColor: ChatifyColors.darkGrey,
              indicatorSize: TabBarIndicatorSize.tab,
              overlayColor: WidgetStateProperty.all(ChatifyColors.darkerGrey),
              dividerColor: ChatifyColors.transparent,
              tabs: const [
                Tab(
                  text: 'Мой код',
                ),
                Tab(
                  text: 'Сканировать код',
                ),
              ],
            ),
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildQrCodeTab(),
            _buildCameraView(),
          ],
        ),
      ),
    );
  }

  Widget _buildQrCodeTab() {
    return Padding(
      padding: const EdgeInsets.all(40.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(12.0),
            width: 350,
            decoration: BoxDecoration(
              color: ChatifyColors.blackGrey,
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 90.0, bottom: 30),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12.0),
                            child: QrImageView(
                              data: shareLink,
                              version: QrVersions.auto,
                              size: 180,
                              gapless: false,
                              backgroundColor: ChatifyColors.white,
                            ),
                          ),
                          SvgPicture.asset(
                            ChatifyVectors.logo,
                            height: 35,
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      top: -35,
                      left: 0,
                      right: 0,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircleAvatar(
                            radius: 25,
                            backgroundColor: ChatifyColors.transparent,
                            child: CircleAvatar(
                              radius: 24,
                              backgroundColor: ChatifyColors.transparent,
                              child: widget.user.image.isNotEmpty
                                  ? CircleAvatar(
                                radius: 24,
                                backgroundImage:
                                NetworkImage(widget.user.image),
                                backgroundColor: ChatifyColors.darkerGrey,
                              )
                                  : SvgPicture.asset(
                                ChatifyVectors.profile,
                                height: 40,
                                width: 40,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8.0),
                          Text(
                            widget.user.name,
                            style: const TextStyle(
                              color: ChatifyColors.white,
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4.0),
                          Text(
                            'Контакт Chatify',
                            style: TextStyle(
                              color: ChatifyColors.darkGrey,
                              fontSize: ChatifySizes.fontSizeLm,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24.0),
          const Text(
            'Ваш QR-код конфиденциален. Пользователи, с которыми вы им поделитесь, смогут просканировать его с помощью камеры Chatify, чтобы добавить вас в свой список контактов.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: ChatifyColors.darkGrey,
              fontSize: 14.0,
            ),
          ),
        ],
      ),
    );
  }

  void _showResetDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.white,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Сбросить QR-код?'),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
          content: Text(
            'Прежний QR-код больше не будет действителен.',
            style: TextStyle(
              color: context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.blackGrey,
              fontSize: ChatifySizes.fontSizeMd,
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: TextButton.styleFrom(
                foregroundColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                backgroundColor: colorsController.getColor(colorsController.selectedColorScheme.value).withAlpha((0.1 * 255).toInt()),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              ),
              child: Text(
                'Сохранить',
                style: TextStyle(color: colorsController.getColor(colorsController.selectedColorScheme.value), fontSize: ChatifySizes.fontSizeMd),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  _generateQrCode();
                });
              },
              style: TextButton.styleFrom(
                foregroundColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                backgroundColor: colorsController.getColor(colorsController.selectedColorScheme.value).withAlpha((0.1 * 255).toInt()),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              ),
              child: Text(
                'Сброс',
                style: TextStyle(color: colorsController.getColor(colorsController.selectedColorScheme.value), fontSize: ChatifySizes.fontSizeMd),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildCameraView() {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(colorsController.getColor(colorsController.selectedColorScheme.value))));
    }

    return Stack(
      children: [
        Positioned.fill(
          child: CameraPreview(_cameraController!),
        ),
        Positioned.fill(
          child: ClipPath(clipper: QRScannerClipper(), child: Container(color: ChatifyColors.black.withAlpha((0.5 * 255).toInt()))),
        ),
        Positioned(
          top: MediaQuery.of(context).size.height * 0.6,
          left: 0,
          right: 0,
          child: Center(
            child: Text('Сканировать QR-код Chatify',style: TextStyle(color: ChatifyColors.white,fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.bold)),
          ),
        ),
        Positioned(
          left: 16,
          bottom: 16,
          child: IconButton(
            icon: const Icon(BootstrapIcons.images, color: Colors.white),
            onPressed: () {
              Navigator.push(context, createPageRoute(const GalleryScreen()));
            },
          ),
        ),
        Positioned(
          right: 16,
          bottom: 16,
          child: IconButton(
            icon: Icon(
              _isFlashOn ? Icons.flash_on_outlined : Icons.flash_off_outlined,
              color: ChatifyColors.white,
            ),
            onPressed: _toggleFlash,
          ),
        ),
      ],
    );
  }
}

String _generateUniqueId({int length = 16}) {
  const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
  Random random = Random();

  return List.generate(length, (index) => chars[random.nextInt(chars.length)]).join();
}

class QRScannerClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    double cutoutSize = 250.0;
    double cornerRadius = 24.0;

    double left = (size.width - cutoutSize) / 2;
    double top = (size.height - cutoutSize) / 2;

    Path path = Path()..addRRect(RRect.fromRectAndRadius(Rect.fromLTWH(left, top, cutoutSize, cutoutSize), Radius.circular(cornerRadius)));

    return Path.combine(PathOperation.difference, Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height)), path);
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
