import 'package:chatify/features/bot/models/support_model.dart';
import 'package:chatify/features/group/models/group_model.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../../../../../common/widgets/bars/scrollbar/custom_scrollbar.dart';
import '../../../../../generated/l10n/l10n.dart';
import '../../../../../utils/constants/app_links.dart';
import '../../../../../utils/constants/app_sizes.dart';
import '../../../../../utils/urls/url_utils.dart';
import '../../../../chat/models/user_model.dart';
import '../../../../community/models/community_model.dart';
import '../../../../community/widgets/info/encryption_info_block.dart';
import '../../../../home/widgets/dialogs/overlays/contacting_support_overlay.dart';
import '../../../../utils/widgets/no_glow_scroll_behavior.dart';
import '../light_dialog.dart';

class EncryptionOptionWidget extends StatefulWidget {
  final UserModel? user;
  final GroupModel? group;
  final SupportAppModel? support;
  final CommunityModel? community;

  const EncryptionOptionWidget({super.key, this.user, this.group, this.support, this.community});

  @override
  State<EncryptionOptionWidget> createState() => _EncryptionOptionWidgetState();
}

class _EncryptionOptionWidgetState extends State<EncryptionOptionWidget> {
  final ScrollController _scrollController = ScrollController();
  bool isInside = false;
  bool isHovered = false;
  bool isHoveredSecurity = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.group != null || widget.support != null)
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
          child: Text(
            widget.support != null ? S.of(context).security : S.of(context).encryption,
            style: const TextStyle(fontSize: 21, fontWeight: FontWeight.w500),
          ),
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
              child: SingleChildScrollView(
                controller: _scrollController,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      if (widget.group != null || widget.support != null) _buildEncryptionChat(),
                      if (widget.user != null || widget.community != null) _buildEncryptionGroup(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEncryptionChat() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              style: TextStyle(fontSize: ChatifySizes.fontSizeLm),
              children: [
                TextSpan(text: S.of(context).youCommunicatingOfficialAppSupport, style: TextStyle(fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w300)),
                TextSpan(
                  text: S.of(context).readMore,
                  style: TextStyle(
                    color: colorsController.getColor(colorsController.selectedColorScheme.value),
                    fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w300, decoration: isHoveredSecurity ? TextDecoration.none : TextDecoration.underline,
                  ),
                  recognizer: TapGestureRecognizer()..onTap = () async {
                    ContactingSupportOverlay(context, showStartChatButton: false).show();
                  },
                  onEnter: (_) => setState(() => isHoveredSecurity = true),
                  onExit: (_) => setState(() => isHoveredSecurity = false),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEncryptionGroup() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        EncryptionInfoBlock(withContainer: false),
        const SizedBox(height: 6),
        MouseRegion(
          onEnter: (_) => setState(() => isHovered = true),
          onExit: (_) => setState(() => isHovered = false),
          child: RichText(
            text: TextSpan(
              text: S.of(context).readMore,
              style: TextStyle(
                fontSize: ChatifySizes.fontSizeSm,
                fontWeight: FontWeight.w300,
                color: colorsController.getColor(colorsController.selectedColorScheme.value),
                decoration: isHovered ? TextDecoration.none : TextDecoration.underline,
              ),
              recognizer: TapGestureRecognizer()..onTap = () async {
                await UrlUtils.launchURL(AppLinks.helpCenter);
              },
            ),
          ),
        ),
      ],
    );
  }
}
