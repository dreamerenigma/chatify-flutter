import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../features/home/controllers/dialog_controller.dart';
import '../../../features/personalization/widgets/dialogs/light_dialog.dart';
import '../../../utils/constants/app_colors.dart';
import '../../../utils/constants/app_sizes.dart';

class CustomBottomButtons extends StatefulWidget {
  final String confirmText;
  final String cancelText;
  final VoidCallback? onConfirm;
  final VoidCallback? onClose;
  final VoidCallback? onCancel;
  final bool showConfirmButton;
  final OverlayEntry? overlayEntry;
  final DialogController? dialogController;
  final bool autoCloseOnTap;
  final Color primaryColor;
  final Color? confirmButtonColor;
  final Color? cancelButtonColor;
  final bool reverseButtons;

  const CustomBottomButtons({
    super.key,
    this.showConfirmButton = false,
    required this.confirmText,
    required this.cancelText,
    this.onConfirm,
    this.onClose,
    this.onCancel,
    this.overlayEntry,
    this.dialogController,
    this.autoCloseOnTap = true,
    required this.primaryColor,
    this.confirmButtonColor,
    this.cancelButtonColor,
    this.reverseButtons = false,
  });

  @override
  State<CustomBottomButtons> createState() => _CustomBottomButtonsState();
}

class _CustomBottomButtonsState extends State<CustomBottomButtons> {
  bool isDropDown = false;
  bool isHovered = false;
  bool isTapped = false;

  void _closeDialog() {
    Future.delayed(const Duration(milliseconds: 100), () {
      widget.overlayEntry?.remove();
      widget.dialogController?.closeWindowsDialog();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: context.isDarkMode ? ChatifyColors.youngNight : ChatifyColors.softGrey,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(15)),
        border: Border(top: BorderSide(color: context.isDarkMode ? ChatifyColors.darkBackground : ChatifyColors.buttonGrey, width: 0.5)),
      ),
      child: widget.showConfirmButton
        ? Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(width: 240, child: _buildCancelButton()),
            ],
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              if (widget.reverseButtons)
                ...[
                  Expanded(child: _buildLongPressCancelButton()),
                  const SizedBox(width: 12),
                  Expanded(child: _buildConfirmButton()),
                ]
              else
                ...[
                  Expanded(child: _buildConfirmButton()),
                  const SizedBox(width: 12),
                  Expanded(child: _buildLongPressCancelButton()),
                ]
            ],
          ),
    );
  }

  Widget _buildConfirmButton() {
    return TextButton(
      onPressed: () {
        _closeDialog();
        widget.onClose?.call();
        widget.onConfirm?.call();
      },
      style: TextButton.styleFrom(
        splashFactory: NoSplash.splashFactory,
        backgroundColor: widget.confirmButtonColor ?? widget.primaryColor,
        foregroundColor: ChatifyColors.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        elevation: 1,
        shadowColor: ChatifyColors.black,
      ).copyWith(
        mouseCursor: WidgetStateProperty.all(SystemMouseCursors.basic),
        side: WidgetStateProperty.all(BorderSide(color: ChatifyColors.lightSoftNight, width: 1)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Text(
          widget.confirmText,
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w300, color: context.isDarkMode ? ChatifyColors.black : ChatifyColors.white),
        ),
      ),
    );
  }

  Widget _buildCancelButton() {
    return TextButton(
      onPressed: () {
        _closeDialog();
        widget.onCancel?.call();
      },
      style: TextButton.styleFrom(
        backgroundColor: widget.cancelButtonColor ?? widget.primaryColor,
        foregroundColor: ChatifyColors.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        splashFactory: NoSplash.splashFactory,
        shadowColor: ChatifyColors.black,
      ).copyWith(
        mouseCursor: WidgetStateProperty.all(SystemMouseCursors.basic),
        side: WidgetStateProperty.all(BorderSide(color: colorsController.getColor(colorsController.selectedColorScheme.value).withAlpha((0.5 * 255).toInt()), width: 1)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        child: Text(widget.cancelText, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w300, color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black)),
      ),
    );
  }

  Widget _buildLongPressCancelButton() {
    return GestureDetector(
      onTap: _closeDialog,
      onLongPressStart: (_) => setState(() => isTapped  = true),
      onLongPressEnd: (_) => setState(() => isTapped  = false),
      child: MouseRegion(
        onEnter: (_) => setState(() => isHovered = true),
        onExit: (_) => setState(() => isHovered = false),
        child: Container(
          width: double.infinity,
          height: 35,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: widget.cancelButtonColor != null
              ? widget.cancelButtonColor!
              : isTapped
              ? (context.isDarkMode ? ChatifyColors.mildNight : ChatifyColors.grey.withAlpha(100))
              : isHovered
              ? (context.isDarkMode
              ? ChatifyColors.lightSoftNight.withAlpha((0.8 * 255).toInt())
              : ChatifyColors.black.withAlpha((0.3 * 255).toInt()))
              : (context.isDarkMode ? ChatifyColors.softNight : ChatifyColors.white),
            borderRadius: BorderRadius.all(Radius.circular(8)),
            border: Border.all(color: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Text(
              widget.cancelText,
              style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w300, color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black),
            ),
          ),
        ),
      ),
    );
  }
}
