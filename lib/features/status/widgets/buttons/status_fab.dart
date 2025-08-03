import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../../api/apis.dart';
import '../../../../routes/custom_page_route.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_vectors.dart';
import '../../../personalization/widgets/dialogs/light_dialog.dart';
import '../../screens/enter_status_screen.dart';
import '../dialogs/add_status_bottom_dialog.dart';

class StatusFAB extends StatefulWidget {
  const StatusFAB({super.key});

  @override
  State<StatusFAB> createState() => _StatusFABState();
}

class _StatusFABState extends State<StatusFAB> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _slideAnimation;
  late final Animation<double> _fadeAnimation;
  bool _shouldShowEditButton = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 400));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _shouldShowEditButton = false;

    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        setState(() {
          _shouldShowEditButton = true;
        });
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final editButton = _shouldShowEditButton
      ? SlideTransition(
          position: _slideAnimation,
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: context.isDarkMode ? ChatifyColors.youngNight : ChatifyColors.softGrey,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: ChatifyColors.black.withAlpha((0.2 * 255).toInt()),
                    offset: const Offset(0, 4),
                    blurRadius: 4,
                  ),
                ],
              ),
              child: Material(
                color: ChatifyColors.transparent,
                child: InkWell(
                  onTap: () {
                    Navigator.push(context, createPageRoute(EnterStatusScreen(user: APIs.me)));
                  },
                  borderRadius: BorderRadius.circular(12),
                  splashColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey,
                  highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey,
                  child: Center(child: Icon(Icons.edit, color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black)),
                ),
              ),
            ),
          ),
        )
      : const SizedBox.shrink();

    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        Padding(padding: const EdgeInsets.only(bottom: 85, right: 7), child: editButton),
        Padding(
          padding: const EdgeInsets.only(bottom: 5),
          child: FloatingActionButton(
            heroTag: 'status',
            onPressed: () {
              showAddStatusBottomDialog(context);
            },
            backgroundColor: colorsController.getColor(colorsController.selectedColorScheme.value),
            foregroundColor: ChatifyColors.white,
            elevation: 2,
            child: SvgPicture.asset(ChatifyVectors.cameraAdd, color: ChatifyColors.black, width: 26, height: 26),
          ),
        ),
      ],
    );
  }
}
