import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatify/features/calls/screens/audio/outgoing_audio_call_screen.dart';
import 'package:chatify/features/calls/screens/schedule_call_screen.dart';
import 'package:chatify/features/calls/screens/scheduled_calls_screen.dart';
import 'package:chatify/features/calls/screens/select_contact_screen.dart';
import 'package:chatify/features/calls/widgets/dialog/clear_calls_dialog.dart';
import 'package:chatify/features/community/screens/communities_screen.dart';
import 'package:chatify/features/utils/widgets/scrolls/no_glow_scroll_behavior.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../api/apis.dart';
import '../../../data/mock/recent_calls_mock.dart';
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
import '../models/recent_call_model.dart';
import '../widgets/actions/calls_quick_action.dart';
import '../widgets/lists/recent_calls_list.dart';
import '../widgets/popups/items/app_popup_menu_item.dart';
import 'call_phone_number.dart';
import 'details_call_screen.dart';

class CallsScreen extends StatefulWidget {
  final UserModel user;

  const CallsScreen({super.key, required this.user});

  @override
  CallsScreenState createState() => CallsScreenState();
}

class CallsScreenState extends State<CallsScreen> {
  final List<UserModel> searchList = [];
  final List<RecentCallModel> recentCalls = mockRecentCalls;
  final Set<RecentCallModel> selectedCalls = {};
  List<UserModel> list = [];
  bool isSearching = false;
  bool isPressed = false;
  int selectedIndex = 3;

  bool get selectionMode => selectedCalls.isNotEmpty;
  List<RecentCallModel> get favoriteCalls => recentCalls.where((call) => call.isFavorite).toList();

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
        Navigator.push(context, createPageRoute(CommunitiesScreen(user: APIs.me)));
        break;
      case 3:
        break;
      default:
        break;
    }
  }

  void toggleCallSelection(RecentCallModel call) {
    setState(() {
      if (selectedCalls.contains(call)) {
        selectedCalls.remove(call);
      } else {
        selectedCalls.add(call);
      }
    });
  }

  void clearSelection() {
    setState(() {
      selectedCalls.clear();
    });
  }

  void setPressed(bool value) {
    if (mounted) {
      setState(() {
        isPressed = value;
      });
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
            setState(() {
              searchList.clear();

              for (var i in list) {
                if (i.name.toLowerCase().contains(val.toLowerCase()) || i.email.toLowerCase().contains(val.toLowerCase())) {
                  searchList.add(i);
                }
              }
            });
          },
          onToggleSearch: () {
            setState(() {
              isSearching = !isSearching;
            });
          },
          hintText: S.of(context).settingsSearch,
          title: Text(S.of(context).calls),
          popupMenuButton: _buildCallsPopupMenu(context),
          selectionMode: selectionMode,
          selectedCount: selectedCalls.length,
          onSelectionBack: clearSelection,
          isFavorite: selectedCalls.length == 1 && selectedCalls.first.isFavorite,
          onDelete: () {
            setState(() {
              recentCalls.removeWhere((call) => selectedCalls.contains(call));
              selectedCalls.clear();
            });
          },
          onFavorite: () {
            if (selectedCalls.length != 1) return;

            final call = selectedCalls.first;

            setState(() {
              final index = recentCalls.indexOf(call);

              if (index == -1) return;

              final updatedCall = call.copyWith(isFavorite: !call.isFavorite);

              recentCalls[index] = updatedCall;
              selectedCalls.clear();
            });
          },
          moreButton: TooltipTheme(
            data: TooltipThemeData(decoration: BoxDecoration(color: context.isDarkMode ? ChatifyColors.black : ChatifyColors.white, borderRadius: BorderRadius.circular(8))),
            child: Theme(
              data: Theme.of(context).copyWith(splashColor: ChatifyColors.darkerGrey, highlightColor: ChatifyColors.darkerGrey, hoverColor: ChatifyColors.darkerGrey),
              child: PopupMenuButton<int>(
                tooltip: S.of(context).more,
                position: PopupMenuPosition.under,
                offset: const Offset(-8, 0),
                menuPadding: EdgeInsets.symmetric(vertical: 4),
                constraints: const BoxConstraints(minWidth: 0, maxWidth: 160),
                icon: const Icon(Icons.more_vert),
                color: context.isDarkMode ? ChatifyColors.darkSlate : ChatifyColors.white,
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
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 1,
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: AppPopupMenuItem(
                      text: 'Заблокировать',
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
              child: recentCalls.isEmpty
                ? FloatingActionButton.extended(
                    heroTag: 'calls',
                    onPressed: () {
                      Navigator.push(context, createPageRoute(SelectContactScreen(user: widget.user)));
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
        body: recentCalls.isEmpty ? _buildEmptyCallsState() : _buildCallsContent(),
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
    final favorites = recentCalls.where((call) => call.isFavorite).toList();

    return ScrollConfiguration(
      behavior: NoGlowScrollBehavior(),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (favorites.isNotEmpty)
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ...List.generate(
                      favorites.length, (index) => Padding(
                        padding: EdgeInsets.only(right: index < favorites.length - 1 ? 6 : 0),
                        child: _buildFavoriteCallItem(favorites[index]),
                      ),
                    ),
                    SizedBox(
                      width: 320,
                      child: CallsQuickActions(
                        onNewCall: () {
                          Navigator.push(context, createPageRoute(SelectContactScreen(user: widget.user)));
                        },
                        onScheduled: () {
                          Navigator.push(context, createPageRoute(ScheduleCallScreen(user: widget.user)));
                        },
                        onKeyboard: () {
                          Navigator.push(context, createPageRoute(const CallPhoneNumber()));
                        },
                        onFavorites: () {
                          Navigator.push(context, createPageRoute(FavoriteScreen()));
                        },
                      ),
                    ),
                  ],
                ),
              )
            else
              SizedBox(
                width: double.infinity,
                child: CallsQuickActions(
                  onNewCall: () {
                    Navigator.push(context, createPageRoute(SelectContactScreen(user: widget.user)));
                  },
                  onScheduled: () {
                    Navigator.push(context, createPageRoute(ScheduleCallScreen(user: widget.user)));
                  },
                  onKeyboard: () {
                    Navigator.push(context, createPageRoute(const CallPhoneNumber()));
                  },
                  onFavorites: () {
                    Navigator.push(context, createPageRoute(FavoriteScreen()));
                  },
                ),
              ),
            RecentCallsList(
              calls: recentCalls,
              selectionMode: selectionMode,
              selectedCalls: selectedCalls,
              onCallTap: (call) {
                if (selectionMode) {
                  toggleCallSelection(call);
                  return;
                }

                Navigator.push(context, createPageRoute(DetailsCallScreen(user: call.user)));
              },
              onCallLongPress: toggleCallSelection,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFavoriteCallItem(RecentCallModel call) {
    final user = call.user;

    return GestureDetector(
      onTapDown: (_) {
        setState(() {
          isPressed = true;
        });
      },
      onTapUp: (_) {
        setState(() {
          isPressed = false;
        });

        Navigator.push(context, createPageRoute(OutgoingAudioCallScreen(user: user, onMinimize: () {})));
      },
      onTapCancel: () {
        setState(() {
          isPressed = false;
        });
      },
      child: AnimatedScale(
        scale: isPressed ? 0.92 : 1.0,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeOut,
        child: Padding(
          padding: const EdgeInsets.only(left: 16, top: 10),
          child: SizedBox(
            width: 52,
            child: Column(
              children: [
                ClipOval(
                  child: user.image.isNotEmpty
                    ? CachedNetworkImage(
                        imageUrl: user.image,
                        width: 54,
                        height: 54,
                        fit: BoxFit.cover,
                        errorWidget: (context, url, error) {
                          return _buildFavoriteAvatarPlaceholder(user.id);
                        },
                      )
                    : _buildFavoriteAvatarPlaceholder(user.id),
                ),
                const SizedBox(height: 5),
                Text(
                  user.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black, fontSize: 13, fontWeight: FontWeight.w400),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFavoriteAvatarPlaceholder(String userId) {
    return Container(
      width: 58,
      height: 58,
      alignment: Alignment.center,
      child: SvgPicture.asset(ChatifyVectors.profile, width: 58, height: 58),
    );
  }

  Widget _buildCallsPopupMenu(BuildContext context) {
    return TooltipTheme(
      data: TooltipThemeData(decoration: BoxDecoration(color: context.isDarkMode ? ChatifyColors.black : ChatifyColors.white, borderRadius: BorderRadius.circular(8))),
      child: Theme(
        data: Theme.of(context).copyWith(splashColor: ChatifyColors.darkerGrey, highlightColor: ChatifyColors.darkerGrey, hoverColor: ChatifyColors.darkerGrey),
        child: PopupMenuButton<int>(
          tooltip: S.of(context).more,
          position: PopupMenuPosition.under,
          offset: const Offset(-8, 0),
          menuPadding: EdgeInsets.symmetric(vertical: 4),
          constraints: const BoxConstraints(minWidth: 0, maxWidth: 250),
          icon: const Icon(Icons.more_vert),
          color: context.isDarkMode ? ChatifyColors.darkSlate : ChatifyColors.white,
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
          itemBuilder: (context) => [
            if (recentCalls.isNotEmpty)
              PopupMenuItem(
                value: 1,
                enabled: false,
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: AppPopupMenuItem(
                  text: S.of(context).clearList,
                  onTap: () {
                    Navigator.pop(context);

                    const ClearCallsDialog().showClearCallsDialog(
                      context,
                      (String? image) {},
                      () {
                          setState(() {
                            recentCalls.clear();
                          });
                        },
                    );
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
                  Navigator.push(context, createPageRoute(ScheduledCallsScreen(user: widget.user)));
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
                  Navigator.push(context, createPageRoute(SettingsScreen(user: APIs.me)));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
