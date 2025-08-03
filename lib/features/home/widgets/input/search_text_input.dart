import 'dart:math' as math;
import 'package:chatify/features/utils/widgets/no_glow_scroll_behavior.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';
import '../../../../generated/l10n/l10n.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../authentication/widgets/inputs/phone_input_formatter.dart';
import '../../../personalization/widgets/dialogs/light_dialog.dart';

class SearchTextInput extends StatefulWidget {
  final String hintText;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final EdgeInsetsGeometry padding;
  final bool showPrefixIcon;
  final bool showSuffixIcon;
  final bool showDialPad;
  final bool showTooltip;
  final bool wrapInScrollView;
  final int? maxLines;
  final Color? enabledBorderColor;
  final Color? underlineBorderColor;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onSuffixTap;
  final bool showAdditionalSuffixIcon;
  final bool allowOnlyDigits;
  final bool hideClearIcon;
  final Color? backgroundColor;

  const SearchTextInput({
    super.key,
    this.hintText = 'Поиск или новый чат',
    this.controller,
    this.focusNode,
    this.padding = const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
    this.showPrefixIcon = true,
    this.showSuffixIcon = true,
    this.showDialPad = false,
    this.showTooltip = true,
    this.wrapInScrollView = true,
    this.maxLines = 1,
    this.enabledBorderColor,
    this.underlineBorderColor,
    this.onChanged,
    this.onSuffixTap,
    this.showAdditionalSuffixIcon = false,
    this.allowOnlyDigits = false,
    this.hideClearIcon = false,
    this.backgroundColor,
  });

  @override
  SearchTextInputState createState() => SearchTextInputState();
}

class SearchTextInputState extends State<SearchTextInput> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;
  bool _isFocused = false;

  bool _isPhoneValid(String text) {
    final onlyDigits = text.replaceAll(RegExp(r'\D'), '');
    return onlyDigits.length >= 10 && onlyDigits.length <= 15;
  }

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
  }

  void _onTextChanged() {
    setState(() {});
  }

  void _clearText() {
    setState(() {
      _controller.clear();
    });
  }

  void _onTapOutside() {
    if (!_focusNode.hasFocus) {
      FocusScope.of(context).requestFocus(_focusNode);
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget tooltipWidget = widget.showTooltip
      ? Tooltip(
          verticalOffset: -50,
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
          message: 'Ctrl+F',
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
          child: _buildSearchTextInput(),
        )
      : _buildSearchTextInput();

    return GestureDetector(
      onTap: _onTapOutside,
      child: Padding(padding: widget.padding, child: tooltipWidget),
    );
  }

  Widget _buildSearchTextInput() {
    Color inputBackgroundColor = widget.backgroundColor ?? (_isFocused ? context.isDarkMode ? ChatifyColors.deepNight : ChatifyColors.transparent : ChatifyColors.mildNight);

    Widget inputField = Container(
      decoration: BoxDecoration(
        color: inputBackgroundColor,
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
          height: widget.maxLines == 1 ? 32 : null,
          child: TextField(
            controller: _controller,
            focusNode: _focusNode,
            maxLines: widget.maxLines,
            cursorWidth: 1,
            onChanged: widget.onChanged,
            keyboardType: widget.allowOnlyDigits ? TextInputType.number : TextInputType.text,
            inputFormatters: widget.allowOnlyDigits ? [PhoneNumberInputFormatter()] : [],
            decoration: InputDecoration(
              prefixIconConstraints: BoxConstraints(minWidth: 32, minHeight: 32),
              prefixIcon: widget.showPrefixIcon
                ? Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.rotationY(math.pi),
                    child: Icon(Ionicons.search_outline, color: context.isDarkMode ? ChatifyColors.grey : ChatifyColors.darkBackground, size: 14),
                  )
                : null,
              suffixIconConstraints: BoxConstraints(minWidth: 28, minHeight: 28),
              suffixIcon: (widget.showSuffixIcon && (widget.showDialPad || _controller.text.isNotEmpty)) || (widget.showAdditionalSuffixIcon && _isPhoneValid(_controller.text))
                ? Material(
                    color: ChatifyColors.transparent,
                    child: InkWell(
                      onTap: widget.showDialPad ? widget.onSuffixTap ?? () {} : () {
                        _clearText();
                        widget.onSuffixTap?.call();
                      },
                      mouseCursor: SystemMouseCursors.basic,
                      splashFactory: NoSplash.splashFactory,
                      borderRadius: BorderRadius.circular(6),
                      splashColor: context.isDarkMode ? ChatifyColors.darkerGrey : ChatifyColors.grey,
                      highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey : ChatifyColors.grey,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          if (widget.showDialPad)
                            Tooltip(
                              verticalOffset: -50,
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                              message: S.of(context).phoneNumber,
                              textStyle: TextStyle(
                                color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black,
                                fontSize: ChatifySizes.fontSizeLm,
                                fontWeight: FontWeight.w300,
                              ),
                              decoration: BoxDecoration(
                                color: context.isDarkMode ? ChatifyColors.youngNight.withAlpha((0.7 * 255).toInt()) : ChatifyColors.white,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: context.isDarkMode ? ChatifyColors.darkBackground.withAlpha((0.7 * 255).toInt()) : ChatifyColors.grey,
                                  width: 1,
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(right: 6),
                                child: Icon(Icons.dialpad_rounded, size: 15, color: context.isDarkMode ? ChatifyColors.grey : ChatifyColors.darkBackground),
                              ),
                            ),
                          if (widget.showAdditionalSuffixIcon && _isPhoneValid(_controller.text))
                            Padding(
                              padding: const EdgeInsets.only(left: 6, right: 4),
                              child: Icon(PhosphorIcons.check_circle_fill, size: 20, color: ChatifyColors.green),
                            ),
                          if (!widget.hideClearIcon && _controller.text.isNotEmpty && _isFocused)
                            Padding(
                              padding: const EdgeInsets.only(right: 4),
                              child: Icon(Icons.close, size: 15, color: context.isDarkMode ? ChatifyColors.grey : ChatifyColors.darkBackground),
                            ),
                        ],
                      ),
                    ),
                  )
                : null,
              hintText: widget.hintText,
              hintStyle: TextStyle(
                color: context.isDarkMode ? ChatifyColors.buttonDisabled : ChatifyColors.steelGrey,
                fontSize: ChatifySizes.fontSizeSm,
                fontWeight: FontWeight.w200,
                overflow: TextOverflow.ellipsis,
              ),
              border: InputBorder.none,
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: widget.underlineBorderColor ?? widget.enabledBorderColor ?? (context.isDarkMode ? ChatifyColors.lightGrey : ChatifyColors.grey), width: 0.5),
                borderRadius: BorderRadius.circular(4),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: colorsController.getColor(colorsController.selectedColorScheme.value), width: 2),
                borderRadius: BorderRadius.circular(4),
              ),
              contentPadding: widget.showPrefixIcon ? EdgeInsets.only(right: 12) : EdgeInsets.only(left: 12, right: 4, bottom: 18),
            ),
            style: TextStyle(fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w300, fontFamily: 'Roboto', height: 1.3),
          ),
        ),
      ),
    );

    if (widget.wrapInScrollView) {
      inputField = ScrollConfiguration(
        behavior: NoGlowScrollBehavior(),
        child: SingleChildScrollView(child: inputField),
      );
    }

    return inputField;
  }
}
