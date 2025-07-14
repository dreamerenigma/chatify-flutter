import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatify/api/apis.dart';
import 'package:chatify/features/personalization/widgets/input/group_input.dart';
import 'package:chatify/routes/custom_page_route.dart';
import 'package:chatify/utils/helper/date_util.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../../utils/constants/app_images.dart';
import '../../../../utils/devices/device_utility.dart';
import '../../chat/models/message_model.dart';
import '../../chat/widgets/cards/message_card.dart';
import '../../community/screens/add_user_screen.dart';
import '../../personalization/widgets/dialogs/light_dialog.dart';
import '../models/group_model.dart';
import '../widgets/bars/group_chat_app_bar.dart';
import 'about_group_screen.dart';
import 'description_group_screen.dart';

class GroupChatScreen extends StatefulWidget {
  final String groupName;
  final List<String> members;
  final String groupImage;
  final DateTime createdAt;
  final String groupId;
  final GroupModel group;

  const GroupChatScreen({
    super.key,
    required this.groupName,
    required this.members,
    required this.groupImage,
    required this.createdAt,
    required this.groupId,
    required this.group,
  });

  @override
  State<GroupChatScreen> createState() => _GroupChatScreenState();
}

class _GroupChatScreenState extends State<GroupChatScreen> {
  List<MessageModel> list = [];
  List<MessageModel> messages = [];
  late Future<Map<String, String>> userNamesFuture;

  @override
  void initState() {
    super.initState();
    userNamesFuture = APIs.fetchUserNames(widget.members, shortenNames: true);
  }

  @override
  Widget build(BuildContext context) {
    final backgroundImage = context.isDarkMode ? ChatifyImages.chatBackgroundDark : ChatifyImages.chatBackgroundLight;

    return Scaffold(
      appBar: GroupChatAppBar(groupImage: widget.groupImage, groupName: widget.groupName, members: widget.members, userNamesFuture: userNamesFuture),
      body: Stack(
        children: [
          Container(decoration: BoxDecoration(image: DecorationImage(image: AssetImage(backgroundImage), fit: BoxFit.cover))),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Align(
              alignment: Alignment.topCenter,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                margin: const EdgeInsets.only(top: 4),
                decoration: BoxDecoration(
                  color: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.white,
                  borderRadius: BorderRadius.circular(9),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha((0.1 * 255).toInt()),
                      blurRadius: 3,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: Text(
                  DateUtil.formatDateTime(widget.createdAt),
                  style: TextStyle(fontSize: ChatifySizes.fontSizeLm, color: context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.textSecondary),
                ),
              ),
            ),
          ),
          SingleChildScrollView(
            child: Center(
              child: Column(
                children: [
                  const SizedBox(height: 22),
                  _buildCardGroup(),
                ],
              ),
            ),
          ),
          Column(
            children: [
              Expanded(
                child: StreamBuilder(
                  stream: APIs.getGroupMessages(widget.group),
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                      case ConnectionState.none:
                        return const SizedBox();

                      case ConnectionState.active:
                      case ConnectionState.done:
                        final data = snapshot.data?.docs;
                        list = data?.map((e) => MessageModel.fromJson(e.data())).toList() ?? [];

                        if (list.isNotEmpty) {
                          return ListView.builder(
                            reverse: true,
                            itemCount: list.length,
                            padding: EdgeInsets.only(top: DeviceUtils.getScreenHeight(context) * .01),
                            physics: const ClampingScrollPhysics(),
                            itemBuilder: (context, index) {
                              return MessageCard(message: list[index], isSelected: false, onLongPress: () {}, onTap: () {}, messages: messages);
                            },
                          );
                        } else {
                          return const SizedBox();
                        }
                    }
                  },
                ),
              ),
              GroupInput(
                groupId: widget.groupId,
                members: widget.members,
                groupName: widget.groupName,
                groupImage: widget.groupImage,
                createdAt: widget.createdAt,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCardGroup() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 16),
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
      width: double.infinity,
      decoration: BoxDecoration(
        color: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha((0.1 * 255).toInt()),
            blurRadius: 3,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(23),
            child: CachedNetworkImage(
              width: MediaQuery.of(context).size.height * .07,
              height: MediaQuery.of(context).size.height * .07,
              imageUrl: widget.groupImage,
              fit: BoxFit.cover,
              imageBuilder: (context, imageProvider) => CircleAvatar(backgroundImage: imageProvider),
              placeholder: (context, url) => CircleAvatar(
                backgroundColor: ChatifyColors.buttonSecondary,
                child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(colorsController.getColor(colorsController.selectedColorScheme.value))),
              ),
              errorWidget: (context, url, error) => const CircleAvatar(
                backgroundColor: ChatifyColors.buttonSecondary,
                child: Icon(Icons.group, color: ChatifyColors.grey),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text('Вы создали эту группу', style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Text('Группа • ${widget.members.length} участники', style: TextStyle(fontSize: ChatifySizes.fontSizeSm, color: ChatifyColors.grey)),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: () {
              Navigator.push(context, createPageRoute(const DescriptionGroupScreen()));
            },
            child: Text('Добавить описание...', style: TextStyle(fontSize: ChatifySizes.fontSizeSm, color: colorsController.getColor(colorsController.selectedColorScheme.value))),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 40,
            child: OutlinedButton.icon(
              onPressed: () {
                Navigator.push(context, createPageRoute(AboutGroupScreen(group: widget.group, members: widget.members, user: const {})));
              },
              icon: Icon(Icons.info_outline,
                color: colorsController.getColor(colorsController.selectedColorScheme.value),
              ),
              label: Text(
                'О группе',
                style: TextStyle(
                  color: colorsController.getColor(colorsController.selectedColorScheme.value),
                  fontWeight: FontWeight.w500,
                  fontSize: ChatifySizes.fontSizeMd,
                ),
              ),
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                side: BorderSide(color: context.isDarkMode ? ChatifyColors.darkerGrey : ChatifyColors.darkGrey),
                padding: const EdgeInsets.symmetric(horizontal: 16),
              ),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            height: 40,
            child: OutlinedButton.icon(
              onPressed: () {
                Navigator.push(context, createPageRoute(const AddUserScreen()));
              },
              icon: Icon(Icons.person_add_alt_outlined, size: 20, color: colorsController.getColor(colorsController.selectedColorScheme.value)),
              label: Text(
                'Добавить участников',
                style: TextStyle(
                  color: colorsController.getColor(colorsController.selectedColorScheme.value),
                  fontWeight: FontWeight.w500,
                  fontSize: ChatifySizes.fontSizeMd,
                ),
              ),
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                side: BorderSide(color: context.isDarkMode ? ChatifyColors.darkerGrey : ChatifyColors.darkGrey),
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
