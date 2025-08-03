import 'package:chatify/features/utils/widgets/no_glow_scroll_behavior.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:remixicon/remixicon.dart';
import '../../../../api/apis.dart';
import '../../../../generated/l10n/l10n.dart';
import '../../../../routes/custom_page_route.dart';
import '../../../../utils/constants/app_colors.dart';
import 'package:unicons/unicons.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../personalization/widgets/dialogs/light_dialog.dart';
import '../../screens/enter_status_screen.dart';
import '../images/camera_screen.dart';
import 'create_maket_bottom_dialog.dart';

void showAddStatusBottomDialog(BuildContext context) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
    backgroundColor: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.white,
    isScrollControlled: true,
    builder: (BuildContext context) {
      return FractionallySizedBox(
        heightFactor: 0.96,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 12, top: 12),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(onTap: () => Navigator.pop(context), child: const Icon(Icons.close, size: 26)),
                  ),
                  Center(child: Text(S.of(context).addingStatus, style: TextStyle(fontSize: ChatifySizes.fontSizeBg, fontWeight: FontWeight.w400))),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Stack(
                children: [
                  ScrollConfiguration(
                    behavior: NoGlowScrollBehavior(),
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.only(bottom: 90),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _buildStatusOption(context, Remix.text, S.of(context).text, () {
                                  Navigator.push(context, createPageRoute(EnterStatusScreen(user: APIs.me)));
                                }),
                                _buildStatusOption(context, UniconsLine.window_grid, S.of(context).layout, () {
                                  showCreateLayoutBottomDialog(context);
                                }),
                                _buildStatusOption(context, Icons.mic, S.of(context).voice, () {
                                  Navigator.push(context, createPageRoute(EnterStatusScreen(user: APIs.me)));
                                }),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),
                          _buildAlbums(context),
                          const SizedBox(height: 8),
                          _buildImageGrid(),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 16,
                    right: 16,
                    child: Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: context.isDarkMode ? ChatifyColors.softNight : ChatifyColors.grey,
                        border: Border.all(color: ChatifyColors.darkerGrey, width: 1),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: FloatingActionButton(
                        heroTag: 'addStatus',
                        onPressed: () {},
                        backgroundColor: ChatifyColors.transparent,
                        foregroundColor: ChatifyColors.white,
                        elevation: 0,
                        child: const Icon(Icons.folder_copy_outlined, size: 20),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }
  );
}

Widget _buildStatusOption(BuildContext context, IconData icon, String label, VoidCallback onTap) {
  return Container(
    width: 115,
    height: 75,
    decoration: BoxDecoration(
      color: ChatifyColors.transparent,
      borderRadius: BorderRadius.circular(18),
      border: Border.all(color: context.isDarkMode ? ChatifyColors.darkerGrey : ChatifyColors.grey, width: 1),
    ),
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      splashColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey,
      highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 23, color: colorsController.getColor(colorsController.selectedColorScheme.value)),
          const SizedBox(height: 6),
          Text(label, style: TextStyle(fontSize: ChatifySizes.fontSizeSm), textAlign: TextAlign.center),
        ],
      ),
    ),
  );
}

Widget _buildAlbums(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 6),
    child: InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(6),
      splashColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey,
      highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(S.of(context).recent, style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400)),
            SizedBox(width: 6),
            const Icon(Icons.arrow_drop_down_sharp, size: 20),
          ],
        ),
      ),
    ),
  );
}

Widget _buildImageGrid() {
  final images = List.generate(30, (index) => 'Image $index');

  return GridView.builder(
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    itemCount: images.length,
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 3,
      crossAxisSpacing: 3,
      mainAxisSpacing: 3,
      childAspectRatio: 1,
    ),
    itemBuilder: (context, index) {
      if (index == 0) {
        return InkWell(
          onTap: () {
            Navigator.push(context, createPageRoute(const CameraScreen()));
          },
          child: Container(
            decoration: BoxDecoration(color: ChatifyColors.transparent, border: Border.all(color: context.isDarkMode ? ChatifyColors.softNight : ChatifyColors.grey, width: 1)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.camera_alt_outlined, size: 28, color: colorsController.getColor(colorsController.selectedColorScheme.value)),
                const SizedBox(height: 6),
                Text(S.of(context).camera, style: TextStyle(fontSize: ChatifySizes.fontSizeSm, color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black)),
              ],
            ),
          ),
        );
      } else {
        return GestureDetector(
          onTap: () {},
          child: Container(
            decoration: BoxDecoration(color: context.isDarkMode ? ChatifyColors.mildNight : ChatifyColors.grey),
            child: Center(
              child: Text(images[index], style: TextStyle(color: ChatifyColors.white)),
            ),
          ),
        );
      }
    },
  );
}
