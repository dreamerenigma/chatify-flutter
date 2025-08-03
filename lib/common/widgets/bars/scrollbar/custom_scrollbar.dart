import 'dart:async';
import 'package:flutter/material.dart';
import '../../../../utils/constants/app_colors.dart';

class CustomScrollbar extends StatefulWidget {
  final ScrollController scrollController;
  final Widget child;
  final bool isInsidePersonalizedOption;
  final ValueChanged<bool> onHoverChange;
  final bool bottomPadding;

  const CustomScrollbar({
    super.key,
    required this.child,
    required this.scrollController,
    required this.isInsidePersonalizedOption,
    required this.onHoverChange,
    this.bottomPadding = true,
  });

  @override
  State<CustomScrollbar> createState() => _CustomScrollbarState();
}

class _CustomScrollbarState extends State<CustomScrollbar> {
  bool _isHovered = false;
  bool _isDragging = false;
  bool _canScroll = false;
  Timer? _scrollTimer;

  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(_updateCanScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) => _updateCanScroll());
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_updateCanScroll);
    _scrollTimer?.cancel();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant CustomScrollbar oldWidget) {
    super.didUpdateWidget(oldWidget);
    WidgetsBinding.instance.addPostFrameCallback((_) => _updateCanScroll());
  }

  void _updateCanScroll() {
    final canScrollNow = widget.scrollController.hasClients && widget.scrollController.position.maxScrollExtent > 0;
    if (canScrollNow != _canScroll) {
      setState(() {
        _canScroll = canScrollNow;
      });
    }
  }

  void startAutoScroll(bool up) {
    stopAutoScroll();
    _scrollTimer = Timer.periodic(Duration(milliseconds: 30), (_) {
      widget.scrollController.jumpTo(
        (widget.scrollController.offset + (up ? -20 : 20)).clamp(
          0.0,
          widget.scrollController.position.maxScrollExtent,
        ),
      );
    });
  }

  void stopAutoScroll() {
    _scrollTimer?.cancel();
    _scrollTimer = null;
  }

  void _scrollUp() {
    widget.scrollController.animateTo(
      (widget.scrollController.offset - 50).clamp(0.0, widget.scrollController.position.maxScrollExtent),
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _scrollDown() {
    widget.scrollController.animateTo(
      (widget.scrollController.offset + 50).clamp(0.0, widget.scrollController.position.maxScrollExtent),
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        WidgetsBinding.instance.addPostFrameCallback((_) => _updateCanScroll());
        return false;
      },
      child: Listener(
        onPointerDown: (_) {
          _isDragging = true;
        },
        onPointerUp: (_) {
          _isDragging = false;
          if (!_isHovered && !widget.isInsidePersonalizedOption) {
            Future.delayed(Duration(milliseconds: 300), () {
              if (!_isHovered && !_isDragging) {
                setState(() => _isHovered = false);
                widget.onHoverChange(false);
              }
            });
          }
        },
        child: MouseRegion(
          onEnter: (_) {
            if (!widget.isInsidePersonalizedOption) {
              setState(() {
                _isHovered = true;
              });
              widget.onHoverChange(true);
            }
          },
          onExit: (_) {
            if (!widget.isInsidePersonalizedOption) {
              if (_isDragging) return;
              setState(() {
                _isHovered = false;
              });
              widget.onHoverChange(false);
            }
          },
          child: Stack(
            children: [
              if (_canScroll && _isHovered)
              Positioned(
                top: -5,
                right: -7,
                child: AnimatedOpacity(
                  opacity: _isHovered ? 1.0 : 0.0,
                  duration: Duration(milliseconds: 200),
                  child: GestureDetector(
                    onTap: _scrollUp,
                    onTapDown: (_) => startAutoScroll(true),
                    onTapUp: (_) => stopAutoScroll(),
                    onTapCancel: stopAutoScroll,
                    onLongPressStart: (_) => startAutoScroll(true),
                    onLongPressEnd: (_) => stopAutoScroll(),
                    child: Icon(Icons.arrow_drop_up_rounded, color: ChatifyColors.darkGrey, size: 28),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 16, bottom: widget.bottomPadding ? 16 : 0, right: 2),
                child: ScrollbarTheme(
                  data: ScrollbarThemeData(thumbColor: WidgetStateProperty.all(ChatifyColors.darkerGrey)),
                  child: Scrollbar(
                    controller: widget.scrollController,
                    thickness: _isHovered ? 6 : 4,
                    thumbVisibility: false,
                    radius: Radius.circular(12),
                    child: widget.child,
                  ),
                ),
              ),
              if (_canScroll && _isHovered)
              Positioned(
                bottom: -5,
                right: -7,
                child: AnimatedOpacity(
                  opacity: _isHovered ? 1.0 : 0.0,
                  duration: Duration(milliseconds: 200),
                  child: GestureDetector(
                    onTap: _scrollDown,
                    onTapDown: (_) => startAutoScroll(false),
                    onTapUp: (_) => stopAutoScroll(),
                    onTapCancel: stopAutoScroll,
                    onLongPressStart: (_) => startAutoScroll(false),
                    onLongPressEnd: (_) => stopAutoScroll(),
                    child: Icon(Icons.arrow_drop_down_rounded, color: ChatifyColors.darkGrey, size: 28),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
