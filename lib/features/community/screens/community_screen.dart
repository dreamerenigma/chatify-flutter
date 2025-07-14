import 'dart:developer';
import 'package:chatify/routes/custom_page_route.dart';
import 'package:flutter/material.dart';
import 'package:chatify/features/community/widgets/community_widget.dart';
import 'package:chatify/features/community/models/community_model.dart';
import 'package:chatify/features/community/widgets/lists/community_list.dart';
import 'package:chatify/features/community/widgets/cards/new_community_card.dart';
import 'package:chatify/utils/constants/app_images.dart';
import 'package:get/get.dart';
import '../../../api/apis.dart';
import '../../../generated/l10n/l10n.dart';
import '../../../utils/constants/app_colors.dart';
import '../../../utils/constants/app_sizes.dart';
import '../../calls/screens/calls_screen.dart';
import '../../chat/models/user_model.dart';
import '../../home/screens/home_screen.dart';
import '../../home/widgets/app_bars/home_app_bar.dart';
import '../../personalization/screens/settings/settings_screen.dart';
import '../../personalization/widgets/dialogs/light_dialog.dart';
import '../../status/screens/status_screen.dart';
import 'created_community_screen.dart';

class CommunityScreen extends StatefulWidget {
  final UserModel user;

  const CommunityScreen({
    super.key,
    required this.user,
  });

  @override
  CommunityScreenState createState() => CommunityScreenState();
}

class CommunityScreenState extends State<CommunityScreen> {
  List<CommunityModel> list = [];
  int selectedIndex = 2;
  DateTime? createdAt;

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.push(context, createPageRoute(HomeScreen(user: APIs.me)));
        break;
      case 1:
        Navigator.push(context, createPageRoute(StatusScreen(user: APIs.me)));
        break;
      case 2:
        break;
      case 3:
        Navigator.push(context, createPageRoute(CallsScreen(user: APIs.me)));
        break;
      default:
        break;
    }
  }

  Future<void> fetchCommunities() async {
    try {
      List<CommunityModel> communities = await APIs.getCommunity();
      setState(() {
        list = communities;

        if (list.isNotEmpty) {
          createdAt = list[0].createdAt;
        } else {
          createdAt = null;
        }
      });
    } catch (e) {
      setState(() {
        createdAt = null;
      });
    }
  }

  bool isValidDate(DateTime date) {
    log('Validating Date: $date');
    return date.isAfter(DateTime(2000)) && date.isBefore(DateTime.now());
  }

  @override
  void initState() {
    super.initState();
    fetchCommunities();
    initializeCommunity();
  }

  Future<void> initializeCommunity() async {
    List<CommunityModel> communities = await APIs.getCommunity();
    if (communities.isNotEmpty) {
      APIs.community = communities.first;
    } else {
      APIs.community = null;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var mq = MediaQuery.of(context);
    if (APIs.community == null) {
      return Center(child: CircularProgressIndicator(color: colorsController.getColor(colorsController.selectedColorScheme.value)));
    }

    return Scaffold(
      appBar: HomeAppBar(
        isSearching: false,
        onSearch: (val) {},
        onToggleSearch: () {},
        hintText: '',
        title: Text(S.of(context).community),
        popupMenuButton: PopupMenuButton<int>(
          position: PopupMenuPosition.under,
          color: context.isDarkMode ? ChatifyColors.darkSlate : ChatifyColors.white,
          icon: const Icon(Icons.more_vert),
          onSelected: (value) {
            if (value == 1) {
              Navigator.push(context, createPageRoute(SettingsScreen(user: APIs.me)));
            }
          },
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 1,
              child: Text(S.of(context).settings, style: TextStyle(fontSize: ChatifySizes.fontSizeMd)),
            ),
          ],
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        ),
        showSearch: false,
      ),
      body: list.isEmpty ? Padding(
        padding: EdgeInsets.symmetric(horizontal: mq.size.width * 0.05),
        child: Column(
          children: [
            SizedBox(height: mq.size.height * 0.05),
            Image.asset(
              ChatifyImages.community,
              width: 150,
              height: 150,
            ),
            const SizedBox(height: 20),
            Text(S.of(context).connectedCommunity, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
            const SizedBox(height: 10),
            Text(S.of(context).communityThematic, style: const TextStyle(fontSize: 16), textAlign: TextAlign.center),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () {},
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    S.of(context).communityExamples,
                    style: TextStyle(fontSize: ChatifySizes.fontSizeSm, color: colorsController.getColor(colorsController.selectedColorScheme.value)),
                  ),
                  const SizedBox(width: 5),
                  Icon(Icons.arrow_forward_ios_rounded, color: colorsController.getColor(colorsController.selectedColorScheme.value), size: 13),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: mq.size.width * 0.05),
              child: SizedBox(
                height: 45,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(context, createPageRoute(CreatedCommunityScreen(onCommunitySelected: (community) {})));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    side: BorderSide.none,
                    padding: EdgeInsets.zero,
                  ),
                  child: Center(child: Text(S.of(context).createCommunity)),
                ),
              ),
            ),
          ],
        ),
      )
      : Column(
        children: [
          NewCommunityCard(
            onTap: () {
              Navigator.push(context, createPageRoute(CreatedCommunityScreen(onCommunitySelected: (community) {})));
            },
          ),
          Expanded(
            child: Column(
              children: [
                Flexible(child: CommunityList(communities: list, onCommunitySelected: (community) {})),
                const SizedBox(height: 12),
                const Divider(height: 0, thickness: 1),
                const SizedBox(height: 8),
                CommunityWidgets(createdAt: createdAt, isValidDate: isValidDate, showAllButton: true, community: APIs.community!),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
