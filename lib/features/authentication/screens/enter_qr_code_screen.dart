import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../generated/l10n/l10n.dart';
import '../../../utils/constants/app_colors.dart';
import '../../utils/widgets/no_glow_scroll_behavior.dart';
import '../../welcome/screen/problem_detected_screen.dart';
import '../widgets/bars/auth_app_bar.dart';
import '../widgets/widget/qr_code_widget.dart';
import '../widgets/widget/text_description_widget.dart';

class EnterQrCodeScreen extends StatefulWidget {
  const EnterQrCodeScreen({super.key});

  @override
  State<EnterQrCodeScreen> createState() => _EnterQrCodeScreenState();
}

class _EnterQrCodeScreenState extends State<EnterQrCodeScreen> {
  bool isHovered = false;
  bool _isQrCodeExpired = false;
  bool _isLoading = true;
  Timer? _refreshTimer;
  Timer? _expiryTimer;
  String _qrCodeData = '';

  @override
  void initState() {
    super.initState();
    _generateNewQrCode();
    _startRefreshTimer();
    _startQrCodeTimer();
    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    _expiryTimer?.cancel();
    super.dispose();
  }

  String _generateUniqueId({int length = 256}) {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    Random random = Random();

    return List.generate(length, (index) => chars[random.nextInt(chars.length)]).join();
  }

  void _generateNewQrCode() {
    setState(() {
      _qrCodeData = _generateUniqueId();
    });
  }

  void _startRefreshTimer() {
    _refreshTimer = Timer.periodic(const Duration(seconds: 20), (timer) {
      if (mounted) {
        if (_isQrCodeExpired) {
          return;
        }

        setState(() {
          _isLoading = true;
        });

        Future.delayed(const Duration(seconds: 1), () {
          if (mounted) {
            setState(() {
              _generateNewQrCode();
              _isLoading = false;
              _isQrCodeExpired = false;
              _startQrCodeTimer();
            });
          }
        });
      }
    });
  }

  void _startQrCodeTimer() {
    _expiryTimer = Timer(const Duration(minutes: 1), () {
      if (mounted) {
        setState(() {
          _isQrCodeExpired = true;
        });
      }
    });
  }

  void reloadQrCode() {
    setState(() {
      _isLoading = true;
      _isQrCodeExpired = false;
    });

    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _generateNewQrCode();
          _isLoading = false;
          _startQrCodeTimer();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.grey.withAlpha((0.7 * 255).toInt()),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AuthAppBar(
            title: S.of(context).enterYourPhoneNum,
            onMenuItemIndex1: () {
              Navigator.of(context).push(PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) => const ProblemDetectedScreen(),
                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                  return FadeTransition(opacity: animation, child: child);
                },
              ));
            },
            menuItem1Text: S.of(context).help,
          ),
          _buildLoginForm(),
        ],
      ),
    );
  }

  Widget _buildLoginForm() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15),
        child: Center(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth >= 750;

              return ScrollConfiguration(
                behavior: NoGlowScrollBehavior(),
                child: SingleChildScrollView(
                  child: Align(
                    alignment: Alignment.center,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      constraints: const BoxConstraints(maxWidth: 1000),
                      child: Container(
                        padding: EdgeInsets.only(left: 20, right: isWide ? 40 : 0, top: isWide ? 85 : 20, bottom: isWide ? 85 : 20),
                        decoration: BoxDecoration(color: ChatifyColors.deepNight, borderRadius: BorderRadius.circular(15)),
                        child: isWide
                            ? Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: TextDescriptionWidget(topTitle: S.of(context).installYourComputer, bottomTitle: S.of(context).contactPhoneNumber),
                            ),
                            const SizedBox(width: 20),
                            QrCodeWidget(isLoading: _isLoading, isQrCodeExpired: _isQrCodeExpired, qrCodeData: _qrCodeData, reloadQrCode: reloadQrCode),
                          ],
                        )
                            : Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const SizedBox(height: 35),
                            QrCodeWidget(isLoading: _isLoading, isQrCodeExpired: _isQrCodeExpired, qrCodeData: _qrCodeData, reloadQrCode: reloadQrCode),
                            const SizedBox(height: 25),
                            Center(
                              child: ConstrainedBox(
                                constraints: const BoxConstraints(maxWidth: 500),
                                child: TextDescriptionWidget(topTitle: S.of(context).installYourComputer, bottomTitle: S.of(context).contactPhoneNumber),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
