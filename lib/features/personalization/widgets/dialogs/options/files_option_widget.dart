import 'package:chatify/utils/constants/app_sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../../../common/widgets/bars/scrollbar/custom_scrollbar.dart';
import '../../../../../utils/constants/app_colors.dart';
import '../../../../../utils/constants/app_vectors.dart';
import '../../../../utils/widgets/no_glow_scroll_behavior.dart';
import '../light_dialog.dart';

class FilesOptionWidget extends StatefulWidget {
  const FilesOptionWidget({super.key});

  @override
  State<FilesOptionWidget> createState() => _FilesOptionWidgetState();
}

class _FilesOptionWidgetState extends State<FilesOptionWidget> {
  final ScrollController _scrollController = ScrollController();
  final Map<int, bool> _hoveredStates = {};
  final Map<int, bool> _clickedStates = {};
  final List<String> files = [];
  bool isInside = false;

  void _updateHoveredState(int index, bool isHovered) {
    setState(() {
      _hoveredStates[index] = isHovered;
    });
  }

  void _updateClickedState(int index) {
    setState(() {
      _clickedStates[index] = !_clickedStates[index]!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 8),
          child: Text('Файлы', style: TextStyle(fontSize: 21, fontWeight: FontWeight.w500)),
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
                  child: files.isEmpty
                    ? SizedBox(
                        height: MediaQuery.of(context).size.height * 0.45,
                        child: Center(
                          child: Text(
                            'Нет файлов',
                            style: TextStyle(color: ChatifyColors.grey, fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w300),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      )
                    : Wrap(
                        spacing: 5,
                        runSpacing: 5,
                        children: List.generate(files.length, (index) => _buildFiles(index)),
                      ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFiles(int index) {
    return MouseRegion(
      onEnter: (_) => _updateHoveredState(index, true),
      onExit: (_) => _updateHoveredState(index, false),
      child: Stack(
        children: [
          Material(
            color: ChatifyColors.transparent,
            child: InkWell(
              onTap: () {},
              borderRadius: BorderRadius.circular(8),
              splashColor: ChatifyColors.transparent,
              hoverColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.5 * 255).toInt()) : ChatifyColors.grey,
              highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.5 * 255).toInt()) : ChatifyColors.grey,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: context.isDarkMode ? ChatifyColors.softNight : ChatifyColors.softGrey,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: SvgPicture.asset(ChatifyVectors.file, width: 34, height: 34),
                    ),
                  ),
                  SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Название файла', style: TextStyle(fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w300, height: 1.2, fontFamily: 'Roboto')),
                        Text('300 МБ, apk Application', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w300, height: 1.2, fontFamily: 'Roboto')),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          AnimatedPositioned(
            duration: Duration(milliseconds: 300),
            curve: Curves.easeOut,
            top: 0,
            right: _hoveredStates[index] ?? false ? 0 : 0,
            child: AnimatedOpacity(
              duration: Duration(milliseconds: 300),
              opacity: _hoveredStates[index] ?? false ? 1.0 : 0.0,
              child: Container(
                width: 21,
                height: 21,
                decoration: BoxDecoration(borderRadius: BorderRadius.only(topRight: Radius.circular(8)), color: ChatifyColors.black),
                child: GestureDetector(
                  onTap: () => _updateClickedState(index),
                  child: Icon(Icons.check, size: 14, color: ChatifyColors.white),
                ),
              ),
            ),
          ),
          AnimatedContainer(
            duration: Duration(milliseconds: 300),
            curve: Curves.easeOut,
            decoration: BoxDecoration(
              border: Border.all(color: _clickedStates[index] ?? false ? colorsController.getColor(colorsController.selectedColorScheme.value) : ChatifyColors.transparent, width: 2.0),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ],
      ),
    );
  }
}
