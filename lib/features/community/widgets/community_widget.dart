import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';
import '../../../api/apis.dart';
import '../../../utils/constants/app_colors.dart';
import '../../../utils/constants/app_sizes.dart';
import '../../../utils/helper/date_util.dart';
import '../screens/community_info_screen.dart';
import '../screens/general_chat_screen.dart';
import 'package:chatify/features/community/models/community_model.dart';
import 'package:chatify/features/home/screens/home_screen.dart';
import 'package:chatify/routes/custom_page_route.dart';

class CommunityWidgets extends StatefulWidget {
  final DateTime? createdAt;
  final bool Function(DateTime) isValidDate;
  final bool showAllButton;
  final bool isInteractive;
  final bool showGroupsSection;
  final CommunityModel community;

  const CommunityWidgets({
    super.key,
    required this.createdAt,
    required this.isValidDate,
    this.showAllButton = false,
    this.isInteractive = true,
    this.showGroupsSection = false,
    required this.community,
  });

  @override
  State<CommunityWidgets> createState() => _CommunityWidgetsState();
}

class _CommunityWidgetsState extends State<CommunityWidgets> {
  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      absorbing: !widget.isInteractive,
      child: Container(
        color: context.isDarkMode ? ChatifyColors.black : ChatifyColors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Material(
              color: context.isDarkMode ? ChatifyColors.black : ChatifyColors.white,
              child: InkWell(
                onTap: () {
                  Navigator.push(context, createPageRoute(HomeScreen(user: APIs.me)));
                },
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(color: ChatifyColors.community, borderRadius: BorderRadius.circular(14)),
                        child: const Center(child: Icon(Ionicons.megaphone, color: ChatifyColors.white, size: 24)),
                      ),
                      const SizedBox(width: 16),
                      _buildAds(context),
                    ],
                  ),
                ),
              ),
            ),
            if (widget.showGroupsSection) ...[
              const Divider(height: 0, thickness: 1),
              const Padding(
                padding: EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 8),
                child: Text('Группы, в которых вы состоите'),
              ),
            ],
            Material(
              color: context.isDarkMode ? ChatifyColors.black : ChatifyColors.white,
              child: InkWell(
                onTap: () {
                  Navigator.push(context, createPageRoute(const GeneralChatScreen()));
                },
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(color: ChatifyColors.darkGrey, borderRadius: BorderRadius.circular(25)),
                        child: const Center(child: Icon(Icons.chat, color: ChatifyColors.white, size: 24)),
                      ),
                      const SizedBox(width: 16),
                      _general(context),
                    ],
                  ),
                ),
              ),
            ),
            if (widget.showAllButton) _buildAll(context),
          ],
        ),
      ),
    );
  }

  Widget _buildAds(BuildContext context) {
    return Flexible(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Объявления', style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text('Добро пожаловать в наше сообщество!', style: TextStyle(fontSize: ChatifySizes.fontSizeSm),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Text(
            widget.createdAt != null ? (widget.isValidDate(widget.createdAt!) ? DateUtil.getCommunityCreationDate(context: context, creationDate: widget.createdAt!) : 'Invalid Date') : 'Нет даты',
            style: TextStyle(color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black),
          ),
        ],
      ),
    );
  }

  Widget _general(BuildContext context) {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Общая', style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(
                  'Новые участники сообщества больше не будут добавляться автоматически.',
                  style: TextStyle(fontSize: ChatifySizes.fontSizeSm),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          SizedBox(
            width: 100,
            child: Text(
              widget.createdAt != null ? (widget.isValidDate(widget.createdAt!) ? DateUtil.getCommunityCreationDate(
                context: context,
                creationDate: widget.createdAt!,
              ) : 'Invalid Date') : 'Нет даты',
              style: TextStyle(color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAll(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.push(context, createPageRoute(CommunityInfoScreen(community: widget.community, isValidDate: widget.isValidDate, fileToSend: '')));
        },
        child: Container(
          padding: const EdgeInsets.only(left: 25, top: 16, bottom: 16),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(child: Icon(Icons.arrow_forward_ios_rounded, size: 18)),
              const SizedBox(width: 25),
              Text('Все', style: TextStyle(fontSize: ChatifySizes.fontSizeMd)),
            ],
          ),
        ),
      ),
    );
  }
}
