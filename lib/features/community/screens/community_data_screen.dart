import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatify/features/community/screens/edit_community_screen.dart';
import 'package:chatify/routes/custom_page_route.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../generated/l10n/l10n.dart';
import '../../../utils/constants/app_colors.dart';
import '../../../utils/constants/app_sizes.dart';
import '../../../utils/devices/device_utility.dart';
import '../../personalization/widgets/dialogs/light_dialog.dart';
import '../models/community_model.dart';

class CommunityDataScreen extends StatefulWidget {
  final CommunityModel community;

  const CommunityDataScreen({super.key, required this.community});

  @override
  State<CommunityDataScreen> createState() => _CommunityDataScreenState();
}

class _CommunityDataScreenState extends State<CommunityDataScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _arrowBack(context),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 60),
              GestureDetector(
                onTap: () {
                  Navigator.push(context, createPageRoute(EditCommunityScreen()));
                },
                child: Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: CachedNetworkImage(
                      imageUrl: widget.community.image,
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(color: ChatifyColors.darkerGrey, borderRadius: BorderRadius.circular(20)),
                        child: const Center(child: Icon(Icons.groups, color: ChatifyColors.white, size: 60)),
                      ),
                      errorWidget: (context, url, error) => Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(color: ChatifyColors.darkerGrey, borderRadius: BorderRadius.circular(20)),
                        child: const Center(child: Icon(Icons.groups, color: ChatifyColors.white, size: 60)),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.community.name, style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text('Сообщество · 2 группы', style: TextStyle(fontSize: ChatifySizes.fontSizeSm, color: ChatifyColors.grey)),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              _buttonsCommunity(context),
            ],
          ),
        ],
      ),
    );
  }

  Widget _arrowBack(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      top: 40,
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  Widget _buttonsCommunity(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 18),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.link, color: colorsController.getColor(colorsController.selectedColorScheme.value), size: 22),
                  const SizedBox(height: 4),
                  Text(
                    S.of(context).invite,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black, fontSize: ChatifySizes.fontSizeSm),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: DeviceUtils.getScreenWidth(context) * 0.03),
          Expanded(
            child: OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.person_add_alt_outlined, color: colorsController.getColor(colorsController.selectedColorScheme.value), size: 22),
                  const SizedBox(height: 4),
                  Text(
                    S.of(context).addParticipants,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black, fontSize: ChatifySizes.fontSizeSm),
                    overflow: TextOverflow.visible,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: DeviceUtils.getScreenWidth(context) * 0.03),
          Expanded(
            child: OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.group_add_outlined, color: colorsController.getColor(colorsController.selectedColorScheme.value), size: 22),
                  const SizedBox(height: 4),
                  Text(
                    S.of(context).addGroups,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black, fontSize: ChatifySizes.fontSizeSm),
                    overflow: TextOverflow.visible,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
