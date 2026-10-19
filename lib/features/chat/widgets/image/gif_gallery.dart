import 'dart:convert';
import 'dart:developer';
import 'package:chatify/utils/constants/app_sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:http/http.dart' as http;
import '../../../../config/config.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../personalization/widgets/dialogs/light_dialog.dart';

class GifGallery extends StatefulWidget {
  final ValueChanged<String>? onGifTap;

  const GifGallery({
    super.key,
    this.onGifTap,
  });

  @override
  State<GifGallery> createState() => _GifGalleryState();
}

class _GifGalleryState extends State<GifGallery> {
  List<Map<String, dynamic>> _gifs = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadGifs();
  }

  Future<void> _loadGifs() async {
    try {
      final uri = Uri.https(
        'api.giphy.com',
        '/v1/gifs/trending',
        {
          'api_key': Config.giphyKey,
          'limit': '30',
          'rating': 'g',
          'bundle': 'messaging_non_clips',
        },
      );

      final response = await http.get(uri);

      if (response.statusCode != 200) {
        throw Exception('GIPHY: HTTP ${response.statusCode}');
      }

      final json = jsonDecode(response.body) as Map<String, dynamic>;
      final data = json['data'] as List<dynamic>;

      final gifs = data.whereType<Map<String, dynamic>>().where((gif) {
        final images = gif['images'] as Map<String, dynamic>?;

        return images?['fixed_width']?['url'] != null || images?['downsized']?['url'] != null;
      }).toList();

      if (!mounted) return;

      setState(() {
        _gifs = gifs;
        _isLoading = false;
        _error = null;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
        _error = 'Не удалось загрузить GIF';
      });

      log('GIF loading error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark ? ChatifyColors.nightGrey : ChatifyColors.white;

    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      child: Container(
        color: backgroundColor,
        child: Column(
          children: [
            Expanded(child: _buildGallery(isDark)),
          ],
        ),
      ),
    );
  }

  Widget _buildGallery(bool isDark) {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(colorsController.getColor(colorsController.selectedColorScheme.value)), strokeWidth: 3));
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(_error!),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () {
                setState(() {
                  _isLoading = true;
                  _error = null;
                });
                _loadGifs();
              },
              child: Text('Повторить', style: TextStyle(fontSize: ChatifySizes.borderRadiusMd, fontWeight: FontWeight.w400)),
            ),
          ],
        ),
      );
    }

    if (_gifs.isEmpty) {
      return Center(child: Text('GIF не найдены', style: TextStyle(fontSize: ChatifySizes.borderRadiusMd, fontWeight: FontWeight.w400)));
    }

    return MasonryGridView.count(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 0, bottom: 10),
      crossAxisCount: 3,
      mainAxisSpacing: 4,
      crossAxisSpacing: 4,
      itemCount: _gifs.length,
      itemBuilder: (context, index) {
        final images = _gifs[index]['images'] as Map<String, dynamic>;
        final rendition = images['fixed_width'] ?? images['downsized'];
        final url = rendition['url'] as String;
        final aspectRatio = switch (index % 4) {0 => 0.85, 1 => 1.15, 2 => 0.72, _ => 1.0};

        return GestureDetector(
          onTap: () => widget.onGifTap?.call(url),
          child: ClipRRect(
            child: AspectRatio(
              aspectRatio: aspectRatio,
              child: Image.network(
                url,
                fit: BoxFit.cover,
                gaplessPlayback: true,
                loadingBuilder: (context, child, progress) {
                  if (progress == null) return child;

                  return Container(
                    color: isDark ? ChatifyColors.youngNight : ChatifyColors.lightGrey,
                    alignment: Alignment.center,
                    child: SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(colorsController.getColor(colorsController.selectedColorScheme.value)), strokeWidth: 3),
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: isDark ? ChatifyColors.youngNight : ChatifyColors.lightGrey,
                    alignment: Alignment.center,
                    child: const Icon(Icons.gif, size: 27),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
