import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_cheme_assets.dart';
import '../../../../generated/l10n/l10n.dart';
import '../../../../routes/custom_page_route.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../../utils/constants/app_vectors.dart';
import '../../../chat/models/user_model.dart';
import '../../widgets/dialogs/light_dialog.dart';
import 'add_edit_phone_screen.dart';

class EditPhoneScreen extends StatefulWidget {
  final UserModel user;

  const EditPhoneScreen({
    super.key,
    required this.user,
  });

  @override
  State<EditPhoneScreen> createState() => EditPhoneScreenState();
}

class EditPhoneScreenState extends State<EditPhoneScreen> {
  final asset = AppSchemeAssets.getAsset(
    schemeIndex: AppSchemeAssets.mapSchemeToIndex(colorsController.selectedColorScheme.value),
    assets: [ChatifyVectors.simCardRed, ChatifyVectors.simCardGreen, ChatifyVectors.simCardBlue, ChatifyVectors.simCardOrange],
  );

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
            backgroundColor: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.white,
            titleSpacing: 0,
            elevation: 0,
            title: Text(S.of(context).changeNumber, style: TextStyle(fontSize: ChatifySizes.fontSizeMg, fontWeight: FontWeight.w400)),
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),
                  Center(child: SvgPicture.asset(asset, width: 70, height: 70)),
                  const SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 16),
                    child: Text(S.of(context).changingYourPhoneNumber, style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400, height: 1.5)),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 30, right: 30, top: 5, bottom: 16),
                    child: Text('Мероприятия и запланированные звонки не будут перенесены на ваш новый номер и будут удалены.', style: TextStyle(color: ChatifyColors.darkGrey, fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400, height: 1.5)),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Text(
                      S.of(context).beforeContinueReceiveCallsNumber,
                      style: TextStyle(color: ChatifyColors.darkGrey, fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w400, height: 1.5),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Text(
                      S.of(context).changedPhoneYourNumber,
                      style: TextStyle(color: ChatifyColors.darkGrey, fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w400, height: 1.5),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 12, bottom: 20),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(context, createPageRoute(AddEditPhoneScreen(user: widget.user)));
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: ChatifyColors.white,
                  backgroundColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  side: BorderSide.none,
                  padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
                ),
                child: Text(S.of(context).next, style: TextStyle( color: ChatifyColors.black, fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
