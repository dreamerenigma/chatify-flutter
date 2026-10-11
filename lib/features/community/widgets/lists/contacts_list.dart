import 'package:flutter/material.dart';
import 'package:flutter_contacts/models/contact/contact.dart';
import '../../../personalization/widgets/cards/invite_user_card.dart';

class ContactsList extends StatelessWidget {
  final List<Contact> contacts;

  const ContactsList({
    super.key,
    required this.contacts,
  });

  List<Contact> _filterAndSortContacts(List<Contact> contacts) {
    bool isRussian(String name) {
      final cyrillicRegex = RegExp(r'[А-Яа-яЁё]');

      return cyrillicRegex.hasMatch(name);
    }

    final filteredContacts = contacts.where((contact) {
      return contact.phones.any((phone) => phone.number.trim().isNotEmpty);
    }).toList();

    filteredContacts.sort((a, b) {
      final aName = a.displayName ?? '';
      final bName = b.displayName ?? '';

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
