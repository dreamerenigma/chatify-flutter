import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../../../generated/l10n/l10n.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../../utils/constants/app_vectors.dart';
import '../../../personalization/widgets/dialogs/light_dialog.dart';

class QrCodeWidget extends StatelessWidget {
  final bool isLoading;
  final bool isQrCodeExpired;
  final String qrCodeData;
  final VoidCallback reloadQrCode;

  const QrCodeWidget({
    super.key,
    required this.isLoading,
    required this.isQrCodeExpired,
    required this.qrCodeData,
    required this.reloadQrCode,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double width = constraints.maxWidth;
        final double qrSize = width - 40;
        const double logoHeight = 60;

        return Center(
          child: Container(
            padding: const EdgeInsets.all(12.0),
            width: 240,
            height: 240,
            decoration: BoxDecoration(color: ChatifyColors.white, borderRadius: BorderRadius.circular(30)),
            child: Stack(
              alignment: Alignment.center,
              children: [
                if (isLoading)
                  CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(colorsController.getColor(colorsController.selectedColorScheme.value)))
                else if (isQrCodeExpired)
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    width: 280,
                    height: 280,
                    decoration: BoxDecoration(
                      color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.white,
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: ChatifyColors.grey, width: 2),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(S.of(context).qrCodeExpired, textAlign: TextAlign.center, style: TextStyle(fontSize: ChatifySizes.fontSizeMd, color: ChatifyColors.darkGrey)),
                        const SizedBox(height: 20),
                        ElevatedButton.icon(
                          onPressed: reloadQrCode,
                          icon: const Icon(Icons.refresh, color: ChatifyColors.white),
                          label: Text(S.of(context).reboot),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                            backgroundColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                            foregroundColor: ChatifyColors.white,
                            side: BorderSide.none,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                          ).copyWith(
                            mouseCursor: WidgetStateProperty.all(SystemMouseCursors.basic),
                          ),
                        ),
                      ],
                    ),
                  )
                else ...[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(25),
                    child: QrImageView(
                      data: qrCodeData,
                      version: QrVersions.auto,
                      size: qrSize * 0.85,
                      gapless: false,
                      backgroundColor: ChatifyColors.white,
                    ),
                  ),
                  Positioned(child: SvgPicture.asset(ChatifyVectors.logo, height: logoHeight)),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}
