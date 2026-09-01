import 'package:chatify/features/utils/widgets/scrolls/no_glow_scroll_behavior.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:photo_manager_image_provider/photo_manager_image_provider.dart';
import 'package:remixicon/remixicon.dart';
import '../../../../api/apis.dart';
import '../../../../generated/l10n/l10n.dart';
import '../../../../routes/custom_page_route.dart';
import '../../../../utils/constants/app_colors.dart';
import 'package:unicons/unicons.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../../utils/constants/app_vectors.dart';
import '../../../personalization/widgets/dialogs/light_dialog.dart';
import '../../screens/enter_status_screen.dart';
import '../images/camera_screen.dart';
import '../options/action_option.dart';
import 'create_maket_bottom_dialog.dart';

void showAddStatusBottomDialog(BuildContext context) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
    backgroundColor: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.white,
    isScrollControlled: true,
    builder: (_) => const AddStatusBottomSheet(),
  );
}

class AddStatusBottomSheet extends StatefulWidget {
  const AddStatusBottomSheet({super.key});

  @override
  State<AddStatusBottomSheet> createState() => _AddStatusBottomSheetState();
}

class _AddStatusBottomSheetState extends State<AddStatusBottomSheet> {
  final List<AssetEntity> selectedImages = [];
  bool isLoadingAlbums = true;
  bool isAlbumsExpanded = false;
  bool isSelectionMode = false;
  List<AssetPathEntity> albums = [];
  AssetPathEntity? selectedAlbum;

  int _getSelectionNumber(AssetEntity asset) {
    final index = selectedImages.indexOf(asset);

    if (index == -1) {
      return 0;
    }

    return index + 1;
  }

  @override
  void initState() {
    super.initState();
    _loadImages();
    _loadAlbums();
  }

  void _toggleImageSelection(AssetEntity asset) {
    setState(() {
      if (selectedImages.contains(asset)) {
        selectedImages.remove(asset);

        if (selectedImages.isEmpty) {
          isSelectionMode = false;
        }
      } else {
        isSelectionMode = true;
        selectedImages.add(asset);
      }
    });
  }

  Future<List<AssetEntity>> _loadImages() async {
    final permission = await PhotoManager.requestPermissionExtend();

    if (!permission.isAuth && !permission.hasAccess) {
      return [];
    }

    final albums = await PhotoManager.getAssetPathList(type: RequestType.image, hasAll: true, onlyAll: true);

    if (albums.isEmpty) {
      return [];
    }

    final recentAlbum = albums.first;
    final images = await recentAlbum.getAssetListPaged(page: 0, size: 200);

    images.sort((a, b) => b.createDateTime.compareTo(a.createDateTime));

    return images;
  }

  Future<void> _loadAlbums() async {
    final permission = await PhotoManager.requestPermissionExtend();

    if (!permission.isAuth && !permission.hasAccess) {
      return;
    }

    final result = await PhotoManager.getAssetPathList(type: RequestType.image, hasAll: true, onlyAll: false);

    if (!mounted) return;

    setState(() {
      albums = result;

      if (albums.isNotEmpty) {
        selectedAlbum = albums.first;
      }

      isLoadingAlbums = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      heightFactor: 0.96,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 12, top: 12),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Align(alignment: Alignment.centerLeft, child: GestureDetector(onTap: () => Navigator.pop(context), child: const Icon(Icons.close, size: 26))),
                Center(child: Text(S.of(context).addingStatus, style: TextStyle(fontSize: ChatifySizes.fontSizeBg, fontWeight: FontWeight.w400))),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Stack(
              children: [
                ScrollConfiguration(
                  behavior: NoGlowScrollBehavior(),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.only(bottom: 90),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ActionOption(
                                icon: Remix.text,
                                label: S.of(context).text,
                                onTap: () {
                                  Navigator.push(context, createPageRoute(EnterStatusScreen(user: APIs.me)));
                                },
                              ),
                              const SizedBox(width: 24),
                              ActionOption(
                                icon: UniconsLine.window_grid,
                                label: S.of(context).layout,
                                onTap: () {
                                  showCreateLayoutBottomDialog(context);
                                },
                              ),
                              const SizedBox(width: 24),
                              ActionOption(
                                icon: Icons.mic,
                                label: S.of(context).voice,
                                onTap: () {
                                  Navigator.push(context, createPageRoute(EnterStatusScreen(user: APIs.me)));
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        _buildAlbums(context),
                        const SizedBox(height: 8),
                        _buildImageGrid(context),
                      ],
                    ),
                  ),
                ),
                if (!isSelectionMode)
                  Positioned(
                    bottom: 16,
                    right: 16,
                    child: Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(color: context.isDarkMode ? ChatifyColors.softNight : ChatifyColors.grey, border: Border.all(color: ChatifyColors.darkerGrey, width: 1), borderRadius: BorderRadius.circular(18)),
                      child: FloatingActionButton(
                        heroTag: 'addStatus',
                        onPressed: () {},
                        backgroundColor: ChatifyColors.transparent,
                        foregroundColor: ChatifyColors.white,
                        elevation: 0,
                        child: const Icon(Icons.folder_copy_outlined, size: 20),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAlbums(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6),
          child: InkWell(
            onTap: () {
              setState(() {
                isAlbumsExpanded = !isAlbumsExpanded;
              });
            },
            borderRadius: BorderRadius.circular(6),
            splashColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey,
            highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(S.of(context).recent, style: TextStyle(color: ChatifyColors.darkGrey, fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400)),
                  SizedBox(width: 4),
                  const Icon(Icons.arrow_drop_down_sharp, size: 22),
                ],
              ),
            ),
          ),
        ),
        if (isAlbumsExpanded) ...[
          const SizedBox(height: 4),
          _buildAlbumsList(context),
        ],
      ],
    );
  }

  Widget _buildAlbumsList(BuildContext context) {
    if (isLoadingAlbums) {
      return Padding(padding: const EdgeInsets.all(20), child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(colorsController.getColor(colorsController.selectedColorScheme.value))));
    }

    if (albums.isEmpty) {
      return Padding(padding: const EdgeInsets.all(20), child: Text('Альбомы не найдены', style: TextStyle(color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black)));
    }

    const int maxVisibleAlbums = 5;

    final visibleAlbums = albums.take(maxVisibleAlbums).toList();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      constraints: const BoxConstraints(maxWidth: 240, maxHeight: 380),
      decoration: BoxDecoration(color: context.isDarkMode ? ChatifyColors.red : ChatifyColors.white, borderRadius: BorderRadius.circular(12)),
      child: ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.symmetric(vertical: 6),
        children: [
          ...visibleAlbums.map((album) => _buildAlbumTile(context, album)),
          if (albums.length > maxVisibleAlbums)
            _buildMoreAlbumsTile(context),
        ],
      ),
    );
  }

  Widget _buildAlbumTile(BuildContext context, AssetPathEntity album) {
    final isSelected = selectedAlbum?.id == album.id;

    return FutureBuilder<List<AssetEntity>>(
      future: album.getAssetListPaged(page: 0, size: 1),
      builder: (context, snapshot) {
        AssetEntity? previewAsset;

        if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          previewAsset = snapshot.data!.first;
        }

        return InkWell(
          onTap: () {
            setState(() {
              selectedAlbum = album;
              isAlbumsExpanded = false;
            });
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: SizedBox(
                    width: 45,
                    height: 45,
                    child: previewAsset != null
                      ? Image(
                          image: AssetEntityImageProvider(previewAsset, isOriginal: false, thumbnailSize: const ThumbnailSize.square(150), thumbnailFormat: ThumbnailFormat.jpeg),
                          fit: BoxFit.cover,
                        )
                      : Container(
                          color: context.isDarkMode ? ChatifyColors.darkerGrey : ChatifyColors.grey,
                          child: Icon(Icons.photo_library_outlined, color: ChatifyColors.iconGrey, size: 24),
                        ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FutureBuilder<int>(
                    future: album.assetCountAsync,
                    builder: (context, countSnapshot) {
                      final count = countSnapshot.data ?? 0;

                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(album.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400)),
                          const SizedBox(height: 3),
                          Text('$count items', maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: ChatifySizes.fontSizeSm, color: ChatifyColors.grey)),
                        ],
                      );
                    },
                  ),
                ),
                const SizedBox(width: 8),
                if (isSelected)
                  Icon(Icons.check, size: 22, color: colorsController.getColor(colorsController.selectedColorScheme.value)),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMoreAlbumsTile(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() {
          isAlbumsExpanded = false;
        });
      },
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Container(
                width: 50,
                height: 50,
                color: context.isDarkMode ? ChatifyColors.darkerGrey : ChatifyColors.grey,
                alignment: Alignment.center,
                child: SvgPicture.asset(ChatifyVectors.folder, width: 24, height: 24, colorFilter: ColorFilter.mode(context.isDarkMode ? ChatifyColors.white : ChatifyColors.black, BlendMode.srcIn)),
              ),
            ),
            const SizedBox(width: 12),
            Text('Ещё', style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400)),
          ],
        ),
      ),
    );
  }

  Widget _buildImageGrid(BuildContext context) {
    return FutureBuilder<List<AssetEntity>>(
      future: _loadImages(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Padding(padding: const EdgeInsets.all(30), child: Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(colorsController.getColor(colorsController.selectedColorScheme.value)))));
        }

        if (snapshot.hasError) {
          return Padding(
            padding: const EdgeInsets.all(20),
            child: Center(child: Text('Не удалось загрузить фотографии', style: TextStyle(color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black))),
          );
        }

        final images = snapshot.data ?? [];

        if (images.isEmpty) {
          return Padding(
            padding: const EdgeInsets.all(30),
            child: Center(child: Text('Фотографии не найдены', style: TextStyle(color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black))),
          );
        }

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: images.length + 1,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 3, mainAxisSpacing: 3, childAspectRatio: 1),
          itemBuilder: (context, index) {
            if (index == 0) {
              return _buildCameraTile(context);
            }
            final asset = images[index - 1];

            return _buildPhotoTile(context, asset);
          },
        );
      },
    );
  }

  Widget _buildCameraTile(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(context, createPageRoute(const CameraScreen()));
      },
      child: Container(
        decoration: BoxDecoration(color: ChatifyColors.transparent, border: Border.all(color: context.isDarkMode ? ChatifyColors.softNight : ChatifyColors.grey, width: 1)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.camera_alt_outlined, size: 28, color: colorsController.getColor(colorsController.selectedColorScheme.value)),
            const SizedBox(height: 6),
            Text(S.of(context).camera, style: TextStyle(fontSize: ChatifySizes.fontSizeSm, color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black)),
          ],
        ),
      ),
    );
  }

  Widget _buildPhotoTile(BuildContext context, AssetEntity asset) {
    final isSelected = selectedImages.contains(asset);
    final selectionNumber = _getSelectionNumber(asset);

    return GestureDetector(
      onLongPress: () {
        _toggleImageSelection(asset);
      },
      onTap: () {
        if (isSelectionMode) {
          _toggleImageSelection(asset);
          return;
        }
      },
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image(image: AssetEntityImageProvider(asset, isOriginal: false, thumbnailSize: const ThumbnailSize.square(300), thumbnailFormat: ThumbnailFormat.jpeg), fit: BoxFit.cover),
          if (isSelected)
            Container(color: Colors.white.withValues(alpha: 0.45)),
          if (isSelected)
            Positioned(
              top: 8,
              right: 8,
              child: Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(color: colorsController.getColor(colorsController.selectedColorScheme.value), shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 2)),
                alignment: Alignment.center,
                child: Text('$selectionNumber', style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600)),
              ),
            ),
        ],
      ),
    );
  }
}
