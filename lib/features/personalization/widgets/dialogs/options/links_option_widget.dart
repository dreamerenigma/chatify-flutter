import 'package:flutter/material.dart';
import '../../../../../common/widgets/bars/scrollbar/custom_scrollbar.dart';
import '../../../../../utils/constants/app_colors.dart';
import '../../../../../utils/constants/app_sizes.dart';
import '../../../../utils/widgets/no_glow_scroll_behavior.dart';

class LinksOptionWidget extends StatefulWidget {
  const LinksOptionWidget({super.key});

  @override
  State<LinksOptionWidget> createState() => _LinksOptionWidgetState();
}

class _LinksOptionWidgetState extends State<LinksOptionWidget> {
  final ScrollController _scrollController = ScrollController();
  bool isInside = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 8),
          child: Text('Ссылки', style: TextStyle(fontSize: 21, fontWeight: FontWeight.w500)),
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
                  child: Column(
                    children: [
                      _buildLinks(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLinks() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.45,
      child: Center(
        child: Text('Нет ссылок', style: TextStyle(color: ChatifyColors.grey, fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w300), textAlign: TextAlign.center),
      ),
    );
  }
}
