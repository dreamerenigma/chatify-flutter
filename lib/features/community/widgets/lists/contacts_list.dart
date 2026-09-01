import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';

import '../../../personalization/widgets/cards/invite_user_card.dart';

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