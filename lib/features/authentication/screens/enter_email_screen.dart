import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../api/apis.dart';
import '../../../generated/l10n/l10n.dart';
import '../../../routes/custom_page_route.dart';
import '../../../utils/constants/app_colors.dart';
import '../../../utils/constants/app_sizes.dart';
import '../../home/screens/home_screen.dart';
import '../../personalization/widgets/dialogs/light_dialog.dart';
import '../../utils/widgets/no_glow_scroll_behavior.dart';
import '../../welcome/screen/problem_detected_screen.dart';
import '../widgets/bars/auth_app_bar.dart';
import 'binding_auxiliary_device_screen.dart';

class EnterEmailScreen extends StatefulWidget {
  const EnterEmailScreen({super.key});

  @override
  EnterEmailScreenState createState() => EnterEmailScreenState();
}

class EnterEmailScreenState extends State<EnterEmailScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> signUpWithEmailAndPassword() async {
    try {
      final String email = emailController.text.trim();
      final String password = passwordController.text.trim();

      try {
        final UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        await FirebaseFirestore.instance.collection('Users').doc(userCredential.user!.uid).set({
          'email': email,
          'createdAt': Timestamp.now(),
        });

        Navigator.pushReplacement(context, createPageRoute(HomeScreen(user: APIs.me)));

        Get.snackbar(S.of(context).success, S.of(context).registrationSuccessful);
      } on FirebaseAuthException catch (e) {
        if (e.code == 'email-already-in-use') {
          APIs.signInWithEmailAndPassword(context, email, password);
        } else {
          Get.snackbar(S.of(context).errorRegistration, e.message ?? e.code);
        }
      }
    } catch (e) {
      Get.snackbar(S.of(context).error, S.of(context).unknownErrorRegistration);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.grey.withAlpha((0.7 * 255).toInt()),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AuthAppBar(
            title: S.of(context).loginByMail,
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
                pageBuilder: (context, animation, secondaryAnimation) => const ProblemDetectedScreen(),
                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                  return FadeTransition(opacity: animation, child: child);
                },
              ));
            },
            menuItem1Text: S.of(context).bindAuxiliaryDevice,
            menuItem2Text: S.of(context).help,
          ),
          _buildEmailLoginForm(),
        ],
      ),
    );
  }

  Widget _buildEmailLoginForm() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15),
        child: Center(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth >= 750;

              return Platform.isWindows
                ? ScrollConfiguration(
                behavior: NoGlowScrollBehavior(),
                  child: SingleChildScrollView(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      constraints: const BoxConstraints(maxWidth: 500),
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: isWide ? 55 : 10),
                        decoration: BoxDecoration(color: ChatifyColors.deepNight, borderRadius: BorderRadius.circular(15)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(S.of(context).enterYourEmailLogInApp, style: TextStyle(fontSize: ChatifySizes.fontSizeMd), textAlign: TextAlign.center),
                            const SizedBox(height: 16),
                            SizedBox(
                              width: 400,
                              child: TextSelectionTheme(
                                data: TextSelectionThemeData(
                                  cursorColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                                  selectionColor: colorsController.getColor(colorsController.selectedColorScheme.value).withAlpha((0.3 * 255).toInt()),
                                  selectionHandleColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                                ),
                                child: TextField(
                                  controller: emailController,
                                  decoration: InputDecoration(
                                    hintText: 'Email',
                                    hintStyle: TextStyle(color: context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.grey, fontSize: ChatifySizes.fontSizeMd),
                                    filled: true,
                                    fillColor: Theme.of(context).brightness == Brightness.dark ? ChatifyColors.popupColorDark.withAlpha((0.5 * 255).toInt()) : ChatifyColors.grey.withAlpha((0.2 * 255).toInt()),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(color: colorsController.getColor(colorsController.selectedColorScheme.value), width: 1),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(color: ChatifyColors.darkerGrey, width: 1),
                                    ),
                                  ),
                                  keyboardType: TextInputType.emailAddress,
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            SizedBox(
                              width: 400,
                              child: TextSelectionTheme(
                                data: TextSelectionThemeData(
                                  cursorColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                                  selectionColor: colorsController.getColor(colorsController.selectedColorScheme.value).withAlpha((0.3 * 255).toInt()),
                                  selectionHandleColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                                ),
                                child: TextField(
                                  controller: passwordController,
                                  obscureText: !_isPasswordVisible,
                                  decoration: InputDecoration(
                                    hintText: S.of(context).password,
                                    hintStyle: TextStyle(color: context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.grey, fontSize: ChatifySizes.fontSizeMd),
                                    filled: true,
                                    fillColor: Theme.of(context).brightness == Brightness.dark ? ChatifyColors.popupColorDark.withAlpha((0.5 * 255).toInt()) : ChatifyColors.grey.withAlpha((0.2 * 255).toInt()),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(color: colorsController.getColor(colorsController.selectedColorScheme.value), width: 1),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(color: ChatifyColors.darkerGrey, width: 1),
                                    ),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _isPasswordVisible = !_isPasswordVisible;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            SizedBox(
                              width: 400,
                              child: ElevatedButton(
                                onPressed: signUpWithEmailAndPassword,
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                                  backgroundColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                                  foregroundColor: ChatifyColors.white,
                                  side: BorderSide.none,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
                                child: Text(S.of(context).login),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ) : Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [],
                );
            },
          ),
        ),
      ),
    );
  }
}
