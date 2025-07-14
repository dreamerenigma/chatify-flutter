import '../../../api/apis.dart';

class MessageModel {
  late final String toId;
  late final String msg;
  late final String read;
  late final String fromId;
  late final String sent;
  late final Type type;
  late final String? documentName;
  late final String? fileSize;
  late final List<String> deletedBy;
  late final String? reaction;
  late final DateTime? deletedAt;

  MessageModel({
    required this.toId,
    required this.msg,
    required this.read,
    required this.type,
    required this.fromId,
    required this.sent,
    this.documentName,
    this.fileSize,
    required this.deletedBy,
    required this.reaction,
    required this.deletedAt,
  });

  bool get isMe => fromId == APIs.user.uid;

  MessageModel.fromJson(Map<String, dynamic> json) {
    toId = json['toId'].toString();
    msg = json['msg'].toString();
    read = json['read'].toString();
    fromId = json['fromId'].toString();
    sent = json['sent'].toString();
    documentName = json['documentName'] as String?;
    fileSize = json['fileSize'] as String?;
    deletedBy = List<String>.from(json['deletedBy'] ?? []);
    reaction = json['reaction'] as String?;
    deletedAt = json['deletedAt'] != null ? DateTime.tryParse(json['deletedAt'].toString()) : null;

    switch (json['type'].toString()) {
      case 'image':
        type = Type.image;
        break;
      case 'gif':
        type = Type.gif;
        break;
      case 'video':
        type = Type.video;
        break;
      case 'audio':
        type = Type.audio;
        break;
      case 'document':
        type = Type.document;
        break;
      default:
        type = Type.text;
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['toId'] = toId;
    data['msg'] = msg;
    data['read'] = read;
    data['type'] = type.name;
    data['fromId'] = fromId;
    data['sent'] = sent;
    if (documentName != null) {
      data['documentName'] = documentName;
    }
    if (fileSize != null) {
      data['fileSize'] = fileSize;
    }
    data['deletedBy'] = deletedBy;
    if (reaction != null) {
      data['reaction'] = reaction;
    }
    if (deletedAt != null) {
      data['deletedAt'] = deletedAt!.toIso8601String();
    }
    return data;
  }
}

enum Type { text, image, gif, video, audio, document, emoji }
