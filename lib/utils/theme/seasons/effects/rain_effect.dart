import 'dart:async';
import 'dart:math' as math;
import 'package:chatify/utils/theme/seasons/effects/rain_painter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_images.dart';

class RaindropEffect extends StatefulWidget {
  const RaindropEffect({super.key});

  @override
  RaindropEffectState createState() => RaindropEffectState();
}

class RaindropEffectState extends State<RaindropEffect> {
  late List<Raindrop> _raindrops = [];
  late Timer _timer;

  final List<String> raindropAssets = [
    ChatifyImages.raindrop1,
    ChatifyImages.raindrop2,
  ];

  @override
  void initState() {
    super.initState();
    _loadRaindropImage();
  }

  Future<void> _loadRaindropImage() async {
    await rootBundle.load(ChatifyImages.raindrop1);

    setState(() {
      _initializeRaindrops();
      _startAnimation();
    });
  }

  void _initializeRaindrops() {
    final random = math.Random();
    final size = MediaQuery.of(context).size;

    if (size.width == 0 || size.height == 0) {
      return;
    }

    _raindrops = List.generate(
      100,
      (_) {
        double xOffset = random.nextDouble() * 20;
        double yOffset = random.nextDouble() * 20;
        double radius = random.nextDouble() * 5 + 5;

        return Raindrop(
          x: (random.nextDouble() * size.width) + xOffset,
          y: (random.nextDouble() * size.height) + yOffset,
          radius: radius,
          speed: random.nextDouble() * 2 + 2,
          angle: random.nextDouble() * 0.1 - 0.05,
          asset: raindropAssets[random.nextInt(raindropAssets.length)],
          trail: [],
          sizeVariation: radius,
          trailLength: 10,

        );
      },
    );
  }

  void _startAnimation() {
    _timer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      setState(() {
        for (final raindrop in _raindrops) {
          raindrop.y += raindrop.speed;

          if (raindrop.y > MediaQuery.of(context).size.height) {
            raindrop.y = -raindrop.radius;
            raindrop.x = math.Random().nextDouble() * MediaQuery.of(context).size.width;
          }

          raindrop.trail.add(Offset(raindrop.x, raindrop.y));
          
          if (raindrop.trail.length > raindrop.trailLength) {
            raindrop.trail.removeAt(0);
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
    if (_raindrops.isEmpty) {
      return const SizedBox.shrink();
    }

    return Stack(
      children: [
        ..._raindrops.expand((raindrop) {
          return raindrop.trail.map((trailPoint) {
            return Positioned(
              left: trailPoint.dx,
              top: trailPoint.dy,
              child: Opacity(
                opacity: 0.3,
                child: Container(
                  width: raindrop.sizeVariation,
                  height: raindrop.sizeVariation,
                  decoration: BoxDecoration(
                    color: ChatifyColors.white.withAlpha((0.05 * 255).toInt()),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            );
          }).toList();
        }),
        ..._raindrops.map((raindrop) {
          return Positioned(
            left: raindrop.x,
            top: raindrop.y,
            child: Transform.rotate(
              angle: raindrop.angle,
              child: Image.asset(
                raindrop.asset,
                width: raindrop.radius,
                height: raindrop.radius,
              ),
            ),
          );
        }),
      ],
    );
  }
}
