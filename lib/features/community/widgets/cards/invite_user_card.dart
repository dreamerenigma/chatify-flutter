import 'package:android_intent_plus/android_intent.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:get/get.dart';
import '../../../../../utils/constants/app_colors.dart';
import '../../../../generated/l10n/l10n.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../../utils/constants/app_vectors.dart';
import '../../../../utils/popups/dialogs.dart';
import '../../../personalization/widgets/dialogs/light_dialog.dart';

class InviteUserCard extends StatefulWidget {
  final Contact contact;
  final Function(Contact) onContactSelected;
  final VoidCallback onInvite;

  const InviteUserCard({
    super.key,
    required this.contact,
    required this.onContactSelected,
    required this.onInvite,
  });

  @override
  State<InviteUserCard> createState() => InviteUserCardState();
}

class InviteUserCardState extends State<InviteUserCard> {
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
            onTap: () async {
              await _showLoadingAndSendInvite(context, widget.contact);
              setState(() {
                isSelected = !isSelected;
                if (isSelected) {
                  widget.onContactSelected(widget.contact);
                }
              });
            },
            borderRadius: BorderRadius.circular(15),
            splashColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey,
            highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey,
            child: Padding(
              padding: EdgeInsets.all(12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset(ChatifyVectors.profile, width: 42, height: 42),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(widget.contact.displayName, maxLines: 1, overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.titleMedium),
                        Text(widget.contact.phones.isNotEmpty ? widget.contact.phones.first.number : S.of(context).noPhone,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 8),
                  TextButton(
                    onPressed: () => _showLoadingAndSendInvite(context, widget.contact),
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(Colors.transparent),
                      overlayColor: WidgetStateProperty.resolveWith((states) {
                        if (states.contains(WidgetState.pressed)) {
                          return colorsController.getColor(colorsController.selectedColorScheme.value).withAlpha((0.2 * 255).toInt());
                        }
                        return ChatifyColors.transparent;
                      }),
                      foregroundColor: WidgetStateProperty.all(colorsController.getColor(colorsController.selectedColorScheme.value)),
                      shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
                      padding: WidgetStateProperty.all(const EdgeInsets.symmetric(horizontal: 12, vertical: 6)),
                    ),
                    child: Text(S.of(context).invite, style: TextStyle(fontSize: ChatifySizes.fontSizeSm, color: colorsController.getColor(colorsController.selectedColorScheme.value))),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showLoadingAndSendInvite(BuildContext context, Contact contact) async {
    await Dialogs.showCustomDialog(context: context, message: S.of(context).loading, duration: const Duration(seconds: 2));
    _sendInvite(contact);
  }

  Future<void> _sendInvite(Contact contact) async {
    final phoneNumber = contact.phones.isNotEmpty ? contact.phones.first.number : null;

    if (phoneNumber != null) {
      final intent = AndroidIntent(
        action: 'android.intent.action.VIEW',
        data: 'sms:$phoneNumber',
        arguments: {
          'sms_body': 'Привет! Приглашаю тебя присоединиться к нашему чату!',
        },
      );

      try {
        await intent.launch();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(S.of(context).unableOpenMessagesApp)));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(S.of(context).contactContainPhoneNumber)));
    }
  }
}

class ContactsList extends StatelessWidget {
  final List<Contact> contacts;

  const ContactsList({super.key, required this.contacts});

  List<Contact> _filterAndSortContacts(List<Contact> contacts) {
    bool isRussian(String name) {
      final cyrillicRegex = RegExp(r'[А-Яа-я]');
      return cyrillicRegex.hasMatch(name);
    }

    List<Contact> filteredContacts = contacts.where((contact) {
      return contact.phones.isNotEmpty && contact.phones.first.number.isNotEmpty;
    }).toList();

    filteredContacts.sort((a, b) {
      final aName = a.displayName;
      final bName = b.displayName;

      final aIsRussian = isRussian(aName);
      final bIsRussian = isRussian(bName);

      if (aIsRussian != bIsRussian) {
        return aIsRussian ? -1 : 1;
      }

      return aName.toLowerCase().compareTo(bName.toLowerCase());
    });

    return filteredContacts;
  }

  @override
  Widget build(BuildContext context) {
    final sortedContacts = _filterAndSortContacts(contacts);

    return ListView.builder(
      itemCount: sortedContacts.length,
      itemBuilder: (context, index) {
        final contact = sortedContacts[index];
        return InviteUserCard(contact: contact, onContactSelected: (selectedContact) {}, onInvite: () {});
      },
    );
  }
}
