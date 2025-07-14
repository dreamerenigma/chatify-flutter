import 'package:flutter/material.dart';
import '../../../utils/constants/app_colors.dart';

class BlinkAnimation extends StatefulWidget {
  const BlinkAnimation({super.key});

  @override
  BlinkAnimationState createState() => BlinkAnimationState();
}

class BlinkAnimationState extends State<BlinkAnimation> {
  double _opacity = 1.0;

  @override
  void initState() {
    super.initState();
    _startBlinking();
  }

  void _startBlinking() async {
    while (mounted) {
      setState(() => _opacity = 0.0);
      await Future.delayed(Duration(milliseconds: 800));

      setState(() => _opacity = 1.0);
      await Future.delayed(Duration(milliseconds: 800));
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: Duration(milliseconds: 400),
      opacity: _opacity,
      child: Container(width: 9, height: 9, decoration: BoxDecoration(color: ChatifyColors.ascentRed, shape: BoxShape.circle)),
    );
  }
}
