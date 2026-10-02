import 'dart:developer';
import 'package:chatify/features/utils/widgets/dividers/custom_divider.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/context_extensions.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../../../utils/constants/app_colors.dart';
import '../../../utils/constants/app_sizes.dart';
import '../../personalization/widgets/dialogs/light_dialog.dart';
import '../widgets/painters/qr_frame_painter.dart';
import '../widgets/painters/qr_scanner_overlay_painter.dart';

class ScanQrCodeScreen extends StatefulWidget {
  const ScanQrCodeScreen({super.key});

  @override
  State<ScanQrCodeScreen> createState() => _ScanQrCodeScreenState();
}

class _ScanQrCodeScreenState extends State<ScanQrCodeScreen> {
  final MobileScannerController _scannerController = MobileScannerController(facing: CameraFacing.back);
  bool _isScanned = false;
  bool _isQrDetected = false;

  bool _isChatifyPairingQr(String value) {
    return value.startsWith('chatify://pair');
  }

  @override
  void dispose() {
    _scannerController.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) {
    if (_isScanned) return;

    for (final barcode in capture.barcodes) {
      final value = barcode.rawValue;

      if (value == null || value.isEmpty) {
        continue;
      }

      if (!_isChatifyPairingQr(value)) {
        continue;
      }

      log('CHATIFY PAIR QR: $value');

      setState(() {
        _isQrDetected = true;
      });

      _isScanned = true;

      _scannerController.stop();

      break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ChatifyColors.blackGrey,
      appBar: AppBar(
        titleSpacing: 0,
        elevation: 0,
        title: Text('Сканировать QR-код', style: TextStyle(fontSize: ChatifySizes.fontSizeMg, fontWeight: FontWeight.w400)),
        backgroundColor: ChatifyColors.blackGrey,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, size: 25),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          CustomDivider(indent: 0, endIndent: 0, left: 0, right: 0, top: 5, bottom: 0),
          const SizedBox(height: 14),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              'Откройте web.chatify.ru, приложение на компьютере или другом устройстве.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.darkerGrey,
                fontSize: ChatifySizes.fontSizeMg,
                fontWeight: FontWeight.w300,
                height: 1.2,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Stack(
              children: [
                Positioned.fill(child: MobileScanner(controller: _scannerController, onDetect: _onDetect,)),
                Positioned.fill(child: CustomPaint(painter: QrScannerOverlayPainter(borderColor: ChatifyColors.white))),
                if (_isQrDetected)
                  Positioned.fill(child: IgnorePointer(child: CustomPaint(painter: QrFramePainter(color: colorsController.getColor(colorsController.selectedColorScheme.value))))),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(color: ChatifyColors.black.withValues(alpha: 0.55)),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                    child: Center(
                      child: Text(
                        'Связать по номеру телефона',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: ChatifyColors.white, fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w400,
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
    );
  }
}
