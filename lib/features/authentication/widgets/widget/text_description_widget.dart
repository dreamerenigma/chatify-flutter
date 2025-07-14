import 'package:flutter/material.dart';
import '../../../../generated/l10n/l10n.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../personalization/widgets/dialogs/light_dialog.dart';
import '../../screens/enter_phone_number.dart';

class TextDescriptionWidget extends StatelessWidget {
  final String? topTitle;
  final String? bottomTitle;

  const TextDescriptionWidget({super.key, this.topTitle, this.bottomTitle});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (topTitle != null) ...[
            Text(topTitle!, style: TextStyle(fontSize: ChatifySizes.fontSizeBg, fontWeight: FontWeight.w300)),
          ],
          const SizedBox(height: 25),
          _buildStep("1.", S.of(context).openAppYourPrimary),
          const SizedBox(height: 25),
          _buildStepWithIcons(context),
          const SizedBox(height: 25),
          _buildStep3(context),
          const SizedBox(height: 25),
          _buildStep("4.", S.of(context).pointYourPhone),
          const SizedBox(height: 25),
          if (bottomTitle != null)
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) => const EnterPhoneNumberScreen(),
                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                  return FadeTransition(opacity: animation, child: child);
                },
              ));
            },
            child: Text(
              bottomTitle!,
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w300, color: colorsController.getColor(colorsController.selectedColorScheme.value)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStep(String number, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(number, style: TextStyle(fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.bold)),
        const SizedBox(width: 8),
        Expanded(
          child: Text(text, style: TextStyle(fontSize: ChatifySizes.fontSizeSm)),
        ),
      ],
    );
  }

  Widget _buildStepWithIcons(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: Text("2.", style: TextStyle(fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.bold)),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: TextStyle(
                fontSize: ChatifySizes.fontSizeMd,
                fontWeight: FontWeight.w400,
                color: Theme.of(context).brightness == Brightness.dark ? ChatifyColors.darkGrey : ChatifyColors.darkerGrey,
              ),
              children: <InlineSpan>[
                TextSpan(
                  text: S.of(context).press,
                  style: TextStyle(
                    fontSize: ChatifySizes.fontSizeSm,
                    fontWeight: FontWeight.normal,
                    color: Theme.of(context).brightness == Brightness.dark ? ChatifyColors.white : ChatifyColors.black,
                  ),
                ),
                TextSpan(
                  text: S.of(context).menu,
                  style: TextStyle(
                    fontSize: ChatifySizes.fontSizeSm,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).brightness == Brightness.dark ? ChatifyColors.white : ChatifyColors.black,
                  ),
                ),
                WidgetSpan(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(border: Border.all(color: ChatifyColors.mildNight, width: 1), borderRadius: BorderRadius.all(Radius.circular(6))),
                      child: Center(child: Icon(Icons.more_vert_rounded, size: 17)),
                    ),
                  ),
                ),
                TextSpan(
                  text: S.of(context).onAndroid,
                  style: TextStyle(
                    fontSize: ChatifySizes.fontSizeSm,
                    fontWeight: FontWeight.normal,
                    color: Theme.of(context).brightness == Brightness.dark ? ChatifyColors.white : ChatifyColors.black,
                  ),
                ),
                TextSpan(
                  text:  S.of(context).settings,
                  style: TextStyle(
                    fontSize: ChatifySizes.fontSizeSm,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).brightness == Brightness.dark ? ChatifyColors.white : ChatifyColors.black,
                  ),
                ),
                WidgetSpan(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(border: Border.all(color: ChatifyColors.mildNight, width: 1), borderRadius: BorderRadius.all(Radius.circular(6))),
                      child: Center(child: Icon(Icons.settings_outlined, size: 16)),
                    ),
                  ),
                ),
                TextSpan(
                  text: S.of(context).oniPhone,
                  style: TextStyle(
                    fontSize: ChatifySizes.fontSizeSm,
                    fontWeight: FontWeight.normal,
                    color: Theme.of(context).brightness == Brightness.dark ? ChatifyColors.white : ChatifyColors.black,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStep3(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("3.", style: TextStyle(fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.bold)),
        const SizedBox(width: 8),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: TextStyle(fontSize: ChatifySizes.fontSizeSm),
              children: [
                TextSpan(text: S.of(context).press, style: TextStyle(fontWeight: FontWeight.normal)),
                TextSpan(text: S.of(context).relatedDevices, style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(text: S.of(context).then, style: TextStyle(fontWeight: FontWeight.normal)),
                TextSpan(text: S.of(context).linkingDevice, style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
