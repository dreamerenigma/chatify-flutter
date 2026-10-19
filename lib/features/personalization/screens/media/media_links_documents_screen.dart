import 'dart:developer';
import 'package:chatify/features/utils/widgets/scrolls/no_glow_scroll_behavior.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/context_extensions.dart';
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as img;
import '../../../../api/chat_api.dart';
import '../../../../core/enums/chat_media_type.dart';
import '../../../../generated/l10n/l10n.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../widgets/dialogs/light_dialog.dart';
import '../../widgets/items/chat_media_item.dart';
import '../../widgets/media/chat_media_preview.dart';

class MediaLinksDocumentsScreen extends StatefulWidget {
  final String userId;

  const MediaLinksDocumentsScreen({
    super.key,
    required this.userId,
  });

  @override
  State<MediaLinksDocumentsScreen> createState() => _MediaLinksDocumentsScreenState();
}

class _MediaLinksDocumentsScreenState extends State<MediaLinksDocumentsScreen> with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  late final PageController _pageController;
  late final Stream<List<ChatMediaItem>> _mediaStream;
  final Set<String> _failedImageIds = {};

  String _getMediaPeriodTitle(DateTime date) {
    final now = DateTime.now();
    final currentMonth = DateTime(now.year, now.month);
    final mediaMonth = DateTime(date.year, date.month);
    final difference = now.difference(date);

    if (!date.isAfter(now)) {
      if (difference.inDays < 7 && date.year == now.year && date.month == now.month) {
        return 'НЕДАВНО';
      }
    } else if (date.year == now.year && date.month == now.month) {
      return 'НЕДАВНО';
    }

    final previousMonth = DateTime(currentMonth.year, currentMonth.month - 1);

    if (mediaMonth == previousMonth) {
      return 'В ПРОШЛОМ МЕСЯЦЕ';
    }

    const months = [
      'ЯНВАРЬ',
      'ФЕВРАЛЬ',
      'МАРТ',
      'АПРЕЛЬ',
      'МАЙ',
      'ИЮНЬ',
      'ИЮЛЬ',
      'АВГУСТ',
      'СЕНТЯБРЬ',
      'ОКТЯБРЬ',
      'НОЯБРЬ',
      'ДЕКАБРЬ',
    ];

    return '${months[date.month - 1]} ${date.year}';
  }

  Stream<List<ChatMediaItem>> _getMediaStream() {
    final conversationId = ChatApi.getConversationId(widget.userId);

    log('[MEDIA SOURCE] conversationId=$conversationId');

    return FirebaseFirestore.instance.collection('Chats').doc(conversationId).collection('messages').orderBy('sent', descending: true).snapshots().asyncMap((snapshot) async {
      final items = <ChatMediaItem>[];

      for (final doc in snapshot.docs) {
        final data = doc.data();

        if ((data['type'] ?? '').toString().toLowerCase() == 'video') {
          log('[MEDIA FIRESTORE] ''document=${doc.reference.path}, ''duration=${data['duration']}, ''durationType=${data['duration']?.runtimeType}, ''fields=${data.keys.toList()}');
        }

        final rawType = (data['type'] ?? '').toString().toLowerCase();
        final rawPath = data['msg'] ?? data['path'] ?? data['url'];
        final path = rawPath?.toString() ?? '';

        if (path.isEmpty) continue;

        ChatMediaType? mediaType;

        switch (rawType) {
          case 'image':
          case 'photo':
            mediaType = ChatMediaType.image;
            break;
          case 'video':
          case 'videomessage':
          case 'video_message':
            mediaType = ChatMediaType.video;
            break;
          case 'audio':
          case 'voice':
          case 'voicemessage':
          case 'voice_message':
            mediaType = ChatMediaType.audio;
            break;
          case 'document':
          case 'file':
            mediaType = ChatMediaType.document;
            break;
        }

        if (mediaType == null) continue;

        final uri = Uri.tryParse(path);
        final filePath = uri?.path.toLowerCase() ?? path.toLowerCase();

        if (mediaType == ChatMediaType.image && (filePath.endsWith('.gif') ||
                (data['fileName']?.toString().toLowerCase().endsWith('.gif') ?? false) ||
                (data['file_name']?.toString().toLowerCase().endsWith('.gif') ?? false))) {
          continue;
        }

        final sent = data['sent'];
        if (sent is! Timestamp) continue;

        final rawDuration = data['duration'] ?? data['videoDuration'];
        final int? duration = rawDuration is num ? rawDuration.toInt() : rawDuration is String ? int.tryParse(rawDuration) : null;

        items.add(
          ChatMediaItem(
            messageId: doc.id,
            type: mediaType,
            path: path,
            sent: sent,
            fileName: data['fileName']?.toString() ?? data['file_name']?.toString(),
            fileSize: data['fileSize']?.toString() ?? data['file_size']?.toString(),
            duration: duration,
            thumbnail: data['thumbnail']?.toString(),
          ),
        );
      }

      return items;
    });
  }

  @override
  void initState() {
    super.initState();
    _mediaStream = _getMediaStream();
    _tabController = TabController(length: 3, vsync: this);
    _pageController = PageController();
    _tabController.addListener(_onTabChanged);
  }

  @override
  void dispose() {
    _tabController.removeListener(_onTabChanged);
    _tabController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _onTabChanged() {
    if (_tabController.indexIsChanging) {
      _pageController.animateToPage(_tabController.index, duration: const Duration(milliseconds: 250), curve: Curves.easeInOut);
    }
  }

  void _onPageChanged(int index) {
    if (_tabController.index != index) {
      _tabController.animateTo(index);
    }
  }

  void _onImageError(String messageId) {
    if (!mounted || _failedImageIds.contains(messageId)) return;
    setState(() { _failedImageIds.add(messageId); });
  }

  Future<bool> isValidImage(String path) async {
    try {
      final uri = Uri.tryParse(path);

      if (uri == null || !uri.hasScheme || !(uri.scheme == 'http' || uri.scheme == 'https')) {
        return false;
      }

      final response = await http.get(uri).timeout(const Duration(seconds: 10));

      log('[ImageCheck] URL: $path');
      log('[ImageCheck] Status: ${response.statusCode}');
      log('[ImageCheck] Content-Type: ${response.headers['content-type']}');
      log('[ImageCheck] Bytes: ${response.bodyBytes.length}');

      if (response.statusCode != 200 || response.bodyBytes.isEmpty) {
        return false;
      }

      final decoded = img.decodeImage(response.bodyBytes);
      log('[ImageCheck] Decoded: ${decoded != null}');

      return decoded != null && decoded.width > 0 && decoded.height > 0;
    } catch (_) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight + 48),
        child: Container(
          decoration: BoxDecoration(
            color: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.white,
            boxShadow: [BoxShadow(color: ChatifyColors.black.withAlpha((0.1 * 255).toInt()), spreadRadius: 1, blurRadius: 3, offset: const Offset(0, 1))],
          ),
          child: Column(
            children: [
              AppBar(
                title: Text(S.of(context).allMedia, style: TextStyle(fontSize: ChatifySizes.fontSizeMg, fontWeight: FontWeight.w400)),
                titleSpacing: 0,
                backgroundColor: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.white,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back_rounded, size: 25),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                actions: [
                  IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () {},
                  ),
                ],
              ),
              TabBar(
                controller: _tabController,
                isScrollable: false,
                indicatorColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                labelColor: ChatifyColors.white,
                splashFactory: NoSplash.splashFactory,
                unselectedLabelColor: ChatifyColors.darkGrey.withValues(alpha: 0.7),
                indicatorSize: TabBarIndicatorSize.tab,
                overlayColor: WidgetStateProperty.all(ChatifyColors.softNight),
                dividerColor: ChatifyColors.transparent,
                tabs: const [
                  Tab(text: 'Медиа'),
                  Tab(text: 'Документы'),
                  Tab(text: 'Ссылки'),
                ],
              ),
            ],
          ),
        ),
      ),
      body: ScrollConfiguration(
        behavior: NoGlowScrollBehavior(),
        child: PageView(
          controller: _pageController,
          onPageChanged: _onPageChanged,
          children: [
            _buildMediaPage(),
            _buildDocumentsPage(),
            _buildLinksPage(),
          ],
        ),
      ),
    );
  }

  Widget _buildMediaPage() {
    return StreamBuilder<List<ChatMediaItem>>(
      stream: _mediaStream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text('Не удалось загрузить медиа.'));
        }

        if (snapshot.connectionState == ConnectionState.waiting && !snapshot.hasData) {
          return Center(child:  CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(colorsController.getColor(colorsController.selectedColorScheme.value)), strokeWidth: 3));
        }

        final mediaItems = (snapshot.data ?? []).where((item) {
          final isMedia = item.type == ChatMediaType.image || item.type == ChatMediaType.video;

          if (!isMedia) return false;

          if (item.type == ChatMediaType.image && _failedImageIds.contains(item.messageId)) {
            return false;
          }

          return true;
        }).toList();

        final groupedMedia = <String, List<ChatMediaItem>>{};

        for (final item in mediaItems) {
          final title = _getMediaPeriodTitle(item.sent.toDate());

          groupedMedia.putIfAbsent(title, () => []).add(item);
        }

        if (mediaItems.isEmpty) {
          return Center(child: Text('Медиа не найдены.', style: TextStyle(fontSize: ChatifySizes.fontSizeXl, fontWeight: FontWeight.w400, color: ChatifyColors.darkGrey)));
        }

        return ListView(
          padding: const EdgeInsets.all(2),
          children: groupedMedia.entries.map((entry) {
            final title = entry.key;
            final items = entry.value;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 16, 8, 8),
                  child: Text(title, style: TextStyle(fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w600, color: ChatifyColors.darkGrey)),
                ),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.zero,
                  itemCount: items.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 2, mainAxisSpacing: 2, childAspectRatio: 1),
                  itemBuilder: (context, index) {
                    final media = items[index];

                    return GestureDetector(onTap: () {}, child: ChatMediaPreview(key: ValueKey(media.messageId), media: media, borderRadius: 2, onImageError: _onImageError));
                  },
                ),
              ],
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildDocumentsPage() {
    return Center(child: Text('Документы не найдены.', style: TextStyle(fontSize: ChatifySizes.fontSizeXl, fontWeight: FontWeight.w400)));
  }

  Widget _buildLinksPage() {
    return Center(child: Text('Ссылки не найдены.', style: TextStyle(fontSize: ChatifySizes.fontSizeXl, fontWeight: FontWeight.w400)));
  }
}
