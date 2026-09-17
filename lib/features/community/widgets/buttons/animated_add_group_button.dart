import 'package:flutter/material.dart';
import '../../../../generated/l10n/l10n.dart';
import '../../../../routes/custom_page_route.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../group/screens/add_group_screen.dart';
import '../../../personalization/widgets/dialogs/light_dialog.dart';
import '../../models/community_model.dart';

class AnimatedAddGroupButton extends StatefulWidget {
  final CommunityModel community;

  const AnimatedAddGroupButton({
    super.key,
    required this.community,
  });

  @override
  State<AnimatedAddGroupButton> createState() => _AnimatedAddGroupButtonState();
}

class _AnimatedAddGroupButtonState extends State<AnimatedAddGroupButton> {
  bool _pressed = false;

  void _setPressed(bool value) {
    if (!mounted) return;

    setState(() {
      _pressed = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: (_) => _setPressed(true),
      onTapUp: (_) {
        _setPressed(false);
        Navigator.push(context, createPageRoute(AddGroupScreen(community: widget.community)));
      },
      onTapCancel: () => _setPressed(false),
      child: AnimatedScale(
        scale: _pressed ? 0.96 : 1.0,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeOut,
        child: SizedBox(
          height: 42,
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: null,
            icon: const Icon(Icons.add, size: 18, color: ChatifyColors.black),
            label: Text(S.of(context).addGroup, style: TextStyle(color: ChatifyColors.black, fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400)),
            style: ElevatedButton.styleFrom(
              elevation: 1,
              side: BorderSide.none,
              backgroundColor: colorsController.getColor(colorsController.selectedColorScheme.value),
              disabledBackgroundColor: colorsController.getColor(colorsController.selectedColorScheme.value),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              padding: EdgeInsets.zero,
            ),
          ),
        ),
      ),
    );
  }
}
