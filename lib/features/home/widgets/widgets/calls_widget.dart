import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatify/utils/popups/custom_tooltip.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../../generated/l10n/l10n.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../../utils/constants/app_vectors.dart';
import '../../../../utils/devices/device_utility.dart';
import '../../../../utils/platforms/platform_utils.dart';
import '../../../calls/widgets/dialog/new_calls_dialog.dart';
import '../../../chat/models/user_model.dart';
import '../../../personalization/widgets/dialogs/light_dialog.dart';
import '../dialogs/overlays/favorite_call_overlay.dart';
import '../input/search_text_input.dart';

class CallsWidget extends StatefulWidget {
  final String groupName;
  final String groupImage;
  final VoidCallback onStartCall;
  final bool showCurrentCall;

  const CallsWidget({
    super.key,
    required this.groupName,
    required this.groupImage,
    required this.onStartCall,
    required this.showCurrentCall,
  });

  @override
  State<CallsWidget> createState() => _CallsWidgetState();
}

class _CallsWidgetState extends State<CallsWidget> {
  final TextEditingController callsController = TextEditingController();
  final GlobalKey _favoriteMoreKey = GlobalKey();
  List<UserModel> recentsCalls = [];
  bool _isDialogOpen = false;
  bool isHovered = false;

  void _openDialog(BuildContext context) {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final position = renderBox.localToGlobal(Offset.zero);

    setState(() => _isDialogOpen = true);

    showNewCallDialog(context, position).then((_) {
      setState(() => _isDialogOpen = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final hasRecentCalls = recentsCalls.isNotEmpty;

    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
                      child: Text(S.of(context).calls, style: TextStyle(fontSize: 21, fontWeight: FontWeight.w500)),
                    ),
                    Tooltip(
                      message: S.of(context).newCall,
                      waitDuration: Duration(milliseconds: 800),
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                      textStyle: TextStyle(color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black, fontSize: ChatifySizes.fontSizeLm, fontWeight: FontWeight.w300),
                      decoration: BoxDecoration(
                        color: context.isDarkMode ? ChatifyColors.youngNight.withAlpha((0.7 * 255).toInt()) : ChatifyColors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: context.isDarkMode ? ChatifyColors.darkBackground.withAlpha((0.7 * 255).toInt()) : ChatifyColors.grey, width: 1),
                        boxShadow: [
                          BoxShadow(
                            color: ChatifyColors.black.withAlpha((0.1 * 255).toInt()),
                            spreadRadius: 1,
                            blurRadius: 2,
                            offset: Offset(1, 2),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 16, right: 10, top: 14),
                        child: Row(
                          children: [
                            Material(
                              color: ChatifyColors.transparent,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: _isDialogOpen ? context.isDarkMode ? ChatifyColors.softNight : ChatifyColors.grey : ChatifyColors.transparent,
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: InkWell(
                                  onTap: () => _openDialog(context),
                                  mouseCursor: SystemMouseCursors.basic,
                                  borderRadius: BorderRadius.circular(8.0),
                                  splashColor: context.isDarkMode ? ChatifyColors.softNight : ChatifyColors.grey,
                                  highlightColor: context.isDarkMode ? ChatifyColors.softNight : ChatifyColors.grey,
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: SvgPicture.asset(ChatifyVectors.callsAdd, width: 20, height: 20, color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SearchTextInput(hintText: S.of(context).searchNewCall, controller: callsController, padding: EdgeInsets.all(16)),
                if (widget.showCurrentCall) Divider(height: 10, thickness: 6, color: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.grey.withAlpha((0.1 * 255).toInt())),
                if (widget.showCurrentCall)
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Text(S.of(context).currentCall, style: TextStyle(fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w200)),
                    ),
                    _buildCurrentCall(),
                  ],
                ),
                Divider(height: 10, thickness: 6, color: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.grey.withAlpha((0.1 * 255).toInt())),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Text(S.of(context).favorite, style: TextStyle(fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w200)),
                    ),
                    _buildFavoriteCalls(),
                    _buildMoreFavorite(),
                  ],
                ),
                Divider(height: 12, thickness: 6, color: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.grey.withAlpha((0.1 * 255).toInt())),
                if (hasRecentCalls) ...[
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    child: Text(S.of(context).recent, style: TextStyle(fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w300)),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFavoriteCalls() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Material(
        color: ChatifyColors.transparent,
        child: InkWell(
          onTap: () {},
          mouseCursor: SystemMouseCursors.basic,
          splashColor: ChatifyColors.transparent,
          highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey,
          hoverColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey,
          borderRadius: BorderRadius.circular(6),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
            child: MouseRegion(
              onEnter: (_) => setState(() => isHovered = true),
              onExit: (_) => setState(() => isHovered = false),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(23),
                    child: CachedNetworkImage(
                      width: isWindows ? 46 : DeviceUtils.getScreenHeight(context) * .055,
                      height: isWindows ? 46 : DeviceUtils.getScreenHeight(context) * .055,
                      imageUrl: widget.groupImage,
                      fit: BoxFit.cover,
                      imageBuilder: (context, imageProvider) => CircleAvatar(backgroundImage: imageProvider),
                      placeholder: (context, url) => CircleAvatar(
                        backgroundColor: context.isDarkMode ? ChatifyColors.softNight : ChatifyColors.grey,
                        foregroundColor:  context.isDarkMode ? ChatifyColors.softNight : ChatifyColors.grey,
                        child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(colorsController.getColor(colorsController.selectedColorScheme.value))),
                      ),
                      errorWidget: (context, url, error) => CircleAvatar(
                        backgroundColor: context.isDarkMode ? ChatifyColors.softNight : ChatifyColors.grey,
                        foregroundColor:  context.isDarkMode ? ChatifyColors.softNight : ChatifyColors.grey,
                        child: SvgPicture.asset(ChatifyVectors.communityUsers, color: context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.iconGrey, width: 28, height: 28),
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.groupName, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
                    ],
                  ),
                  if (isHovered) ...[
                    Expanded(child: Container()),
                    SizedBox(width: 11),
                    CustomTooltip(
                      message: S.of(context).audioCall,
                      child: Material(
                        color: ChatifyColors.transparent,
                        child: InkWell(
                          onTap: () {},
                          mouseCursor: SystemMouseCursors.basic,
                          borderRadius: BorderRadius.circular(6),
                          splashColor: ChatifyColors.transparent,
                          highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey,
                          hoverColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey,
                          child: Padding(
                            padding: const EdgeInsets.all(11),
                            child: SvgPicture.asset(ChatifyVectors.calls, width: 21, height: 21, color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 15),
                    CustomTooltip(
                      message: S.of(context).videoCall,
                      child: Material(
                        color: ChatifyColors.transparent,
                        child: InkWell(
                          onTap: () {},
                          mouseCursor: SystemMouseCursors.basic,
                          borderRadius: BorderRadius.circular(6),
                          splashColor: ChatifyColors.transparent,
                          highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey,
                          hoverColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey,
                          child: Padding(
                            padding: const EdgeInsets.all(11),
                            child: Icon(FluentIcons.video_20_regular, size: 21, color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black),
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMoreFavorite() {
    return CustomTooltip(
      message: S.of(context).seeMoreFavorites,
      horizontalOffset: -65,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8),
        child: Material(
          color: ChatifyColors.transparent,
          child: InkWell(
            onTap: () async {
              final RenderBox renderBox = _favoriteMoreKey.currentContext?.findRenderObject() as RenderBox;
              final position = renderBox.localToGlobal(Offset.zero);
              final size = renderBox.size;

              final adjustedOffset = Offset(position.dx + size.width + 10, position.dy - 45);

              await showFavoriteCallOverlay(context, adjustedOffset);
            },
            mouseCursor: SystemMouseCursors.basic,
            borderRadius: BorderRadius.circular(8),
            splashColor: ChatifyColors.transparent,
            highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey,
            hoverColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey,
            child: Container(
              key: _favoriteMoreKey,
              width: double.infinity,
              height: 48,
              padding: const EdgeInsets.only(left: 70),
              alignment: Alignment.centerLeft,
              child: Text(
                S.of(context).more,
                style: TextStyle(color: colorsController.getColor(colorsController.selectedColorScheme.value), fontSize: 15, fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCurrentCall() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Container(
        decoration: BoxDecoration(
          color: colorsController.getColor(colorsController.selectedColorScheme.value).withAlpha((0.15 * 255).toInt()),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Material(
          color: ChatifyColors.transparent,
          child: InkWell(
            onTap: () {},
            mouseCursor: SystemMouseCursors.basic,
            splashColor: ChatifyColors.transparent,
            highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey,
            hoverColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey,
            borderRadius: BorderRadius.circular(6),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(23),
                    child: CachedNetworkImage(
                      width: isWindows ? 46 : DeviceUtils.getScreenHeight(context) * .055,
                      height: isWindows ? 46 : DeviceUtils.getScreenHeight(context) * .055,
                      imageUrl: widget.groupImage,
                      fit: BoxFit.cover,
                      imageBuilder: (context, imageProvider) => CircleAvatar(backgroundImage: imageProvider),
                      placeholder: (context, url) => CircleAvatar(
                        backgroundColor: context.isDarkMode ? ChatifyColors.softNight : ChatifyColors.grey,
                        foregroundColor:  context.isDarkMode ? ChatifyColors.softNight : ChatifyColors.grey,
                        child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(colorsController.getColor(colorsController.selectedColorScheme.value))),
                      ),
                      errorWidget: (context, url, error) => CircleAvatar(
                        backgroundColor: context.isDarkMode ? ChatifyColors.softNight : ChatifyColors.grey,
                        foregroundColor:  context.isDarkMode ? ChatifyColors.softNight : ChatifyColors.grey,
                        child: SvgPicture.asset(ChatifyVectors.newUser, color: context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.iconGrey, width: 28, height: 28),
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(S.of(context).waitingOtherParticipants, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500), overflow: TextOverflow.ellipsis),
                              SizedBox(height: 4),
                              Text(
                                S.of(context).currentVideoCall,
                                style: TextStyle(
                                  color: context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.lightGrey,
                                  fontSize: ChatifySizes.fontSizeSm,
                                  fontWeight: FontWeight.w300,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 8),
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: ChatifyColors.green,
                              minimumSize: const Size(120, 42),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              side: BorderSide.none,
                              padding: EdgeInsets.zero,
                            ).copyWith(
                              mouseCursor: WidgetStateProperty.all(SystemMouseCursors.basic),
                            ),
                            child: Text(S.of(context).open, style: TextStyle(color: ChatifyColors.white, fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w300)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
