import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatify/utils/constants/app_colors.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';
import '../../../../api/apis.dart';
import '../../../../generated/l10n/l10n.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../../utils/constants/app_vectors.dart';
import '../../../../utils/popups/custom_tooltip.dart';
import '../../../chat/models/user_model.dart';
import '../../../personalization/widgets/dialogs/light_dialog.dart';
import '../dialogs/settings_dialog.dart';

class SideNavBar extends StatefulWidget {
  final UserModel user;
  final int selectedIndex;
  final Function(int) onItemTapped;
  final bool isMenuExpanded;
  final VoidCallback toggleMenu;
  final bool isCalling;

  const SideNavBar({
    super.key,
    required this.user,
    required this.selectedIndex,
    required this.onItemTapped,
    required this.isMenuExpanded,
    required this.toggleMenu,
    required this.isCalling,
  });

  @override
  State<SideNavBar> createState() => SideNavBarState();
}

class SideNavBarState extends State<SideNavBar> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _rotationAnimation;
  late AnimationController _pulseController;
  bool isRotated = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    _rotationAnimation = Tween<double>(begin: 0.0, end: 3.14159).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeInOut));
    _pulseController = AnimationController(vsync: this, duration: Duration(seconds: 1))..repeat(reverse: true);
    APIs.loadUserDataFromFirestore();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      width: widget.isMenuExpanded ? 250 : 50,
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        color: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.grey.withAlpha((0.1 * 255).toInt())
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 4, right: 4, top: 14),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildMenu(svgPath: ChatifyVectors.menu, isActive: widget.selectedIndex == -1, duration: Duration(milliseconds: 300)),
                SizedBox(height: 8),
                _buildIconButton(icon: FluentIcons.chat_24_regular, index: 0, size: 20),
                SizedBox(height: 2),
                _buildIconButton(svgPath: ChatifyVectors.calls, index: 1, size: 16),
                SizedBox(height: 2),
                _buildIconButton(svgPath: ChatifyVectors.status, index: 2),
              ],
            ),
          ),
          Expanded(child: SizedBox.shrink()),
          Padding(
            padding: const EdgeInsets.only(left: 4, right: 4, top: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildIconButton(icon: PhosphorIcons.star, index: 3, size: 18),
                SizedBox(height: 2),
                _buildIconButton(icon: BootstrapIcons.archive, index: 4, size: 16),
                SizedBox(height: 8),
                SizedBox(width: 32, child: Divider(height: 1, thickness: 1, color: context.isDarkMode ? ChatifyColors.youngNight : ChatifyColors.buttonDisabled)),
                SizedBox(height: 8),
                _buildIconButton(icon: Ionicons.settings_outline, index: 5, size: 19, onTap: () {
                  final RenderBox renderBox = context.findRenderObject() as RenderBox;
                  final position = renderBox.localToGlobal(Offset.zero);
                  showSettingsDialog(context, position, initialIndex: 0);
                }),
              ],
            ),
          ),
          Padding(padding: const EdgeInsets.only(left: 4, right: 4, bottom: 5), child:  _buildAvatar(widget.user)),
        ],
      ),
    );
  }

  Widget _buildIconButton({IconData? icon, String? svgPath, required int index, double? size = 22, VoidCallback? onTap}) {
    bool isActive = widget.selectedIndex == index;

    String tooltipMessage;
    switch (index) {
      case 0:
        tooltipMessage = S.of(context).chats;
        break;
      case 1:
        tooltipMessage = S.of(context).calls;
        break;
      case 2:
        tooltipMessage = S.of(context).status;
        break;
      case 3:
        tooltipMessage = S.of(context).favoriteMessages;
        break;
      case 4:
        tooltipMessage = S.of(context).archivedChats;
        break;
      case 5:
        tooltipMessage = S.of(context).settings;
        break;
      default:
        tooltipMessage = 'Иконка $index';
        break;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1),
      child: Material(
        color: ChatifyColors.transparent,
        child: InkWell(
          onTap: () {
            if (onTap != null) {
              onTap();
            } else {
              widget.onItemTapped(index);
            }
          },
          mouseCursor: SystemMouseCursors.basic,
          splashColor: context.isDarkMode ? ChatifyColors.deepNight : ChatifyColors.darkGrey.withAlpha((0.1 * 255).toInt()),
          highlightColor: context.isDarkMode ? ChatifyColors.deepNight : ChatifyColors.darkGrey.withAlpha((0.1 * 255).toInt()),
          borderRadius: BorderRadius.circular(ChatifySizes.borderRadiusMd),
          child: CustomTooltip(
            message: tooltipMessage,
            verticalOffset: -75,
            horizontalOffset: -25,
            child: Stack(
              alignment: Alignment.centerLeft,
              children: [
                Container(
                  width: 52,
                  height: 36,
                  decoration: BoxDecoration(color: isActive ? context.isDarkMode ? ChatifyColors.youngNight : ChatifyColors.buttonDisabled.withAlpha((0.5 * 255).toInt()) : ChatifyColors.transparent, borderRadius: BorderRadius.circular(8)),
                  child: Center(
                    child: icon != null ? Icon(icon, color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black, size: size) : svgPath != null
                      ? SvgPicture.asset(svgPath, color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black, width: 19, height: 19)
                      : SizedBox.shrink(),
                  ),
                ),
                if (isActive)
                Positioned(
                  left: 0,
                  top: 8,
                  bottom: 8,
                  child: Container(
                    width: 2.5,
                    decoration: BoxDecoration(color: colorsController.getColor(colorsController.selectedColorScheme.value), borderRadius: BorderRadius.circular(2)),
                  ),
                ),
                if (index == 1 && widget.isCalling)
                Positioned(
                  top: 0,
                  right: 0,
                  child: AnimatedBuilder(
                    animation: _pulseController,
                    builder: (_, child) {
                      double size = 12 + (_pulseController.value * 6);
                      double opacity = 1 - _pulseController.value;

                      return SizedBox(
                        width: 20,
                        height: 20,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              width: size,
                              height: size,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: ChatifyColors.green.withAlpha((opacity * 255).toInt()), width: 2),
                              ),
                            ),
                            Container(
                              width: 12,
                              height: 12,
                              decoration: const BoxDecoration(shape: BoxShape.circle, color: ChatifyColors.green),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMenu({String? svgPath, required bool isActive, required Duration duration}) {
    return Tooltip(
      verticalOffset: -50,
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      message: S.of(context).openNavigation,
      textStyle: TextStyle(color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black, fontSize: ChatifySizes.fontSizeLm, fontWeight: FontWeight.w300),
      decoration: BoxDecoration(
        color: context.isDarkMode ? ChatifyColors.youngNight : ChatifyColors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: context.isDarkMode ? ChatifyColors.darkBackground.withAlpha((0.7 * 255).toInt()) : ChatifyColors.buttonGrey, width: 1),
        boxShadow: [
          BoxShadow(
            color: ChatifyColors.black.withAlpha((0.2 * 255).toInt()),
            spreadRadius: 1,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          setState(() {
            isRotated = !isRotated;
            if (isRotated) {
              _animationController.forward();
            } else {
              _animationController.reverse();
            }
            widget.toggleMenu();
          });
        },
        mouseCursor: SystemMouseCursors.basic,
        splashColor: context.isDarkMode ? ChatifyColors.deepNight : ChatifyColors.grey,
        highlightColor: context.isDarkMode ? ChatifyColors.deepNight : ChatifyColors.grey,
        borderRadius: BorderRadius.circular(ChatifySizes.borderRadiusMd),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: Stack(
            alignment: Alignment.centerLeft,
            children: [
              Container(
                width: 52,
                height: 36,
                decoration: BoxDecoration(color: isActive ? ChatifyColors.youngNight : ChatifyColors.transparent, borderRadius: BorderRadius.circular(8)),
                child: Center(
                  child: AnimatedBuilder(
                    animation: _rotationAnimation,
                    builder: (context, child) {
                      return Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.rotationY(_rotationAnimation.value),
                        child: child,
                      );
                    },
                    child: SvgPicture.asset(svgPath!, width: 14, height: 14, color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black)
                  ),
                ),
              ),
              if (isActive)
              Positioned(
                left: 0,
                top: 8,
                bottom: 8,
                child: Container(
                  width: 2.5,
                  decoration: BoxDecoration(color: colorsController.getColor(colorsController.selectedColorScheme.value), borderRadius: BorderRadius.circular(2)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar(UserModel user) {
    return Tooltip(
      verticalOffset: -50,
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      message: S.of(context).profile,
      textStyle: TextStyle(
        color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black,
        fontSize: ChatifySizes.fontSizeLm,
        fontWeight: FontWeight.w300,
      ),
      decoration: BoxDecoration(
        color: context.isDarkMode ? ChatifyColors.youngNight : ChatifyColors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: context.isDarkMode ? ChatifyColors.darkBackground.withAlpha((0.7 * 255).toInt()) : ChatifyColors.buttonGrey, width: 1),
        boxShadow: [
          BoxShadow(
            color: ChatifyColors.black.withAlpha((0.2 * 255).toInt()),
            spreadRadius: 1,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          final RenderBox renderBox = context.findRenderObject() as RenderBox;
          final position = renderBox.localToGlobal(Offset.zero);
          showSettingsDialog(context, position);
        },
        mouseCursor: SystemMouseCursors.basic,
        splashColor: context.isDarkMode ? ChatifyColors.deepNight : ChatifyColors.grey,
        highlightColor: context.isDarkMode ? ChatifyColors.deepNight : ChatifyColors.grey,
        borderRadius: BorderRadius.circular(ChatifySizes.borderRadiusMd),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Align(
            alignment: Alignment.center,
            child: ClipOval(
              child: AspectRatio(
                aspectRatio: 1,
                child: CachedNetworkImage(
                  imageUrl: widget.user.image,
                  fit: BoxFit.cover,
                  errorWidget: (context, url, error) => CircleAvatar(
                    backgroundColor: context.isDarkMode ? ChatifyColors.softNight : ChatifyColors.grey,
                    foregroundColor:  context.isDarkMode ? ChatifyColors.softNight : ChatifyColors.grey,
                    child: SvgPicture.asset(
                      ChatifyVectors.newUser,
                      color: context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.iconGrey,
                      width: 28,
                      height: 28,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
