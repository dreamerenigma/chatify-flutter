import 'dart:async';
import 'dart:math' as math;
import 'package:chatify/utils/constants/app_vectors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'leaf_painter.dart';

class LeafEffect extends StatefulWidget {
  const LeafEffect({super.key});

  @override
  LeafEffectState createState() => LeafEffectState();
}

class LeafEffectState extends State<LeafEffect> {
  late List<AutumnLeaf> _autumnLeafs;
  late Timer _timer;

  final List<String> leafAssets = [
    ChatifyVectors.autumnLeaf1,
    ChatifyVectors.autumnLeaf2,
  ];

  @override
  void initState() {
    super.initState();
    _loadLeafImage();
  }

  Future<void> _loadLeafImage() async {
    await rootBundle.load(ChatifyVectors.autumnLeaf1);

    setState(() {
      _initializeLeaf();
      _startAnimation();
    });
  }

  void _initializeLeaf() {
    final random = math.Random();
    final size = MediaQuery.of(context).size;

    if (size.width == 0 || size.height == 0) {
      return;
    }

    _autumnLeafs = List.generate(
      100,
      (_) {
        double xOffset = random.nextDouble() * 20;
        double yOffset = random.nextDouble() * 20;

        return AutumnLeaf(
          x: (random.nextDouble() * size.width) + xOffset,
          y: (random.nextDouble() * size.height) + yOffset,
          radius: random.nextDouble() * 20 + 10,
          speed: random.nextDouble() * 2 + 0.8,
          asset: leafAssets[random.nextInt(leafAssets.length)],
          oscillationAmplitude: random.nextDouble() * 30 + 10,
          oscillationSpeed: random.nextDouble() * 0.5 + 0.1,
          oscillationOffset: random.nextDouble() * 2 * math.pi,
        );
      },
    );
  }

  void _startAnimation() {
    _timer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      setState(() {
        for (final autumnLeaf in _autumnLeafs) {
          autumnLeaf.x += math.sin(autumnLeaf.oscillationOffset) * autumnLeaf.oscillationAmplitude * 0.01;
          autumnLeaf.oscillationOffset += autumnLeaf.oscillationSpeed;

          autumnLeaf.y += autumnLeaf.speed;
          autumnLeaf.rotation += 0.05;

          if (autumnLeaf.rotation >= 2 * math.pi) {
            autumnLeaf.rotation -= 2 * math.pi;
          }

          if (autumnLeaf.y > MediaQuery.of(context).size.height) {
            autumnLeaf.y = -autumnLeaf.radius;
            autumnLeaf.x = math.Random().nextDouble() * MediaQuery.of(context).size.width;
          }
        }
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_autumnLeafs.isEmpty) {
      return const SizedBox.shrink();
    }

    return Stack(
      children: _autumnLeafs.map((autumnLeaf) {
        return Positioned(
          left: autumnLeaf.x,
          top: autumnLeaf.y,
          child: Transform.rotate(
            angle: autumnLeaf.rotation,
            child: SvgPicture.asset(
              autumnLeaf.asset,
              width: autumnLeaf.radius * 1,
              height: autumnLeaf.radius * 1,
            ),
          ),
        );
      }).toList(),
    );
  }
}
