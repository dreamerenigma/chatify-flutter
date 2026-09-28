import 'dart:developer';
import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:chatify/features/utils/widgets/scrolls/no_glow_scroll_behavior.dart';
import 'package:chatify/utils/constants/app_vectors.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_utils/src/extensions/context_extensions.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:photo_manager_image_provider/photo_manager_image_provider.dart';
import '../../../../api/chat_api.dart';
import '../../../../domain/entities/chat_target.dart';
import '../../../../generated/l10n/l10n.dart';
import '../../../../routes/custom_page_route.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../personalization/widgets/dialogs/light_dialog.dart';
import '../../../status/screens/add_detail_image_screen.dart';
import '../../../status/widgets/dialogs/overlays/albums_overlay.dart';
import '../../../status/widgets/images/camera_screen.dart';
import '../../../survey/screens/create_survey_screen.dart';
import '../../models/user_model.dart';
import '../../screens/contact_seeding_screen.dart';
import '../../screens/create_event_screen.dart';
import '../buttons/media_folder_button.dart';
import '../image/gallery_image.dart';
import '../input/buttons/send_button.dart';
import 'add_geolocation_dialog.dart';

void showEditBottomSheetDialog(
  BuildContext context, {
  required ChatTarget chatTarget,
  required UserModel user,
  required bool isUploading,
  required ValueChanged<bool> setUploading,
}) {
  bool isLoadingAlbums = true;
  List<AssetPathEntity> albums = [];
  OverlayEntry? albumsOverlay;

  void closeAlbumsOverlay() {
    if (albumsOverlay?.mounted ?? false) {
      albumsOverlay!.remove();
    }

    albumsOverlay = null;
  }

  final overlayContext = context;

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: ChatifyColors.transparent,
    enableDrag: true,
    isDismissible: true,
    showDragHandle: false,
    builder: (sheetContext) {
      return EditMediaBottomSheet(
        chatTarget: chatTarget,
        user: user,
        isUploading: isUploading,
        setUploading: setUploading,
        isLoadingAlbums: isLoadingAlbums,
        albums: albums,
        overlayContext: overlayContext,
        closeAlbumsOverlay: closeAlbumsOverlay,
        onAlbumsOverlayChanged: (overlay) {
          albumsOverlay = overlay;
        },
      );
    },
  );
}

class EditMediaBottomSheet extends StatefulWidget {
  final ChatTarget chatTarget;
  final UserModel user;
  final bool isUploading;
  final ValueChanged<bool> setUploading;
  final bool isLoadingAlbums;
  final List<AssetPathEntity> albums;
  final BuildContext overlayContext;
  final VoidCallback closeAlbumsOverlay;
  final ValueChanged<OverlayEntry?> onAlbumsOverlayChanged;

  const EditMediaBottomSheet({super.key,
    required this.chatTarget,
    required this.user,
    required this.isUploading,
    required this.setUploading,
    required this.isLoadingAlbums,
    required this.albums,
    required this.overlayContext,
    required this.closeAlbumsOverlay,
    required this.onAlbumsOverlayChanged,
  });

  @override
  State<EditMediaBottomSheet> createState() => EditMediaBottomSheetState();
}

class EditMediaBottomSheetState extends State<EditMediaBottomSheet> {
  final DraggableScrollableController _sheetController = DraggableScrollableController();
  final TextEditingController _captionController = TextEditingController();
  final FocusNode _captionFocusNode = FocusNode();
  final List<AssetEntity> _assets = [];
  final List<AssetEntity> _selectedAssets = [];
  final ImagePicker _imagePicker = ImagePicker();
  List<AssetPathEntity> _albums = [];
  AssetPathEntity? _currentAlbum;
  bool _isLoading = true;
  bool _isLoadingMore = false;
  bool _hasMore = true;
  bool _showActionPanel = true;
  bool _isHdEnabled = false;
  int _page = 0;

  static const int _pageSize = 100;

  @override
  void initState() {
    super.initState();
    _sheetController.addListener(_onSheetSizeChanged);
    _loadGallery();
  }

  @override
  void dispose() {
    _captionController.dispose();
    _captionFocusNode.dispose();
    _sheetController.dispose();
    super.dispose();
  }

  void _onSheetSizeChanged() {
    if (!_sheetController.isAttached) {
      return;
    }

    final size = _sheetController.size;

    if (size >= 0.94) {
      if (_showActionPanel) {
        setState(() {
          _showActionPanel = false;
        });
      }
    }

    else if (size <= 0.66) {
      if (!_showActionPanel) {
        setState(() {
          _showActionPanel = true;
        });
      }
    }
  }

  void _toggleAssetSelection(AssetEntity asset) {
    setState(() {
      if (_selectedAssets.any((item) => item.id == asset.id)) {
        _selectedAssets.removeWhere((item) => item.id == asset.id);
      } else {
        _selectedAssets.add(asset);
      }
    });
  }

  Future<void> _sendSelectedMedia() async {
    if (_selectedAssets.isEmpty) {
      return;
    }

    final caption = _captionController.text.trim();

    log('SEND MEDIA');
    log('SELECTED: ${_selectedAssets.length}');
    log('CAPTION: $caption');

    try {
      for (final asset in _selectedAssets) {
        final file = await asset.file;

        if (file == null) {
          log('SEND MEDIA: file is null');
          continue;
        }

        log('SEND MEDIA: file = ${file.path}');
        log('SEND MEDIA: type = ${asset.type}');
        log('SEND MEDIA: duration = ${asset.duration}');

        if (asset.type == AssetType.image) {
          await ChatApi.sendChatImage(widget.user, file);
        } else if (asset.type == AssetType.video) {
          await ChatApi.sendChatVideo(widget.user, file, fileName: asset.title, fileSize: '${await file.length()}', videoDuration: asset.duration);
        }
      }

      if (!mounted) return;

      _selectedAssets.clear();

      Navigator.pop(context);
    } catch (e, st) {
      log('SEND MEDIA ERROR: $e');
      log('SEND MEDIA STACK: $st');
    }
  }

  Future<void> sendGif(File file) async {
    widget.setUploading(true);
    await widget.chatTarget.sendImage(file);
    widget.setUploading(false);
  }

  Future<void> sendVideo(File file) async {
    widget.setUploading(true);

    try {
      log('SEND VIDEO UI: started');
      log('SEND VIDEO UI: file = ${file.path}');
      log('SEND VIDEO UI: size = ${await file.length()}');

      await widget.chatTarget.sendVideo(file);

      log('SEND VIDEO UI: finished');
    } catch (e, st) {
      log('SEND VIDEO UI: error = $e');
      log('SEND VIDEO UI: stack = $st');
    } finally {
      widget.setUploading(false);
      log('SEND VIDEO UI: uploading = false');
    }
  }

  Future<int?> getAudioDuration(File file) async {
    final player = AudioPlayer();
    try {
      await player.setSource(DeviceFileSource(file.path));

      final duration = await player.getDuration();

      log('AUDIO DURATION: ${duration?.inSeconds} seconds');

      return duration?.inSeconds;
    } catch (e) {
      log('AUDIO DURATION ERROR: $e');
      return null;
    } finally {
      await player.dispose();
    }
  }

  Future<void> _loadGallery() async {
    try {
      final permission = await PhotoManager.requestPermissionExtend();

      if (!permission.isAuth) {
        setState(() {
          _isLoading = false;
        });

        return;
      }

      final albums = await PhotoManager.getAssetPathList(
        type: RequestType.common,
        filterOption: FilterOptionGroup(imageOption: const FilterOption(sizeConstraint: SizeConstraint(minWidth: 0, minHeight: 0))),
        onlyAll: false,
      );

      if (albums.isEmpty) {
        setState(() {
          _isLoading = false;
          _hasMore = false;
        });

        return;
      }

      AssetPathEntity selectedAlbum;

      final allAlbum = albums.where((album) => album.isAll).toList();

      if (allAlbum.isNotEmpty) {
        selectedAlbum = allAlbum.first;
      } else {
        selectedAlbum = albums.first;
      }

      setState(() {
        _albums = albums;
        _currentAlbum = selectedAlbum;
        _page = 0;
        _assets.clear();
        _isLoading = true;
      });

      await _loadPage();
    } catch (e, stackTrace) {
      log('GALLERY LOAD ERROR: $e', stackTrace: stackTrace);

      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _loadPage() async {
    if (_currentAlbum == null) return;

    try {
      final assets = await _currentAlbum!.getAssetListPaged(page: _page, size: _pageSize);

      if (!mounted) return;

      setState(() {
        _assets.addAll(assets);

        if (assets.length < _pageSize) {
          _hasMore = false;
        }

        _isLoading = false;
        _isLoadingMore = false;
      });
    } catch (e, stackTrace) {
      log('GALLERY PAGE ERROR: $e', stackTrace: stackTrace);

      if (mounted) {
        setState(() {
          _isLoading = false;
          _isLoadingMore = false;
        });
      }
    }
  }

  Future<void> _loadMoreAssets() async {
    if (_isLoadingMore || !_hasMore) return;

    setState(() {
      _isLoadingMore = true;
      _page++;
    });

    await _loadPage();
  }

  Future<void> _openImageEditor(AssetEntity asset) async {
    final file = await asset.file;

    if (file == null || !mounted) {
      return;
    }

    Navigator.push(context, createPageRoute(AddDetailImageScreen(imageFile: file, user: widget.user)));
  }

  Future<void> _openSystemGallery() async {
    try {
      final List<XFile> images = await _imagePicker.pickMultiImage(imageQuality: 100);

      if (images.isEmpty) return;

      for (final image in images) {
        log('SELECTED IMAGE: ${image.path}');
      }

    } catch (e, stackTrace) {
      log('SYSTEM GALLERY ERROR: $e', stackTrace: stackTrace);
    }
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      controller: _sheetController,
      initialChildSize: 0.65,
      minChildSize: 0.45,
      maxChildSize: 0.95,
      expand: false,
      snap: true,
      snapSizes: const [0.65, 0.95],
      builder: (context, sheetScrollController) {
        return Container(
          decoration: BoxDecoration(
            color: context.isDarkMode ? ChatifyColors.nightGrey : ChatifyColors.softGrey,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: Stack(
            children: [
              Column(
                children: [
                  const SizedBox(height: 12),
                  Container(width: 36, height: 4, decoration: BoxDecoration(color: ChatifyColors.steelGrey, borderRadius: BorderRadius.circular(2))),
                  const SizedBox(height: 20),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 350),
                    reverseDuration: const Duration(milliseconds: 250),
                    switchInCurve: Curves.easeOutCubic,
                    switchOutCurve: Curves.easeInCubic,
                    transitionBuilder: (child, animation) {
                      return FadeTransition(opacity: animation, child: SizeTransition(sizeFactor: animation, alignment: Alignment.topCenter, child: child));
                    },
                    child: _showActionPanel ? _buildActionPanel(context) : const SizedBox.shrink(),
                  ),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    switchInCurve: Curves.easeOutCubic,
                    switchOutCurve: Curves.easeInCubic,
                    transitionBuilder: (child, animation) {
                      return FadeTransition(opacity: animation, child: SizeTransition(sizeFactor: animation, alignment: Alignment.topCenter, child: child));
                    },
                    child: !_showActionPanel ? _buildHeader(context) : const SizedBox.shrink(),
                  ),
                  Expanded(child: _buildGallery(context, sheetScrollController)),
                ],
              ),
              Positioned(
                top: 12,
                left: 0,
                right: 0,
                child: Center(child: Container(width: 36, height: 4, decoration: BoxDecoration(color: ChatifyColors.steelGrey, borderRadius: BorderRadius.circular(2)))),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  switchInCurve: Curves.easeOutCubic,
                  switchOutCurve: Curves.easeInCubic,
                  child: _selectedAssets.isEmpty
                    ? Align(
                        key: const ValueKey('folder_button'),
                        alignment: Alignment.centerRight,
                        child: Padding(padding: const EdgeInsets.only(right: 20, bottom: 20), child: MediaFolderButton(onTap: _openSystemGallery)),
                      )
                    : _buildBottomPanelSend(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 52,
          width: double.infinity,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                left: 16,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _isHdEnabled = !_isHdEnabled;
                    });
                  },
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 180),
                    transitionBuilder: (child, animation) {
                      return ScaleTransition(scale: animation, child: child);
                    },
                    child: _isHdEnabled
                      ? SvgPicture.asset(
                          ChatifyVectors.hdCheck,
                          key: const ValueKey('hd'),
                          width: 24,
                          height: 24,
                          colorFilter: ColorFilter.mode(colorsController.getColor(colorsController.selectedColorScheme.value), BlendMode.srcIn),
                        )
                      : const Icon(Icons.hd_outlined, key: ValueKey('hd_outlined'), size: 24, color: ChatifyColors.grey,
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  widget.closeAlbumsOverlay();

                  final overlay = showAlbumsOverlay(widget.overlayContext, albums: _albums, isLoadingAlbums: _isLoading);

                  widget.onAlbumsOverlayChanged(overlay);
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _currentAlbum?.name ?? 'Недавние',
                      style: TextStyle(color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black, fontSize: ChatifySizes.fontSizeBg, fontWeight: FontWeight.w400),
                    ),
                    const SizedBox(width: 3),
                    Icon(Icons.arrow_drop_down, size: 22, color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black),
                  ],
                ),
              ),
              Positioned(
                right: 4,
                child: IconButton(
                  onPressed: () {
                    widget.closeAlbumsOverlay();
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.close_rounded, size: 26, color: ChatifyColors.grey),
                  splashRadius: 20,
                  tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildGallery(BuildContext context, ScrollController scrollController) {
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (notification is UserScrollNotification) {
          if (notification.direction == ScrollDirection.reverse) {
            if (_showActionPanel) {
              setState(() {
                _showActionPanel = false;
              });
            }
          } else if (notification.direction == ScrollDirection.forward) {
            if (!_showActionPanel) {
              setState(() {
                _showActionPanel = true;
              });
            }
          }
        }

        if (notification.metrics.pixels >= notification.metrics.maxScrollExtent - 800) {
          _loadMoreAssets();
        }

        return false;
      },
      child: Stack(
        children: [
          ScrollConfiguration(
            behavior: NoGlowScrollBehavior(),
            child: GridView.builder(
              controller: scrollController,
              padding: EdgeInsets.only(top: 2, bottom: _selectedAssets.isEmpty ? 2 : 70),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4, crossAxisSpacing: 2, mainAxisSpacing: 2),
              itemCount: _assets.length,
              itemBuilder: (context, index) {
                final asset = _assets[index];
                final selectionIndex = _selectedAssets.indexWhere((item) => item.id == asset.id);

                return GalleryImage(
                  asset: asset,
                  isSelected: selectionIndex != -1,
                  selectionIndex: selectionIndex,
                  onTap: () {
                    _toggleAssetSelection(asset);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionPanel(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.count(
        crossAxisCount: 4,
        shrinkWrap: true,
        padding: EdgeInsets.symmetric(vertical: 0),
        physics: const NeverScrollableScrollPhysics(),
        crossAxisSpacing: 12,
        mainAxisSpacing: 1,
        childAspectRatio: 1.15,
        children: [
          _buildIconButton(
            context,
            icon: Icon(Icons.image, color: ChatifyColors.blue, size: 24),
            label: S.of(context).gallery,
            onTap: () async {
              final result = await FilePicker.pickFiles(type: FileType.custom, allowedExtensions: ['gif', 'jpg', 'jpeg', 'png', 'webp', 'heic', 'heif']);

              if (result.isNotEmpty) {
                for (var file in result) {
                  final filePath = file.path!;
                  if (file.extension == 'gif') {
                    await sendGif(File(filePath));
                  } else {
                    widget.setUploading(true);
                    await widget.chatTarget.sendImage(File(filePath));
                    widget.setUploading(false);
                  }
                }
              }
              Navigator.pop(context);
            },
          ),
          _buildIconButton(
            context,
            icon: Icon(Icons.videocam, color: ChatifyColors.pink, size: 24),
            label: S.of(context).camera,
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, createPageRoute(CameraScreen(chatTarget: widget.chatTarget)));
            },
          ),
          _buildIconButton(
            context,
            icon: SvgPicture.asset(ChatifyVectors.documents, width: 24, height: 24, colorFilter: ColorFilter.mode(ChatifyColors.purple, BlendMode.srcIn)),
            label: 'Документ',
            onTap: () async {
              final result = await FilePicker.pickFiles(type: FileType.custom, allowedExtensions: ['pdf', 'doc', 'docx', 'odt', 'rtf', 'txt', 'xls', 'xlsx', 'ods', 'csv', 'ppt', 'pptx', 'odp', 'zip', 'rar', '7z', 'tar', 'gz', 'apk']);

              if (result.isNotEmpty) {
                widget.setUploading(true);

                for (var file in result) {
                  if (file.path == null) continue;

                  final documentFile = File(file.path!);
                  await widget.chatTarget.sendDocument(documentFile);
                }

                widget.setUploading(false);
              }

              Navigator.pop(context);
            },
          ),
          _buildIconButton(
            context,
            icon: Icon(Icons.location_on, color: ChatifyColors.blueGreen, size: 24),
            label: 'Геопозиция',
            onTap: () {
              Navigator.pop(context);
              showAddGeolocationDialog(context);
            },
          ),
          _buildIconButton(
            context,
            icon: Icon(Icons.headphones, color: ChatifyColors.orange, size: 24),
            label: S.of(context).audio,
            onTap: () async {
              final result = await FilePicker.pickFiles(type: FileType.custom, allowedExtensions: ['mp3', 'aac', 'm4a', 'wav', 'ogg', 'opus', 'flac', 'wma', 'aiff', 'alac']);

              if (result.isNotEmpty) {
                widget.setUploading(true);
                for (var file in result) {
                  final documentFile = File(file.path!);
                  final originalFileName = file.name;
                  final audioDuration = await getAudioDuration(documentFile);

                  await widget.chatTarget.sendAudio(documentFile, originalFileName, audioDuration: audioDuration);
                }
                widget.setUploading(false);
              }
              Navigator.pop(context);
            },
          ),
          _buildIconButton(
            context,
            icon: Icon(Icons.person, color: ChatifyColors.lightBlue, size: 24),
            label: S.of(context).contact,
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, createPageRoute(const ContactsSendingScreen(selectedUsers: [])));
            },
          ),
          _buildIconButton(
            context,
            icon: SvgPicture.asset(ChatifyVectors.list, width: 24, height: 24, colorFilter: ColorFilter.mode(ChatifyColors.green, BlendMode.srcIn)),
            label: S.of(context).survey,
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, createPageRoute(CreateSurveyScreen(user: widget.user)));
            },
          ),
          _buildIconButton(
            context,
            icon: SvgPicture.asset(ChatifyVectors.calendarEvent, width: 24, height: 24, colorFilter: ColorFilter.mode(ChatifyColors.violet, BlendMode.srcIn)),
            label: S.of(context).events,
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, createPageRoute(CreateEventScreen(user: widget.user)));
            },
          ),
        ],
      ),
    );
  }

  Widget _buildIconButton(BuildContext context, {required Widget icon, required String label, required VoidCallback onTap}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: 68,
            height: 32,
            decoration: BoxDecoration(
              color: ChatifyColors.transparent,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: context.isDarkMode ? ChatifyColors.softNight : ChatifyColors.grey, width: 1),
            ),
            child: Center(child: Padding(padding: const EdgeInsets.all(4), child: icon)),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: TextStyle(color: ChatifyColors.darkGrey, fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w400),
        ),
      ],
    );
  }

  Widget _buildBottomPanelSend() {
    if (_selectedAssets.isEmpty) {
      return const SizedBox.shrink();
    }

    final previewAsset = _selectedAssets.first;

    return Container(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
      decoration: BoxDecoration(
        color: context.isDarkMode ? ChatifyColors.nightGrey : ChatifyColors.softGrey,
        border: Border(top: BorderSide(color: context.isDarkMode ? ChatifyColors.steelGrey.withAlpha(40) : ChatifyColors.grey)),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            _buildSelectedImagePreview(previewAsset),
            const SizedBox(width: 8),
            Expanded(
              child: Container(
                constraints: const BoxConstraints(minHeight: 48, maxHeight: 120),
                decoration: BoxDecoration(
                  color: context.isDarkMode ? ChatifyColors.youngNight : ChatifyColors.white,
                  borderRadius: BorderRadius.circular(22),
                ),
                child: TextSelectionTheme(
                  data: TextSelectionThemeData(
                    cursorColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                    selectionColor: colorsController.getColor(colorsController.selectedColorScheme.value).withAlpha((0.3 * 255).toInt()),
                    selectionHandleColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                  ),
                  child: TextField(
                    controller: _captionController,
                    focusNode: _captionFocusNode,
                    minLines: 1,
                    maxLines: 5,
                    textInputAction: TextInputAction.newline,
                    style: TextStyle(color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black, fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400),
                    decoration: InputDecoration(
                      hintText: 'Добавить подпись...',
                      hintStyle: TextStyle(color: ChatifyColors.darkGrey, fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400),
                      border: InputBorder.none,
                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(45), borderSide: BorderSide.none),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(45), borderSide: BorderSide.none),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            SendButton(isTyping: false, isMediaMode: true, selectedCount: _selectedAssets.length, sendMessage: _sendSelectedMedia),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectedImagePreview(AssetEntity asset) {
    return GestureDetector(
      onTap: () => _openImageEditor(asset),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: SizedBox(
              width: 48,
              height: 48,
              child: AssetEntityImage(asset, isOriginal: false, thumbnailSize: const ThumbnailSize(120, 120), fit: BoxFit.cover),
            ),
          ),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                color: ChatifyColors.black.withAlpha(90),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: context.isDarkMode ? ChatifyColors.black.withAlpha((0.8 * 255).toInt()) : ChatifyColors.grey, width: 1),
              ),
              child: const Center(child: Icon(Icons.edit_outlined, size: 20, color: ChatifyColors.white)),
            ),
          ),
        ],
      ),
    );
  }
}
