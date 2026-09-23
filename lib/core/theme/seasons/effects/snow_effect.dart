import 'dart:async';
import 'dart:math' as math;
import 'package:chatify/utils/constants/app_vectors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'snow_painter.dart';

class SnowEffect extends StatefulWidget {
  const SnowEffect({super.key});

  @override
  SnowEffectState createState() => SnowEffectState();
}

class SnowEffectState extends State<SnowEffect> {
  late List<Snowflake> _snowflakes;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _loadSnowflakeImage();
    _snowflakes = List.generate(100, (index) => Snowflake());
  }

  Future<void> _loadSnowflakeImage() async {
    await rootBundle.load(ChatifyVectors.snowFlake);

    setState(() {
      _initializeSnowflakes();
      _startAnimation();
    });
  }

  void _initializeSnowflakes() {
    final random = math.Random();
    final size = MediaQuery.of(context).size;

    if (size.width == 0 || size.height == 0) {
      return;
    }

    _snowflakes = List.generate(
      100,
          (_) => Snowflake(
        x: random.nextDouble() * size.width,
        y: random.nextDouble() * size.height,
        radius: random.nextDouble() * 20 + 10,
        speed: random.nextDouble() * 2 + 0.8,
        oscillationAmplitude: random.nextDouble() * 30 + 10,
        oscillationSpeed: random.nextDouble() * 0.5 + 0.1,
        oscillationOffset: random.nextDouble() * 2 * math.pi,
      ),
    );
  }

  void _startAnimation() {
    _timer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      setState(() {
        for (final snowflake in _snowflakes) {
          snowflake.x += math.sin(snowflake.oscillationOffset) * snowflake.oscillationAmplitude * 0.01;
          snowflake.oscillationOffset += snowflake.oscillationSpeed;

          snowflake.y += snowflake.speed;
          snowflake.rotation += 0.05;

          if (snowflake.rotation >= 2 * math.pi) {
            snowflake.rotation -= 2 * math.pi;
          }

          if (snowflake.y > MediaQuery.of(context).size.height) {
            snowflake.y = -snowflake.radius;
            snowflake.x = math.Random().nextDouble() * MediaQuery.of(context).size.width;
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
    if (_snowflakes.isEmpty) {
      return const SizedBox.shrink();
    }

    return Stack(
      children: _snowflakes.map((snowflake) {
        return Positioned(
          left: snowflake.x,
          top: snowflake.y,
          child: Transform.rotate(
            angle: snowflake.rotation,
            child: SvgPicture.asset(
              ChatifyVectors.snowFlake,
              width: snowflake.radius * 1,
              height: snowflake.radius * 1,
            ),
          ),
        );
      }).toList(),
    );
  }
}
