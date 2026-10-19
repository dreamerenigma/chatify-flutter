import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../../../utils/constants/app_colors.dart';
import '../../../../generated/l10n/l10n.dart';
import '../../../../utils/constants/app_vectors.dart';
import '../dialogs/light_dialog.dart';

class InviteUserCard extends StatefulWidget {
  final Contact contact;
  final Function(Contact) onContactSelected;
  final VoidCallback onInvite;

  const InviteUserCard({super.key, required this.contact, required this.onContactSelected, required this.onInvite});

  @override
  State<InviteUserCard> createState() => InviteUserCardState();
}

class InviteUserCardState extends State<InviteUserCard> {
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final contact = widget.contact;

    return Card(
      margin: EdgeInsets.only(left: Platform.isWindows ? 16 : 8, right: Platform.isWindows ? 15 : 8, top: 8),
      elevation: isSelected ? 4 : 0.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      color: isSelected ? colorsController.getColor(colorsController.selectedColorScheme.value).withAlpha((0.1 * 255).toInt()) : null,
      child: GestureDetector(
        onLongPress: () {
          setState(() {
            isSelected = !isSelected;
            if (isSelected) {
              widget.onContactSelected(widget.contact);
            }
          });
        },
        child: Ink(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.grey),
          child: InkWell(
            splashFactory: NoSplash.splashFactory,
            borderRadius: BorderRadius.circular(15),
            splashColor: context.isDarkMode ? ChatifyColors.steelGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
            highlightColor: context.isDarkMode ? ChatifyColors.steelGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
            hoverColor: context.isDarkMode ? ChatifyColors.lightSoftNight.withAlpha((0.15 * 255).toInt()) : ChatifyColors.steelGrey,
            onTap: () {
              setState(() {
                isSelected = !isSelected;
                if (isSelected) {
                  widget.onContactSelected(widget.contact);
                }
              });
            },
            child: ListTile(
              leading: SvgPicture.asset(ChatifyVectors.profile, width: 45, height: 45),
              title: Text(contact.displayName ?? ''),
              subtitle: contact.phones.isNotEmpty ? Text(contact.phones.first.number) : Text(S.of(context).noPhone),
            ),
          ),
        ),
      ),
    );
  }
}
