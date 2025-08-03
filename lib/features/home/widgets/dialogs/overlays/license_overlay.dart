import 'package:chatify/utils/constants/app_sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../../../common/widgets/bars/scrollbar/custom_scrollbar.dart';
import '../../../../../generated/l10n/l10n.dart';
import '../../../../../utils/constants/app_colors.dart';

class LicenseOverlay {
  late OverlayEntry _overlayEntry;
  final BuildContext context;
  final TextEditingController controller = TextEditingController();
  final ScrollController scrollController = ScrollController();
  LicenseOverlay(this.context);
  bool isInside = false;

  void show() async {
    if (!context.mounted) return;
    final licenseText = await rootBundle.loadString('assets/licenses/third_party_notices.md');
    final overlay = Overlay.of(context);

    _overlayEntry = OverlayEntry(
      builder: (BuildContext context) {
        return Material(
          color: ChatifyColors.transparent,
          child: Stack(
            children: [
              GestureDetector(
                onTap: close,
                behavior: HitTestBehavior.opaque,
                child: Container(color: ChatifyColors.black.withAlpha((0.3 * 256).toInt())),
              ),
              Center(
                child: StatefulBuilder(
                  builder: (context, localSetState) {
                    return ConstrainedBox(
                      constraints: BoxConstraints(maxHeight: 800, maxWidth: 660),
                      child: Container(
                        decoration: BoxDecoration(
                          color: context.isDarkMode ? ChatifyColors.mildNight : ChatifyColors.white,
                          border: Border.all(color: context.isDarkMode ? ChatifyColors.buttonDarkGrey : ChatifyColors.grey, width: 1),
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: ChatifyColors.black.withAlpha((0.1 * 255).toInt()),
                              spreadRadius: 1,
                              blurRadius: 3,
                              offset: const Offset(0, 1),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(S.of(context).licenses, style: TextStyle(fontSize: 19, fontWeight: FontWeight.w500)),
                              SizedBox(height: 12),
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(color: context.isDarkMode ? ChatifyColors.darkerGrey : ChatifyColors.lightGrey, borderRadius: BorderRadius.circular(10)),
                                  child: CustomScrollbar(
                                    scrollController: scrollController,
                                    isInsidePersonalizedOption: isInside,
                                    onHoverChange: (bool hovered) {
                                      localSetState(() {
                                        isInside = hovered;
                                      });
                                    },
                                    child: SingleChildScrollView(
                                      controller: scrollController,
                                      padding: const EdgeInsets.only(left: 12, right: 2),
                                      child: Text(
                                        licenseText,
                                        style: TextStyle(
                                          color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                  onPressed: close,
                                  style: TextButton.styleFrom(
                                    splashFactory: NoSplash.splashFactory,
                                    backgroundColor: context.isDarkMode ? ChatifyColors.lightSoftNight : ChatifyColors.lightGrey,
                                    foregroundColor: ChatifyColors.black,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                    elevation: 1,
                                    minimumSize: Size(55, 40),
                                    shadowColor: ChatifyColors.black,
                                  ).copyWith(
                                    mouseCursor: WidgetStateProperty.all(SystemMouseCursors.basic),
                                  ),
                                  child: Text(S.of(context).ok, style: TextStyle(color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black, fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w300)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );

    overlay.insert(_overlayEntry);
  }

  void close() {
    _overlayEntry.remove();
  }
}
