import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../../common/widgets/buttons/custom_search_button.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../../utils/constants/app_vectors.dart';
import '../../../chat/widgets/dialogs/chat_settings_dialog.dart';
import '../../../personalization/widgets/dialogs/light_dialog.dart';
import '../../models/support_model.dart';

class SupportAppBar extends StatefulWidget implements PreferredSizeWidget {
  final SupportAppModel support;

  const SupportAppBar({super.key, required this.support});

  @override
  State<SupportAppBar> createState() => SupportAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(Platform.isWindows ? kToolbarHeight + 10 : kToolbarHeight);
}

class SupportAppBarState extends State<SupportAppBar> with SingleTickerProviderStateMixin {
  late AnimationController _searchController;
  late Animation<double> _searchScaleAnimation;
  bool showRealStatus = false;

  @override
  void initState() {
    super.initState();
    _searchController = AnimationController(duration: const Duration(milliseconds: 150), vsync: this);
    _searchScaleAnimation = Tween<double>(begin: 1.0, end: 0.8).animate(CurvedAnimation(parent: _searchController, curve: Curves.easeInOut));

    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        showRealStatus = true;
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _buildAppBar(context, widget.support);
  }

  Widget _buildAppBar(BuildContext context, SupportAppModel support) {
    return Stack(
      children: [
        _buildSupportAppBar(context, support),
      ],
    );
  }

  Widget _buildSupportAppBar(BuildContext context, SupportAppModel support) {
    return Container(
      decoration: BoxDecoration(border: Border(bottom: BorderSide(color: context.isDarkMode ? ChatifyColors.darkBackground : ChatifyColors.grey))),
      child: AppBar(
        backgroundColor: context.isDarkMode ? ChatifyColors.deepNight : ChatifyColors.lightGrey,
        surfaceTintColor: ChatifyColors.transparent,
        titleSpacing: 0,
        elevation: 0,
        title: Padding(
          padding: const EdgeInsets.only(left: 15, top: 10),
          child: Row(
            children: [
              _buildSupportInfo(context, support),
            ],
          ),
        ),
        actions: [
          CustomSearchButton(
            searchController: _searchController,
            searchScaleAnimation: _searchScaleAnimation,
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildSupportInfo(BuildContext context, SupportAppModel support) {
    return InkWell(
      onTap: () {
        final RenderBox renderBox = context.findRenderObject() as RenderBox;
        final position = renderBox.localToGlobal(Offset.zero);
        showChatSettingsDialog(context, widget.support, position, initialIndex: 0);
      },
      mouseCursor: SystemMouseCursors.basic,
      borderRadius: BorderRadius.circular(8),
      splashColor: ChatifyColors.transparent,
      highlightColor: context.isDarkMode ? ChatifyColors.steelGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey,
      hoverColor: context.isDarkMode ? ChatifyColors.lightSoftNight.withAlpha((0.3 * 255).toInt()) : ChatifyColors.steelGrey,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              backgroundColor: colorsController.getColor(colorsController.selectedColorScheme.value),
              foregroundColor: colorsController.getColor(colorsController.selectedColorScheme.value),
              child: SvgPicture.asset(ChatifyVectors.logoApp, color: ChatifyColors.white, width: 26, height: 26),
            ),
            SizedBox(width: Platform.isWindows ? 14 : 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AnimatedPadding(
                  duration: const Duration(milliseconds: 300),
                  padding: EdgeInsets.only(top: showRealStatus ? 16 : 0),
                  child: Row(
                    children: [
                      Text(
                        'Chatify Support',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: Platform.isWindows ? ChatifySizes.fontSizeSm : ChatifySizes.fontSizeMd, fontFamily: 'Roboto', fontWeight: Platform.isWindows ? FontWeight.w600 : FontWeight.w400),
                      ),
                      SizedBox(width: 4),
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          SvgPicture.asset(ChatifyVectors.starburst, width: 18, height: 18, color: colorsController.getColor(colorsController.selectedColorScheme.value)),
                          SvgPicture.asset(ChatifyVectors.checkmark, width: 10, height: 10, color: ChatifyColors.white),
                        ],
                      ),
                    ],
                  ),
                ),
                AnimatedOpacity(
                  opacity: showRealStatus ? 0.0 : 1.0,
                  duration: const Duration(milliseconds: 300),
                  child: Text(
                    widget.support.description,
                    style: TextStyle(fontSize: Platform.isWindows ? 13 : 13, fontWeight: FontWeight.w300, color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.darkGrey),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
