import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../utils/constants/app_colors.dart';
import '../../personalization/widgets/dialogs/light_dialog.dart';
import '../widgets/bars/image_app_bar.dart';

class FullScreenImageScreen extends StatefulWidget {
  final List<String> imageUrls;
  final int initialIndex;

  const FullScreenImageScreen({super.key, required this.imageUrls, this.initialIndex = 0});

  @override
  FullScreenImageScreenState createState() => FullScreenImageScreenState();
}

class FullScreenImageScreenState extends State<FullScreenImageScreen> with SingleTickerProviderStateMixin {
  double _initialYOffset = 0.0;
  double _currentYOffset = 0.0;
  late AnimationController _controller;
  late Animation<double> _animation;
  late TransformationController _transformationController;
  TapDownDetails _doubleTapDetails = TapDownDetails();
  bool _isAppBarVisible = true;
  bool _zoomedIn = false;
  late int _activeIndex;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
    _animation = Tween<double>(begin: 0, end: 0).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut))
      ..addListener(() {
        setState(() {
          _currentYOffset = _animation.value;
        });
      });
    _transformationController = TransformationController();
    _activeIndex = widget.initialIndex;
  }

  @override
  void dispose() {
    _controller.dispose();
    _transformationController.dispose();
    super.dispose();
  }

  void _handleVerticalDragEnd() {
    if (_currentYOffset > 100 || _currentYOffset < -100) {
      _animation = Tween<double>(begin: _currentYOffset, end: _currentYOffset > 0 ? MediaQuery.of(context).size.height : -MediaQuery.of(context).size.height).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut))
        ..addStatusListener((status) {
          if (status == AnimationStatus.completed) {
            Navigator.of(context).pop();
          }
        });
      _controller.forward(from: 0);
    } else {
      _animation = Tween<double>(begin: _currentYOffset, end: 0).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
      _controller.forward(from: 0);
    }
  }

  void _handleDoubleTap(TapDownDetails details) {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final localPosition = renderBox.globalToLocal(details.globalPosition);
    final scale = _zoomedIn ? 1.0 : 2.0;

    _transformationController.value = Matrix4.identity()
      ..translate(-localPosition.dx * (scale - 1), -localPosition.dy * (scale - 1))
      ..scale(scale);

    setState(() {
      _zoomedIn = !_zoomedIn;
      _isAppBarVisible = !_zoomedIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ChatifyColors.black,
      appBar: _isAppBarVisible ? const FullScreenAppBar() : null,
      body: GestureDetector(
        onVerticalDragStart: (details) {
          _initialYOffset = details.globalPosition.dy;
          _controller.stop();
        },
        onVerticalDragUpdate: (details) {
          setState(() {
            _currentYOffset = details.globalPosition.dy - _initialYOffset;
          });
        },
        onVerticalDragEnd: (details) {
          _handleVerticalDragEnd();
        },
        onDoubleTapDown: (details) => _doubleTapDetails = details,
        onDoubleTap: () => _handleDoubleTap(_doubleTapDetails),
        child: Stack(
          children: [
            Transform.translate(
              offset: Offset(0, _currentYOffset),
              child: Center(
                child: InteractiveViewer(
                  panEnabled: true,
                  scaleEnabled: true,
                  minScale: 1.0,
                  maxScale: 4.0,
                  transformationController: _transformationController,
                  child: CachedNetworkImage(
                    imageUrl: widget.imageUrls[_activeIndex],
                    placeholder: (context, url) => Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(colorsController.getColor(colorsController.selectedColorScheme.value)))),
                    errorWidget: (context, url, error) => const Center(child: Icon(Icons.error)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
