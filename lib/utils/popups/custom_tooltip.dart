import 'dart:ui';
import 'package:chatify/utils/constants/app_sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../constants/app_colors.dart';

class CustomTooltip extends StatefulWidget {
  final String message;
  final Widget child;
  final double verticalOffset;
  final double horizontalOffset;
  final bool disableOnTap;
  final bool disableTooltipOnLongPress;

  const CustomTooltip({
    super.key,
    required this.message,
    required this.child,
    this.verticalOffset = -75,
    this.horizontalOffset = 0,
    this.disableOnTap = false,
    this.disableTooltipOnLongPress = false,
  });

  @override
  State<CustomTooltip> createState() => _CustomTooltipState();
}

class _CustomTooltipState extends State<CustomTooltip> with TickerProviderStateMixin {
  final GlobalKey _key = GlobalKey();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  OverlayEntry? _overlayEntry;
  Offset _hoverPosition = Offset.zero;
  bool _isHovered = false;
  bool _showTooltip = false;
  final bool _isHolding = false;
  bool _isDisposed = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    _fadeAnimation = CurvedAnimation(parent: _animationController, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _isDisposed = true;
    _animationController.dispose();
    _overlayEntry?.remove();
    super.dispose();
  }

  void _insertTooltip() {
    if (_showTooltip && !_isHolding && mounted && !_isDisposed) {
      final RenderBox renderBox = _key.currentContext!.findRenderObject() as RenderBox;
      final position = renderBox.localToGlobal(Offset.zero);

      _overlayEntry = _createOverlayEntry(position);
      Overlay.of(context).insert(_overlayEntry!);
      _animationController.forward(from: 0);
    }
  }

  void _removeTooltip() {
    if (_isDisposed || !mounted) return;
    if (_overlayEntry!.mounted) {
      _animationController.reverse().then((_) {
        if (_overlayEntry!.mounted) {
          _overlayEntry!.remove();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onHover: (event) {
        setState(() {
          _hoverPosition = event.localPosition;
        });
      },
      onEnter: (_) {
        setState(() {
          _isHovered = true;
        });
        Future.delayed(Duration(milliseconds: 800), () {
          if (_isHovered && !_isHolding && !widget.disableOnTap) {
            _showTooltip = true;
            _insertTooltip();
          }
        });
      },
      onExit: (_) {
        setState(() {
          _isHovered = false;
        });
        Future.delayed(Duration(milliseconds: 800), () {
          if (!_isHovered && _showTooltip) {
            _showTooltip = false;
            _removeTooltip();
          }
        });
      },
      child: RepaintBoundary(key: _key, child: widget.child),
    );
  }

  OverlayEntry _createOverlayEntry(Offset position) {
    return OverlayEntry(
      builder: (context) {
        return Positioned(
          left: position.dx + _hoverPosition.dx + widget.horizontalOffset,
          top: position.dy + widget.verticalOffset,
          child: MouseRegion(
            onEnter: (_) {
              _isHovered = true;
            },
            onExit: (_) {
              _isHovered = false;
              Future.delayed(Duration(milliseconds: 800), () {
                if (!_isHovered && _showTooltip) {
                  _showTooltip = false;
                  _removeTooltip();
                }
              });
            },
            child: Material(
              color: ChatifyColors.transparent,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      constraints: BoxConstraints(maxWidth: 320),
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                      decoration: BoxDecoration(
                        color: context.isDarkMode ? ChatifyColors.youngNight.withAlpha((0.5 * 255).toInt()) : ChatifyColors.white.withAlpha((0.5 * 255).toInt()),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: context.isDarkMode ? ChatifyColors.mildNight.withAlpha((0.7 * 255).toInt()) : ChatifyColors.buttonGrey, width: 1),
                        boxShadow: [
                          BoxShadow(
                            color: ChatifyColors.black.withAlpha((0.2 * 255).toInt()),
                            spreadRadius: 1,
                            blurRadius: 8,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Text(
                        widget.message,
                        softWrap: true,
                        overflow: TextOverflow.visible,
                        style: TextStyle(
                          color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black,
                          fontSize: ChatifySizes.fontSizeLm,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
