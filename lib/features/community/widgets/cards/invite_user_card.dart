import 'package:android_intent_plus/android_intent.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:get/get.dart';
import '../../../../../utils/constants/app_colors.dart';
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
    final mq = MediaQuery.of(context);

    return Card(
      margin: EdgeInsets.symmetric(horizontal: mq.size.width * .04, vertical: 4),
      elevation: isSelected ? 4 : 0.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      color: isSelected ? Colors.blue.withAlpha((0.1 * 255).toInt()) : null,
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
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.grey,
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(15),
            onTap: () async {
              await _showLoadingAndSendInvite(context, widget.contact);
              setState(() {
                isSelected = !isSelected;
                if (isSelected) {
                  widget.onContactSelected(widget.contact);
                }
              });
            },
            child: Padding(
              padding: EdgeInsets.zero,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset(ChatifyVectors.profile, width: 45, height: 45),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(widget.contact.displayName, maxLines: 1, overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.titleMedium),
                        Text(widget.contact.phones.isNotEmpty ? widget.contact.phones.first.number : 'No phone',
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
                        return Colors.transparent;
                      }),
                      foregroundColor: WidgetStateProperty.all(colorsController.getColor(colorsController.selectedColorScheme.value)),
                      shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
                      padding: WidgetStateProperty.all(const EdgeInsets.symmetric(horizontal: 12, vertical: 6)),
                    ),
                    child: Text('Пригласить', style: TextStyle(fontSize: ChatifySizes.fontSizeSm, color: colorsController.getColor(colorsController.selectedColorScheme.value))),
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
    await Dialogs.showCustomDialog(context: context, message: 'Загрузка...', duration: const Duration(seconds: 2));
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
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Не удается открыть приложение сообщений')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Контакт не содержит номера телефона')),
      );
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
