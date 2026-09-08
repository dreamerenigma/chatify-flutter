import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatify/features/calls/screens/video/outgoing_video_call_screen.dart';
import 'package:chatify/features/home/widgets/dialogs/profile_dialog.dart';
import 'package:chatify/features/utils/widgets/dividers/custom_divider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_utils/src/extensions/context_extensions.dart';
import '../../../generated/l10n/l10n.dart';
import '../../../routes/custom_page_route.dart';
import '../../../utils/constants/app_colors.dart';
import '../../../utils/constants/app_sizes.dart';
import '../../../utils/constants/app_vectors.dart';
import '../../chat/models/user_model.dart';
import '../../chat/screens/chat_screen.dart';
import '../../personalization/widgets/dialogs/light_dialog.dart';
import '../../status/widgets/options/action_option.dart';
import '../widgets/popups/items/app_popup_menu_item.dart';
import 'audio/outgoing_audio_call_screen.dart';

class DetailsCallScreen extends StatefulWidget {
  final UserModel user;

  const DetailsCallScreen({super.key, required this.user});

  @override
  State<DetailsCallScreen> createState() => _DetailsCallScreenState();
}

class _DetailsCallScreenState extends State<DetailsCallScreen> {
  final Set<int> selectedCalls = <int>{};
  bool selectionMode = false;

  void _toggleSelection(int index) {
    setState(() {
      if (selectedCalls.contains(index)) {
        selectedCalls.remove(index);
      } else {
        selectedCalls.add(index);
      }

      selectionMode = selectedCalls.isNotEmpty;
    });
  }

  void _clearSelection() {
    setState(() {
      selectedCalls.clear();
      selectionMode = false;
    });
  }

  void _deleteSelectedCalls() {
    if (selectedCalls.isEmpty) return;

    setState(() {
      selectedCalls.clear();
      selectionMode = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration: BoxDecoration(
            color: ChatifyColors.white,
            boxShadow: [BoxShadow(color: ChatifyColors.black.withAlpha((0.1 * 255).toInt()), spreadRadius: 1, blurRadius: 3, offset: const Offset(0, 1))],
          ),
          child: AppBar(
            titleSpacing: 15,
            backgroundColor: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.white,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                if (selectionMode) {
                  _clearSelection();
                } else {
                  Navigator.pop(context);
                }
              },
            ),
            title: Text(selectionMode ? '${selectedCalls.length}' : 'Данные о звонке', style: TextStyle(fontSize: ChatifySizes.fontSizeMg, fontWeight: FontWeight.w400)),
            actions: [
              if (selectionMode)
                IconButton(
                  tooltip: 'Удалить',
                  icon: SvgPicture.asset(ChatifyVectors.delete, width: 22, height: 22, colorFilter: ColorFilter.mode(context.isDarkMode ? ChatifyColors.white : ChatifyColors.black, BlendMode.srcIn)),
                  onPressed: _deleteSelectedCalls,
                )
              else
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: TooltipTheme(
                    data: TooltipThemeData(decoration: BoxDecoration(color: context.isDarkMode ? ChatifyColors.black : ChatifyColors.white, borderRadius: BorderRadius.circular(8))),
                    child: Theme(
                      data: Theme.of(context).copyWith(splashColor: ChatifyColors.darkerGrey, highlightColor: ChatifyColors.darkerGrey, hoverColor: ChatifyColors.darkerGrey),
                      child: PopupMenuButton<int>(
                        tooltip: S.of(context).more,
                        position: PopupMenuPosition.under,
                        offset: const Offset(-8, 0),
                        menuPadding: EdgeInsets.symmetric(vertical: 4),
                        constraints: const BoxConstraints(minWidth: 0, maxWidth: 275),
                        icon: const Icon(Icons.more_vert),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        color: context.isDarkMode ? ChatifyColors.deepNight : ChatifyColors.white,
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
                            enabled: false,
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: AppPopupMenuItem(
                              text: 'Удалить из журнала звонков',
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
                              text: 'Пожаловаться',
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
            ],
          ),
        ),
      ),
      body: _buildProfileInfo(context, widget.user),
    );
  }

  Widget _buildProfileInfo(BuildContext context, UserModel user) {
    var mq = MediaQuery.of(context).size;
    List<Widget> profileInfoWidgets = [];

    profileInfoWidgets.add(SizedBox(height: mq.height * .02));
    profileInfoWidgets.add(
      GestureDetector(
        onTap: () {
          showDialog(context: context, builder: (_) => ProfileDialog(user: user));
        },
        child: Center(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(MediaQuery.of(context).size.height * .1),
            child: CachedNetworkImage(
              width: MediaQuery.of(context).size.height * .15,
              height: MediaQuery.of(context).size.height * .15,
              fit: BoxFit.cover,
              imageUrl: user.image,
              errorWidget: (context, url, error) => CircleAvatar(
                backgroundColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                foregroundColor: ChatifyColors.white,
                child: SvgPicture.asset(ChatifyVectors.profile, width: MediaQuery.of(context).size.height * .15, height: MediaQuery.of(context).size.height * .15),
              ),
            ),
          ),
        ),
      ),
    );
    profileInfoWidgets.add(SizedBox(height: mq.height * .008));
    profileInfoWidgets.add(Center(child: Text('${user.name} ${user.surname}', style: TextStyle(fontSize: ChatifySizes.fontSizeMg, fontWeight: FontWeight.w400))));
    profileInfoWidgets.add(SizedBox(height: mq.height * .006));
    if (user.phoneNumber.isNotEmpty && user.phoneNumber != "null") {
      profileInfoWidgets.add(Center(child: Text(user.phoneNumber, style: TextStyle(color: ChatifyColors.darkGrey, fontSize: ChatifySizes.fontSizeBg, fontWeight: FontWeight.w400))));
    }
    profileInfoWidgets.add(SizedBox(height: mq.height * .02));
    profileInfoWidgets.add(
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ActionOption(
            icon: Icons.message,
            label: S.of(context).write,
            onTap: () {
              Navigator.push(context, createPageRoute(ChatScreen(user: user)));
            },
          ),
          SizedBox(width: mq.width * 0.08),
          ActionOption(
            icon: Icons.call_outlined,
            label: S.of(context).audio,
            onTap: () {
              Navigator.push(context, createPageRoute(OutgoingAudioCallScreen(user: user)));
            },
          ),
          SizedBox(width: mq.width * 0.08),
          ActionOption(
            icon: Icons.videocam_outlined,
            label: S.of(context).video,
            onTap: () {
              Navigator.push(context, createPageRoute(OutgoingVideoCallScreen(user: user)));
            },
          ),
        ],
      ),
    );
    profileInfoWidgets.add(SizedBox(height: mq.height * .03));
    profileInfoWidgets.add(CustomDivider(indent: 0, endIndent: 0, left: 0, right: 0));
    profileInfoWidgets.add(
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 12, bottom: 6),
            child: Text('31 августа', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.darkerGrey)),
          ),
          _buildCallCard(
            context: context,
            icon: SvgPicture.asset(ChatifyVectors.phoneOutgoing, width: 21, height: 21, colorFilter: const ColorFilter.mode(ChatifyColors.green, BlendMode.srcIn)),
            iconColor: ChatifyColors.green,
            title: 'Исходящий вызов',
            time: '12:45',
            duration: '00:32',
            index: 0,
          ),
        ],
      ),
    );

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: profileInfoWidgets);
  }

  Widget _buildCallCard({
    required BuildContext context,
    required int index, required Widget icon,
    required Color iconColor,
    required String title,
    required String time,
    required String duration,
    String? status,
  }) {
    final bool isSelected = selectedCalls.contains(index);

    return Material(
      color: ChatifyColors.transparent,
      child: InkWell(
        splashFactory: NoSplash.splashFactory,
        splashColor: ChatifyColors.transparent,
        highlightColor: context.isDarkMode ? ChatifyColors.steelGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey,
        hoverColor: context.isDarkMode ? ChatifyColors.lightSoftNight.withAlpha((0.3 * 255).toInt()) : ChatifyColors.steelGrey,
        onTap: () {
          if (selectionMode) {
            _toggleSelection(index);
          }
        },
        onLongPress: () {
          _toggleSelection(index);
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          color: isSelected ? context.isDarkMode ? colorsController.getColor(colorsController.selectedColorScheme.value).withValues(alpha: 0.2) : ChatifyColors.lightGrey : ChatifyColors.transparent,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 44,
                height: 44,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(shape: BoxShape.circle, color: ChatifyColors.darkBackground),
                      alignment: Alignment.center,
                      child: SizedBox(width: 21, height: 21, child: icon),
                    ),
                    if (isSelected)
                      Positioned(
                        right: -2,
                        bottom: -2,
                        child: Container(
                          width: 23,
                          height: 23,
                          decoration: BoxDecoration(shape: BoxShape.circle, color: iconColor, border: Border.all(color: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.white, width: 1.5)),
                          child: Center(child: SizedBox(child: Icon(Icons.check_rounded, size: 20, color: ChatifyColors.black))),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400)),
                    const SizedBox(height: 3),
                    Text(time, style: TextStyle(fontSize: ChatifySizes.fontSizeSm, color: ChatifyColors.grey)),
                  ],
                ),
              ),
              if (status != null) ...[
                Text(status, style: const TextStyle(fontSize: 13, color: ChatifyColors.grey)),
                const SizedBox(width: 8),
              ],
              Text(duration, style: const TextStyle(fontSize: 13, color: ChatifyColors.grey)),
            ],
          ),
        ),
      ),
    );
  }
}
