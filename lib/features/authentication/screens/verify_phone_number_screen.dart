import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../api/apis.dart';
import '../../../generated/l10n/l10n.dart';
import '../../../routes/custom_page_route.dart';
import '../../../utils/constants/app_colors.dart';
import '../../../utils/constants/app_sizes.dart';
import '../../chat/models/user_model.dart';
import '../../personalization/widgets/dialogs/light_dialog.dart';
import '../../welcome/screen/problem_detected_screen.dart';
import '../widgets/dialogs/verify_code_sheet_dialog.dart';
import '../widgets/fields/opt_field.dart';
import 'enter_phone_number.dart';
import '../../home/screens/home_screen.dart';

class VerifyPhoneNumberScreen extends StatefulWidget {
  final UserModel user;
  final String phoneNumber;
  final String verificationId;

  const VerifyPhoneNumberScreen({
    super.key,
    required this.phoneNumber,
    required this.user,
    required this.verificationId,
  });

  @override
  VerifyPhoneNumberScreenState createState() => VerifyPhoneNumberScreenState();
}

class VerifyPhoneNumberScreenState extends State<VerifyPhoneNumberScreen> {
  bool isLoading = false;
  final List<TextEditingController> _controllers = List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());
  final TextEditingController _otpController = TextEditingController();

  void _verifyOtp() async {
    try {
      final smsCode = _otpController.text.trim();

      if (smsCode.length == 6) {
        final credential = PhoneAuthProvider.credential(
          verificationId: widget.verificationId,
          smsCode: smsCode,
        );

        await FirebaseAuth.instance.signInWithCredential(credential);

        Navigator.pushReplacement(context, createPageRoute(HomeScreen(user: APIs.me)));
        Get.snackbar(S.of(context).success, S.of(context).registrationSuccess);
      } else {
        Get.snackbar(S.of(context).warning, S.of(context).incorrectOtpCode);
      }
    } catch (e) {
      Get.snackbar(S.of(context).error, S.of(context).errorCheckingOtpCode);
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading ? Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(colorsController.getColor(colorsController.selectedColorScheme.value)))) : Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 40),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: Text(S.of(context).numberConfirm, textAlign: TextAlign.center, style: TextStyle(fontSize: ChatifySizes.fontSizeLg)),
                      ),
                    ],
                  ),
                ),
                PopupMenuButton<int>(
                  position: PopupMenuPosition.under,
                  color: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.white,
                  icon: const Icon(Icons.more_vert),
                  onSelected: (value) {
                    if (value == 1) {
                      Navigator.push(context, createPageRoute(const ProblemDetectedScreen()));
                    }
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 1,
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(S.of(context).help, style: TextStyle(fontSize: ChatifySizes.fontSizeMd), maxLines: 1, overflow: TextOverflow.ellipsis),
                      ),
                    ),
                  ],
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                ),
              ],
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 30, right: 30, top: 16, bottom: 8),
                child: Center(
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: S.of(context).smsSentNumber,
                          style: TextStyle(
                            color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black,
                            height: 1.5,
                          ),
                        ),
                        TextSpan(
                          text: widget.phoneNumber,
                          style: TextStyle(
                            color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black,
                            fontWeight: FontWeight.bold,
                            height: 1.5,
                          ),
                        ),
                        TextSpan(
                          text: '.',
                          style: TextStyle(
                            color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black,
                            height: 1.5,
                          ),
                        ),
                        TextSpan(
                          text: S.of(context).invalidNumber,
                          style: TextStyle(
                            color: colorsController.getColor(colorsController.selectedColorScheme.value),
                            decoration: TextDecoration.none,
                            height: 1.5,
                          ),
                          recognizer: TapGestureRecognizer()..onTap = () async {
                            Navigator.push(context, createPageRoute(const EnterPhoneNumberScreen()));
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(6, (index) {
                  return OtpField(
                    controller: _controllers[index],
                    focusNode: _focusNodes[index],
                    nextFocusNode: index < 5 ? _focusNodes[index + 1] : null,
                    onChanged: (value) {
                      String otp = _controllers.map((controller) => controller.text).join();
                      _otpController.text = otp;

                      if (otp.length == 6) {
                        _verifyOtp();
                      }
                    },
                  );
                }),
              ),
              const SizedBox(height: 20),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: S.of(context).noReceiveCode,
                      style: TextStyle(
                        color: colorsController.getColor(colorsController.selectedColorScheme.value),
                        fontSize: ChatifySizes.fontSizeSm,
                        decoration: TextDecoration.none,
                      ),
                      recognizer: TapGestureRecognizer()..onTap = () {
                        showVerifyCodeBottomSheetDialog(context);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
