import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../generated/l10n/l10n.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../personalization/widgets/dialogs/light_dialog.dart';
import '../bars/full_screen_image_app_bar.dart';

class FullScreenImageWidget extends StatefulWidget {
  final List<String> imageUrls;
  final int initialIndex;

  const FullScreenImageWidget({super.key, required this.imageUrls, this.initialIndex = 0});

  factory FullScreenImageWidget.singleImage(String imageUrl, {int initialIndex = 0}) {
    return FullScreenImageWidget(imageUrls: [imageUrl], initialIndex: initialIndex);
  }

  @override
  State<FullScreenImageWidget> createState() => _FullScreenImageWidgetState();
}

class _FullScreenImageWidgetState extends State<FullScreenImageWidget> {
  final PageController _pageController = PageController();
  bool _isLeftPressed = false;
  bool _isRightPressed = false;
  late int _activeIndex;
  double _currentScale = 1.0;

  @override
  void initState() {
    super.initState();
    _activeIndex = (widget.imageUrls.isNotEmpty) ? widget.initialIndex.clamp(0, widget.imageUrls.length - 1) : 0;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_pageController.hasClients) {
        _pageController.jumpToPage(_activeIndex);
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _changeIndex(int delta) {
    final newIndex = (_activeIndex + delta).clamp(0, widget.imageUrls.length - 1);
    setState(() {
      _activeIndex = newIndex;
    });

    _pageController.animateToPage(
      _activeIndex,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.isDarkMode ? ChatifyColors.deepNight : ChatifyColors.lightGrey,
      appBar: const FullScreenImageAppBar(),
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 10),
                  child: Center(
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: widget.imageUrls.length,
                      onPageChanged: (index) {
                        setState(() {
                          _activeIndex = index;
                        });
                      },
                      itemBuilder: (context, index) {
                        return Center(
                          child: InteractiveViewer(
                            panEnabled: true,
                            scaleEnabled: true,
                            minScale: 1.0,
                            maxScale: 4.0,
                            onInteractionUpdate: (details) {
                              setState(() {
                                _currentScale = details.scale;
                              });
                            },
                            child: MouseRegion(
                              onEnter: (_) {
                                if (_currentScale > 1.0) {
                                  SystemMouseCursors.zoomIn;
                                }
                              },
                              onExit: (_) {
                                SystemMouseCursors.basic;
                              },
                              child: CachedNetworkImage(
                                imageUrl: widget.imageUrls.isNotEmpty && _activeIndex >= 0 && _activeIndex < widget.imageUrls.length ? widget.imageUrls[_activeIndex] : '',
                                placeholder: (context, url) => Center(
                                  child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(colorsController.getColor(colorsController.selectedColorScheme.value))),
                                ),
                                errorWidget: (context, url, error) {
                                  return const Center(child: Icon(Icons.error));
                                },
                              ),
                            ),
                          ),
                        );
                      }
                    ),
                  ),
                ),
                Positioned(
                  left: 16,
                  top: 0,
                  bottom: 0,
                  child: Center(
                    child: InkWell(
                      onTap: () {
                        setState(() => _isLeftPressed = true);
                        _changeIndex(-1);
                        Future.delayed(const Duration(milliseconds: 100), () {
                          setState(() => _isLeftPressed = false);
                        });
                      },
                      mouseCursor: SystemMouseCursors.basic,
                      splashColor: ChatifyColors.transparent,
                      highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey,
                      hoverColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey,
                      borderRadius: BorderRadius.circular(6),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 100),
                        child: Transform.translate(
                          offset: _isLeftPressed ? const Offset(-2, 0) : Offset.zero,
                          child: const Padding(
                            padding: EdgeInsets.all(13),
                            child: Icon(Icons.arrow_back_ios, color: ChatifyColors.white, size: 15),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  right: 16,
                  top: 0,
                  bottom: 0,
                  child: Center(
                    child: InkWell(
                      onTap: () {
                        setState(() => _isRightPressed = true);
                        _changeIndex(1);
                        Future.delayed(const Duration(milliseconds: 100), () {
                          setState(() => _isRightPressed = false);
                        });
                      },
                      mouseCursor: SystemMouseCursors.basic,
                      splashColor: ChatifyColors.transparent,
                      highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey,
                      hoverColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey,
                      borderRadius: BorderRadius.circular(6),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 100),
                        child: Transform.translate(
                          offset: _isRightPressed ? const Offset(2, 0) : Offset.zero,
                          child: const Padding(
                            padding: EdgeInsets.all(13),
                            child: Icon(Icons.arrow_forward_ios, color: ChatifyColors.white, size: 15),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          _buildBottomGrid(),
        ],
      ),
    );
  }

  Widget _buildBottomGrid() {
    if (widget.imageUrls.isEmpty) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Center(child: Text(S.of(context).noImagesAvailable)),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: SizedBox(
        height: 60,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: List.generate(widget.imageUrls.length, (index) {
              final isActive = index == _activeIndex;
              final isHovered = ValueNotifier(false);
              final scale = ValueNotifier<double>(1.0);

              return ValueListenableBuilder<bool>(
                valueListenable: isHovered,
                builder: (context, hovered, _) {
                  return ValueListenableBuilder<double>(
                    valueListenable: scale,
                    builder: (context, scaleValue, _) {
                      return GestureDetector(
                        onTapDown: (_) => scale.value = 0.98,
                        onTapUp: (_) => scale.value = 1.0,
                        onTapCancel: () => scale.value = 1.0,
                        onLongPressStart: (_) => scale.value = 0.98,
                        onLongPressEnd: (_) => scale.value = 1.0,
                        onTap: () {
                          setState(() {
                            _activeIndex = index;
                          });
                          _pageController.animateToPage(_activeIndex, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
                        },
                        child: MouseRegion(
                          onEnter: (_) {
                            if (!isActive) isHovered.value = true;
                          },
                          onExit: (_) {
                            if (!isActive) isHovered.value = false;
                          },
                          child: AnimatedScale(
                            scale: scaleValue,
                            duration: const Duration(milliseconds: 150),
                            curve: Curves.easeOutCubic,
                            child: Stack(
                              children: [
                                AnimatedContainer(
                                  width: 50,
                                  height: 50,
                                  duration: const Duration(milliseconds: 250),
                                  curve: Curves.easeOutCubic,
                                  margin: const EdgeInsets.symmetric(horizontal: 2),
                                  decoration: BoxDecoration(
                                    color: context.isDarkMode ? ChatifyColors.darkerGrey : ChatifyColors.grey,
                                    borderRadius: BorderRadius.circular(6),
                                    border: isActive ? Border.all(color: colorsController.getColor(colorsController.selectedColorScheme.value), width: 2.5) : null,
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(6),
                                    child: CachedNetworkImage(
                                      imageUrl: widget.imageUrls[index],
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) => Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(colorsController.getColor(colorsController.selectedColorScheme.value)), strokeWidth: 2)),
                                      errorWidget: (context, url, error) => const Icon(Icons.error, color: ChatifyColors.white),
                                    ),
                                  ),
                                ),
                                if (!isActive && hovered)
                                Positioned.fill(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 2),
                                    child: Container(
                                      decoration: BoxDecoration(color: ChatifyColors.black.withAlpha((0.4 * 255).toInt()), borderRadius: BorderRadius.circular(6)),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }
                  );
                },
              );
            }),
          ),
        ),
      ),
    );
  }
}
