import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:chatify/utils/popups/custom_tooltip.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:iconoir_icons/iconoir_icons.dart';
import '../../../../generated/l10n/l10n.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_vectors.dart';
import '../../controllers/zoom_controller.dart';
import '../dialogs/image_more_dialog.dart';
import '../dialogs/overlays/zoom_image_overlay_entry.dart';
import '../dialogs/select_emoji_dialog.dart';
import '../input/full_screen_image_input.dart';

class FullScreenImageAppBar extends StatefulWidget implements PreferredSizeWidget {
  const FullScreenImageAppBar({super.key});

  @override
  FullScreenImageAppBarState createState() => FullScreenImageAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight - 5);
}

class FullScreenImageAppBarState extends State<FullScreenImageAppBar> {
  final TextEditingController _textController = TextEditingController();
  final zoomsController = Get.put(ZoomsController());
  final FocusNode _focusNode = FocusNode();
  final LayerLink _layerZoomLink = LayerLink();
  OverlayEntry? _zoomOverlayEntry;
  bool isZoomAppDropdown = false;
  bool isRatioOneToOne = false;
  bool _isFavoriteIcon = true;
  int selectedPercent = 23;

  @override
  void dispose() {
    _hideZoomOverlay();
    super.dispose();
  }

  void _showZoomImageOverlay() {
    _hideZoomOverlay();
    _zoomOverlayEntry = createZoomImageOverlayEntry(
      context: context,
      layerLink: _layerZoomLink,
      selectedOption: '$selectedPercent%',
      onZoomImageSelected: (zoomValue) {
        final zoomInt = int.tryParse(zoomValue.replaceAll('%', '')) ?? 100;
        setState(() => selectedPercent = zoomInt);
        _saveSelectedZoom(zoomInt);
        zoomsController.applyZoom(zoomInt);
      },
      hideOverlay: _hideZoomOverlay,
      zoomOptions: [],
    );
    Overlay.of(context).insert(_zoomOverlayEntry!);
    isZoomAppDropdown = true;
  }

  void _hideZoomOverlay() {
    _zoomOverlayEntry?.remove();
    _zoomOverlayEntry = null;
    isZoomAppDropdown = false;
  }

  void _toggleDropdown() {
    if (isZoomAppDropdown) {
      _hideZoomOverlay();
    } else {
      _showZoomImageOverlay();
    }
  }

  void _saveSelectedZoom(int zoom) {
    final box = GetStorage();
    box.write('selectedPercent', zoom);
  }

  void _toggleRatioOneToOne() {
    setState(() {
      isRatioOneToOne = !isRatioOneToOne;
      selectedPercent = 100;
    });
    _saveSelectedZoom(100);
    zoomsController.applyZoom(100);
  }

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(kToolbarHeight),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: AppBar(
            backgroundColor: context.isDarkMode ? ChatifyColors.deepNight : ChatifyColors.lightGrey,
            leading: CustomTooltip(
              message: S.of(context).back,
              child: InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                },
                mouseCursor: SystemMouseCursors.basic,
                borderRadius: BorderRadius.circular(6),
                splashFactory: NoSplash.splashFactory,
                splashColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey,
                highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey,
                child: Padding(padding: const EdgeInsets.all(11), child: Icon(Icons.arrow_back, size: 18, color: ChatifyColors.buttonDisabled)),
              ),
            ),
            actions: [
              CompositedTransformTarget(
                link: _layerZoomLink,
                child: FullScreenImageInput(
                  controller: _textController,
                  focusNode: _focusNode,
                  toggleRatioOneToOne: _toggleRatioOneToOne,
                  onToggleDropdown: _toggleDropdown,
                ),
              ),
              CustomTooltip(
                message: isRatioOneToOne ?  S.of(context).enlargeToDesiredSize : S.of(context).enlargeToOriginalSize,
                child: InkWell(
                  onTap: () {
                    setState(() {
                      isRatioOneToOne = !isRatioOneToOne;
                    });
                  },
                  mouseCursor: SystemMouseCursors.basic,
                  borderRadius: BorderRadius.circular(6),
                  splashColor: ChatifyColors.transparent,
                  highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey,
                  hoverColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey,
                  child: isRatioOneToOne
                    ? Padding(
                        padding: const EdgeInsets.all(12),
                        child: SvgPicture.asset(ChatifyVectors.maximizeImage, color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black, width: 18, height: 18),
                      )
                    : Padding(padding: const EdgeInsets.all(10), child: Icon(FluentIcons.ratio_one_to_one_20_regular, size: 22))),
              ),
              CustomTooltip(
                message: S.of(context).zoomIn,
                child: InkWell(
                  onTap: () {},
                  mouseCursor: SystemMouseCursors.basic,
                  borderRadius: BorderRadius.circular(6),
                  splashColor: ChatifyColors.transparent,
                  highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey,
                  hoverColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey,
                  child: Padding(padding: const EdgeInsets.all(14), child: Icon(BootstrapIcons.zoom_in, size: 15)),
                ),
              ),
              CustomTooltip(
                message: S.of(context).zoomOut,
                child: InkWell(
                  onTap: () {},
                  mouseCursor: SystemMouseCursors.basic,
                  borderRadius: BorderRadius.circular(6),
                  splashColor: ChatifyColors.transparent,
                  highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey,
                  hoverColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey,
                  child: Padding(padding: const EdgeInsets.all(14), child: Icon(BootstrapIcons.zoom_out, size: 15)),
                ),
              ),
              VerticalDivider(color: context.isDarkMode ? ChatifyColors.softNight : ChatifyColors.white, thickness: 1, indent: 16, endIndent: 16),
              CustomTooltip(
                message: S.of(context).addToFavorites,
                child: InkWell(
                  onTap: () {
                    setState(() {
                      _isFavoriteIcon = !_isFavoriteIcon;
                    });
                  },
                  mouseCursor: SystemMouseCursors.basic,
                  borderRadius: BorderRadius.circular(6),
                  splashColor: ChatifyColors.transparent,
                  highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey,
                  hoverColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey,
                  child: Padding(padding: const EdgeInsets.all(11), child: Icon(_isFavoriteIcon ? FluentIcons.star_16_filled : FluentIcons.star_16_regular, size: 21)),
                ),
              ),
              CustomTooltip(
                message: S.of(context).reactToMessage,
                child: InkWell(
                  onTap: () {
                    final RenderBox renderBox = context.findRenderObject() as RenderBox;
                    final position = renderBox.localToGlobal(Offset.zero);
                    final iconWidth = renderBox.size.width;
                    showSelectEmojiDialog(context, position.translate(-iconWidth - 10, 0));
                  },
                  mouseCursor: SystemMouseCursors.basic,
                  borderRadius: BorderRadius.circular(6),
                  splashColor: ChatifyColors.transparent,
                  highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey,
                  hoverColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey,
                  child: Padding(padding: const EdgeInsets.all(11), child: Iconoir(IconoirIcons.emoji, size: 20)),
                ),
              ),
              CustomTooltip(
                message: S.of(context).otherOptionsHidden,
                child: InkWell(
                  onTap: () {
                    final RenderBox renderBox = context.findRenderObject() as RenderBox;
                    final position = renderBox.localToGlobal(Offset.zero);
                    final iconWidth = renderBox.size.width;
                    showImageMoreDialog(context, position.translate(-iconWidth - 10, 0));
                  },
                  mouseCursor: SystemMouseCursors.basic,
                  borderRadius: BorderRadius.circular(6),
                  splashColor: ChatifyColors.transparent,
                  highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey,
                  hoverColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey,
                  child: Padding(padding: const EdgeInsets.all(10), child: Icon(FluentIcons.more_horizontal_16_filled, size: 20)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
