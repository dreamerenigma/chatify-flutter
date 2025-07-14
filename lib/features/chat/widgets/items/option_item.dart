import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../utils/constants/app_sizes.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/devices/device_utility.dart';

class OptionItem extends StatelessWidget {
  final Icon icon;
  final String name;
  final VoidCallback onTap;

  const OptionItem({
    super.key,
    required this.icon,
    required this.name,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap(),
      child: Padding(
        padding: EdgeInsets.only(left: DeviceUtils.getScreenWidth(context) * .05, top: DeviceUtils.getScreenHeight(context) * .015, bottom: DeviceUtils.getScreenHeight(context) * .015),
        child: Row(
          children: [
            icon,
            Flexible(
              child: Text(
                '    $name',
                style: TextStyle(
                  fontSize: ChatifySizes.fontSizeMd,
                  color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
