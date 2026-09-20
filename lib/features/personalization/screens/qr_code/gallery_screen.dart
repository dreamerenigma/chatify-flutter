import 'dart:typed_data';
import 'package:chatify/api/apis.dart';
import 'package:chatify/routes/custom_page_route.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/context_extensions.dart';
import 'package:photo_manager/photo_manager.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../status/screens/add_detail_image_screen.dart';
import '../../../utils/widgets/scrolls/no_glow_scroll_behavior.dart';
import '../../widgets/dialogs/light_dialog.dart';

class GalleryScreen extends StatefulWidget {
  final String title;
  final VoidCallback? onTitleTap;
  final VoidCallback? onBottomTap;

  const GalleryScreen({
    super.key,
    required this.title,
    this.onTitleTap,
    this.onBottomTap,
  });

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  List<AssetEntity> galleryImages = [];
  bool isLoading = true;
  bool isSelectionMode = false;

  @override
  void initState() {
    super.initState();
    _loadImages();
  }

  Future<void> _loadImages() async {
    try {
      final permitted = await PhotoManager.requestPermissionExtend();

      if (!permitted.isAuth) {
        PhotoManager.openSetting();
        return;
      }

      final albums = await PhotoManager.getAssetPathList(type: RequestType.image, onlyAll: true);

      if (albums.isEmpty) {
        if (mounted) {
          setState(() {
            isLoading = false;
          });
        }
        return;
      }

      final recentAlbum = albums.first;
      final images = await recentAlbum.getAssetListPaged(page: 0, size: 100);

      if (!mounted) return;

      setState(() {
        galleryImages = images;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> loadAlbum(AssetPathEntity album) async {
    setState(() {
      isLoading = true;
      galleryImages.clear();
    });

    try {
      final images = await album.getAssetListPaged(page: 0, size: 100);

      if (!mounted) return;

      setState(() {
        galleryImages = images;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.close_rounded, size: 26),
        ),
        centerTitle: true,
        title: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: widget.onTitleTap,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(widget.title, style: TextStyle(fontSize: ChatifySizes.fontSizeXl, fontWeight: FontWeight.w400)),
              const SizedBox(width: 3),
              Icon(Icons.arrow_drop_down_outlined, size: 20),
            ],
          ),
        ),
      ),

      body: Stack(
        children: [
          _buildGallery(),
          if (!isSelectionMode)
            Positioned(
              bottom: 16,
              right: 16,
              child: Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(color: context.isDarkMode ? ChatifyColors.softNight : ChatifyColors.grey, border: Border.all(color: ChatifyColors.darkerGrey, width: 1), borderRadius: BorderRadius.circular(18)),
                child: FloatingActionButton(
                  heroTag: 'addQrCode',
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
    );
  }

  Widget _buildGallery() {
    if (isLoading) {
      return Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(colorsController.getColor(colorsController.selectedColorScheme.value))));
    }

    if (galleryImages.isEmpty) {
      return Center(child: Text('Нет фото', style: TextStyle(color: ChatifyColors.grey, fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400)));
    }

    return ScrollConfiguration(
      behavior: NoGlowScrollBehavior(),
      child: CustomScrollView(

        slivers: [
          SliverGrid(
            delegate: SliverChildBuilderDelegate((context, index) => _buildImageItem(galleryImages[index]), childCount: galleryImages.length),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, mainAxisSpacing: 2, crossAxisSpacing: 2, childAspectRatio: 1),
          ),
        ],
      ),
    );
  }

  Widget _buildImageItem(AssetEntity image) {
    return GestureDetector(
      onTap: () async {
        final file = await image.originFile;

        if (file == null || !context.mounted) {
          return;
        }

        Navigator.push(context, createPageRoute(AddDetailImageScreen(imageFile: file, user: APIs.me)));
      },
      child: FutureBuilder<Uint8List?>(
        future: image.thumbnailDataWithSize(const ThumbnailSize(250, 250)),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
            return ClipRRect(borderRadius: BorderRadius.circular(0), child: Image.memory(snapshot.data!, fit: BoxFit.cover));
          }

          return Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(colorsController.getColor(colorsController.selectedColorScheme.value))));
        },
      ),
    );
  }
}
