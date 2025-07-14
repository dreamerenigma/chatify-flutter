import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_vectors.dart';
import '../../../personalization/widgets/dialogs/light_dialog.dart';

class FullScreenImageInput extends StatefulWidget {
  final TextEditingController controller;
  final VoidCallback toggleRatioOneToOne;
  final VoidCallback onToggleDropdown;
  final FocusNode focusNode;

  const FullScreenImageInput({
    super.key,
    required this.controller,
    required this.toggleRatioOneToOne,
    required this.onToggleDropdown,
    required this.focusNode,
  });

  @override
  State<FullScreenImageInput> createState() => _FullScreenImageInputState();
}

class _FullScreenImageInputState extends State<FullScreenImageInput> {
  final LayerLink _layerZoomLink = LayerLink();
  late TextPainter _textPainter;
  VoidCallback? _focusListener;
  bool isFocused = false;
  bool isZoomAppDropdown = false;
  bool isHovered = false;

  @override
  void initState() {
    super.initState();
    _focusListener = () {
      if (!mounted) return;
      setState(() {
        isFocused = widget.focusNode.hasFocus;

        if (isFocused) {
          widget.controller.selection = TextSelection(
            baseOffset: 0,
            extentOffset: widget.controller.text.length,
          );
        }
      });
    };
    widget.focusNode.addListener(_focusListener!);

    _textPainter = TextPainter(
      textDirection: TextDirection.ltr,
      text: TextSpan(text: widget.controller.text, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w300, fontFamily: 'Roboto')),
    );
    _textPainter.layout();
  }

  @override
  void dispose() {
    if (_focusListener != null) {
      widget.focusNode.removeListener(_focusListener!);
    }
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updateTextWidth();
  }

  void _updateTextWidth() {
    _textPainter.text = TextSpan(text: widget.controller.text, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w300, fontFamily: 'Roboto'));
    _textPainter.layout();
  }

  double getTextWidth(String text) {
    final textPainter = TextPainter(
      text: TextSpan(text: text, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w300, fontFamily: 'Roboto')),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    return textPainter.width;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CompositedTransformTarget(
            link: _layerZoomLink,
            child: GestureDetector(
              onTap: () => widget.toggleRatioOneToOne(),
              child: Material(
                color: ChatifyColors.transparent,
                child: MouseRegion(
                  onEnter: (_) => setState(() => isHovered = true),
                  onExit: (_) => setState(() => isHovered = false),
                  child: Container(
                    width: 75,
                    decoration: BoxDecoration(
                      color: isHovered
                        ? context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey.withAlpha((0.15 * 255).toInt())
                        : isFocused ? (context.isDarkMode ? ChatifyColors.deepNight : ChatifyColors.transparent) : ChatifyColors.transparent,
                      border: Border.all(color: isFocused ? (context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.5 * 255).toInt()) : ChatifyColors.grey) : ChatifyColors.transparent),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    height: 36,
                    child: TextSelectionTheme(
                      data: TextSelectionThemeData(
                        cursorColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                        selectionColor: colorsController.getColor(colorsController.selectedColorScheme.value).withAlpha((0.3 * 255).toInt()),
                        selectionHandleColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                      ),
                      child: TextField(
                        focusNode: widget.focusNode,
                        controller: widget.controller,
                        cursorWidth: 1,
                        cursorHeight: 21,
                        inputFormatters: [LengthLimitingTextInputFormatter(4)],
                        style: const TextStyle(color: ChatifyColors.white, fontSize: 15, fontWeight: FontWeight.w300, fontFamily: 'Roboto'),
                        decoration: InputDecoration(
                          counterText: '',
                          contentPadding: const EdgeInsets.only(left: 10, right: 2, top: 9),
                          isDense: true,
                          border: InputBorder.none,
                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide(color: ChatifyColors.transparent, width: 1)),
                          focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: colorsController.getColor(colorsController.selectedColorScheme.value), width: 1.8), borderRadius: BorderRadius.circular(4)),
                          suffixIcon: InkWell(
                            onTap: () {
                              widget.onToggleDropdown.call();
                              setState(() {
                                isZoomAppDropdown = !isZoomAppDropdown;
                              });
                            },
                            mouseCursor: SystemMouseCursors.basic,
                            borderRadius: BorderRadius.circular(6),
                            splashFactory: NoSplash.splashFactory,
                            splashColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey,
                            highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey,
                            hoverColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey,
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              transform: Matrix4.translationValues(0, isZoomAppDropdown ? 2.0 : 0, 0),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SvgPicture.asset(ChatifyVectors.arrowDown, width: 15, height: 15, color: context.isDarkMode ? ChatifyColors.grey : ChatifyColors.white),
                              ),
                            ),
                          ),
                        ),
                        onChanged: (text) {
                          setState(() {
                            _updateTextWidth();
                          });
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
