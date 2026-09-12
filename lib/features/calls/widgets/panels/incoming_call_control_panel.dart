import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_utils/src/extensions/context_extensions.dart';
import '../../../../generated/l10n/l10n.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_vectors.dart';

class IncomingCallControlPanel extends StatefulWidget {
  final VoidCallback onAccept;
  final VoidCallback onReject;
  final VoidCallback onMessage;

  const IncomingCallControlPanel({
    super.key,
    required this.onAccept,
    required this.onReject,
    required this.onMessage,
  });

  @override
  State<IncomingCallControlPanel> createState() => _IncomingCallControlPanelState();
}

class _IncomingCallControlPanelState extends State<IncomingCallControlPanel> {
  bool _isAccepting = false;
  double _dragOffset = 0;

  static const double _maxDragDistance = 120;
  static const double _acceptThreshold = 85;

  void _onAcceptDragUpdate(DragUpdateDetails details) {
    final double delta = details.primaryDelta ?? 0;

    if (delta >= 0) {
      return;
    }

    setState(() {
      _dragOffset = (_dragOffset + delta).clamp(-_maxDragDistance, 0.0);
    });
  }

  void _onAcceptDragEnd(DragEndDetails details) {
    final bool reachedThreshold = _dragOffset.abs() >= _acceptThreshold;

    if (reachedThreshold) {
      _acceptCall();
      return;
    }

    _returnButton();
  }

  void _acceptCall() {
    if (_isAccepting) return;

    setState(() {
      _isAccepting = true;
    });

    widget.onAccept();
  }

  void _returnButton() {
    setState(() {
      _dragOffset = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final double progress = (-_dragOffset / _maxDragDistance).clamp(0.0, 1.0);

    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 100,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: _buildCircleButton(icon: Icons.call_end_rounded, backgroundColor: ChatifyColors.buttonRedNight, onPressed: widget.onReject),
                  ),
                  Text(S.of(context).reject, textAlign: TextAlign.center, style: TextStyle(color: ChatifyColors.darkGrey, fontSize: 13, fontWeight: FontWeight.w400, height: 1.3)),
                ],
              ),
            ),
            SizedBox(
              width: 100,
              child: Column(
                children: [
                  SizedBox(
                    width: 100,
                    child: Column(
                      children: [
                        _buildCircleButton(
                          icon: Icons.call_rounded,
                          backgroundColor: ChatifyColors.green,
                          onPressed: _acceptCall,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          S.of(context).accept,
                          textAlign: TextAlign.center,
                          style: TextStyle(color: ChatifyColors.darkGrey, fontSize: 13, fontWeight: FontWeight.w400, height: 1.3),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Opacity(
                    opacity: 1.0 - progress,
                    child: Text(S.of(context).swipeUpToAccept, textAlign: TextAlign.center, style: TextStyle(color: ChatifyColors.darkGrey, fontSize: 13, fontWeight: FontWeight.w400, height: 1.3)),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 100,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: _buildCircleButton(
                      iconWidget: SvgPicture.asset(
                        ChatifyVectors.messageFilled,
                        width: 28,
                        height: 28,
                        colorFilter: ColorFilter.mode(context.isDarkMode ? ChatifyColors.white : ChatifyColors.black, BlendMode.srcIn),
                      ),
                      backgroundColor:
                      context.isDarkMode ? ChatifyColors.popupColorDark : ChatifyColors.softGrey,
                      onPressed: widget.onMessage,
                    ),
                  ),
                  Text(S.of(context).message, textAlign: TextAlign.center, style: TextStyle(color: ChatifyColors.darkGrey, fontSize: 13, fontWeight: FontWeight.w400, height: 1.3)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCircleButton({IconData? icon, Widget? iconWidget, required Color backgroundColor, required VoidCallback onPressed}) {
    return SizedBox(
      width: 55,
      height: 55,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(padding: EdgeInsets.zero, shape: const CircleBorder(), backgroundColor: backgroundColor, side: BorderSide.none, minimumSize: const Size(55, 55)),
        child: iconWidget ?? Icon(icon, size: 28, color: ChatifyColors.white),
      ),
    );
  }
}
