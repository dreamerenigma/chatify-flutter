import '../../../chat/models/message_model.dart';
import 'package:flutter/material.dart';
import '../../../chat/widgets/views/message_list_view.dart';

class CommunityMessageListView extends StatelessWidget {
  final List<MessageModel> messages;
  final ScrollController scrollController;

  const CommunityMessageListView({super.key, required this.messages, required this.scrollController});

  @override
  Widget build(BuildContext context) {
    return MessageListView(
      messages: messages,
      isHovered: false,
      isInside: true,
      scrollController: scrollController,
      selectedMessages: {},
      startSelection: () {},
      toggleMessageSelection: (_) {},
    );
  }
}
