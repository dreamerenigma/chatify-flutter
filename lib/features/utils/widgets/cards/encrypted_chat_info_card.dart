import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/context_extensions.dart';
import '../../../../generated/l10n/l10n.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../home/widgets/dialogs/chats_calls_privacy_sheet_dialog.dart';

class EncryptedChatInfoCard extends StatefulWidget {
  const EncryptedChatInfoCard({super.key});

  @override
  State<EncryptedChatInfoCard> createState() => _EncryptedChatInfoCardState();
}

class _EncryptedChatInfoCardState extends State<EncryptedChatInfoCard> {
  late final TapGestureRecognizer _moreRecognizer;

  @override
  void initState() {
    super.initState();
    _moreRecognizer = TapGestureRecognizer();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _moreRecognizer.onTap = () {
      showChatsCallsPrivacyBottomSheet(context, headerText: S.of(context).chatsCallsConfidential, titleText: S.of(context).yourPrivateMessagesAndCalls);
    };
  }

  @override
  void dispose() {
    _moreRecognizer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: ChatifyColors.transparent,
      child: InkWell(
        splashFactory: NoSplash.splashFactory,
        splashColor: context.isDarkMode ? ChatifyColors.steelGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
        highlightColor: context.isDarkMode ? ChatifyColors.steelGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
        hoverColor: context.isDarkMode ? ChatifyColors.lightSoftNight.withAlpha((0.15 * 255).toInt()) : ChatifyColors.steelGrey,
        onTap: () {
          showChatsCallsPrivacyBottomSheet(context, headerText: S.of(context).chatsCallsConfidential, titleText: S.of(context).yourPrivateMessagesAndCalls);
        },
        child: Container(
          margin: const EdgeInsets.only(left: 30, right: 30, top: 14),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [BoxShadow(color: ChatifyColors.black.withAlpha((0.1 * 255).toInt()), blurRadius: 3, spreadRadius: 1)],
          ),
          child: Center(
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: TextStyle(color: ChatifyColors.yellow, fontSize: 13, fontWeight: FontWeight.w400, height: 1.5),
                children: [
                  const WidgetSpan(child: Padding(padding: EdgeInsets.only(right: 5), child: Icon(Icons.lock_outline, color: ChatifyColors.yellow, size: 13)), alignment: PlaceholderAlignment.middle),
                  TextSpan(text: 'Сообщения и звонки защищены сквозным шифрованием. ''Прочитать, прослушать или переслать их могут только ''участники этого чата. ', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400, height: 1.3)),
                  TextSpan(text: 'Подробнее', style: TextStyle(color: ChatifyColors.yellow, fontSize: 13, fontWeight: FontWeight.w600, height: 1.3), recognizer: _moreRecognizer),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}