import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../../generated/l10n/l10n.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../widgets/dialogs/light_dialog.dart';

class PrivacyCallsScreen extends StatefulWidget {
  const PrivacyCallsScreen({super.key});

  @override
  State<PrivacyCallsScreen> createState() => PrivacyCallsScreenState();
}

class PrivacyCallsScreenState extends State<PrivacyCallsScreen> {
  bool isMuted = false;
  bool isLoading = false;
  final storage = GetStorage();

  @override
  void initState() {
    super.initState();
    isMuted = storage.read('isMuted') ?? false;
  }

  void toggleSwitch(bool value) async {
    setState(() {
      isLoading = true;
    });

    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      isMuted = value;
      isLoading = false;
    });

    storage.write('isMuted', isMuted);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration: BoxDecoration(
            color: ChatifyColors.white,
            boxShadow: [
              BoxShadow(
                color: ChatifyColors.black..withAlpha((0.1 * 255).toInt()),
                spreadRadius: 1,
                blurRadius: 3,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: AppBar(
            title: Text(
              S.of(context).calls,
              style: TextStyle(fontSize: ChatifySizes.fontSizeMg, fontWeight: FontWeight.w400),
            ),
            titleSpacing: 0,
            backgroundColor: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.white,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 16, bottom: 25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(child: Text(S.of(context).muteUnknownNumbers, style: TextStyle(fontSize: ChatifySizes.fontSizeMd))),
                    Container(
                      alignment: Alignment.topRight,
                      child: isLoading ? SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(colorsController.getColor(colorsController.selectedColorScheme.value)),
                          strokeWidth: 3,
                        ),
                      )
                          : Switch(
                        value: isMuted,
                        onChanged: (value) {
                          toggleSwitch(value);
                        },
                        activeColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                        activeTrackColor: colorsController.getColor(colorsController.selectedColorScheme.value).withAlpha((0.5 * 255).toInt()),
                      ),
                    ),
                  ],
                ),
                RichText(
                  text: TextSpan(
                    text: S.of(context).callsUnknownNumMutedNotify,
                    style: TextStyle(fontSize: ChatifySizes.fontSizeSm, color: ChatifyColors.darkGrey, height: 1.5),
                    children: [
                      TextSpan(
                        text: S.of(context).readMore,
                        style: TextStyle(height: 1.5, color: colorsController.getColor(colorsController.selectedColorScheme.value), fontWeight: FontWeight.bold),
                        recognizer: TapGestureRecognizer()..onTap = () {},
                      ),
                    ],
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
