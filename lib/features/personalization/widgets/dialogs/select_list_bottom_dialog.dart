import 'package:chatify/utils/constants/app_sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../generated/l10n/l10n.dart';
import '../../../../utils/constants/app_colors.dart';
import 'light_dialog.dart';

class SelectListBottomSheet extends StatefulWidget {
  const SelectListBottomSheet({super.key});

  @override
  SelectListBottomSheetState createState() => SelectListBottomSheetState();
}

class SelectListBottomSheetState extends State<SelectListBottomSheet> {
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.center,
          child: Text(
            S.of(context).selectList,
            style: TextStyle(fontSize: ChatifySizes.fontSizeBg, fontWeight: FontWeight.normal, color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.blackGrey),
          ),
        ),
        const SizedBox(height: 20),
        ListTile(
          leading: Icon(
            Icons.add,
            size: 26,
            color: colorsController.getColor(colorsController.selectedColorScheme.value),
          ),
          title: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(S.of(context).newList, style: TextStyle(fontSize: ChatifySizes.fontSizeLg, color: colorsController.getColor(colorsController.selectedColorScheme.value))),
          ),
          splashColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey,
          onTap: () {},
        ),
        ListTile(
          leading: Icon(
            Icons.favorite_outline_outlined,
            color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black,
          ),
          title: Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Text(S.of(context).favorite, style: TextStyle(fontSize: ChatifySizes.fontSizeLg)),
          ),
          trailing: Icon(
            isSelected ? Icons.check_circle : Icons.circle_outlined,
            color: isSelected
              ? colorsController.getColor(colorsController.selectedColorScheme.value)
              : (context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.grey),
            size: 28,
          ),
          splashColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey,
          onTap: () {
            setState(() {
              isSelected = !isSelected;
            });
          },
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 20, bottom: 16),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                padding: const EdgeInsets.symmetric(vertical: 10),
                backgroundColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                side: BorderSide.none,
                elevation: 2,
              ),
              child: Text(S.of(context).ready, style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.normal, color: ChatifyColors.black)),
            ),
          ),
        ),
      ],
    );
  }
}

void showSelectListBottomSheetDialog(BuildContext context) {
  showModalBottomSheet(
    context: context,
    backgroundColor: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.white,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
    isScrollControlled: true,
    builder: (context) => const SelectListBottomSheet(),
  );
}

