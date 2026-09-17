import 'package:flutter/material.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../personalization/widgets/dialogs/light_dialog.dart';

class AddMemberButton extends StatefulWidget {
  const AddMemberButton({super.key});

  @override
  State<AddMemberButton> createState() => _AddMemberButtonState();
}

class _AddMemberButtonState extends State<AddMemberButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final color = colorsController.getColor(colorsController.selectedColorScheme.value);

    return AnimatedScale(
      scale: _isPressed ? 0.96 : 1.0,
      duration: const Duration(milliseconds: 100),
      curve: Curves.easeOut,
      child: SizedBox(
        width: double.infinity,
        height: 42,
        child: Material(
          color: ChatifyColors.transparent,
          borderRadius: BorderRadius.circular(30),
          child: InkWell(
            borderRadius: BorderRadius.circular(30),
            splashFactory: InkRipple.splashFactory,
            splashColor: color.withValues(alpha: 0.12),
            highlightColor: color.withValues(alpha: 0.05),
            onTapDown: (_) {
              setState(() {
                _isPressed = true;
              });
            },
            onTapUp: (_) {
              setState(() {
                _isPressed = false;
              });
            },
            onTapCancel: () {
              setState(() {
                _isPressed = false;
              });
            },
            onTap: () {},
            child: Container(
              decoration: BoxDecoration(border: Border.all(color: ChatifyColors.darkerGrey,), borderRadius: BorderRadius.circular(30)),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.person_add_alt_outlined, size: 20, color: color),
                  const SizedBox(width: 8),
                  Text('Добавить участников', style: TextStyle(color: color, fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w400)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
