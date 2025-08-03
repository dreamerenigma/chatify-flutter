import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../../generated/l10n/l10n.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../../utils/constants/app_vectors.dart';
import '../../../utils/widgets/no_glow_scroll_behavior.dart';
import '../../widgets/dialogs/light_dialog.dart';

class RequestAccountInformationScreen extends StatefulWidget {
  const RequestAccountInformationScreen({super.key});

  @override
  State<RequestAccountInformationScreen> createState() => RequestAccountInformationScreenState();
}

class RequestAccountInformationScreenState extends State<RequestAccountInformationScreen> {
  final GetStorage storage = GetStorage();
  static const String switchKey = 'autoReportSwitch';
  bool isSwitched = false;

  @override
  void initState() {
    super.initState();
    isSwitched = storage.read<bool>(switchKey) ?? false;
  }

  void toggleSwitch(bool value) {
    setState(() {
      isSwitched = value;
      storage.write(switchKey, value);
    });
  }

  static const Map<String, int> _schemeMap = {
    'blue': 0,
    'red': 1,
    'green': 2,
    'orange': 3,
  };

  String getAsset(int schemeIndex) {
    switch (schemeIndex) {
      case 0:
        return ChatifyVectors.documentBlue;
      case 1:
        return ChatifyVectors.documentRed;
      case 2:
        return ChatifyVectors.documentGreen;
      case 3:
        return ChatifyVectors.documentOrange;
      default:
        return ChatifyVectors.documentBlue;
    }
  }

  int mapSchemeToIndex(String scheme) {
    return _schemeMap[scheme.toLowerCase().trim()] ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    String scheme = colorsController.selectedColorScheme.value.toString();
    int schemeIndex = mapSchemeToIndex(scheme);

    return Scaffold(
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
            backgroundColor: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.white,
            titleSpacing: 0,
            title: Text(S.of(context).requestAccountInfo, style: TextStyle(fontSize: ChatifySizes.fontSizeMg, fontWeight: FontWeight.w400)),
            elevation: 1,
          ),
        ),
      ),
      body: ScrollConfiguration(
        behavior: NoGlowScrollBehavior(),
        child: ScrollbarTheme(
          data: ScrollbarThemeData(thumbColor: WidgetStateProperty.all(ChatifyColors.darkerGrey)),
          child: Scrollbar(
            thickness: 4,
            thumbVisibility: false,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 40),
                        Center(child: SvgPicture.asset(getAsset(schemeIndex), width: 70, height: 70)),
                        const SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          child: RichText(
                            text: TextSpan(
                              style: TextStyle(fontSize: ChatifySizes.fontSizeMd, height: 1.5, color: ChatifyColors.darkGrey),
                              children: [
                                TextSpan(text: S.of(context).generateReportAppAccountInfo),
                                TextSpan(
                                  text: S.of(context).readMore,
                                  style: TextStyle(fontSize: ChatifySizes.fontSizeMd, color: colorsController.getColor(colorsController.selectedColorScheme.value), decoration: TextDecoration.none),
                                  recognizer: TapGestureRecognizer()..onTap = () {},
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Divider(height: 0, thickness: 1),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                          child: Text(S.of(context).accountInfo, style: TextStyle(color: ChatifyColors.darkGrey)),
                        ),
                        const Divider(height: 0, thickness: 1),
                        InkWell(
                          onTap: () {},
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                            child: Row(
                              children: [
                                Icon(FluentIcons.document_text_20_regular, size: 28, color: colorsController.getColor(colorsController.selectedColorScheme.value)),
                                const SizedBox(width: 20),
                                Text(S.of(context).requestReport, style: TextStyle(fontSize: ChatifySizes.fontSizeMd)),
                              ],
                            ),
                          ),
                        ),
                        const Divider(height: 0, thickness: 1),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                          child: RichText(
                            text: TextSpan(
                              style: TextStyle(fontSize: ChatifySizes.fontSizeSm, color: ChatifyColors.darkGrey, height: 1.5),
                              children: [
                                TextSpan(text: S.of(context).generateReportInfoSettings),
                                TextSpan(
                                  text: S.of(context).readMore,
                                  style: TextStyle(fontSize: ChatifySizes.fontSizeSm, color: colorsController.getColor(colorsController.selectedColorScheme.value), decoration: TextDecoration.none),
                                  recognizer: TapGestureRecognizer()..onTap = () {},
                                ),
                              ],
                            ),
                          ),
                        ),
                        const Divider(height: 0, thickness: 1),
                        InkWell(
                          onTap: () {
                            toggleSwitch(!isSwitched);
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.access_time_outlined, size: 28, color: colorsController.getColor(colorsController.selectedColorScheme.value)),
                                    const SizedBox(width: 20),
                                    Text(S.of(context).generateReportsAuto, style: TextStyle(fontSize: ChatifySizes.fontSizeMd)),
                                  ],
                                ),
                                Switch(
                                  value: isSwitched,
                                  onChanged: toggleSwitch,
                                  activeColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                                  activeTrackColor: colorsController.getColor(colorsController.selectedColorScheme.value).withAlpha((0.5 * 255).toInt()),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const Divider(height: 0, thickness: 1),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                          child: RichText(
                            text: TextSpan(
                              style: TextStyle(fontSize: ChatifySizes.fontSizeSm, height: 1.5, color: ChatifyColors.darkGrey),
                              children: [
                                TextSpan(text: S.of(context).newReportGeneratedMonthly),
                                TextSpan(
                                  text: S.of(context).readMore,
                                  style: TextStyle(fontSize: ChatifySizes.fontSizeSm, color: colorsController.getColor(colorsController.selectedColorScheme.value), decoration: TextDecoration.none),
                                  recognizer: TapGestureRecognizer()..onTap = () {},
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}