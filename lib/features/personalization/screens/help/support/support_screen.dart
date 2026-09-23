import 'dart:typed_data';
import 'package:chatify/features/utils/widgets/scrolls/no_glow_scroll_behavior.dart';
import 'package:chatify/utils/constants/app_sizes.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_manager/photo_manager.dart';
import '../../../../../../../data/repositories/email/email_send_repository.dart';
import '../../../../../../generated/l10n/l10n.dart';
import '../../../../../../routes/custom_page_route.dart';
import '../../../../../../utils/constants/app_colors.dart';
import '../../../../../../utils/constants/app_links.dart';
import '../../../../../../utils/platforms/platform_utils.dart';
import '../../../../../../utils/popups/custom_tooltip.dart';
import '../../../../../../utils/urls/url_utils.dart';
import '../../../widgets/buttons/support_button.dart';
import '../../../widgets/dialogs/light_dialog.dart';
import '../../../widgets/dialogs/reset_feedback_dialog.dart';
import '../../../widgets/forms/support_form.dart';
import '../help_screen.dart';

class SupportScreen extends StatefulWidget {
  final String title;
  final List<AssetEntity>? selectedImages;
  final bool showText;
  final bool showReadMoreText;
  final bool showCompactButtonOnly;

  const SupportScreen({
    super.key,
    this.selectedImages,
    required this.title,
    this.showText = true,
    this.showReadMoreText = false,
    this.showCompactButtonOnly = false,
  });

  @override
  SupportScreenState createState() => SupportScreenState();
}

class SupportScreenState extends State<SupportScreen> {
  late List<AssetEntity> selectedImages;
  TextEditingController problemController = TextEditingController();
  bool isHovered = false;
  bool allFieldsFilled = false;
  bool isHoveredHelp = false;

  bool get hasUnsavedChanges {
    return problemController.text.trim().isNotEmpty || (widget.selectedImages?.isNotEmpty ?? false);
  }

  @override
  void dispose() {
    problemController.dispose();
    super.dispose();
  }

  void updateFieldsFilled(bool filled) {
    setState(() {
      allFieldsFilled = filled;
    });
  }

  Future<void> handleSendFeedback() async {
    List<Uint8List> imageBytes = [];

    for (AssetEntity image in selectedImages) {
      Uint8List? bytes = await image.originBytes;
      if (bytes != null) {
        imageBytes.add(bytes);
      }
    }

    bool success = await EmailSendRepository.instance.sendFeedback(
      context, suggestion: problemController.text.isEmpty ? null : problemController.text, images: imageBytes,
    );

    if (success) {
      setState(() {
        problemController.clear();
        selectedImages.clear();
        allFieldsFilled = false;
      });
    }
  }

  Future<void> _handleBack() async {
    if (!hasUnsavedChanges) {
      if (mounted) {
        Navigator.pop(context);
      }
      return;
    }

    final shouldReset = await showResetFeedbackDialog(context);

    if (!shouldReset || !mounted) {
      return;
    }

    problemController.clear();
    widget.selectedImages?.clear();

    setState(() {
      allFieldsFilled = false;
    });

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;

        _handleBack();
      },
      child: Scaffold(
        backgroundColor: isWebOrWindows ? (context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.grey.withAlpha((0.7 * 255).toInt())) : null,
        appBar: _buildAppBar(),
        body: Column(
          children: [
            Expanded(child: _buildContent()),
            if (isMobile)
              _buildMobileBottomBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    return isWebOrWindows ? _buildDesktopContent() : _buildMobileContent();
  }

  Widget _buildDesktopContent() {
    return Center(
      child: ScrollConfiguration(
        behavior: NoGlowScrollBehavior(),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildDescription(),
              const SizedBox(height: 20),
              _buildSupportForm(),
              const SizedBox(height: 20),
              if (isWindows)
                _buildWindowsActions(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMobileContent() {
    return ScrollConfiguration(
      behavior: NoGlowScrollBehavior(),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (!widget.showText) ...[
              _buildDescription(),
              const SizedBox(height: 15),
            ],
            _buildSupportForm(),
            if (isMobile && widget.showReadMoreText)
              _buildReadMore(),
            if (isWindows)
              _buildWindowsActions(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildDescription() {
    final linkColor = colorsController.getColor(colorsController.selectedColorScheme.value);

    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 592),
        child: RichText(
          textAlign: isWebOrWindows ? TextAlign.center : TextAlign.start,
          text: TextSpan(
            style: TextStyle(
              fontSize: ChatifySizes.fontSizeSm,
              fontWeight: FontWeight.w400,
              color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black,
            ),
            children: [
              TextSpan(text: S.of(context).pleaseDescribeHappenedAttachImages, style: TextStyle(color: ChatifyColors.darkGrey, fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w400, height: 1.5)),
              const TextSpan(text: ' '),
              TextSpan(
                text: S.of(context).helpCenter,
                style: TextStyle(color: linkColor, fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w400, height: 1.5, decoration: TextDecoration.none, decorationColor: linkColor),
                recognizer: TapGestureRecognizer()..onTap = () {
                  UrlUtils.launchURL(AppLinks.helpCenter);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSupportForm() {
    if (!isWebOrWindows) {
      return SupportForm(selectedImages: widget.selectedImages, onFieldsFilledChanged: updateFieldsFilled);
    }

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 592),
        child: SupportForm(selectedImages: widget.selectedImages, onFieldsFilledChanged: updateFieldsFilled),
      ),
    );
  }

  Widget _buildReadMore() {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: S.of(context).continuingAgreeAppTechInfo,
            style: TextStyle(fontSize: ChatifySizes.fontSizeSm, color: context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.darkerGrey, height: 1.5),
          ),
          WidgetSpan(
            alignment: PlaceholderAlignment.baseline,
            baseline: TextBaseline.alphabetic,
            child: Material(
              color: ChatifyColors.transparent,
              child: InkWell(
                onTap: () {
                  Navigator.push(context, createPageRoute(const HelpScreen()));
                },
                splashColor: ChatifyColors.blueAccent.withAlpha((0.2 * 255).toInt()),
                highlightColor: ChatifyColors.blueAccent.withAlpha((0.1 * 255).toInt()),
                child: Text(
                  S.of(context).readMore,
                  style: TextStyle(color: ChatifyColors.blueAccent, fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w500),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWindowsActions() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      constraints: const BoxConstraints(maxWidth: 592),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildHelpCenterButton(),
          const Spacer(),
          SupportButton(allFieldsFilled: allFieldsFilled, handleSendFeedback: handleSendFeedback),
        ],
      ),
    );
  }

  Widget _buildHelpCenterButton() {
    final color = colorsController.getColor(colorsController.selectedColorScheme.value);

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => isHoveredHelp = true),
      onExit: (_) => setState(() => isHoveredHelp = false),
      child: GestureDetector(
        onTap: () => UrlUtils.launchURL(AppLinks.helpCenter),
        child: Text(
          S.of(context).visitHelpCenter,
          style: TextStyle(
            fontSize: ChatifySizes.fontSizeSm,
            color: isHoveredHelp ? color.withAlpha((0.7 * 255).toInt()) : color,
            decoration: isHoveredHelp ? TextDecoration.underline : TextDecoration.none,
            decorationColor: color,
            decorationThickness: 1.5,
          ),
        ),
      ),
    );
  }

  Widget _buildMobileBottomBar() {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 12, bottom: 20),
      child: widget.showCompactButtonOnly
        ? SizedBox(
            width: double.infinity,
            child: SupportButton(allFieldsFilled: allFieldsFilled, handleSendFeedback: handleSendFeedback, buttonText: S.of(context).send),
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () => UrlUtils.launchURL(AppLinks.helpCenter),
                child: Text(
                  S.of(context).visitHelpCenter,
                  style: TextStyle(color: colorsController.getColor(colorsController.selectedColorScheme.value), fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w400),
                ),
              ),
              const Spacer(),
              SupportButton(allFieldsFilled: allFieldsFilled, handleSendFeedback: handleSendFeedback),
            ],
          ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    if (isWindows || isWebOrWindows) {
      return PreferredSize(preferredSize: const Size.fromHeight(55), child: _buildDesktopAppBar());
    }

    return AppBar(
      backgroundColor: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.white,
      leading: IconButton(icon: const Icon(Icons.arrow_back_rounded), onPressed: _handleBack),
      titleSpacing: 0,
      elevation: 0,
      title: Text(widget.title, style: TextStyle(fontSize: ChatifySizes.fontSizeMg, fontWeight: FontWeight.w400)),
      iconTheme: IconThemeData(color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black),
    );
  }

  Widget _buildDesktopAppBar() {
    return Container(
      height: 55,
      decoration: BoxDecoration(
        color: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.grey.withAlpha((0.7 * 255).toInt()),
        boxShadow: [BoxShadow(color: ChatifyColors.black.withAlpha((0.1 * 255).toInt()), spreadRadius: 1, blurRadius: 3, offset: const Offset(0, 2))],
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 8, right: 5, top: 5),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomTooltip(
              message: S.of(context).back,
              horizontalOffset: -35,
              verticalOffset: 10,
              child: MouseRegion(
                onEnter: (_) {
                  setState(() {
                    isHovered = true;
                  });
                },
                onExit: (_) {
                  setState(() {
                    isHovered = false;
                  });
                },
                child: Material(
                  color: ChatifyColors.transparent,
                  child: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    mouseCursor: SystemMouseCursors.basic,
                    splashFactory: NoSplash.splashFactory,
                    borderRadius: BorderRadius.circular(8),
                    splashColor: context.isDarkMode ? ChatifyColors.mildNight : ChatifyColors.grey,
                    highlightColor: context.isDarkMode ? ChatifyColors.mildNight : ChatifyColors.grey,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(6)),
                      child: Icon(Icons.arrow_back_rounded, size: 25, color: isHovered ? context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.white : ChatifyColors.white),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Align(
                alignment: Alignment.topCenter,
                child: Text(widget.title, style: TextStyle(fontSize: ChatifySizes.fontSizeMg, fontWeight: FontWeight.w400)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
