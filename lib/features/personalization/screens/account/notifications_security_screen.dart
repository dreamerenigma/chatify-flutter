import 'package:chatify/features/personalization/screens/help/help_center_screen.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../../common/widgets/switches/custom_switch.dart';
import '../../../../generated/l10n/l10n.dart';
import '../../../../routes/custom_page_route.dart';
import '../../../../utils/constants/app_color_assets.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_links.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../../utils/constants/app_vectors.dart';
import '../../../../utils/urls/url_utils.dart';
import '../../../utils/widgets/scrolls/no_glow_scroll_behavior.dart';
import '../../widgets/dialogs/light_dialog.dart';

class NotificationsSecurityScreen extends StatefulWidget {
  const NotificationsSecurityScreen({super.key});

  @override
  State<NotificationsSecurityScreen> createState() => _NotificationsSecurityScreenState();
}

class _NotificationsSecurityScreenState extends State<NotificationsSecurityScreen> {
  final storage = GetStorage();
  bool isNotifySecurityEnabled = false;

  @override
  void initState() {
    super.initState();
    isNotifySecurityEnabled = storage.read('notifySecurity') ?? false;
  }

  void toggleSwitch(bool value) {
    setState(() {
      isNotifySecurityEnabled = value;
    });
    storage.write('notifySecurity', value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration: BoxDecoration(color: ChatifyColors.white, boxShadow: [BoxShadow(color: ChatifyColors.black.withAlpha((0.1 * 255).toInt()), spreadRadius: 1, blurRadius: 3, offset: const Offset(0, 1))]),
          child: AppBar(
            backgroundColor: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.white,
            titleSpacing: 0,
            title: Text(S.of(context).securityNotices, style: TextStyle(fontSize: ChatifySizes.fontSizeMg, fontWeight: FontWeight.w400)),
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
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),
                  Center(child: SvgPicture.asset(colorsController.getAsset(ChatifyColorAssetsList.strongbox), width: 70, height: 70)),
                  const SizedBox(height: 40),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    child: Text(S.of(context).chatsCallsConfidential, style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400)),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(S.of(context).endToEndEncryptionPrivateMessages, style: TextStyle(fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w400, color: ChatifyColors.darkGrey, height: 1.5)),
                  ),
                  const SizedBox(height: 16),
                  _buildInfoRow(Icon(Icons.message, size: 22, color: colorsController.getColor(colorsController.selectedColorScheme.value)), S.of(context).textVoiceMessages),
                  _buildInfoRow(Icon(Icons.call, size: 24, color: colorsController.getColor(colorsController.selectedColorScheme.value)), S.of(context).openInBrowser),
                  _buildInfoRow(Icon(Icons.attach_file, size: 24, color: colorsController.getColor(colorsController.selectedColorScheme.value)), S.of(context).photosVideosDocuments),
                  _buildInfoRow(Icon(Icons.location_on, size: 24, color: colorsController.getColor(colorsController.selectedColorScheme.value)), S.of(context).yourLocation),
                  _buildInfoRow(SvgPicture.asset(ChatifyVectors.status, width: 24, height: 24, colorFilter: ColorFilter.mode(colorsController.getColor(colorsController.selectedColorScheme.value), BlendMode.srcIn)), S.of(context).statusUpdates),
                  const SizedBox(height: 12),
                  GestureDetector(
                    onTap: () => UrlUtils.launchURL(AppLinks.security),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(S.of(context).readMore, style: TextStyle(color: ChatifyColors.lightBlueLink, fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w500, decoration: TextDecoration.none)),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Divider(),
                  InkWell(
                    onTap: () {
                      setState(() {
                        toggleSwitch(!isNotifySecurityEnabled);
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.only(left: 20, right: 10, top: 16, bottom: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(S.of(context).securityNotificationsDevice, style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400)),
                              ),
                              const SizedBox(width: 12),
                              CustomSwitch(
                                value: isNotifySecurityEnabled,
                                onChanged: toggleSwitch,
                                switchWidth: 58,
                                switchHeight: 35,
                                thumbSize: 27,
                                thumbPadding: 3,
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Padding(
                            padding: const EdgeInsets.only(right: 60),
                            child: RichText(
                              text: TextSpan(
                                style: const TextStyle(fontSize: 15, color: ChatifyColors.darkGrey, height: 1.5),
                                children: [
                                  TextSpan(text: S.of(context).notifySecurityCodeEndToEndEncrypted),
                                  TextSpan(
                                    text: S.of(context).readMore,
                                    style: TextStyle(color: ChatifyColors.lightBlueLink, fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w500, decoration: TextDecoration.none),
                                    recognizer: TapGestureRecognizer()..onTap = () {
                                      Navigator.push(context, createPageRoute(const HelpCenterScreen()));
                                    },
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
      ),
    );
  }

  Widget _buildInfoRow(Widget icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Row(
        children: [
          icon,
          const SizedBox(width: 16),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w400, color: ChatifyColors.darkGrey))),
        ],
      ),
    );
  }
}
