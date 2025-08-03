import 'dart:typed_data';
import 'package:chatify/features/utils/widgets/no_glow_scroll_behavior.dart';
import 'package:chatify/utils/constants/app_sizes.dart';
import 'package:flutter/foundation.dart';
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
import '../../../../widgets/buttons/support_button.dart';
import '../../../../widgets/dialogs/light_dialog.dart';
import '../../../../widgets/forms/support_form.dart';
import '../../help_screen.dart';

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
  TextEditingController problemController = TextEditingController();
  late List<AssetEntity> selectedImages;
  bool isHovered = false;
  bool allFieldsFilled = false;
  bool isHoveredHelp = false;

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
      context,
      suggestion: problemController.text.isEmpty ? null : problemController.text,
      images: imageBytes,
    );
    if (success) {
      setState(() {
        problemController.clear();
        selectedImages.clear();
        allFieldsFilled = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isWebOrWindows ? (context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.grey.withAlpha((0.7 * 255).toInt())) : null,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: (isWebOrWindows && !isMobile) ? 55 : 75,
            decoration: BoxDecoration(
              color: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.grey.withAlpha((0.7 * 255).toInt()),
              boxShadow: [
                BoxShadow(
                  color: ChatifyColors.black.withAlpha((0.1 * 255).toInt()),
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            clipBehavior: Clip.none,
            child: Padding(
              padding: EdgeInsets.only(left: 5, right: 5, top: isMobile ? 35 : 5),
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
                            decoration: BoxDecoration(shape: BoxShape.rectangle, borderRadius: BorderRadius.circular(6)),
                            clipBehavior: Clip.hardEdge,
                            child: Icon(Icons.arrow_back, color: isHovered ? context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.white : ChatifyColors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 15),
                  isWindows
                    ? Expanded(
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: Text(widget.title, style: TextStyle(fontSize: ChatifySizes.fontSizeMg, fontWeight: FontWeight.w500)),
                        ),
                      )
                    : Text(widget.title, style: TextStyle(fontSize: ChatifySizes.fontSizeMg, fontWeight: FontWeight.w500)),
                ],
              ),
            ),
          ),
          Expanded(
            child: isWebOrWindows
              ? Center(
              child: ScrollConfiguration(
                behavior: NoGlowScrollBehavior(),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 592),
                          child: Text(
                            S.of(context).pleaseDescribeHappenedAttachImages,
                            style: TextStyle(fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w400),
                            textAlign: isWebOrWindows ? TextAlign.center : TextAlign.start,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      isWebOrWindows
                        ? Center(
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 592),
                              child: SupportForm(selectedImages: widget.selectedImages, onFieldsFilledChanged: updateFieldsFilled),
                            ),
                          )
                        : SupportForm(selectedImages: widget.selectedImages, onFieldsFilledChanged: updateFieldsFilled),
                      const SizedBox(height: 20),
                      if (isWindows) ...[
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          constraints: const BoxConstraints(maxWidth: 592),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              MouseRegion(
                                cursor: SystemMouseCursors.click,
                                onEnter: (_) => setState(() => isHoveredHelp = true),
                                onExit: (_) => setState(() => isHoveredHelp = false),
                                child: GestureDetector(
                                  onTap: () => UrlUtils.launchURL(AppLinks.helpCenter),
                                  child: Text(
                                    S.of(context).visitHelpCenter,
                                    style: TextStyle(
                                      fontSize: ChatifySizes.fontSizeSm,
                                      color: isHoveredHelp
                                          ? colorsController.getColor(colorsController.selectedColorScheme.value).withAlpha((0.7 * 255).toInt())
                                          : colorsController.getColor(colorsController.selectedColorScheme.value),
                                      decoration: isHoveredHelp ? TextDecoration.underline : TextDecoration.none,
                                      decorationColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                                      decorationThickness: 1.5,
                                    ),
                                  ),
                                ),
                              ),
                              const Spacer(),
                              Align(alignment: Alignment.center, child: SupportButton(allFieldsFilled: allFieldsFilled, handleSendFeedback: handleSendFeedback)),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ) : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 592),
                      child: widget.showText ? Text(
                        S.of(context).pleaseDescribeHappenedAttachImages,
                        style: TextStyle(fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w400),
                        textAlign: isWebOrWindows ? TextAlign.center : TextAlign.start,
                      ) : SizedBox.shrink(),
                    ),
                  ),
                  SizedBox(height: widget.showText ? 20 : 0),
                  isWebOrWindows
                    ? Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 592),
                        child: SupportForm(selectedImages: widget.selectedImages, onFieldsFilledChanged: updateFieldsFilled),
                      ),
                    ) : SupportForm(selectedImages: widget.selectedImages, onFieldsFilledChanged: updateFieldsFilled),
                  SizedBox(height: widget.showReadMoreText ? 12 : 0),
                  if (widget.showReadMoreText)
                  StatefulBuilder(
                    builder: (context, setState) {
                      return RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text:
                              S.of(context).continuingAgreeAppTechInfo,
                              style: TextStyle(fontSize: ChatifySizes.fontSizeSm, color: context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.darkerGrey, height: 1.2),
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
                                  child: Text(S.of(context).readMore, style: TextStyle(fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w500, color: ChatifyColors.blueAccent)),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  if (isWindows) ...[
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      constraints: const BoxConstraints(maxWidth: 592),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          MouseRegion(
                            cursor: SystemMouseCursors.click,
                            onEnter: (_) => setState(() => isHoveredHelp = true),
                            onExit: (_) => setState(() => isHoveredHelp = false),
                            child: GestureDetector(
                              onTap: () => UrlUtils.launchURL(AppLinks.helpCenter),
                              child: Text(
                                S.of(context).visitHelpCenter,
                                style: TextStyle(
                                  fontSize: ChatifySizes.fontSizeSm,
                                  color: isHoveredHelp
                                      ? colorsController.getColor(colorsController.selectedColorScheme.value).withAlpha((0.7 * 255).toInt())
                                      : colorsController.getColor(colorsController.selectedColorScheme.value),
                                  decoration: isHoveredHelp ? TextDecoration.underline : TextDecoration.none,
                                  decorationColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                                  decorationThickness: 1.5,
                                ),
                              ),
                            ),
                          ),
                          const Spacer(),
                          Align(alignment: Alignment.center, child: SupportButton(allFieldsFilled: allFieldsFilled, handleSendFeedback: handleSendFeedback)),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          if (isMobile)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: widget.showCompactButtonOnly
                  ? SizedBox(
                width: double.infinity,
                child: SupportButton(allFieldsFilled: allFieldsFilled, handleSendFeedback: handleSendFeedback, buttonText: S.of(context).save),
              )
                  : Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => UrlUtils.launchURL(AppLinks.helpCenter),
                    child: Text(
                      S.of(context).visitHelpCenter,
                      style: TextStyle(
                        fontSize: ChatifySizes.fontSizeSm,
                        color: colorsController.getColor(colorsController.selectedColorScheme.value),
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ),
                  const Spacer(),
                  SizedBox(
                    child: SupportButton(allFieldsFilled: allFieldsFilled, handleSendFeedback: handleSendFeedback),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
