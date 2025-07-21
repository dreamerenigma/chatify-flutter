import 'dart:async';
import 'dart:math';
import 'package:chatify/features/utils/widgets/no_glow_scroll_behavior.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../generated/l10n/l10n.dart';
import '../../../utils/constants/app_colors.dart';
import '../../../utils/constants/app_sizes.dart';
import '../widgets/bars/auth_app_bar.dart';
import '../widgets/widget/qr_code_widget.dart';
import '../widgets/widget/text_description_widget.dart';
import 'enter_phone_number.dart';

class BindingAuxiliaryDeviceScreen extends StatefulWidget {
  const BindingAuxiliaryDeviceScreen({super.key});

  @override
  State<BindingAuxiliaryDeviceScreen> createState() => _BindingAuxiliaryDeviceScreenState();
}

class _BindingAuxiliaryDeviceScreenState extends State<BindingAuxiliaryDeviceScreen> {
  final GlobalKey _newMenuKey = GlobalKey();
  bool _isQrCodeExpired = false;
  bool _isLoading = true;
  bool isHovered = false;
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

  void _generateNewQrCode() {
    setState(() {
      _qrCodeData = _generateUniqueId();
    });
  }

  String _generateUniqueId({int length = 256}) {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    Random random = Random();

    return List.generate(length, (index) => chars[random.nextInt(chars.length)]).join();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.grey.withAlpha((0.7 * 255).toInt()),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AuthAppBar(
            title: S.of(context).bindingAuxiliaryDevice,
            onMenuItemIndex1: () {
              Navigator.of(context).push(PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) => const BindingAuxiliaryDeviceScreen(),
                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                  return FadeTransition(opacity: animation, child: child);
                },
              ));
            },
            onMenuItemIndex2: () {
              Navigator.of(context).push(PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) => const EnterPhoneNumberScreen(),
                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                  return FadeTransition(opacity: animation, child: child);
                },
              ));
            },
            menuItem1Text: 'Помощь',
            menuItem2Text: 'Зарегистрировать новый аккаунт',
          ),
          Expanded(
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
                              padding: EdgeInsets.only(left: 20, right: isWide ? 40 : 0, top: isWide ? 55 : 20, bottom: isWide ? 55 : 20),
                              decoration: BoxDecoration(color: ChatifyColors.deepNight, borderRadius: BorderRadius.circular(15)),
                              child: isWide
                                ? Padding(
                                    padding: const EdgeInsets.only(top: 20),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Column(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 12),
                                                child: Text(S.of(context).scanCodeUse, style: TextStyle(color: ChatifyColors.darkGrey, fontSize: ChatifySizes.fontSizeMd, height: 1.2)),
                                              ),
                                              const SizedBox(height: 10),
                                              TextDescriptionWidget(),
                                            ],
                                          ),
                                        ),
                                        QrCodeWidget(isLoading: _isLoading, isQrCodeExpired: _isQrCodeExpired, qrCodeData: _qrCodeData, reloadQrCode: reloadQrCode),
                                      ],
                                    ),
                                  )
                                : Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      const SizedBox(height: 35),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 30),
                                        child: Text(S.of(context).scanCodeUse, textAlign: TextAlign.center, style: TextStyle(color: ChatifyColors.darkGrey, height: 1.2)),
                                      ),
                                      const SizedBox(height: 15),
                                      QrCodeWidget(isLoading: _isLoading, isQrCodeExpired: _isQrCodeExpired, qrCodeData: _qrCodeData, reloadQrCode: reloadQrCode),
                                      const SizedBox(height: 25),
                                      const TextDescriptionWidget(),
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
          ),
        ],
      ),
    );
  }
}
