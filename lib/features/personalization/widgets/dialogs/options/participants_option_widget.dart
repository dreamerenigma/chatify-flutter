import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatify/utils/constants/app_sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';
import '../../../../../generated/l10n/l10n.dart';
import '../../../../../utils/constants/app_colors.dart';
import '../../../../../utils/constants/app_vectors.dart';
import '../../../../chat/models/user_model.dart';
import '../../../../community/models/community_model.dart';
import '../../../../home/widgets/input/search_text_input.dart';

class ParticipantsOptionWidget extends StatefulWidget {
  final UserModel? user;
  final CommunityModel? community;

  const ParticipantsOptionWidget({super.key, this.user, this.community});

  @override
  State<ParticipantsOptionWidget> createState() => _ParticipantsOptionWidgetState();
}

class _ParticipantsOptionWidgetState extends State<ParticipantsOptionWidget> {
  final TextEditingController groupController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 8),
          child: Text(S.of(context).participants, style: TextStyle(fontSize: 21, fontWeight: FontWeight.w500)),
        ),
        Padding(
          padding: EdgeInsets.only(left: 16, right: 16, top: 8),
          child: SearchTextInput(
            hintText: 'Поиск участников',
            controller: groupController,
            enabledBorderColor: context.isDarkMode ? ChatifyColors.lightGrey : ChatifyColors.black,
            padding: EdgeInsets.zero,
            showPrefixIcon: true,
            showSuffixIcon: true,
            showDialPad: false,
            showTooltip: false,
          ),
        ),
        SizedBox(height: 20),
        _buildParticipantsOptions(
          'Добавить участников',
          SvgPicture.asset(ChatifyVectors.addCallUser, width: 28, height: 28, color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black),
          () {},
        ),
        SizedBox(height: 8),
        _buildParticipantsOptions(
          'Пригласить в группу по ссылке',
          Icon(Ionicons.link_outline, size: 22),
          () {},
        ),
        SizedBox(height: 8),
        _buildUserAdmin(),
      ],
    );
  }

  Widget _buildParticipantsOptions(String title, Widget icon, VoidCallback onTap) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: Material(
        color: ChatifyColors.transparent,
        child: InkWell(
          onTap: onTap,
          mouseCursor: SystemMouseCursors.basic,
          borderRadius: BorderRadius.circular(6),
          splashColor: context.isDarkMode ? ChatifyColors.darkGrey.withAlpha((0.1 * 255).toInt()) : ChatifyColors.grey,
          highlightColor: context.isDarkMode ? ChatifyColors.darkGrey.withAlpha((0.1 * 255).toInt()) : ChatifyColors.grey,
          hoverColor: context.isDarkMode ? ChatifyColors.darkGrey.withAlpha((0.1 * 255).toInt()) : ChatifyColors.grey,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  width: 45,
                  height: 45,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: context.isDarkMode ? ChatifyColors.softNight : ChatifyColors.grey,
                    border: Border.all(color: context.isDarkMode ? ChatifyColors.darkerGrey : ChatifyColors.grey, width: 1)),
                  child: Center(child: icon),
                ),
                SizedBox(width: 12),
                Text(title, style: TextStyle(fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w300)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUserAdmin() {
    if (widget.user == null || widget.community == null) {
      return SizedBox.shrink();
    }
    final bool isCreator = widget.user!.id == widget.community!.creatorId;
    final String displayName = isCreator ? S.of(context).you : '${widget.user!.name}${widget.user!.surname.isNotEmpty ? ' ${widget.user!.surname}' : ''}';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Material(
        color: ChatifyColors.transparent,
        child: InkWell(
          onTap: () {},
          mouseCursor: SystemMouseCursors.basic,
          borderRadius: BorderRadius.circular(6),
          splashColor: context.isDarkMode ? ChatifyColors.darkGrey.withAlpha((0.1 * 255).toInt()) : ChatifyColors.grey,
          highlightColor: context.isDarkMode ? ChatifyColors.darkGrey.withAlpha((0.1 * 255).toInt()) : ChatifyColors.grey,
          hoverColor: context.isDarkMode ? ChatifyColors.darkGrey.withAlpha((0.1 * 255).toInt()) : ChatifyColors.grey,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            child: Row(
              children: [
                Container(
                  width: 45,
                  height: 45,
                  decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: context.isDarkMode ? ChatifyColors.darkerGrey : ChatifyColors.grey, width: 1)),
                  child: ClipOval(
                    child: CachedNetworkImage(
                      width: 45,
                      height: 45,
                      imageUrl: widget.user!.image,
                      fit: BoxFit.cover,
                      errorWidget: (context, url, error) => CircleAvatar(
                        backgroundColor: context.isDarkMode ? ChatifyColors.softNight : ChatifyColors.grey,
                        foregroundColor:  context.isDarkMode ? ChatifyColors.softNight : ChatifyColors.grey,
                        child: SvgPicture.asset(ChatifyVectors.newUser, color: context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.iconGrey, width: 28, height: 28),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(displayName, style: TextStyle(fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w500)),
                    Text(widget.user!.status, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400)),
                  ],
                ),
                SizedBox(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.user!.phoneNumber, style: TextStyle(fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w500)),
                    Text(widget.user!.role, style: TextStyle(fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w400)),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
