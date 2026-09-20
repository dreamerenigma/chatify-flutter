import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_utils/src/extensions/context_extensions.dart';
import '../../../utils/constants/app_colors.dart';
import '../../../utils/constants/app_sizes.dart';
import '../../../utils/constants/app_vectors.dart';
import '../../utils/widgets/dividers/custom_divider.dart';
import '../models/user_model.dart';
import '../widgets/cards/message_card.dart';
import '../models/message_model.dart';

class MessageDetailsScreen extends StatelessWidget {
  final UserModel user;
  final MessageModel message;
  final List<MessageModel> messages;

  const MessageDetailsScreen({
    super.key,
    required this.user,
    required this.message,
    required this.messages,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        backgroundColor: ChatifyColors.brown,
        title: Text('Данные о сообщении', style: TextStyle(fontSize: ChatifySizes.fontSizeMg, fontWeight: FontWeight.w400)),
        shape: Border(bottom: BorderSide(color: context.isDarkMode ? ChatifyColors.darkGrey.withValues(alpha: 0.5) : ChatifyColors.buttonDisabled, width: 1)),
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(color: ChatifyColors.brown),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: MessageCard(
                key: ValueKey(message.sent),
                message: message,
                isSelected: false,
                onLongPress: () {},
                onTap: () {},
                messages: messages,
                user: user,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                _buildMessageStatus(
                  context,
                  title: 'Прочитано',
                  date: '27 августа, 10:31',
                  textColor: ChatifyColors.textSecondary,
                  iconColor: ChatifyColors.blue,
                ),
                CustomDivider(indent: 0, endIndent: 0, left: 0, right: 0),
                _buildMessageStatus(
                  context,
                  title: 'Доставлено',
                  date: '27 августа, 10:27',
                  textColor: ChatifyColors.textSecondary,
                  iconColor: ChatifyColors.textSecondary,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageStatus(BuildContext context, {required String title, required String date, Color iconColor = ChatifyColors.blue, Color textColor = ChatifyColors.blue}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SvgPicture.asset(ChatifyVectors.doubleCheck, width: 22, height: 22, colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn)),
              const SizedBox(width: 6),
              Text(title, style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400)),
            ],
          ),
          Text(date, style: TextStyle(color: textColor, fontSize: 15, fontWeight: FontWeight.w400)),
        ],
      ),
    );
  }
}
