import 'package:chatify/features/status/widgets/dialogs/overlays/widgets/album_preview.dart';
import 'package:chatify/features/utils/widgets/scrolls/no_glow_scroll_behavior.dart';
import 'package:chatify/utils/constants/app_sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/context_extensions.dart';
import 'package:photo_manager/photo_manager.dart';
import '../../../../../generated/l10n/l10n.dart';
import '../../../../../utils/constants/app_colors.dart';
import '../../../../personalization/widgets/dialogs/light_dialog.dart';

OverlayEntry showAlbumsOverlay(BuildContext context, {required List<AssetPathEntity> albums, required bool isLoadingAlbums}) {
  final RenderBox renderBox = context.findRenderObject() as RenderBox;
  final Offset position = renderBox.localToGlobal(Offset.zero);
  final Size size = renderBox.size;
  late OverlayEntry overlay;

  overlay = OverlayEntry(
    builder: (_) {
      return AlbumsOverlay(position: position, buttonSize: size, albums: albums, isLoadingAlbums: isLoadingAlbums, onClose: () {
        if (overlay.mounted) {
          overlay.remove();
        }
      });
    },
  );

  final overlayState = Overlay.of(context, rootOverlay: true);

  overlayState.insert(overlay);

  return overlay;
}

class AlbumsOverlay extends StatefulWidget {
  final Offset position;
  final Size buttonSize;
  final List<AssetPathEntity> albums;
  final bool isLoadingAlbums;
  final VoidCallback onClose;

  const AlbumsOverlay({
    super.key,
    required this.position,
    required this.buttonSize,
    required this.albums,
    required this.isLoadingAlbums,
    required this.onClose,
  });

  @override
  State<AlbumsOverlay> createState() => _AlbumsOverlayState();
}

class _AlbumsOverlayState extends State<AlbumsOverlay> {
  String getLocalizedAlbumName(BuildContext context, AssetPathEntity album) {
    final name = album.name.trim().toLowerCase();

    switch (name) {
      case 'camera':
      case 'камера':
        return S.of(context).camera;
      case 'screenshots':
      case 'screenshot':
      case 'снимки экрана':
        return 'Скриншоты';
      case 'downloads':
      case 'загрузки':
        return 'Загрузки';
      case 'favorites':
      case 'избранное':
        return S.of(context).favorites;
      case 'recents':
      case 'recent':
      case 'недавние':
        return S.of(context).recent;
      default:
        return album.name;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(child: GestureDetector(behavior: HitTestBehavior.translucent, onTap: widget.onClose, child: const SizedBox())),
        Positioned(
          left: 16,
          top: widget.position.dy + widget.buttonSize.height + 4,
          child: Material(
            color: ChatifyColors.transparent,
            child: Container(
              width: 200,
              constraints: const BoxConstraints(maxHeight: 380),
              decoration: BoxDecoration(
                color: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [BoxShadow(blurRadius: 12, spreadRadius: 1, offset: const Offset(0, 4), color: ChatifyColors.black.withAlpha(40))],
              ),
              child: _buildContent(context),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildContent(BuildContext context) {
    if (widget.isLoadingAlbums) {
      return Padding(
        padding: const EdgeInsets.all(20),
        child: Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(colorsController.getColor(colorsController.selectedColorScheme.value)))),
      );
    }

    if (widget.albums.isEmpty) {
      return Padding(padding: const EdgeInsets.all(20), child: Text('Альбомы не найдены', style: TextStyle(color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black)));
    }

    const maxVisibleAlbums = 5;

    final visibleAlbums = widget.albums.take(maxVisibleAlbums).toList();

    return ScrollConfiguration(
      behavior: NoGlowScrollBehavior(),
      child: ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.symmetric(vertical: 7),
        children: [
          ...visibleAlbums.map((album) => _buildAlbumOverlayTile(context, album)),
          _buildMoreAlbumsTile(context),
        ],
      ),
    );
  }

  Widget _buildAlbumOverlayTile(BuildContext context, dynamic album) {
    return Material(
      color: ChatifyColors.transparent,
      child: InkWell(
        splashColor: ChatifyColors.transparent,
        highlightColor: context.isDarkMode ? ChatifyColors.steelGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey,
        hoverColor: context.isDarkMode ? ChatifyColors.lightSoftNight.withAlpha((0.3 * 255).toInt()) : ChatifyColors.steelGrey,
        onTap: () {
          widget.onClose();
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          child: Row(
            children: [
              AlbumPreview(album: album, isDarkMode: context.isDarkMode),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(getLocalizedAlbumName(context, album), maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black, fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400)),
                    FutureBuilder<int>(
                      future: album.assetCountAsync,
                      builder: (context, snapshot) {
                        final count = snapshot.data ?? 0;

                        return Text('$count фото', style: TextStyle(color: ChatifyColors.darkGrey, fontSize: 13));
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMoreAlbumsTile(BuildContext context) {
    return Material(
      color: ChatifyColors.transparent,
      child: InkWell(
        splashFactory: NoSplash.splashFactory,
        splashColor: ChatifyColors.transparent,
        highlightColor: context.isDarkMode ? ChatifyColors.steelGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey,
        hoverColor: context.isDarkMode ? ChatifyColors.lightSoftNight.withAlpha((0.3 * 255).toInt()) : ChatifyColors.steelGrey,
        onTap: () {
          widget.onClose();
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(color: context.isDarkMode ? ChatifyColors.youngNight : ChatifyColors.lightGrey, borderRadius: BorderRadius.circular(8)),
                child: Icon(Icons.photo_library_outlined, size: 20, color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Ещё',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black, fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
