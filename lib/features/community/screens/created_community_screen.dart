import 'package:chatify/features/community/screens/new_community_screen.dart';
import 'package:chatify/features/personalization/widgets/dialogs/light_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import '../../../generated/l10n/l10n.dart';
import '../../../routes/custom_page_route.dart';
import '../../../utils/constants/app_colors.dart';
import '../../../utils/constants/app_sizes.dart';
import '../../../utils/constants/app_vectors.dart';
import '../../../utils/devices/device_utility.dart';
import '../models/community_model.dart';

class CreatedCommunityScreen extends StatelessWidget {
  final ValueChanged<CommunityModel> onCommunitySelected;

  const CreatedCommunityScreen({
    super.key,
    required this.onCommunitySelected,
  });

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(statusBarColor: colorsController.getColor(colorsController.selectedColorScheme.value), statusBarIconBrightness: Brightness.dark, statusBarBrightness: Brightness.light),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            Positioned(
              top: 30,
              left: 16,
              child: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                children: [
                  SizedBox(height: DeviceUtils.getScreenHeight(context) * .15),
                  Center(child: SvgPicture.asset(ChatifyVectors.createdCommunity, height: 150)),
                  const SizedBox(height: 20),
                  Text(S.of(context).createNewCommunity, style: TextStyle(fontSize: ChatifySizes.fontSizeMg, fontWeight: FontWeight.bold,), textAlign: TextAlign.center),
                  const SizedBox(height: 10),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      S.of(context).organizeCommunicationEducational,
                      style: TextStyle(fontSize: ChatifySizes.fontSizeMd, color: ChatifyColors.darkGrey),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: () {},
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          S.of(context).communityExamples,
                          style: TextStyle(color: colorsController.getColor(colorsController.selectedColorScheme.value), fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400),
                        ),
                        const SizedBox(width: 5),
                        Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: const Icon(Icons.arrow_forward_ios_rounded, color: ChatifyColors.blue, size: 13),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                    child: SizedBox(
                      width: double.infinity,
                      height: 42,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(context, createPageRoute(NewCommunityScreen(onCommunitySelected: onCommunitySelected)));
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ChatifyColors.blue,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          side: BorderSide.none,
                        ),
                        child: Text(S.of(context).begin, style: TextStyle(color: ChatifyColors.black, fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
