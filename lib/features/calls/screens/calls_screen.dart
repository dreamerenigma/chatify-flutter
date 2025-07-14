import 'package:chatify/features/calls/screens/select_contact_screen.dart';
import 'package:chatify/features/calls/widgets/dialog/clear_calls_dialog.dart';
import 'package:chatify/features/community/screens/community_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../api/apis.dart';
import '../../../generated/l10n/l10n.dart';
import '../../../routes/custom_page_route.dart';
import '../../../utils/constants/app_colors.dart';
import '../../../utils/constants/app_sizes.dart';
import '../../chat/models/user_model.dart';
import '../../home/screens/home_screen.dart';
import '../../home/widgets/app_bars/home_app_bar.dart';
import '../../personalization/screens/favorite/favorite_screen.dart';
import '../../personalization/screens/settings/settings_screen.dart';
import '../../personalization/widgets/dialogs/light_dialog.dart';
import '../../status/screens/status_screen.dart';
import 'add_calls_favorite_screen.dart';

class CallsScreen extends StatefulWidget {
  final UserModel user;
  const CallsScreen({super.key, required this.user});

  @override
  CallsScreenState createState() => CallsScreenState();
}

class CallsScreenState extends State<CallsScreen> {
  List<UserModel> list = [];
  final List<UserModel> searchList = [];
  bool isSearching = false;
  int selectedIndex = 3;

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
          hintText: 'Поиск...',
          title: Text(S.of(context).calls),
          popupMenuButton: PopupMenuButton<int>(
            position: PopupMenuPosition.under,
            color: context.isDarkMode ? ChatifyColors.darkSlate : ChatifyColors.white,
            icon: const Icon(Icons.more_vert),
            onSelected: (value) {
              if (value == 1) {
                const ClearCallsDialog().showClearCallsDialog(context, (String? image) {}, () {});
              } else if (value == 2) {
                Navigator.push(context, createPageRoute(SettingsScreen(user: APIs.me)));
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 1,
                padding: const EdgeInsets.only(left: 16, top: 8, bottom: 8),
                child: Text(S.of(context).clearList, style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400)),
              ),
              PopupMenuItem(
                value: 2,
                padding: const EdgeInsets.only(left: 16, top: 8, bottom: 8),
                child: Text(S.of(context).settings, style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400)),
              ),
            ],
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          ),
        ),
        floatingActionButton: selectedIndex == 3 ?
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: FloatingActionButton(
            heroTag: 'calls',
            onPressed: () async {
              Navigator.push(context, createPageRoute(SelectContactScreen(user: widget.user)));
            },
            elevation: 2,
            backgroundColor: colorsController.getColor(colorsController.selectedColorScheme.value),
            foregroundColor: ChatifyColors.white,
            child: const Icon(Icons.add_ic_call_rounded),
          ),
        )
            : null,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Избранное', style: TextStyle(fontSize: ChatifySizes.fontSizeBg)),
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
                        decoration: BoxDecoration(
                          color: context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.lightBackground,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text('Ещё', style: TextStyle(fontSize: ChatifySizes.fontSizeSm)),
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
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                      radius: 20,
                      child: const Icon(Icons.favorite, color: ChatifyColors.white, size: 20),
                    ),
                    const SizedBox(width: 16),
                    Expanded(child: Text('Добавить в Избранное', style: TextStyle(fontSize: ChatifySizes.fontSizeMd))),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 6),
            list.isEmpty ? Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Center(
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: TextStyle(
                        fontSize: ChatifySizes.fontSizeMd,
                        fontWeight: FontWeight.w400,
                        color: context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.darkerGrey,
                      ),
                      children: <InlineSpan>[
                        const TextSpan(text: 'Чтобы позвонить контактам, у которых есть Chatify, '),
                        WidgetSpan(
                          child: Icon(Icons.add_ic_call_outlined, size: 20, color: context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.darkerGrey),
                        ),
                        const TextSpan(text: ' нажмите на иконку звонка в нижней части экрана'),
                      ],
                    ),
                  ),
                ),
              ),
            )
            : Padding(padding: const EdgeInsets.symmetric(horizontal: 16), child: Text('Недавние', style: TextStyle(fontSize: ChatifySizes.fontSizeMd))),
          ],
        ),
      ),
    );
  }
}
