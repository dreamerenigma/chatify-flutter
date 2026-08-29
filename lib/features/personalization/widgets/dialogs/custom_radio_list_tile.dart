import 'package:flutter/material.dart';
import '../../../utils/widgets/icons/custom_icon.dart';
import 'light_dialog.dart';

class CustomRadioListTile extends StatefulWidget {
  final dynamic icon;
  final Widget title;
  final String value;
  final String groupValue;
  final Function(String?) onChanged;
  final Color iconColor;

  const CustomRadioListTile({
    super.key,
    this.icon,
    required this.title,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    required this.iconColor,
  });

  @override
  CustomRadioListTileState createState() => CustomRadioListTileState();
}

class CustomRadioListTileState extends State<CustomRadioListTile> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        widget.onChanged(widget.value);
      },
      child: Container(
        padding: const EdgeInsets.only(left: 20, right: 12, top: 8, bottom: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                if (widget.icon != null) ...[
                  CustomIcon(icon: widget.icon, color: widget.iconColor, size: 24),
                  const SizedBox(width: 16),
                ],
                widget.title,
              ],
            ),
            Radio<String>(
              value: widget.value,
              groupValue: widget.groupValue,
              onChanged: widget.onChanged,
              activeColor: colorsController.getColor(colorsController.selectedColorScheme.value),
            ),
          ],
        ),
      ),
    );
  }
}
