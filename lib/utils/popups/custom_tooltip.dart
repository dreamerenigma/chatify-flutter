import 'dart:async';
import 'dart:ui';
import 'package:chatify/utils/constants/app_sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/enums/tooltip_position_type.dart';
import '../constants/app_colors.dart';

class CustomTooltip extends StatefulWidget {
  final String message;
  final Widget child;
  final double verticalOffset;
  final double horizontalOffset;
  final bool disableOnTap;
  final bool disableTooltipOnLongPress;
  final bool showOnTap;
  final TooltipPositionType position;

  const CustomTooltip({
    super.key,
    required this.message,
    required this.child,
    this.verticalOffset = -75,
    this.horizontalOffset = 0,
    this.disableOnTap = false,
    this.disableTooltipOnLongPress = false,
    this.showOnTap = false,
    this.position = TooltipPositionType.mouse,
  });

  @override
  State<CustomTooltip> createState() => _CustomTooltipState();
}

class _CustomTooltipState extends State<CustomTooltip> with TickerProviderStateMixin {
  final GlobalKey _key = GlobalKey();
  late final AnimationController _animationController;
  late final Animation<double> _fadeAnimation;
  Timer? _showTimer;
  Timer? _hideTimer;
  bool _isHovered = false;
  bool _showTooltip = false;
  bool _isDisposed = false;
  OverlayEntry? _overlayEntry;
  Offset _hoverPosition = Offset.zero;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
    _fadeAnimation = CurvedAnimation(parent: _animationController, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _isDisposed = true;
    _showTimer?.cancel();
    _hideTimer?.cancel();
    _removeTooltipImmediately();
    _animationController.dispose();
    super.dispose();
  }

  void _scheduleShow() {
    _showTimer?.cancel();
    _hideTimer?.cancel();

    _showTimer = Timer(
      const Duration(milliseconds: 800),
          () {
        if (!mounted ||
            _isDisposed ||
            !_isHovered ||
            widget.disableOnTap ||
            _isHolding) {
          return;
        }

        _showTooltip = true;
        _insertTooltip();
      },
    );
  }

  void _scheduleHide() {
    _showTimer?.cancel();
    _hideTimer?.cancel();

    _hideTimer = Timer(
      const Duration(milliseconds: 800),
          () {
        if (!mounted || _isDisposed) return;

        if (!_isHovered) {
          _showTooltip = false;
          _removeTooltip();
        }
      },
    );
  }

  void _insertTooltip() {
    if (!mounted || _isDisposed) return;

    if (!_showTooltip || _isHolding) return;

    if (_overlayEntry?.mounted ?? false) {
      return;
    }

    final renderObject = _key.currentContext?.findRenderObject();

    if (renderObject is! RenderBox) {
      return;
    }

    final position = renderObject.localToGlobal(Offset.zero);

    _overlayEntry = _createOverlayEntry(position);

    Overlay.of(context).insert(_overlayEntry!);

    _animationController.forward(from: 0);
  }

  void _removeTooltip() {
    if (_isDisposed) return;

    final entry = _overlayEntry;

    if (entry == null) return;

    _overlayEntry = null;

    _animationController.reverse().whenCompleteOrCancel(() {
      if (entry.mounted) {
        entry.remove();
      }
    });
  }

  void _removeTooltipImmediately() {
    final entry = _overlayEntry;

    _overlayEntry = null;

    if (entry != null && entry.mounted) {
      entry.remove();
    }
  }

  Future<void> _showTooltipOnTap() async {
    if (_isDisposed || !mounted) return;

    _showTimer?.cancel();
    _hideTimer?.cancel();
    _removeTooltipImmediately();
    _showTooltip = true;
    _insertTooltip();

    await Future.delayed(const Duration(seconds: 2));

    if (!mounted || _isDisposed) return;

    _showTooltip = false;

    _removeTooltip();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onHover: (event) {
        _hoverPosition = event.localPosition;
      },
      onEnter: (_) {
        _isHovered = true;
        _scheduleShow();
      },
      onExit: (_) {
        _isHovered = false;
        _scheduleHide();
      },
      child: GestureDetector(onTap: widget.showOnTap && !widget.disableOnTap ? _showTooltipOnTap : null, child: RepaintBoundary(key: _key, child: widget.child)),
    );
  }

  OverlayEntry _createOverlayEntry(Offset position) {
    final renderBox = _key.currentContext!.findRenderObject() as RenderBox;
    final childSize = renderBox.size;
    double left;
    double top;

    switch (widget.position) {
      case TooltipPositionType.mouse:
        left = position.dx + _hoverPosition.dx + widget.horizontalOffset;
        top = position.dy + widget.verticalOffset;
        break;
      case TooltipPositionType.top:
        left = position.dx + (childSize.width / 2) + widget.horizontalOffset;
        top = position.dy + widget.verticalOffset;
        break;
      case TooltipPositionType.bottom:
        left = position.dx + (childSize.width / 2) + widget.horizontalOffset;
        top = position.dy + childSize.height + widget.verticalOffset;
        break;
    }

    return OverlayEntry(
      builder: (context) {
        return Positioned(
          left: left,
          top: top,
          child: MouseRegion(
            onEnter: (_) {
              _isHovered = true;
              _showTimer?.cancel();
              _hideTimer?.cancel();
            },
            onExit: (_) {
              _isHovered = false;
              _scheduleHide();
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
                      constraints: const BoxConstraints(maxWidth: 320),
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                      decoration: BoxDecoration(
                        color: context.isDarkMode ? ChatifyColors.youngNight.withAlpha((0.5 * 255).toInt(),) : ChatifyColors.white.withAlpha((0.5 * 255).toInt()),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: context.isDarkMode ? ChatifyColors.mildNight.withAlpha((0.7 * 255).toInt(),) : ChatifyColors.buttonGrey),
                        boxShadow: [BoxShadow(color: ChatifyColors.black.withAlpha((0.2 * 255).toInt(),), spreadRadius: 1, blurRadius: 8, offset: const Offset(0, 4))],
                      ),
                      child: Text(
                        widget.message,
                        softWrap: true,
                        overflow: TextOverflow.visible,
                        style: TextStyle(color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black, fontSize: ChatifySizes.fontSizeLm, fontWeight: FontWeight.w300),
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

  bool get _isHolding => false;
}
