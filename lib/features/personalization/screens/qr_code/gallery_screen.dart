import 'dart:developer';
import 'package:android_intent_plus/android_intent.dart';
import 'package:android_intent_plus/flag.dart';
import 'package:chatify/api/apis.dart';
import 'package:chatify/routes/custom_page_route.dart';
import 'package:chatify/utils/constants/app_vectors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:photo_manager/photo_manager.dart';
import '../../../../generated/l10n/l10n.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import 'dart:typed_data';
import '../../../status/screens/add_detail_image_screen.dart';
import '../../widgets/dialogs/light_dialog.dart';

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({super.key});

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<AssetEntity> _galleryImages = [];
  bool _hasRecentImages() => recentImages.isNotEmpty;
  bool _hasLastWeekImages() => lastWeekImages.isNotEmpty;

  List<AssetEntity> recentImages = [];
  List<AssetEntity> lastWeekImages = [];
  List<AssetEntity> lastMonthImages = [];

  @override
  void initState() {
    super.initState();
    _loadImages();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _openSystemGallery() async {
    try {
      const intent = AndroidIntent(
        action: 'android.intent.action.PICK',
        data: 'content://media/internal/images/media',
        package: 'com.android.gallery3d',
        flags: <int>[Flag.FLAG_ACTIVITY_NEW_TASK],
      );
      await intent.launch();
    } catch (e) {
      log('${S.of(context).failedOpenSystemGallery}: $e');
    }
  }

  Future<void> _openGooglePhotos() async {
    const intent = AndroidIntent(
      action: 'android.intent.action.MAIN',
      package: 'com.google.android.apps.photos',
      flags: <int>[Flag.FLAG_ACTIVITY_NEW_TASK],
    );

    try {
      await intent.launch();
    } catch (e) {
      log('${S.of(context).errorLaunchingGooglePhotos}: $e');
    }
  }

  Future<void> _loadImages() async {
    final permitted = await PhotoManager.requestPermissionExtend();
    if (permitted.isAuth) {
      final albums = await PhotoManager.getAssetPathList(
        type: RequestType.image,
        onlyAll: true,
      );
      final recentAlbum = albums.first;

      final images = await recentAlbum.getAssetListPaged(
        page: 0,
        size: 100,
      );

      recentImages.clear();
      lastWeekImages.clear();
      lastMonthImages.clear();

      final now = DateTime.now();
      final oneWeekAgo = now.subtract(const Duration(days: 7));
      final oneMonthAgo = now.subtract(const Duration(days: 30));

      for (var image in images) {
        final file = await image.originFile;
        if (file != null) {
          final lastModified = file.lastModifiedSync();

          if (lastModified.isAfter(oneWeekAgo)) {
            recentImages.add(image);
          } else if (lastModified.isAfter(oneMonthAgo)) {
            lastWeekImages.add(image);
          } else if (lastModified.isAfter(oneMonthAgo)) {
            lastMonthImages.add(image);
          }
        }
      }

      setState(() {
        _galleryImages = images;
      });
    } else {
      PhotoManager.openSetting();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          PopupMenuButton<int>(
            position: PopupMenuPosition.under,
            color: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.white,
            icon: const Icon(Icons.more_vert),
            onSelected: (value) {
              if (value == 1) {
                _openSystemGallery();
              } else if (value == 2) {
                _openGooglePhotos();
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 1,
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    SvgPicture.asset(ChatifyVectors.googlePhoto, width: 24, height: 24),
                    const SizedBox(width: 16),
                    Text(S.of(context).gallery, style: TextStyle(fontSize: ChatifySizes.fontSizeMd)),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 2,
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    SvgPicture.asset(ChatifyVectors.googlePhoto, width: 24, height: 24),
                    const SizedBox(width: 16),
                    Text(S.of(context).photo, style: TextStyle(fontSize: ChatifySizes.fontSizeMd)),
                  ],
                ),
              ),
            ],
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: colorsController.getColor(colorsController.selectedColorScheme.value),
          labelColor: ChatifyColors.white,
          unselectedLabelColor: ChatifyColors.darkGrey,
          indicatorSize: TabBarIndicatorSize.tab,
          overlayColor: WidgetStateProperty.all(ChatifyColors.darkerGrey),
          dividerColor: ChatifyColors.transparent,
          tabs: [
            Tab(text: S.of(context).recent),
            Tab(text: S.of(context).gallery),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildRecentTab(),
          _buildGalleryTab(),
        ],
      ),
    );
  }

  Widget _buildRecentTab() {
    return _galleryImages.isEmpty
        ? Center(
      child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(colorsController.getColor(colorsController.selectedColorScheme.value))),
    )
    : Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_hasRecentImages()) ...[
          _buildLabel(S.of(context).recent),
          _buildImageGrid(recentImages),
        ],
        if (_hasLastWeekImages()) ...[
          _buildLabel(S.of(context).lastWeek),
          _buildImageGrid(lastWeekImages),
        ],
        if (lastMonthImages.isNotEmpty) ...[
          _buildLabel(S.of(context).lastMonth),
          _buildImageGrid(lastMonthImages),
        ],
      ],
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Text(text, style: TextStyle(fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w500)),
    );
  }

  Widget _buildImageGrid(List<AssetEntity> images) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: images.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 8.0,
        crossAxisSpacing: 8.0,
        childAspectRatio: 1,
      ),
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () async {
            final image = images[index];
            final file = await image.originFile;
            if (file != null) {
              Navigator.push(context, createPageRoute(AddDetailImageScreen(imageFile: file, user: APIs.me)));
            }
          },
          child: FutureBuilder<Uint8List?>(
            future: images[index].thumbnailDataWithSize(const ThumbnailSize(250, 250)),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.memory(snapshot.data!, fit: BoxFit.cover),
                );
              } else {
                return Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(colorsController.getColor(colorsController.selectedColorScheme.value))));
              }
            },
          ),
        );
      },
    );
  }

  Widget _buildGalleryTab() {
    return Padding(
      padding: const EdgeInsets.all(40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(),
        ],
      ),
    );
  }
}
