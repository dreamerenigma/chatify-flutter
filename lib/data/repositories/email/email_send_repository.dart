import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import '../../../generated/l10n/l10n.dart';
import '../../../utils/popups/dialogs.dart';

class EmailSendRepository extends GetxController {
  static EmailSendRepository get instance => Get.find();

  Future<bool> sendFeedback(BuildContext context, {String? dropdownValue, String? suggestion, String? userEmail, List<Uint8List> images = const []}) async {
    String username = 'jarekismail@gmail.com';
    String password = 'ndti ivpn qfjk wgjz';

    final smtpServer = gmail(username, password);
    final Logger logger = Logger();

    final message = Message()
      ..from = Address(username, 'Chatify Support')
      ..recipients.add('jarekismail@gmail.com')
      ..subject = dropdownValue ?? 'No Subject'
      ..text = 'Reason: ${dropdownValue ?? 'No Reason'}\n\nSuggestion: ${suggestion ?? 'No Suggestion'}\n\nUser email: ${userEmail ?? 'No Email'}';

    for (int i = 0; i < images.length; i++) {
      String extension = 'jpg';
      if (images[i][0] == 0xFF && images[i][1] == 0xD8) {
        extension = 'jpg';
      } else if (images[i][0] == 0x89 && images[i][1] == 0x50 && images[i][2] == 0x4E && images[i][3] == 0x47) {
        extension = 'png';
      } else if (images[i][0] == 0x47 && images[i][1] == 0x49 && images[i][2] == 0x46 && images[i][3] == 0x38) {
        extension = 'gif';
      }

      if (kIsWeb) {
        logger.w('Временные файлы для отправки вложений не поддерживаются на Web');
        continue;
      }

      Directory tempDir = await getTemporaryDirectory();
      File tempFile = File('${tempDir.path}/image_$i.$extension');
      await tempFile.writeAsBytes(images[i]);

      message.attachments.add(
        FileAttachment(tempFile),
      );
    }

    try {
      final sendReport = await send(message, smtpServer);
      Dialogs.showSnackbarMargin(context, S.of(context).feedbackSentSuccessfully, margin: const EdgeInsets.only(bottom: 10, left: 10, right: 10));
      logger.d('Message sent: $sendReport');
      return true;
    } on MailerException catch (e) {
      Dialogs.showSnackbarMargin(context, S.of(context).feedbackSentFailed, margin: const EdgeInsets.only(bottom: 10, left: 10, right: 10));
      logger.d('Message not sent. \n$e');
      return false;
    }
  }
}
