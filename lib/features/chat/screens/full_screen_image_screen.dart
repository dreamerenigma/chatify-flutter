import 'package:chatify/utils/constants/app_sizes.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../api/apis.dart';
import '../../../utils/constants/app_colors.dart';
import '../../../utils/constants/app_vectors.dart';
import '../../personalization/widgets/dialogs/light_dialog.dart';
import '../models/message_model.dart';
import '../widgets/bars/image_app_bar.dart';

class FullScreenImageScreen extends StatefulWidget {
  final MessageModel message;
  final List<String> imageUrls;
  final int initialIndex;

  const FullScreenImageScreen({
    super.key,
    required this.message,
    required this.imageUrls,
    this.initialIndex = 0,
  });

  @override
  FullScreenImageScreenState createState() => FullScreenImageScreenState();
}

class FullScreenImageScreenState extends State<FullScreenImageScreen> with SingleTickerProviderStateMixin {
  late int _activeIndex;
  late AnimationController _controller;
  late Animation<double> _animation;
  late TransformationController _transformationController;
  bool _isAppBarVisible = true;
  bool _zoomedIn = false;
  double _initialYOffset = 0.0;
  double _currentYOffset = 0.0;
  int _pointerCount = 0;
  bool _isPinching = false;
  TapDownDetails _doubleTapDetails = TapDownDetails();

  bool get _canSwipeToDismiss {
    return !_isZoomed && !_isPinching;
  }

  double get _currentScale {
    return _transformationController.value.getMaxScaleOnAxis();
  }

  bool get _isZoomed {
    return _currentScale > 1.01;
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
    _animation = Tween<double>(begin: 0, end: 0).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut))..addListener(() {
      setState(() {
        _currentYOffset = _animation.value;
      });
    });
    _transformationController = TransformationController();
    _transformationController.addListener(_onTransformationChanged);
    _activeIndex = widget.initialIndex;
  }

  @override
  void dispose() {
    _controller.dispose();
    _transformationController.dispose();
    _transformationController.removeListener(_onTransformationChanged);
    super.dispose();
  }

  void _handleVerticalDragEnd() {
    if (!_canSwipeToDismiss) {
      _currentYOffset = 0;
      return;
    }

    if (_currentYOffset.abs() > 100) {
      _animation = Tween<double>(begin: _currentYOffset, end: _currentYOffset > 0 ? MediaQuery.of(context).size.height : -MediaQuery.of(context).size.height).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut))..addStatusListener((status) {
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

    if (_isZoomed) {
      _transformationController.value = Matrix4.identity();

      return;
    }

    const scale = 2.0;

    final dx = -localPosition.dx * (scale - 1);
    final dy = -localPosition.dy * (scale - 1);

    _transformationController.value = Matrix4.translationValues(dx, dy, 0) * Matrix4.diagonal3Values(scale, scale, 1);
  }

  void _onTransformationChanged() {
    final zoomed = _currentScale > 1.01;

    if (zoomed != _zoomedIn && mounted) {
      setState(() {
        _zoomedIn = zoomed;
        _isAppBarVisible = !zoomed;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ChatifyColors.black,
      appBar: _isAppBarVisible ? FullScreenAppBar(user: APIs.me, message: widget.message) : null,
      body: Listener(
        onPointerDown: (_) {
          _pointerCount++;

          if (_pointerCount >= 2) {
            _isPinching = true;

            _controller.stop();

            if (_currentYOffset != 0) {
              setState(() {
                _currentYOffset = 0;
              });
            }
          }
        },
        onPointerUp: (_) {
          _pointerCount--;

          if (_pointerCount <= 0) {
            _pointerCount = 0;
            _isPinching = false;
          }
        },
        onPointerCancel: (_) {
          _pointerCount--;

          if (_pointerCount <= 0) {
            _pointerCount = 0;
            _isPinching = false;
          }
        },
        child: GestureDetector(
          onVerticalDragStart: (details) {
            if (_isPinching || !_canSwipeToDismiss) return;

            _initialYOffset = details.globalPosition.dy;
            _controller.stop();
          },
          onVerticalDragUpdate: (details) {
            if (_isPinching || !_canSwipeToDismiss) return;

            setState(() {
              _currentYOffset = details.globalPosition.dy - _initialYOffset;
            });
          },
          onVerticalDragEnd: (details) {
            if (_isPinching || !_canSwipeToDismiss) return;

            _handleVerticalDragEnd();
          },
          onDoubleTapDown: (details) {
            _doubleTapDetails = details;
          },
          onDoubleTap: () {
            _handleDoubleTap(_doubleTapDetails);
          },
          child: SafeArea(
            child: Stack(
              fit: StackFit.expand,
              children: [
                Transform.translate(
                  offset: Offset(0, _currentYOffset),
                  child: InteractiveViewer(
                    panEnabled: true,
                    scaleEnabled: true,
                    minScale: 1.0,
                    maxScale: 4.0,
                    transformationController: _transformationController,
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      child: CachedNetworkImage(
                        imageUrl: widget.imageUrls[_activeIndex],
                        fit: BoxFit.contain,
                        placeholder: (context, url) => Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(colorsController.getColor(colorsController.selectedColorScheme.value)))),
                        errorWidget: (context, url, error) => const Center(child: Icon(Icons.error)),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  height: 60,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(color: ChatifyColors.darkBackground),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 50,
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(color: ChatifyColors.blackGrey, borderRadius: BorderRadius.circular(35)),
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextSelectionTheme(
                                    data: TextSelectionThemeData(
                                      cursorColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                                      selectionColor: colorsController.getColor(colorsController.selectedColorScheme.value).withAlpha((0.3 * 255).toInt()),
                                      selectionHandleColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                                    ),
                                    child: TextField(
                                      style: TextStyle(color: ChatifyColors.white, fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400),
                                      decoration: InputDecoration(
                                        isDense: true,
                                        hintText: 'Ответить',
                                        hintStyle: TextStyle(color: ChatifyColors.darkGrey, fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400),
                                        border: InputBorder.none,
                                        enabledBorder: InputBorder.none,
                                        focusedBorder: InputBorder.none,
                                        disabledBorder: InputBorder.none,
                                        errorBorder: InputBorder.none,
                                        focusedErrorBorder: InputBorder.none,
                                        contentPadding: EdgeInsets.only(left: 12, right: 6)
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                SvgPicture.asset(ChatifyVectors.heartEmoji, width: 25, height: 25),
                                const SizedBox(width: 12),
                                SvgPicture.asset(ChatifyVectors.laughingEmoji, width: 28, height: 28),
                                const SizedBox(width: 12),
                                SvgPicture.asset(ChatifyVectors.emojiAdd, width: 27, height: 27, colorFilter: ColorFilter.mode(context.isDarkMode ? ChatifyColors.borderSecondary : ChatifyColors.black, BlendMode.srcIn)),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
