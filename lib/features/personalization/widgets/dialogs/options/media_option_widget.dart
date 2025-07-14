import 'package:flutter/material.dart';
import '../../../../../common/widgets/bars/scrollbar/custom_scrollbar.dart';
import '../../../../../utils/constants/app_colors.dart';
import '../../../../../utils/constants/app_sizes.dart';
import '../../../../utils/widgets/no_glow_scroll_behavior.dart';

class MediaOptionWidget extends StatefulWidget {
  const MediaOptionWidget({super.key});

  @override
  State<MediaOptionWidget> createState() => _MediaOptionWidgetState();
}

class _MediaOptionWidgetState extends State<MediaOptionWidget> {
  final ScrollController _scrollController = ScrollController();
  final Map<int, bool> _hoveredStates = {};
  final List<String> media = [];
  bool isInside = false;

  void _updateHoveredState(int index, bool isHovered) {
    setState(() {
      _hoveredStates[index] = isHovered;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 8),
          child: Text('Медиа', style: TextStyle(fontSize: 21, fontWeight: FontWeight.w500)),
        ),
        Expanded(
          child: CustomScrollbar(
            scrollController: _scrollController,
            isInsidePersonalizedOption: isInside,
            onHoverChange: (bool isHovered) {
              setState(() {
                isInside = isHovered;
              });
            },
            child: ScrollConfiguration(
              behavior: NoGlowScrollBehavior(),
              child: SingleChildScrollView(
                controller: _scrollController,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: media.isEmpty
                  ? SizedBox(
                      height: MediaQuery.of(context).size.height * 0.45,
                      child: Center(
                        child: Text(
                          'Нет медиафайлов',
                          style: TextStyle(color: ChatifyColors.grey, fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w300),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                  : GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 1,
                    ),
                    itemCount: 30,
                    itemBuilder: (context, index) => _buildItem(index),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildItem(int index) {
    return StatefulBuilder(
      builder: (context, setState) {
        return MouseRegion(
          onEnter: (_) => _updateHoveredState(index, true),
          onExit: (_) => _updateHoveredState(index, false),
          child: Stack(
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(color: ChatifyColors.darkerGrey, borderRadius: BorderRadius.circular(12)),
                alignment: Alignment.center,
                child: Text('Элемент $index'),
              ),
              AnimatedPositioned(
                duration: Duration(milliseconds: 300),
                curve: Curves.easeOut,
                top: 8,
                right: _hoveredStates[index] ?? false ? 8 : 0,
                child: AnimatedOpacity(
                  duration: Duration(milliseconds: 300),
                  opacity: _hoveredStates[index] ?? false ? 1.0 : 0.0,
                  child: Container(
                    width: 21,
                    height: 21,
                    decoration: BoxDecoration(
                      border: Border.all(color: ChatifyColors.white.withAlpha((0.5 * 255).toInt()), width: 1.4),
                      borderRadius: BorderRadius.circular(4),
                      color: ChatifyColors.black,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
