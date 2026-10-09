import 'package:flutter/material.dart';
import '../../../../../api/apis.dart';
import '../../../../../api/chat_api.dart';
import '../../../../../common/widgets/bars/scrollbar/custom_scrollbar.dart';
import '../../../../../core/enums/chat_media_type.dart';
import '../../../../../core/enums/message_type.dart';
import '../../../../../generated/l10n/l10n.dart';
import '../../../../../utils/constants/app_colors.dart';
import '../../../../../utils/constants/app_sizes.dart';
import '../../../../chat/models/message_model.dart';
import '../../../../chat/models/user_model.dart';
import '../../../../utils/widgets/scrolls/no_glow_scroll_behavior.dart';
import '../../items/chat_media_item.dart';
import '../../media/chat_media_preview.dart';

class MediaOptionWidget extends StatefulWidget {
  final UserModel user;

  const MediaOptionWidget({
    super.key,
    required this.user,
  });

  @override
  State<MediaOptionWidget> createState() => _MediaOptionWidgetState();
}

class _MediaOptionWidgetState extends State<MediaOptionWidget> {
  final ScrollController _scrollController = ScrollController();
  final Map<int, bool> _hoveredStates = {};
  late final Stream<List<ChatMediaItem>> _mediaStream;
  bool isInside = false;

  Stream<List<ChatMediaItem>> _createMediaStream() {
    final conversationId = ChatApi.getConversationId(widget.user.id);

    return APIs.firestore.collection('Chats').doc(conversationId).collection('messages').orderBy('sent', descending: true).snapshots().map((snapshot) {
      final result = <ChatMediaItem>[];

      for (final doc in snapshot.docs) {
        final message = MessageModel.fromJson(doc.data(), id: doc.id);
        final media = _createMediaItem(message);

        if (media != null) {
          result.add(media);
        }
      }

      return result;
    });
  }

  ChatMediaItem? _createMediaItem(MessageModel message) {
    switch (message.type) {
      case MessageType.image:
        return ChatMediaItem(messageId: message.id, type: ChatMediaType.image, path: message.msg, sent: message.sent);
      case MessageType.video:
        return ChatMediaItem(messageId: message.id, type: ChatMediaType.video, path: message.msg, sent: message.sent, duration: message.videoDuration);
      case MessageType.audio:
        return ChatMediaItem(messageId: message.id, type: ChatMediaType.audio, path: message.msg, sent: message.sent, duration: message.audioDuration);
      case MessageType.document:
        return ChatMediaItem(messageId: message.id, type: ChatMediaType.document, path: message.msg, fileName: message.documentName, fileSize: message.fileSize, sent: message.sent);
      default:
        return null;
    }
  }

  @override
  void initState() {
    super.initState();
    _mediaStream = _createMediaStream();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 8),
          child: Text(S.of(context).media, style: TextStyle(fontSize: 21, fontWeight: FontWeight.w500)),
        ),
        Expanded(
          child: CustomScrollbar(
            scrollController: _scrollController,
            isInsidePersonalizedOption: isInside,
            onHoverChange: (bool isHovered) {
              setState(() {
                isInside = isHovered;
              });
            },
            child: ScrollConfiguration(
              behavior: NoGlowScrollBehavior(),
              child: StreamBuilder<List<ChatMediaItem>>(
                stream: _mediaStream,
                builder: (context, snapshot) {
                  final media = snapshot.data ?? [];

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (media.isEmpty) {
                    return SizedBox(
                      height: MediaQuery.of(context).size.height * 0.45,
                      child: Center(
                        child: Text(
                          S.of(context).noMediaFiles,
                          style: TextStyle(
                            color: ChatifyColors.grey,
                            fontSize: ChatifySizes.fontSizeSm,
                            fontWeight: FontWeight.w300,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  }

                  return GridView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 1,
                    ),
                    itemCount: media.length,
                    itemBuilder: (context, index) {
                      return ChatMediaPreview(key: ValueKey(media[index].messageId), media: media[index]);
                    },
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
