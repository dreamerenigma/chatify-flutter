import 'package:chatify/features/utils/widgets/scrolls/no_glow_scroll_behavior.dart';
import 'package:chatify/utils/constants/app_colors.dart';
import 'package:chatify/utils/constants/app_sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../dialogs/light_dialog.dart';

class BirthdayDropdownField<T> extends StatefulWidget {
  final T? value;
  final String label;
  final List<T> items;
  final String Function(T item) itemBuilder;
  final String Function(T item) valueBuilder;
  final ValueChanged<T> onChanged;
  final String placeholder;

  const BirthdayDropdownField({
    super.key,
    required this.label,
    required this.items,
    required this.itemBuilder,
    required this.valueBuilder,
    required this.onChanged,
    this.value,
    this.placeholder = '————',
  });

  @override
  State<BirthdayDropdownField<T>> createState() => _BirthdayDropdownFieldState<T>();
}

class _BirthdayDropdownFieldState<T> extends State<BirthdayDropdownField<T>> {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  bool _isExpanded = false;

  double get _fieldWidth {
    final renderBox = context.findRenderObject() as RenderBox;

    return renderBox.size.width;
  }

  @override
  void dispose() {
    _removeOverlay();
    super.dispose();
  }

  void _toggleDropdown() {
    if (_isExpanded) {
      _removeOverlay();
    } else {
      _showOverlay();
    }
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;

    if (mounted && _isExpanded) {
      setState(() {
        _isExpanded = false;
      });
    }
  }

  void _showOverlay() {
    final overlay = Overlay.of(context);

    _overlayEntry = OverlayEntry(
      builder: (context) {
        return Positioned.fill(
          child: Stack(
            children: [
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: _removeOverlay,
                child: const SizedBox.expand(),
              ),
              CompositedTransformFollower(
                link: _layerLink,
                showWhenUnlinked: false,
                targetAnchor: Alignment.bottomLeft,
                followerAnchor: Alignment.topLeft,
                offset: const Offset(0, 4),
                child: Material(
                  color: ChatifyColors.transparent,
                  child: Container(
                    width: _fieldWidth,
                    constraints: const BoxConstraints(maxHeight: 290),
                    decoration: BoxDecoration(
                      color: context.isDarkMode ? ChatifyColors.deepNight : ChatifyColors.softGrey,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: context.isDarkMode ? ChatifyColors.youngNight : ChatifyColors.darkGrey),
                      boxShadow: [BoxShadow(blurRadius: 12, offset: const Offset(0, 4), color: ChatifyColors.black.withAlpha(20))],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: ScrollConfiguration(
                        behavior: NoGlowScrollBehavior(),
                        child: ListView.builder(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          itemCount: widget.items.length,
                          itemBuilder: (context, index) {
                            final item = widget.items[index];
                            final isSelected = item == widget.value;

                            return Material(
                              color: ChatifyColors.transparent,
                              child: InkWell(
                                splashFactory: NoSplash.splashFactory,
                                mouseCursor: SystemMouseCursors.basic,
                                splashColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
                                highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
                                hoverColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
                                onTap: () {
                                  widget.onChanged(item);
                                  _removeOverlay();
                                },
                                child: Container(
                                  height: 48,
                                  padding: const EdgeInsets.symmetric(horizontal: 16),
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    widget.itemBuilder(item),
                                    style: TextStyle(color: isSelected ? colorsController.getColor(colorsController.selectedColorScheme.value) : null, fontSize: 15, fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );

    overlay.insert(_overlayEntry!);

    setState(() {
      _isExpanded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final hasValue = widget.value != null;

    return CompositedTransformTarget(
      link: _layerLink,
      child: GestureDetector(
        onTap: _toggleDropdown,
        child: AbsorbPointer(
          child: SizedBox(
            height: 60,
            child: TextFormField(
              readOnly: true,
              controller: TextEditingController(text: hasValue ? widget.valueBuilder(widget.value as T) : widget.placeholder),
              style: TextStyle(fontSize: hasValue ? ChatifySizes.fontSizeMd : ChatifySizes.fontSizeLm, fontWeight: FontWeight.w400),
              decoration: InputDecoration(
                labelText: widget.label,
                labelStyle: TextStyle(fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w400),
                floatingLabelStyle: TextStyle(color: colorsController.getColor(colorsController.selectedColorScheme.value), fontSize: 15, fontWeight: FontWeight.w400),
                suffixIcon: Icon(Icons.arrow_drop_down, size: 23, color: ChatifyColors.darkGrey),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: colorsController.getColor(colorsController.selectedColorScheme.value), width: 1)),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: colorsController.getColor(colorsController.selectedColorScheme.value), width: 1)),
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 20),
                constraints: const BoxConstraints(minHeight: 60, maxHeight: 60),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
