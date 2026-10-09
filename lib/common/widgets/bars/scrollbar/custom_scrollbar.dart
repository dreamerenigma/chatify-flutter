import 'dart:async';
import 'package:flutter/material.dart';
import '../../../../core/enums/custom_scrollbar_direction.dart';
import '../../../../utils/constants/app_colors.dart';

class CustomScrollbar extends StatefulWidget {
  final ScrollController scrollController;
  final Widget child;
  final bool isInsidePersonalizedOption;
  final ValueChanged<bool> onHoverChange;
  final bool bottomPadding;
  final CustomScrollbarDirectionType direction;

  const CustomScrollbar({
    super.key,
    required this.child,
    required this.scrollController,
    required this.isInsidePersonalizedOption,
    required this.onHoverChange,
    this.bottomPadding = true,
    this.direction = CustomScrollbarDirectionType.vertical,
  });

  @override
  State<CustomScrollbar> createState() => _CustomScrollbarState();
}

class _CustomScrollbarState extends State<CustomScrollbar> {
  bool _isHovered = false;
  bool _isDragging = false;
  bool _canScroll = false;
  Timer? _scrollTimer;

  bool get _isVertical => widget.direction == CustomScrollbarDirectionType.vertical;

  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(_updateCanScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateCanScroll();
    });
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
    if (oldWidget.scrollController != widget.scrollController) {
      oldWidget.scrollController.removeListener(_updateCanScroll);
      widget.scrollController.addListener(_updateCanScroll);
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateCanScroll();
    });
  }

  void _updateCanScroll() {
    if (!widget.scrollController.hasClients) return;

    final canScrollNow = widget.scrollController.hasClients && widget.scrollController.position.maxScrollExtent > 0;

    if (canScrollNow != _canScroll && mounted) {
      setState(() {
        _canScroll = canScrollNow;
      });
    }
  }

  void _scrollPrevious() {
    final position = widget.scrollController.position;

    widget.scrollController.animateTo(
      (widget.scrollController.offset - 50).clamp(0.0, position.maxScrollExtent),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _scrollNext() {
    final position = widget.scrollController.position;

    widget.scrollController.animateTo(
      (widget.scrollController.offset + 50).clamp(0.0, position.maxScrollExtent),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _startAutoScroll(bool up) {
    stopAutoScroll();
    _scrollTimer = Timer.periodic(
      const Duration(milliseconds: 30),
      (_) {
        if (!widget.scrollController.hasClients) {
          stopAutoScroll();
          return;
        }

        final position = widget.scrollController.position;
        final delta = up ? 20.0 : -20.0;
        final newOffset = (widget.scrollController.offset + delta).clamp(0.0, position.maxScrollExtent);

        widget.scrollController.jumpTo(newOffset);
      },
    );
  }

  void stopAutoScroll() {
    _scrollTimer?.cancel();
    _scrollTimer = null;
  }

  Widget _buildPreviousArrow() {
    return _buildArrow(
      icon: _isVertical ? Icons.arrow_drop_up_rounded : Icons.arrow_left_rounded,
      onTap: _scrollPrevious,
      onTapDown: (_) => _startAutoScroll(false),
    );
  }

  Widget _buildNextArrow() {
    return _buildArrow(
      icon: _isVertical ? Icons.arrow_drop_down_rounded : Icons.arrow_right_rounded,
      onTap: _scrollNext,
      onTapDown: (_) => _startAutoScroll(true),
    );
  }

  Widget _buildArrow({required IconData icon, required VoidCallback onTap,required void Function(TapDownDetails) onTapDown}) {
    return AnimatedOpacity(
      opacity: _isHovered ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 200),
      child: GestureDetector(
        onTap: onTap,
        onTapDown: onTapDown,
        onTapUp: (_) => stopAutoScroll(),
        onTapCancel: stopAutoScroll,
        onLongPressStart: (_) => onTap(),
        onLongPressEnd: (_) => stopAutoScroll(),
        child: Icon(icon, color: ChatifyColors.darkGrey, size: 28),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double arrowZone = _isHovered && _canScroll ? 12 : 0;

    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _updateCanScroll();
        });

        return false;
      },
      child: Listener(
        onPointerDown: (_) {
          _isDragging = true;
        },
        onPointerUp: (_) {
          _isDragging = false;

          if (!_isHovered && !widget.isInsidePersonalizedOption) {
            Future.delayed(const Duration(milliseconds: 300), () {
              if (!_isHovered && !_isDragging && mounted) {
                setState(() {
                  _isHovered = false;
                });

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
            clipBehavior: Clip.none,
            children: [
              Padding(
                padding: _isVertical
                  ? EdgeInsets.only(top: arrowZone, bottom: (widget.bottomPadding ? 14 : 0), right: 2)
                  : EdgeInsets.only(left: 0, right: 0, bottom: widget.bottomPadding ? 2 : 0),
                child: ScrollbarTheme(
                  data: ScrollbarThemeData(thumbColor: WidgetStateProperty.all(ChatifyColors.darkerGrey)),
                  child: Scrollbar(
                    controller: widget.scrollController,
                    thickness: _isHovered ? 6 : 4,
                    thumbVisibility: false,
                    radius: const Radius.circular(12),
                    scrollbarOrientation: _isVertical ? ScrollbarOrientation.right : ScrollbarOrientation.bottom,
                    child: widget.child,
                  ),
                ),
              ),
              if (_canScroll && _isHovered)
                if (_isVertical)
                  Positioned(top: -8, right: -7, child: _buildPreviousArrow())
                else
                  Positioned(left: -8, bottom: -7, child: _buildPreviousArrow()),
              if (_canScroll && _isHovered)
                if (_isVertical)
                  Positioned(bottom: -8, right: -7, child: _buildNextArrow())
                else
                  Positioned(right: -8, bottom: -7, child: _buildNextArrow()),
            ],
          ),
        ),
      ),
    );
  }
}
