import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import '../../../../generated/l10n/l10n.dart';
import '../models/user_model.dart';
import '../widgets/input/share_input.dart';

class EditImageScreen extends StatelessWidget {
  final File fileToSend;
  final UserModel user;

  const EditImageScreen({super.key, required this.fileToSend, required this.user});

  @override
  Widget build(BuildContext context) {
    log('fileToSend in EditImageScreen: ${fileToSend.path}');
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).editImage),
      ),
      body: Column(
        children: [
          Expanded(
            child: InteractiveViewer(
              panEnabled: true,
              scaleEnabled: true,
              minScale: 1.0,
              maxScale: 4.0,
              child: Image.file(fileToSend, fit: BoxFit.contain),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ShareInput(user: user, fileToSend: fileToSend),
          ),
        ],
      ),
    );
  }
}
