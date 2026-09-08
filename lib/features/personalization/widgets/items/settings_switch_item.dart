import 'package:flutter/material.dart';
import 'package:chatify/utils/constants/app_colors.dart';
import 'package:chatify/utils/constants/app_sizes.dart';
import 'package:get/get_utils/src/extensions/context_extensions.dart';
import '../../../../common/widgets/switches/custom_switch.dart';

class SettingsSwitchItem extends StatelessWidget {
  final String label;
  final String? description;
  final bool value;
  final ValueChanged<bool> onChanged;

  const SettingsSwitchItem({
    super.key,
    required this.label,
    this.description,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: ChatifyColors.transparent,
      child: InkWell(
        splashFactory: NoSplash.splashFactory,
        splashColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
        highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
        hoverColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
        onTap: () {
          onChanged(!value);
        },
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 10, top: 10, bottom: 10),
          child: Row(
            crossAxisAlignment: description == null ? CrossAxisAlignment.center : CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(label, style: TextStyle(fontSize: 17, fontWeight: FontWeight.w400)),
                    const SizedBox(height: 2),
                    if (description case final description?) ...[
                      Text(description, style: TextStyle(color: ChatifyColors.darkGrey, fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w400)),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Align(
                alignment: Alignment.topCenter,
                child: CustomSwitch(
                  value: value,
                  onChanged: onChanged,
                  switchWidth: 58,
                  switchHeight: 35,
                  thumbSize: 27,
                  thumbPadding: 3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
