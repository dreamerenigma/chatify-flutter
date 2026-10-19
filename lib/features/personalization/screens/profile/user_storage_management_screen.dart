import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatify/features/utils/widgets/scrolls/no_glow_scroll_behavior.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_utils/src/extensions/context_extensions.dart';
import '../../../../api/apis.dart';
import '../../../../api/chat_api.dart';
import '../../../../core/enums/chat_media_type.dart';
import '../../../../core/enums/message_type.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../../utils/constants/app_vectors.dart';
import '../../../chat/models/message_model.dart';
import '../../../chat/models/user_model.dart';
import '../../../home/widgets/checkboxes/custom_checkbox.dart';
import '../../widgets/dialogs/light_dialog.dart';
import '../../widgets/dialogs/sort_bottom_sheet_dialog.dart';
import '../../widgets/items/chat_media_item.dart';
import '../../widgets/media/chat_media_preview.dart';

class UserStorageManagementScreen extends StatefulWidget {
  final UserModel user;
  final Stream<List<ChatMediaItem>> mediaStream;
  final ValueChanged<String>? onTotalSizeChanged;

  const UserStorageManagementScreen({
    super.key,
    required this.user,
    required this.mediaStream,
    this.onTotalSizeChanged,
  });

  @override
  State<UserStorageManagementScreen> createState() => _UserStorageManagementScreenState();
}

class _UserStorageManagementScreenState extends State<UserStorageManagementScreen> {
  final Set<String> _failedImageIds = {};
  final Set<String> _selectedMediaIds = {};
  final RxList<bool> _selectAllOptions = <bool>[false].obs;
  late final Stream<List<ChatMediaItem>> _localMediaStream;
  String? _profileImageUrl;
  String _totalSize = '0 B';
  bool isLoadingProfileImage = false;

  bool get _isSelectionMode => _selectedMediaIds.isNotEmpty;

  int _sizeInBytes(String? value) {
    if (value == null || value.trim().isEmpty) return 0;

    final normalized = value.trim().replaceAll(',', '.');
    final match = RegExp(r'^([\d.]+)\s*(B|KB|MB|GB)?$', caseSensitive: false).firstMatch(normalized);

    if (match == null) return 0;

    final number = double.tryParse(match.group(1)!);
    if (number == null) return 0;

    final unit = (match.group(2) ?? 'B').toUpperCase();

    final multiplier = switch (unit) {
      'KB' => 1024.0,
      'MB' => 1024.0 * 1024,
      'GB' => 1024.0 * 1024 * 1024,
      _ => 1.0,
    };

    return (number * multiplier).round();
  }

  String _formatFileSize(int bytes) {
    if (bytes >= 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
    }
    if (bytes >= 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
    if (bytes >= 1024) {
      return '${(bytes / 1024).toStringAsFixed(1)} KB';
    }
    return '$bytes B';
  }

  int _getTotalSize(List<ChatMediaItem> media) {
    return media.fold<int>(0, (total, item) => total + _sizeInBytes(item.fileSize));
  }

  String _formatTotalSize(List<ChatMediaItem> media) {
    final totalBytes = _getTotalSize(media);

    return _formatFileSize(totalBytes);
  }

  ChatMediaItem? _createMediaItem(MessageModel message) {
    switch (message.type) {
      case MessageType.image:
        return ChatMediaItem(messageId: message.id, type: ChatMediaType.image, path: message.msg, sent: message.sent, fileSize: message.fileSize);
      case MessageType.video:
        return ChatMediaItem(messageId: message.id, type: ChatMediaType.video, path: message.msg, sent: message.sent, duration: message.videoDuration, fileSize: message.fileSize);
      case MessageType.audio:
        return ChatMediaItem(messageId: message.id, type: ChatMediaType.audio, path: message.msg, sent: message.sent, duration: message.audioDuration, fileSize: message.fileSize);
      case MessageType.document:
        return ChatMediaItem(messageId: message.id, type: ChatMediaType.document, path: message.msg, fileName: message.documentName, fileSize: message.fileSize, sent: message.sent);
      default:
        return null;
    }
  }

  @override
  void initState() {
    super.initState();
    final conversationId =
    ChatApi.getConversationId(widget.user.id);

    _localMediaStream = APIs.firestore.collection('Chats').doc(conversationId).collection('messages').orderBy('sent', descending: true).snapshots().map((snapshot) {
      final result = <ChatMediaItem>[];

      for (final doc in snapshot.docs) {
        try {
          final message = MessageModel.fromJson(doc.data(), id: doc.id);
          final item = _createMediaItem(message);

          if (item != null) {
            result.add(item);
          }
        } catch (e) {
          log('[STORAGE PARSE ERROR] ${doc.id}: $e');
        }
      }

      log('[LOCAL STORAGE STREAM] media=${result.length}');
      return result;
    });
    _loadProfileImage();
  }

  void _toggleSelection(ChatMediaItem item) {
    setState(() {
      if (_selectedMediaIds.contains(item.messageId)) {
        _selectedMediaIds.remove(item.messageId);
      } else {
        _selectedMediaIds.add(item.messageId);
      }
    });
  }

  void _selectAll(List<ChatMediaItem> media, bool selectAll) {
    setState(() {
      if (selectAll) {
        _selectedMediaIds..clear()..addAll(media.map((item) => item.messageId));
      } else {
        _selectedMediaIds.clear();
      }
    });

    _selectAllOptions[0] = selectAll;
  }

  void _clearSelection() {
    setState(() {
      _selectedMediaIds.clear();
    });
  }

  void _onImageError(String messageId) {
    if (!mounted || _failedImageIds.contains(messageId)) return;

    setState(() {
      _failedImageIds.add(messageId);
      _selectedMediaIds.remove(messageId);
    });
  }

  Future<void> _loadProfileImage() async {
    final imagePath = widget.user.image.trim();

    if (imagePath.isEmpty) {
      return;
    }

    if (mounted) {
      setState(() {
        isLoadingProfileImage = true;
      });
    }

    try {
      final url = await APIs.getMediaUrl(imagePath);

      if (!mounted) return;

      setState(() {
        _profileImageUrl = url;
        isLoadingProfileImage = false;
      });
    } catch (e, stackTrace) {
      log('PROFILE IMAGE URL ERROR: $e', stackTrace: stackTrace);

      if (!mounted) return;

      setState(() {
        _profileImageUrl = null;
        isLoadingProfileImage = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration: BoxDecoration(
            color: ChatifyColors.white,
            boxShadow: [BoxShadow(color: ChatifyColors.black.withAlpha((0.1 * 255).toInt()), spreadRadius: 1, blurRadius: 3, offset: const Offset(0, 1))],
          ),
          child: AppBar(
            titleSpacing: 0,
            elevation: 0,
            backgroundColor: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.white,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_rounded, size: 25),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            title: Row(
              children: [
                if (_isSelectionMode)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${_selectedMediaIds.length}',
                        style: TextStyle(color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black, fontSize: 19, fontWeight: FontWeight.w400),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _totalSize,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: ChatifyColors.borderSecondary, fontSize: 13, fontWeight: FontWeight.w400),
                      ),
                    ],
                  )
                else ...[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(21),
                    child: CachedNetworkImage(
                      imageUrl: _profileImageUrl ?? '',
                      width: 38,
                      height: 38,
                      fit: BoxFit.cover,
                      errorWidget: (context, url, error) {
                        return CircleAvatar(
                          backgroundColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                          child: SvgPicture.asset(ChatifyVectors.profile, width: 42, height: 42),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.user.username.trim().isNotEmpty ? '@${widget.user.username}' : '${widget.user.name} ${widget.user.surname}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black, fontSize: ChatifySizes.fontSizeLg, fontWeight: FontWeight.w400),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          _totalSize,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: ChatifyColors.darkGrey, fontSize: 15, fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
            actions: [
              if (_isSelectionMode) ...[
                IconButton(
                  tooltip: 'Отменить выбор',
                  onPressed: _clearSelection,
                  icon: const Icon(Icons.star_border_outlined, size: 23),
                ),
                SizedBox(width: 4),
                IconButton(
                  tooltip: 'Удалить выбранное',
                  onPressed: () {},
                  icon: const Icon(FluentIcons.delete_24_regular, size: 23),
                ),
              ] else
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: GestureDetector(
                    onTap: () {
                      showSortBottomSheetDialog(context);
                    },
                    child: SvgPicture.asset(
                      ChatifyVectors.sort,
                      width: 22,
                      height: 22,
                      colorFilter: ColorFilter.mode(context.isDarkMode ? ChatifyColors.white : ChatifyColors.black, BlendMode.srcIn),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
      body: StreamBuilder<List<ChatMediaItem>>(
        stream: _localMediaStream,
        builder: (context, snapshot) {
          final media = snapshot.data ?? <ChatMediaItem>[];
          final totalSize = _formatTotalSize(media);

          final availableMedia = media.where((item) {
            return item.path.trim().isNotEmpty && !_failedImageIds.contains(item.messageId);
          }).toList();

          if (_totalSize != totalSize) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (!mounted || _totalSize == totalSize) return;

              setState(() {
                _totalSize = totalSize;
              });

              widget.onTotalSizeChanged?.call(totalSize);
            });
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Не удалось загрузить медиа'));
          }

          if (snapshot.connectionState == ConnectionState.waiting && media.isEmpty) {
            return Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(colorsController.getColor(colorsController.selectedColorScheme.value)), strokeWidth: 3));
          }

          if (media.isEmpty) {
            return const Center(child: Text('Нет медиафайлов'));
          }

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                child: Row(
                  children: [
                    Text('РАЗМЕР', style: TextStyle(color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black, fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w500)),
                    const Spacer(),
                    Text('Выбрать все', style: TextStyle(color: ChatifyColors.darkGrey, fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w400)),
                    const SizedBox(width: 8),
                    SizedBox(
                      width: 20,
                      height: 20,
                      child: CustomCheckbox(
                        selectedOptions: _selectAllOptions,
                        index: 0,
                        onChanged: (value) {
                          _selectAll(media, value);
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ScrollConfiguration(
                  behavior: NoGlowScrollBehavior(),
                  child: GridView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: availableMedia.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 2, mainAxisSpacing: 2, childAspectRatio: 1),
                    itemBuilder: (context, index) {
                      final item = availableMedia[index];
                      final isSelected = _selectedMediaIds.contains(item.messageId);

                      return Stack(
                        fit: StackFit.expand,
                        children: [
                          ChatMediaPreview(media: item, borderRadius: 0, onImageError: _onImageError),
                          Material(color: ChatifyColors.transparent, child: InkWell(onTap: () => _toggleSelection(item))),
                          if (item.fileSize != null && item.fileSize!.isNotEmpty)
                            Positioned(
                              right: 0,
                              top: 0,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                                child: Text(_formatFileSize(_sizeInBytes(item.fileSize)), style: TextStyle(color: ChatifyColors.white, fontSize: 13, fontWeight: FontWeight.w400)),
                              ),
                            ),
                          if (isSelected)
                            Positioned.fill(
                              child: Container(
                                color: ChatifyColors.black.withAlpha(70),
                                alignment: Alignment.center,
                                padding: const EdgeInsets.all(6),
                                child: const Icon(Icons.check_rounded, size: 28, color: ChatifyColors.white),
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
