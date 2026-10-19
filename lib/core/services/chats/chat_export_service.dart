import 'dart:convert';
import 'dart:io';
import 'package:archive/archive.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class ChatExportService {
  static Future<File> exportChat({required String conversationId, required String username,required bool exportMedia}) async {
    final snapshot = await FirebaseFirestore.instance.collection('Chats').doc(conversationId).collection('messages').get();
    final archive = Archive();
    final messages = <Map<String, dynamic>>[];

    for (final document in snapshot.docs) {
      final data = document.data();
      final message = <String, dynamic>{...data, 'documentId': document.id};

      for (final entry in message.entries.toList()) {
        final value = entry.value;

        if (value is Timestamp) {
          message[entry.key] = value.toDate().toIso8601String();
        }
      }

      if (exportMedia) {
        final value = data['msg'];

        if (value is String) {
          final uri = Uri.tryParse(value);

          if (uri != null && (uri.scheme == 'https' || uri.scheme == 'http') && uri.host.isNotEmpty) {
            try {
              final response = await http.get(uri).timeout(const Duration(seconds: 30));

              if (response.statusCode == 200) {
                final extension = _getExtension(uri);
                final filename = '${document.id}$extension';
                final folder = _getMediaFolder(data['type']);

                archive.addFile(ArchiveFile('$folder/$filename', response.bodyBytes.length, response.bodyBytes));

                message['exportedMedia'] = '$folder/$filename';
              } else {
                message['mediaExportError'] = 'HTTP ${response.statusCode}';
              }
            } catch (e) {
              message['mediaExportError'] = e.toString();
            }
          }
        }
      }

      messages.add(message);
    }

    final jsonBytes = utf8.encode(const JsonEncoder.withIndent('  ').convert(messages));

    archive.addFile(ArchiveFile('messages.json', jsonBytes.length, jsonBytes));

    final zipBytes = ZipEncoder().encode(archive);
    final directory = await getTemporaryDirectory();
    final contactName = username.trim().isEmpty ? 'Контакт' : username.trim();
    final fileName = 'Чат Chatify с контактом $contactName.zip';
    final file = File('${directory.path}/$fileName',);

    await file.writeAsBytes(zipBytes, flush: true);

    return file;
  }

  static String _getExtension(Uri uri) {
    final path = uri.path;
    final filename = path.split('/').last;
    final dotIndex = filename.lastIndexOf('.');

    if (dotIndex < 0) return '.bin';

    final extension = filename.substring(dotIndex);

    if (!RegExp(r'^\.[a-zA-Z0-9]{1,10}$').hasMatch(extension)) {
      return '.bin';
    }

    return extension;
  }

  static String _getMediaFolder(dynamic type) {
    switch (type?.toString().toLowerCase()) {
      case 'image':
      case 'photo':
        return 'media/images';
      case 'video':
        return 'media/videos';
      case 'audio':
      case 'voice':
        return 'media/audio';
      case 'file':
      case 'document':
        return 'media/documents';
      case 'sticker':
        return 'media/stickers';
      default:
        return 'media/other';
    }
  }
}
