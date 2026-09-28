import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_utils/src/extensions/context_extensions.dart';
import '../../../../generated/l10n/l10n.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../home/widgets/dialogs/chats_calls_privacy_sheet_dialog.dart';

class InfoCard extends StatefulWidget {
  final IconData? icon;
  final String? svgIcon;
  final double iconSize;
  final String text;
  final String moreText;
  final Color textColor;
  final Color iconColor;
  final Color moreTextColor;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? margin;

  const InfoCard({
    super.key,
    this.icon,
    this.svgIcon,
    this.iconSize = 13,
    required this.text,
    this.moreText = 'Подробнее',
    this.textColor = ChatifyColors.yellow,
    this.iconColor = ChatifyColors.yellow,
    this.moreTextColor = ChatifyColors.yellow,
    this.onTap,
    this.margin = const EdgeInsets.only(left: 30, right: 30, top: 14),
  });

  @override
  State<InfoCard> createState() => _InfoCardState();
}

class _InfoCardState extends State<InfoCard> {
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
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        margin: widget.margin,
        decoration: BoxDecoration(
          color: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [BoxShadow(color: Colors.black.withAlpha((0.1 * 255).toInt()), blurRadius: 3, spreadRadius: 1)],
        ),
        child: Material(
          color: ChatifyColors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(8),
            splashFactory: NoSplash.splashFactory,
            splashColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
            highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
            hoverColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
            onTap: () {},
            child: Ink(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              decoration: BoxDecoration(color: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.white, borderRadius: BorderRadius.circular(8)),
              child: Center(
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: TextStyle(color: ChatifyColors.yellow, fontSize: 13, fontWeight: FontWeight.w400, height: 1.5),
                    children: [
                      WidgetSpan(alignment: PlaceholderAlignment.middle, child: Padding(padding: const EdgeInsets.only(right: 5), child: _buildIcon())),
                      TextSpan(text: widget.text, style: TextStyle(color: widget.textColor, fontSize: 13, fontWeight: FontWeight.w400, height: 1.3)),
                      TextSpan(text: widget.moreText, style: TextStyle(color: widget.textColor, fontSize: 13, fontWeight: FontWeight.w600, height: 1.3), recognizer: _moreRecognizer),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIcon() {
    if (widget.svgIcon != null) {
      return SvgPicture.asset(widget.svgIcon!, width: widget.iconSize, height: widget.iconSize, colorFilter: ColorFilter.mode(widget.iconColor, BlendMode.srcIn));
    }

    return Icon(widget.icon, color: widget.iconColor, size: widget.iconSize);
  }
}
