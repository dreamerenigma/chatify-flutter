import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../generated/l10n/l10n.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_links.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../../utils/urls/url_utils.dart';
import '../../../utils/widgets/no_glow_scroll_behavior.dart';
import '../../widgets/dialogs/light_dialog.dart';

class AddDataAboutScreen extends StatefulWidget {
  final String title;

  const AddDataAboutScreen({super.key, required this.title});

  @override
  State<AddDataAboutScreen> createState() => _AddDataAboutScreenState();
}

class _AddDataAboutScreenState extends State<AddDataAboutScreen> {
  final TextEditingController textController = TextEditingController();
  final FocusNode focusNode = FocusNode();
  bool isTapped = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    textController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration: BoxDecoration(
            color: ChatifyColors.white,
            boxShadow: [
              BoxShadow(
                color: ChatifyColors.black.withAlpha((0.1 * 255).toInt()),
                spreadRadius: 1,
                blurRadius: 3,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: AppBar(
            title: Text('${S.of(context).addDataAbout} ${widget.title}', style: TextStyle(fontSize: ChatifySizes.fontSizeMg, fontWeight: FontWeight.w400)),
            titleSpacing: 0,
            backgroundColor: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.white,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ScrollConfiguration(
              behavior: NoGlowScrollBehavior(),
              child: ScrollbarTheme(
                data: ScrollbarThemeData(thumbColor: WidgetStateProperty.resolveWith<Color>((Set<WidgetState> states) => ChatifyColors.darkerGrey)),
                child: Scrollbar(
                  thickness: 4,
                  thumbVisibility: false,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 20),
                        _buildAddLinks(context),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          _buildButtonSave(),
        ],
      ),
    );
  }

  Widget _buildAddLinks(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 16, top: 30),
                child: Icon(Icons.alternate_email, color: context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.grey),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${S.of(context).username} ${widget.title}',
                      style: TextStyle(color: colorsController.getColor(colorsController.selectedColorScheme.value), fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w400, height: 1.2),
                    ),
                    TextSelectionTheme(
                      data: TextSelectionThemeData(
                        cursorColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                        selectionColor: colorsController.getColor(colorsController.selectedColorScheme.value).withAlpha((0.3 * 255).toInt()),
                        selectionHandleColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                      ),
                      child: TextField(
                        controller: textController,
                        focusNode: focusNode,
                        keyboardType: TextInputType.multiline,
                        textAlignVertical: TextAlignVertical.center,
                        textCapitalization: TextCapitalization.sentences,
                        style: TextStyle(fontSize: ChatifySizes.fontSizeMd),
                        maxLines: null,
                        minLines: 1,
                        decoration: InputDecoration(
                          isDense: true,
                          enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: ChatifyColors.grey)),
                          focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: colorsController.getColor(colorsController.selectedColorScheme.value), width: 2)),
                          contentPadding: EdgeInsets.only(top: 12, bottom: 8),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Divider(height: 10, thickness: 1, color: context.isDarkMode ? ChatifyColors.softNight : ChatifyColors.lightGrey),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: StatefulBuilder(
            builder: (context, setState) {
              return RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '${S.of(context).addUsername} ${widget.title} ${S.of(context).visibleYourAppProfile}',
                      style: TextStyle(
                        fontSize: ChatifySizes.fontSizeSm,
                        color: context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.darkerGrey,
                        height: 1.7,
                      ),
                    ),
                    WidgetSpan(
                      alignment: PlaceholderAlignment.baseline,
                      baseline: TextBaseline.alphabetic,
                      child: Material(
                        color: ChatifyColors.transparent,
                        child: InkWell(
                          onTap: () {
                            setState(() => isTapped = true);
                            Future.delayed(const Duration(milliseconds: 500), () {
                              setState(() => isTapped = false);
                            });

                            UrlUtils.launchURL(AppLinks.addSocialLink);
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
        ),
      ],
    );
  }

  Widget _buildButtonSave() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: colorsController.getColor(colorsController.selectedColorScheme.value),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            side: BorderSide.none,
            padding: const EdgeInsets.symmetric(vertical: 12),
          ),
          child: Text(S.of(context).save, style: TextStyle(color: ChatifyColors.black, fontWeight: FontWeight.normal, fontSize: ChatifySizes.fontSizeMd)),
        ),
      ),
    );
  }
}
