import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatify/api/apis.dart';
import 'package:chatify/utils/constants/app_sizes.dart';
import 'package:chatify/utils/constants/app_vectors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../../../api/group_api.dart';
import '../../../../../generated/l10n/l10n.dart';
import '../../../../../utils/constants/app_colors.dart';
import '../../../../../utils/devices/device_utility.dart';
import '../../../../group/models/group_model.dart';
import '../../../../home/widgets/input/search_text_input.dart';
import '../light_dialog.dart';

class GroupsOptionWidget extends StatefulWidget {
  final List<GroupModel> currentUserGroups;

  const GroupsOptionWidget({super.key, required this.currentUserGroups});

  @override
  State<GroupsOptionWidget> createState() => _GroupsOptionWidgetState();
}

class _GroupsOptionWidgetState extends State<GroupsOptionWidget> {
  final TextEditingController groupController = TextEditingController();
  List<GroupModel> groups = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchGroups();
  }

  void _fetchGroups() async {
    List<GroupModel> fetchedGroups = await GroupApi.getGroups();
    setState(() {
      groups = fetchedGroups;
    });
  }

  @override
  Widget build(BuildContext context) {
    final sharedGroups = widget.currentUserGroups.where((group) {
      final members = group.members;
      return members.contains(group.groupId) && members.contains(APIs.user.uid);
    }).toList();
    final sharedGroupCount = sharedGroups.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${S.of(context).generalGroups[0].toUpperCase()}${S.of(context).generalGroups.substring(1)}',
                style: const TextStyle(fontSize: 21, fontWeight: FontWeight.w500),
              ),
              if (sharedGroupCount > 0)
              Text('($sharedGroupCount)', style: TextStyle(fontSize: 21)),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 12),
          child: SearchTextInput(
            hintText: '',
            controller: groupController,
            enabledBorderColor: context.isDarkMode ? ChatifyColors.lightGrey : ChatifyColors.black,
            padding: EdgeInsets.zero,
            showPrefixIcon: true,
            showSuffixIcon: true,
            showDialPad: false,
            showTooltip: false,
          ),
        ),
        _buildGeneralGroups(),
      ],
    );
  }

  Widget _buildGeneralGroups() {
    return Column(
      children: groups.map((group) => _buildGroupItem(group, group.members.length)).toList(),
    );
  }

  Widget _buildGroupItem(GroupModel group, int membersCount) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(23),
            child: CachedNetworkImage(
              width: Platform.isWindows ? 46 : DeviceUtils.getScreenHeight(context) * .055,
              height: Platform.isWindows ? 46 : DeviceUtils.getScreenHeight(context) * .055,
              imageUrl: group.groupImage,
              fit: BoxFit.cover,
              imageBuilder: (context, imageProvider) => CircleAvatar(backgroundImage: imageProvider),
              placeholder: (context, url) => CircleAvatar(
                backgroundColor: context.isDarkMode ? ChatifyColors.softNight : ChatifyColors.grey,
                foregroundColor: context.isDarkMode ? ChatifyColors.softNight : ChatifyColors.grey,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    colorsController.getColor(colorsController.selectedColorScheme.value),
                  ),
                ),
              ),
              errorWidget: (context, url, error) => CircleAvatar(
                backgroundColor: context.isDarkMode ? ChatifyColors.softNight : ChatifyColors.grey,
                foregroundColor: context.isDarkMode ? ChatifyColors.softNight : ChatifyColors.grey,
                child: SvgPicture.asset(
                  ChatifyVectors.groups,
                  colorFilter: ColorFilter.mode(context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.iconGrey, BlendMode.srcIn),
                  width: 28,
                  height: 28,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(group.groupName, style: TextStyle(fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w400)),
              SizedBox(height: 2),
              Text(
                '$membersCount ${S.of(context).participant}',
                style: TextStyle(fontSize: ChatifySizes.fontSizeLm, color: context.isDarkMode ? ChatifyColors.grey : ChatifyColors.grey, fontWeight: FontWeight.w300),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
