import 'package:chatify/features/calls/screens/scheduled_calls_screen.dart';
import 'package:chatify/features/calls/screens/select_contact_screen.dart';
import 'package:chatify/features/calls/widgets/dialog/clear_calls_dialog.dart';
import 'package:chatify/features/community/screens/community_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../api/apis.dart';
import '../../../generated/l10n/l10n.dart';
import '../../../routes/custom_page_route.dart';
import '../../../utils/constants/app_colors.dart';
import '../../../utils/constants/app_sizes.dart';
import '../../../utils/constants/app_vectors.dart';
import '../../chat/models/user_model.dart';
import '../../home/screens/home_screen.dart';
import '../../home/widgets/app_bars/home_app_bar.dart';
import '../../personalization/screens/favorite/favorite_screen.dart';
import '../../personalization/screens/settings/settings_screen.dart';
import '../../personalization/widgets/dialogs/light_dialog.dart';
import '../../status/screens/status_screen.dart';
import '../widgets/popups/items/app_popup_menu_item.dart';
import 'add_calls_favorite_screen.dart';

class CallsScreen extends StatefulWidget {
  final UserModel user;

  const CallsScreen({super.key, required this.user});

  @override
  CallsScreenState createState() => CallsScreenState();
}

class CallsScreenState extends State<CallsScreen> {
  final List<UserModel> searchList = [];
  bool isSearching = false;
  int selectedIndex = 3;
  List<UserModel> list = [];

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
        Navigator.push(context, createPageRoute(CommunityScreen(user: APIs.me)));
        break;
      case 3:
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (isSearching) {
          setState(() {
            isSearching = false;
          });
        }
      },
      child: Scaffold(
        appBar: HomeAppBar(
          isSearching: isSearching,
          onSearch: (val) {
            searchList.clear();
            for (var i in list) {
              if (i.name.toLowerCase().contains(val.toLowerCase()) || i.email.toLowerCase().contains(val.toLowerCase())) {
                searchList.add(i);
              }
              setState(() {
                searchList;
              });
            }
          },
          onToggleSearch: () {
            setState(() {
              isSearching = !isSearching;
            });
          },
          hintText: S.of(context).settingsSearch,
          title: Text(S.of(context).calls),
          popupMenuButton: TooltipTheme(
            data: TooltipThemeData(decoration: BoxDecoration(color: context.isDarkMode ? ChatifyColors.black : ChatifyColors.white, borderRadius: BorderRadius.circular(8))),
            child: Theme(
              data: Theme.of(context).copyWith(splashColor: ChatifyColors.darkerGrey, highlightColor: ChatifyColors.darkerGrey, hoverColor: ChatifyColors.darkerGrey),
              child: PopupMenuButton<int>(
                tooltip: 'Ещё',
                position: PopupMenuPosition.under,
                offset: const Offset(-8, 0),
                menuPadding: EdgeInsets.symmetric(vertical: 4),
                constraints: const BoxConstraints(minWidth: 0, maxWidth: 250),
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
                onSelected: (value) {
                  if (value == 1) {
                    const ClearCallsDialog().showClearCallsDialog(context, (String? image) {}, () {});
                  } else if (value == 2) {
                    Navigator.push(context, createPageRoute(ScheduledCallsScreen()));
                  } else if (value == 3) {
                    Navigator.push(context, createPageRoute(SettingsScreen(user: APIs.me)));
                  }
                },
                itemBuilder: (context) => [
                  if (list.isNotEmpty)
                    PopupMenuItem(
                      value: 1,
                      enabled: false,
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: AppPopupMenuItem(
                        text: S.of(context).clearList,
                        onTap: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  PopupMenuItem(
                    value: 2,
                    enabled: false,
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: AppPopupMenuItem(
                      text: 'Запланированные звонки',
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  PopupMenuItem(
                    value: 3,
                    enabled: false,
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: AppPopupMenuItem(
                      text: S.of(context).settings,
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        floatingActionButton: selectedIndex == 3
          ? Padding(
              padding: const EdgeInsets.only(bottom: 5),
              child: list.isEmpty
                ? FloatingActionButton.extended(
                    heroTag: 'calls',
                    onPressed: () {
                      Navigator.push(context, createPageRoute(SelectContactScreen(user: widget.user),));
                    },
                    elevation: 2,
                    backgroundColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                    foregroundColor: ChatifyColors.white,
                    icon: const Icon(Icons.add_ic_call_rounded, color: ChatifyColors.black, size: 26),
                    label: Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Text('Начать звонок', style: TextStyle(fontSize: ChatifySizes.fontSizeSm, color: ChatifyColors.black, fontWeight: FontWeight.w400)),
                    ),
                  )
                : FloatingActionButton(
                    heroTag: 'calls',
                    onPressed: () {
                      Navigator.push(context, createPageRoute(SelectContactScreen(user: widget.user)));
                    },
                    elevation: 2,
                    backgroundColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                    foregroundColor: ChatifyColors.white,
                    child: const Icon(Icons.add_ic_call_rounded, color: ChatifyColors.black, size: 26),
                  ),
                )
          : null,
        body: list.isEmpty ? _buildEmptyCallsState() : _buildCallsContent(),
      ),
    );
  }

  Widget _buildEmptyCallsState() {
    return SizedBox.expand(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(ChatifyVectors.privateCalls, width: 170, height: 170),
              Text('Совершайте личные звонки', style: TextStyle(fontSize: ChatifySizes.fontSizeMg, fontWeight: FontWeight.w400, color: context.isDarkMode ? ChatifyColors.softGrey : ChatifyColors.black, height: 1.3), textAlign: TextAlign.center),
              SizedBox(height: 12),
              Text(S.of(context).toCallContactsWhoHaveApp, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400, color: context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.darkerGrey), textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCallsContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(S.of(context).favorite, style: TextStyle(fontSize: ChatifySizes.fontSizeBg)),
              Material(
                color: ChatifyColors.transparent,
                child: InkWell(
                  onTap: () {
                    Navigator.push(context, createPageRoute(const FavoriteScreen()));
                  },
                  borderRadius: BorderRadius.circular(20),
                  splashColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey,
                  highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(color: context.isDarkMode ? ChatifyColors.youngNight : ChatifyColors.lightBackground, borderRadius: BorderRadius.circular(20)),
                    child: Icon(Icons.keyboard_arrow_right_rounded, size: 22),
                  ),
                ),
              ),
            ],
          ),
        ),
        InkWell(
          onTap: () {
            Navigator.push(context, createPageRoute(const AddCallsFavoriteScreen()));
          },
          splashColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey,
          highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                  radius: 21,
                  child: const Icon(Icons.favorite, color: ChatifyColors.black, size: 20),
                ),
                const SizedBox(width: 16),
                Expanded(child: Text(S.of(context).addToFavorites, style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w500))),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
