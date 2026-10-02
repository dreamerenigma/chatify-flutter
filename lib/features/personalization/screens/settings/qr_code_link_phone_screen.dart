import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_utils/src/extensions/context_extensions.dart';
import 'package:qr/qr.dart';
import '../../../../routes/custom_page_route.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_vectors.dart';
import '../../../chat/models/user_model.dart';
import '../../../utils/widgets/buttons/custom_bottom_button.dart';
import '../../../utils/widgets/scrolls/no_glow_scroll_behavior.dart';
import '../../widgets/painters/qr_painter.dart';

class QrCodeLinkPhoneScreen extends StatefulWidget {
  final UserModel user;

  const QrCodeLinkPhoneScreen({
    super.key,
    required this.user,
  });

  @override
  State<QrCodeLinkPhoneScreen> createState() => _QrCodeLinkPhoneScreenState();
}

class _QrCodeLinkPhoneScreenState extends State<QrCodeLinkPhoneScreen> {
  late String shareLink;

  @override
  void initState() {
    super.initState();
    shareLink = 'https://chatify.app/link/${widget.user.id}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration: BoxDecoration(
            color: ChatifyColors.white,
            boxShadow: [BoxShadow(color: ChatifyColors.black.withAlpha((0.1 * 255).toInt()), spreadRadius: 1, blurRadius: 3, offset: const Offset(0, 1))],
          ),
          child: AppBar(
            titleSpacing: 0,
            elevation: 0,
            backgroundColor: context.isDarkMode ? ChatifyColors.darkBackground : ChatifyColors.white,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_rounded, size: 25),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ScrollConfiguration(
              behavior: NoGlowScrollBehavior(),
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        'Отсканируйте этот код с помощью телефона, чтобы подключиться к аккаунту ${widget.user.name}',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black, fontSize: 26, fontWeight: FontWeight.w400, height: 1.4),
                      ),
                    ),
                    _buildQrCodeTab(),
                  ],
                ),
              ),
            ),
          ),
          CustomBottomButton(text: 'Поделиться ссылкой', onTap: () => Navigator.push(context, createPageRoute(QrCodeLinkPhoneScreen(user: widget.user)))),
        ],
      ),
    );
  }

  Widget _buildQrCodeTab() {
    final qrCode = QrCode(payload: QrPayload.fromString(shareLink), errorCorrectLevel: QrErrorCorrectLevel.medium, minTypeNumber: 5);
    final qrImage = QrImage(qrCode);

    return Padding(
      padding: const EdgeInsets.all(40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 30),
            child: Container(
              width: 270,
              height: 270,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: ChatifyColors.white, borderRadius: BorderRadius.circular(12)),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CustomPaint(size: const Size(246, 246), painter: QrPainter(qrImage: qrImage, finderScale: 0.72)),
                  Container(
                    width: 58,
                    height: 58,
                    padding: EdgeInsets.zero,
                    decoration: BoxDecoration(color: ChatifyColors.white, borderRadius: BorderRadius.circular(50)),
                    child: SvgPicture.asset(ChatifyVectors.logo),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
