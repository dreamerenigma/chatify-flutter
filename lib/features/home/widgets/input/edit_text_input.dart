import 'package:chatify/features/personalization/widgets/dialogs/emoji_stickers_dialog.dart';
import 'package:chatify/utils/constants/app_sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:icon_forest/iconoir.dart';
import '../../../../generated/l10n/l10n.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../personalization/widgets/dialogs/light_dialog.dart';
import '../dialogs/confirmation_dialog.dart';

class EditTextInput extends StatefulWidget {
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final VoidCallback? onUnFocus;
  final double? fontSize;
  final EdgeInsetsGeometry? contentPadding;

  const EditTextInput({
    super.key,
    this.controller,
    this.focusNode,
    this.onUnFocus,
    this.fontSize,
    this.contentPadding,
  });

  @override
  EditTextInputState createState() => EditTextInputState();
}

class EditTextInputState extends State<EditTextInput> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;
  bool _isFocused = false;
  bool _isHovered = false;
  bool _emojiDialogOpen = false;
  bool _submitByButton = false;
  bool _isEmojiButtonTapped = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _controller.addListener(_onTextChanged);
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_onFocusChange);
    if (widget.focusNode != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _focusNode.requestFocus();
      });
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
    _focusNode.removeListener(_onFocusChange);
    if (widget.controller == null) _controller.dispose();
    if (widget.focusNode == null) _focusNode.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });

    if (!_focusNode.hasFocus && !_emojiDialogOpen && !_isEmojiButtonTapped) {
      if (_submitByButton) {
        _submitByButton = false;
      } else {
        widget.onUnFocus?.call();
      }
    }
  }

  void _onTextChanged() {
    setState(() {});
  }

  void _onTapOutside() {
    if (!_focusNode.hasFocus && !_emojiDialogOpen) {
      FocusScope.of(context).requestFocus(_focusNode);
    }
  }

  void onEmojiSelected(String emoji) {
    setState(() {
      _controller.text += emoji;
      _controller.selection = TextSelection.collapsed(offset: _controller.text.length);
    });
  }

  void onGifSelected(String sticker) {
    setState(() {
      _controller.text += '[sticker:$sticker]';
      _controller.selection = TextSelection.collapsed(offset: _controller.text.length);
    });
  }

  void showEmojiDialog() {
    _emojiDialogOpen = true;
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final position = renderBox.localToGlobal(Offset.zero);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      showEmojiStickersDialog(
        context,
        position,
        onEmojiSelected,
        onGifSelected,
        width: 340,
        leftOffset: 150,
        bottomOffset: -130,
        hideTabButton: true,
        topPadding: 0,
      ).whenComplete(() {
        setState(() {
          _emojiDialogOpen = false;
          _isEmojiButtonTapped = false;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double fontSize = widget.fontSize ?? ChatifySizes.fontSizeBg;
    EdgeInsetsGeometry contentPadding = widget.contentPadding ?? EdgeInsets.symmetric(horizontal: 6, vertical: 15);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: _onTapOutside,
          child: Container(
            decoration: BoxDecoration(
              color: _isFocused ? context.isDarkMode ? ChatifyColors.deepNight : ChatifyColors.transparent : ChatifyColors.transparent,
              border: Border.all(color: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.5 * 255).toInt()) : ChatifyColors.grey),
              borderRadius: BorderRadius.circular(6),
            ),
            child: TextSelectionTheme(
              data: TextSelectionThemeData(
                cursorColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                selectionColor: colorsController.getColor(colorsController.selectedColorScheme.value).withAlpha((0.3 * 255).toInt()),
                selectionHandleColor: colorsController.getColor(colorsController.selectedColorScheme.value),
              ),
              child: SizedBox(
                height: 32,
                child: TextField(
                  controller: _controller,
                  focusNode: _focusNode,
                  maxLines: 1,
                  maxLength: 25,
                  cursorWidth: 1.0,
                  inputFormatters: [LengthLimitingTextInputFormatter(25)],
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: context.isDarkMode ? ChatifyColors.lightGrey : ChatifyColors.grey, width: 0.5),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: colorsController.getColor(colorsController.selectedColorScheme.value), width: 2),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    contentPadding: contentPadding,
                    counterText: '',
                  ),
                  style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.w500),
                ),
              ),
            ),
          ),
        ),
        _buildButtons(),
      ],
    );
  }

  Widget _buildButtons() {
    const double fixedWidth = 70;

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Material(
          color: ChatifyColors.transparent,
          child: InkWell(
            onTap: () {
              setState(() {
                _isEmojiButtonTapped = true;
              });
              showEmojiDialog();
            },
            mouseCursor: SystemMouseCursors.basic,
            borderRadius: BorderRadius.circular(6),
            splashColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey,
            highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey,
            hoverColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
              decoration: BoxDecoration(
                border: Border.all(color: context.isDarkMode ? ChatifyColors.softNight : ChatifyColors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Iconoir(Iconoir.emoji, width: 20, height: 20, color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black),
            ),
          ),
        ),
        const SizedBox(width: 5),
        MouseRegion(
          onEnter: (_) => setState(() => _isHovered = true),
          onExit: (_) => setState(() => _isHovered = false),
          child: Container(
            width: fixedWidth,
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: (colorsController.getColor(colorsController.selectedColorScheme.value)),
              borderRadius: BorderRadius.circular(6),
              boxShadow: [
                BoxShadow(
                  color: ChatifyColors.black.withAlpha((0.1 * 255).toInt()),
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: GestureDetector(
              onTap: () {
                String updatedName = _controller.text.trim();

                if (updatedName.isEmpty) {
                  showConfirmationDialog(
                    context: context,
                    width: 410,
                    title: S.of(context).unableChangeYourName,
                    description: S.of(context).yourNameCannotEmpty,
                    cancelText: S.of(context).ok,
                    cancelButtonColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                    cancelTextColor: ChatifyColors.black,
                    cancelButtonWidth: 180,
                    confirmButton: true,
                    onConfirm: () {
                      setState(() {});
                    },
                  );
                } else {
                  _submitByButton = true;
                  widget.onUnFocus?.call();
                }
              },
              child: Text(
                _isHovered ? S.of(context).ready : '${_controller.text.length}/25',
                style: TextStyle(color: ChatifyColors.white, fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w300),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
