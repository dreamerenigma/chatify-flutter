import 'dart:io';
import 'package:chatify/features/utils/widgets/scrolls/no_glow_scroll_behavior.dart';
import 'package:flutter/material.dart';
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
import '../../../chat/models/user_model.dart';
import '../../../personalization/widgets/dialogs/light_dialog.dart';
import '../../screens/add_detail_image_screen.dart';
import '../../screens/enter_status_screen.dart';
import '../images/camera_screen.dart';
import '../options/action_option.dart';
import 'create_maket_bottom_dialog.dart';
import 'overlays/albums_overlay.dart';

void showAddStatusBottomDialog(BuildContext context, UserModel user) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
    backgroundColor: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.white,
    isScrollControlled: true,
    builder: (_) => AddStatusBottomSheet(user: user),
  );
}

class AddStatusBottomSheet extends StatefulWidget {
  final UserModel user;

  const AddStatusBottomSheet({
    super.key,
    required this.user,
  });

  @override
  State<AddStatusBottomSheet> createState() => _AddStatusBottomSheetState();
}

class _AddStatusBottomSheetState extends State<AddStatusBottomSheet> {
  final ScrollController _scrollController = ScrollController();
  final List<AssetEntity> selectedImages = [];
  bool isLoadingAlbums = true;
  bool isAlbumsExpanded = false;
  bool isSelectionMode = false;
  List<AssetPathEntity> albums = [];
  AssetPathEntity? selectedAlbum;
  OverlayEntry? albumsOverlay;

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
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
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

  void _closeAlbumsOverlay() {
    if (albumsOverlay?.mounted ?? false) {
      albumsOverlay!.remove();
    }

    albumsOverlay = null;
  }

  void _onScroll() {
    if (_scrollController.position.isScrollingNotifier.value) {
    }
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
                NotificationListener<ScrollNotification>(
                  onNotification: (notification) {
                    if (notification is ScrollStartNotification) {
                      _closeAlbumsOverlay();
                    }

                    return false;
                  },
                  child: ScrollConfiguration(
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
                if (selectedImages.isNotEmpty)
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: Container(
                      height: 60,
                      decoration: BoxDecoration(color: context.isDarkMode ? ChatifyColors.softNight : ChatifyColors.grey),
                      child: _buildPreviewImagePanel(),
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: Builder(
        builder: (buttonContext) {
          return Material(
            color: ChatifyColors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(6),
              splashFactory: NoSplash.splashFactory,
              splashColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
              highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
              hoverColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
              onTap: () {
                _closeAlbumsOverlay();
                albumsOverlay = showAlbumsOverlay(buttonContext, albums: albums, isLoadingAlbums: isLoadingAlbums);
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(S.of(context).recent, style: TextStyle(color: ChatifyColors.darkGrey, fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400)),
                    const SizedBox(width: 4),
                    const Icon(Icons.arrow_drop_down_sharp, size: 22),
                  ],
                ),
              ),
            ),
          );
        },
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
    return Material(
      color: ChatifyColors.transparent,
      child: InkWell(
        splashFactory: NoSplash.splashFactory,
        splashColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
        highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
        hoverColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
        onTap: () {
          Navigator.push(context, createPageRoute(CameraScreen(chatTarget: widget.user)));
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
      onTap: () async {
        if (isSelectionMode) {
          _toggleImageSelection(asset);
          return;
        }

        final file = await asset.file;

        if (file == null) return;

        Navigator.push(context, MaterialPageRoute(builder: (_) => AddDetailImageScreen(imageFile: file, user: APIs.me)));
      },
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image(image: AssetEntityImageProvider(asset, isOriginal: false, thumbnailSize: const ThumbnailSize.square(300), thumbnailFormat: ThumbnailFormat.jpeg), fit: BoxFit.cover),
          if (isSelected)
            Container(color: Colors.white.withValues(alpha: 0.45)),
          if (isSelected)
            Positioned(
              top: 6,
              right: 6,
              child: Container(
                width: 26,
                height: 26,
                decoration: BoxDecoration(color: colorsController.getColor(colorsController.selectedColorScheme.value), shape: BoxShape.circle),
                alignment: Alignment.center,
                child: Text('$selectionNumber', style: TextStyle(color: ChatifyColors.white, fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.bold)),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPreviewImagePanel() {
    if (selectedImages.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 7, bottom: 7),
      child: SizedBox(
        height: 60,
        child: Row(
          children: [
            Expanded(
              child: ScrollConfiguration(
                behavior: NoGlowScrollBehavior(),
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.only(left: 7),
                  itemCount: selectedImages.length,
                  separatorBuilder: (_, _) => const SizedBox(width: 2),
                  itemBuilder: (context, index) {
                    final asset = selectedImages[index];

                    return FutureBuilder<File?>(
                      future: asset.file,
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(color: context.isDarkMode ? ChatifyColors.softNight : ChatifyColors.lightGrey, borderRadius: BorderRadius.circular(12)),
                            child: const Center(child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))),
                          );
                        }

                        return ClipRRect(borderRadius: BorderRadius.circular(4), child: Image.file(snapshot.data!, width: 50, height: 50, fit: BoxFit.cover));
                      },
                    );
                  },
                ),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              width: 50,
              height: 50,
              margin: const EdgeInsets.only(right: 7),
              decoration: BoxDecoration(shape: BoxShape.circle, color: colorsController.getColor(colorsController.selectedColorScheme.value)),
              child: Material(
                color: ChatifyColors.transparent,
                shape: const CircleBorder(),
                child: InkWell(
                  splashColor: ChatifyColors.transparent,
                  highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
                  hoverColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
                  customBorder: const CircleBorder(),
                  onTap: () {},
                  child: const Center(child: Icon(Icons.check_rounded, size: 24, color: ChatifyColors.white)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
