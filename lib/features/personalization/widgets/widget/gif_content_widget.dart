import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import '../../../../core/services/images/tenor_service.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../home/controllers/emoji_stickers_controller.dart';
import '../../../home/widgets/input/search_text_input.dart';
import '../../models/gif_model.dart';
import '../dialogs/light_dialog.dart';
import '../dialogs/overlays/select_gif_overlay.dart';

class GifContentWidget extends StatefulWidget {
  final TextEditingController stickerController;
  final FocusNode focusNode;
  final EmojiStickersController controller;
  final ScrollController scrollController;
  final Function(String) onGifSelected;
  final Function(String) onEmojiSelected;
  final Future<void> Function() onCloseParentOverlay;

  const GifContentWidget({
    super.key,
    required this.stickerController,
    required this.focusNode,
    required this.controller,
    required this.scrollController,
    required this.onGifSelected,
    required this.onEmojiSelected,
    required this.onCloseParentOverlay,
  });

  @override
  State<GifContentWidget> createState() => _GifContentWidgetState();
}

class _GifContentWidgetState extends State<GifContentWidget> {
  List<GifModel> gifs = [];
  final RxInt selectedIndex = 0.obs;
  final RxList<bool> hoverStates = List.generate(7, (_) => false).obs;
  final List<String> category = ['Популярные', 'Ха-ха', 'Печаль', 'Любовь', 'Реакции', 'Спорт', 'ТВ'];
  final List<String> categoryQueries = ['trending', 'funny', 'sad', 'love', 'reactions', 'sports', 'tv'];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    selectedIndex.value = 0;
    searchGifs(categoryQueries[0]);
  }

  void searchGifs(String query) async {
    setState(() => isLoading = true);
    try {
      final results = await TenorService.searchGifs(query);
      log(results.toString());
      setState(() {
        gifs = results;
      });
    } catch (e) {
      debugPrint('Error loading gifs: $e');
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<List<File>> extractGifFrames(String gifUrl, {int frameCount = 9}) async {
    final response = await http.get(Uri.parse(gifUrl));
    final bytes = response.bodyBytes;

    final gif = img.decodeGif(bytes);
    if (gif == null) throw Exception("Не удалось декодировать GIF");

    final frames = gif.frames;
    final tempDir = await getTemporaryDirectory();

    List<File> files = [];

    for (int i = 0; i < frameCount && i < frames.length; i++) {
      final frame = frames[i];
      final filePath = '${tempDir.path}/frame_$i.png';
      final file = File(filePath);
      await file.writeAsBytes(img.encodePng(frame));
      files.add(file);
    }

    return files;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SearchTextInput(
            hintText: 'Поиск Gif в Tenor',
            controller: widget.stickerController,
            focusNode: widget.focusNode,
            showTooltip: false,
            padding: EdgeInsets.only(left: 12, right: 12, top: 2, bottom: 12),
            onChanged: (value) {
              if (value.trim().isNotEmpty) {
                searchGifs(value);
              }
            },
          ),
          Expanded(
            child: isLoading
              ? Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(colorsController.getColor(colorsController.selectedColorScheme.value))))
              : GridView.builder(
                  controller: widget.scrollController,
                  padding: const EdgeInsets.all(8),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemCount: gifs.length,
                  itemBuilder: (context, index) {
                    final gif = gifs[index];

                    return Builder(
                      builder: (itemContext) {
                        return GestureDetector(
                          onTap: () async {
                            final Offset fixedPosition = Offset(132, 300);
                            final frameFiles = await extractGifFrames(gif.url);
                            final frameUrls = frameFiles.map((f) => f.path).toList();

                            await Future.delayed(Duration(milliseconds: 50));
                            await widget.onCloseParentOverlay();
                            await Future.delayed(Duration(milliseconds: 100));

                            await showSelectGifOverlay(context, fixedPosition, gif, widget.stickerController, widget.focusNode, widget.onEmojiSelected, widget.onGifSelected, frameUrls);
                          },
                          child: Image.network(gif.url, fit: BoxFit.cover),
                        );
                      },
                    );
                  },
                ),
              ),
          _buildGifPanel(context),
        ],
      ),
    );
  }

  Widget _buildGifPanel(BuildContext context) {
    return Obx(() => Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: (context.isDarkMode ? ChatifyColors.youngNight : ChatifyColors.lightGrey).withAlpha((0.6 * 255).toInt()),
        borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15)),
      ),
      padding: const EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: List.generate(category.length, (index) {
          final bool isSelected = selectedIndex.value == index;
          final bool isHovering = hoverStates[index];
          final Color textColor = isSelected || isHovering ? ChatifyColors.white : ChatifyColors.darkGrey;

          return MouseRegion(
            onEnter: (_) => hoverStates[index] = true,
            onExit: (_) => hoverStates[index] = false,
            child: GestureDetector(
              onTap: () {
                selectedIndex.value = index;
                searchGifs(categoryQueries[index]);
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 12),
                child: Text(category[index], style: TextStyle(fontSize: ChatifySizes.fontSizeLm, color: textColor)),
              ),
            ),
          );
        }),
      ),
    ));
  }
}
