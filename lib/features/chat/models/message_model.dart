import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../api/apis.dart';
import '../../../core/enums/call_status_type.dart';
import '../../../core/enums/call_type.dart';
import '../../../core/enums/message_type.dart';

class MessageModel {
  late final String id;
  late final String toId;
  late final String msg;
  late final String read;
  late final String fromId;
  late final Timestamp sent;
  late final MessageType type;
  late final CallType? callType;
  late final CallStatusType? callStatus;
  late final String? documentName;
  late final String? fileSize;
  late final List<String> deletedBy;
  late final Map<String, List<String>> reactions;
  late final DateTime? deletedAt;
  late final int? audioDuration;
  late final int? videoDuration;

  MessageModel({
    required this.id,
    required this.toId,
    required this.msg,
    required this.read,
    required this.type,
    this.callType,
    this.callStatus,
    required this.fromId,
    required this.sent,
    this.documentName,
    this.fileSize,
    required this.deletedBy,
    required this.reactions,
    required this.deletedAt,
    this.audioDuration,
    this.videoDuration,
  });

  bool get isMe => fromId == APIs.user.uid;

  MessageModel.fromJson(Map<String, dynamic> json, {required this.id}) {
    toId = json['toId'].toString();
    msg = json['msg'].toString();
    read = json['read'].toString();
    fromId = json['fromId'].toString();

    switch (json['type'].toString()) {
      case 'image':
        type = MessageType.image;
        break;
      case 'gif':
        type = MessageType.gif;
        break;
      case 'video':
        type = MessageType.video;
        break;
      case 'videoMessage':
        type = MessageType.videoMessage;
        break;
      case 'audio':
        type = MessageType.audio;
        break;
      case 'voice':
        type = MessageType.voice;
        break;
      case 'document':
        type = MessageType.document;
        break;
      case 'call':
        type = MessageType.call;
        break;
      default:
        type = MessageType.text;
    }

    final sentValue = json['sent'];

    if (sentValue is Timestamp) {
      sent = sentValue;
    } else if (sentValue is String) {
      final milliseconds = int.tryParse(sentValue);

      if (milliseconds != null) {
        sent = Timestamp.fromMillisecondsSinceEpoch(milliseconds);
      } else {
        sent = Timestamp.now();
      }
    } else if (sentValue is int) {
      sent = Timestamp.fromMillisecondsSinceEpoch(sentValue);
    } else {
      sent = Timestamp.now();
    }

    documentName = json['documentName'] as String?;
    fileSize = json['fileSize'] as String?;
    deletedBy = List<String>.from(json['deletedBy'] ?? []);
    final reactionsJson = json['reactions'];

    if (reactionsJson is Map) {
      reactions = reactionsJson.map((key, value) {
        if (value is List) {
          return MapEntry(key.toString(), value.map((e) => e.toString()).toList());
        }

        if (value is String) {
          return MapEntry(key.toString(), [value]);
        }

        return MapEntry(key.toString(), <String>[]);
      });
    } else {
      reactions = {};
    }

    deletedAt = json['deletedAt'] != null ? DateTime.tryParse(json['deletedAt'].toString()) : null;

    final audioDurationValue = json['audioDuration'];

    if (audioDurationValue is int) {
      audioDuration = audioDurationValue;
    } else if (audioDurationValue is num) {
      audioDuration = audioDurationValue.toInt();
    } else {
      audioDuration = int.tryParse(audioDurationValue?.toString() ?? '');
    }

    final videoDurationValue = json['videoDuration'];

    if (videoDurationValue is int) {
      videoDuration = videoDurationValue;
    } else if (videoDurationValue is num) {
      videoDuration = videoDurationValue.toInt();
    } else {
      videoDuration = int.tryParse(videoDurationValue?.toString() ?? '');
    }

    final callTypeValue = json['callType'];

    if (callTypeValue == 'audio') {
      callType = CallType.audio;
    } else if (callTypeValue == 'video') {
      callType = CallType.video;
    } else {
      callType = null;
    }

    final callStatusValue = json['callStatus'];

    switch (callStatusValue) {
      case 'answered':
        callStatus = CallStatusType.answered;
        break;
      case 'missed':
        callStatus = CallStatusType.missed;
        break;
      case 'noAnswer':
        callStatus = CallStatusType.noAnswer;
        break;
      default:
        callStatus = null;
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

    if (callType != null) {
      data['callType'] = callType!.name;
    }

    if (callStatus != null) {
      data['callStatus'] = callStatus!.name;
    }

    if (documentName != null) {
      data['documentName'] = documentName;
    }

    if (fileSize != null) {
      data['fileSize'] = fileSize;
    }

    data['deletedBy'] = deletedBy;

    if (reactions.isNotEmpty) {
      data['reactions'] = reactions;
    }

    if (deletedAt != null) {
      data['deletedAt'] = deletedAt!.toIso8601String();
    }

    if (audioDuration != null) {
      data['audioDuration'] = audioDuration;
    }

    if (videoDuration != null) {
      data['videoDuration'] = videoDuration;
    }

    return data;
  }
}
