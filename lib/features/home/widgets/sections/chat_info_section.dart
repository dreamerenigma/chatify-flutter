import 'package:flutter/material.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../utils/widgets/dividers/custom_divider.dart';
import '../infos/private_messages_protected_notice.dart';

class ChatInfoSection extends StatelessWidget {
  const ChatInfoSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text('Нажмите и удерживайте чат, чтобы открыть дополнительные опции', style: TextStyle(color: ChatifyColors.darkGrey, fontSize: ChatifySizes.fontSizeLm, fontWeight: FontWeight.w400), textAlign: TextAlign.center),
        ),
        CustomDivider(indent: 0, endIndent: 0, left: 0, right: 0, top: 10),
        PrivateMessagesProtectedNotice(),
      ],
    );
  }
}
