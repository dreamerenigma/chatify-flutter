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
import '../../calls/widgets/popups/items/app_popup_menu_item.dart';
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
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCommunities();
  }

  bool isValidDate(DateTime date) {
    return date.isAfter(DateTime(2000)) && date.isBefore(DateTime.now());
  }

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

  Future<void> _loadCommunities() async {
    try {
      final communities = await APIs.getCommunity();

      if (!mounted) return;

      setState(() {
        list = communities;
        createdAt = communities.isNotEmpty ? communities.first.createdAt : null;
        APIs.community = communities.isNotEmpty ? communities.first : null;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        list = [];
        createdAt = null;
        APIs.community = null;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var mq = MediaQuery.of(context);
    if (_isLoading) {
      return Center(child: CircularProgressIndicator(color: colorsController.getColor(colorsController.selectedColorScheme.value)));
    }

    return Scaffold(
      appBar: HomeAppBar(
        isSearching: false,
        onSearch: (val) {},
        onToggleSearch: () {},
        hintText: '',
        title: Text(S.of(context).community),
        popupMenuButton: TooltipTheme(
          data: TooltipThemeData(decoration: BoxDecoration(color: context.isDarkMode ? ChatifyColors.black : ChatifyColors.white, borderRadius: BorderRadius.circular(8))),
          child: Theme(
            data: Theme.of(context).copyWith(splashColor: ChatifyColors.darkerGrey, highlightColor: ChatifyColors.darkerGrey, hoverColor: ChatifyColors.darkerGrey),
            child: PopupMenuButton<int>(
              tooltip: S.of(context).more,
              position: PopupMenuPosition.under,
              offset: const Offset(-8, 0),
              menuPadding: EdgeInsets.symmetric(vertical: 4),
              constraints: const BoxConstraints(minWidth: 0, maxWidth: 125),
              icon: const Icon(Icons.more_vert),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.resolveWith((states) {
                  if (states.contains(WidgetState.pressed)) {
                    return context.isDarkMode ? ChatifyColors.softNight : ChatifyColors.lightGrey;
                  }
                  return ChatifyColors.transparent;
                }),
                shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                overlayColor: WidgetStateProperty.all(ChatifyColors.softNight.withAlpha((0.1 * 255).toInt())),
              ),
              color: context.isDarkMode ? ChatifyColors.darkSlate : ChatifyColors.white,
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 1,
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: AppPopupMenuItem(
                    text: S.of(context).settings,
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(context, createPageRoute(SettingsScreen(user: APIs.me)));
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        showSearch: false,
      ),
      body: list.isEmpty ? Padding(
        padding: EdgeInsets.symmetric(horizontal: mq.size.width * 0.05),
        child: Column(
          children: [
            SizedBox(height: mq.size.height * 0.05),
            Image.asset(ChatifyImages.community, width: 150, height: 150),
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
                  Text(S.of(context).communityExamples, style: TextStyle(fontSize: ChatifySizes.fontSizeSm, color: colorsController.getColor(colorsController.selectedColorScheme.value))),
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
          Divider(height: 10, thickness: 10, color: context.isDarkMode ? ChatifyColors.black : ChatifyColors.lightGrey),
          const SizedBox(height: 2),
          Expanded(
            child: Column(
              children: [
                Flexible(child: CommunityList(communities: list, onCommunitySelected: (community) {})),
                Divider(height: 10, thickness: 1, color: context.isDarkMode ? ChatifyColors.softNight : ChatifyColors.lightGrey),
                const SizedBox(height: 6),
                CommunityWidgets(createdAt: createdAt, isValidDate: isValidDate, showAllButton: true, community: APIs.community!),
                Divider(height: 10, thickness: 10, color: context.isDarkMode ? ChatifyColors.black : ChatifyColors.lightGrey),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
