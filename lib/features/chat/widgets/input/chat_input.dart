import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatify/features/chat/models/message_model.dart';
import 'package:chatify/features/utils/widgets/scrolls/no_glow_scroll_behavior.dart';
import 'package:chatify/utils/constants/app_vectors.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../../../../api/apis.dart';
import '../../../../../generated/l10n/l10n.dart';
import '../../../../../utils/constants/app_colors.dart';
import '../../../../../utils/constants/app_sizes.dart';
import '../../../../../utils/constants/app_sounds.dart';
import '../../../../../utils/popups/dialogs.dart';
import '../../../../api/chat_api.dart';
import '../../../../config/config.dart' as app_config;
import '../../../../core/enums/message_bubble_type.dart';
import '../../../../core/enums/message_type.dart';
import '../../../../core/services/links/link_preview_service.dart';
import '../../../../domain/entities/chat_target.dart';
import '../../../../routes/custom_page_route.dart';
import '../../../../utils/constants/app_links.dart';
import '../../../personalization/widgets/dialogs/light_dialog.dart';
import '../../controllers/mention_text_editing_controller.dart';
import '../../models/link_preview_model.dart';
import '../../models/mention_data_model.dart';
import '../../models/user_model.dart';
import '../../screens/stickers_screen.dart';
import '../bars/emoji_mode_bottom_bar.dart';
import '../dialogs/voice_record_bottom_sheet_dialog.dart';
import '../image/gif_gallery.dart';
import 'buttons/camera_button.dart';
import 'buttons/chat_input_attachments_button.dart';

class ChatInput extends StatefulWidget {
  final UserModel user;
  final ChatTarget chatTarget;
  final MessageBubbleType type;
  final FocusNode focusNode;
  final VoidCallback onToggleEmojiKeyboard;
  final bool isReplyVisible;
  final bool isPressed;
  final Future<void> Function(String text, List<MentionDataModel> mentions) onSendMessage;
  final MessageModel? replyMessage;
  final UserModel? replyUser;
  final VoidCallback onClearReply;

  const ChatInput({
    super.key,
    required this.user,
    required this.chatTarget,
    required this.type,
    required this.focusNode,
    required this.onToggleEmojiKeyboard,
    required this.isReplyVisible,
    required this.isPressed,
    required this.onSendMessage,
    required this.replyMessage,
    required this.replyUser,
    required this.onClearReply,
  });

  @override
  ChatInputState createState() => ChatInputState();
}

class ChatInputState extends State<ChatInput> {
  final PageController emojiPageController = PageController();
  final textController = MentionTextEditingController();
  final LinkPreviewService _linkPreviewService = LinkPreviewService();
  final AudioPlayer audioPlayer = AudioPlayer();
  final Map<String, String> mentionAvatarUrls = {};
  final List<MentionDataModel> mentions = [];
  final Map<String, String> stickerPackPreviews = {};
  late final ValueChanged<bool> setUploading;
  bool showEmoji = false;
  bool isUploading = false;
  bool sendWithEnter = false;
  bool isTyping = false;
  bool showVideoToast = false;
  bool isLoadingLinkPreview = false;
  bool showMentionUsers = false;
  bool isLoadingProfileImage = false;
  bool isLoadingStickers = false;
  int selectedEmojiMode = 0;
  int selectedStickerPack = 0;
  String? stickerError;
  double _dragOffset = 0;
  double _emojiDragOffset = 0;
  String? _previewUrl;
  String mentionQuery = '';
  Timer? typingTimer;
  Timer? linkPreviewDebounce;
  UserModel? replyUser;
  List<MessageModel> list = [];
  List<UserModel> mentionUsers = [];
  List<UserModel> filteredMentionUsers = [];
  List<Map<String, dynamic>> stickers = [];
  LinkPreviewModel? _linkPreview;

  bool get hasText => textController.text.trim().isNotEmpty;

  ChatTarget get chatTarget => widget.chatTarget;

  final List<Map<String, String>> stickerPacks = [
    // GIPHY
    {'name': 'Популярные', 'query': ''},
    {'name': 'Реакции', 'query': 'reactions stickers'},
    {'name': 'Смешные', 'query': 'funny stickers'},
    {'name': 'Любовь', 'query': 'love stickers'},
    {'name': 'Животные', 'query': 'cute animals stickers'},
    // Яндекс Диск
    {'name': 'Akane', 'packId': 'akane_stikers_stickersgg_pack', 'source': 'yandex'},
    {'name': 'Ekocane', 'packId': 'ekocane_stickersgg_pack', 'source': 'yandex'},
    {'name': 'Kawaii', 'packId': 'kawaii_stickersgg_pack', 'source': 'yandex'},
    {'name': 'Wumpus', 'packId': 'wumpus_stickersgg_pack', 'source': 'yandex'},
  ];

  String? _extractUrl(String text) {
    final regex = RegExp(r'https?://\S+', caseSensitive: false);
    final match = regex.firstMatch(text);

    if (match == null) {
      return null;
    }

    return match.group(0);
  }

  String _formatPreviewUrl(String url) {
    final uri = Uri.tryParse(url);

    if (uri == null) {
      return url;
    }

    var host = uri.host;

    if (host.startsWith('www.')) {
      host = host.substring(4);
    }

    return host;
  }

  String? _getStickerPackPreview(int index) {
    if (index < 0 || index >= stickerPacks.length) {
      return null;
    }

    final pack = stickerPacks[index];

    if (pack['source'] == 'yandex') {
      final packId = pack['packId'];
      if (packId == null) return null;

      return stickerPackPreviews[packId];

    }
    final name = pack['name'];
    if (name == null) return null;

    return stickerPackPreviews[name];
  }

  bool _isValidPreviewUrl(String url) {
    final uri = Uri.tryParse(url);

    if (uri == null) {
      return false;
    }

    if (uri.scheme != 'http' && uri.scheme != 'https') {
      return false;
    }

    if (uri.host.isEmpty) {
      return false;
    }

    if (!uri.host.contains('.')) {
      return false;
    }

    final parts = uri.host.split('.');

    if (parts.length < 2) {
      return false;
    }

    final tld = parts.last;

    if (tld.length < 2) {
      return false;
    }

    return true;
  }

  @override
  void initState() {
    super.initState();
    textController.addListener(_handleTyping);
    textController.addListener(_onTextChanged);
    widget.focusNode.addListener(_onFocusChanged);
    _loadMentionUsers();
    _loadStickers();
    _loadStickerPackPreviews();
    _loadYandexStickerPackPreviews();
  }

  @override
  void dispose() {
    textController.removeListener(_handleTyping);
    textController.removeListener(_onTextChanged);
    widget.focusNode.removeListener(_onFocusChanged);
    typingTimer?.cancel();
    textController.dispose();
    emojiPageController.dispose();
    audioPlayer.dispose();
    linkPreviewDebounce?.cancel();
    super.dispose();
  }

  void _onFocusChanged() {
    if (!widget.focusNode.hasFocus) {
      typingTimer?.cancel();

      if (isTyping) {
        isTyping = false;
        APIs.updateTypingStatus(false);
      }
    }
  }

  void toggleEmojiKeyboard() {
    if (showEmoji) {
      widget.focusNode.requestFocus();
    } else {
      widget.focusNode.unfocus();
    }
    setState(() {
      showEmoji = !showEmoji;
    });
  }

  void _handleTyping() {
    final hasTextNow = hasText;

    if (!hasTextNow) {
      typingTimer?.cancel();

      if (isTyping) {
        isTyping = false;
        APIs.updateTypingStatus(false);
      }

      if (mounted) {
        setState(() {});
      }

      return;
    }

    if (!isTyping) {
      isTyping = true;
      APIs.updateTypingStatus(true);
    }

    typingTimer?.cancel();

    typingTimer = Timer(
      const Duration(seconds: 3), () {
      if (!isTyping) return;

      isTyping = false;
      APIs.updateTypingStatus(false);

      if (mounted) {
        setState(() {});
      }
    });

    if (mounted) {
      setState(() {});
    }
  }

  void _onTextChanged() {
    _cleanupMentions();
    _updateMentionQuery(textController.text);

    final text = textController.text.trim();

    linkPreviewDebounce?.cancel();

    final url = _extractUrl(text);

    if (url == null) {
      if (_linkPreview != null || _previewUrl != null || isLoadingLinkPreview) {
        setState(() {
          _linkPreview = null;
          _previewUrl = null;
          isLoadingLinkPreview = false;
        });
      }

      setState(() {});
      return;
    }

    if (url == _previewUrl && _linkPreview != null) {
      return;
    }

    if (url != _previewUrl) {
      setState(() {
        _linkPreview = null;
        _previewUrl = url;
        isLoadingLinkPreview = false;
      });
    }

    if (!_isValidPreviewUrl(url)) {
      return;
    }

    linkPreviewDebounce = Timer(const Duration(milliseconds: 700), () => _loadLinkPreview(url));

    setState(() {
      isLoadingLinkPreview = true;
    });
  }

  void _removeLinkPreview() {
    setState(() {
      _linkPreview = null;
      _previewUrl = null;
      isLoadingLinkPreview = false;
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      widget.focusNode.requestFocus();
    });
  }

  void _updateMentionQuery(String text) {
    final selection = textController.selection;

    if (!selection.isValid || selection.baseOffset <= 0) {
      setState(() {
        showMentionUsers = false;
        mentionQuery = '';
      });
      return;
    }

    final cursorPosition = selection.baseOffset;
    final textBeforeCursor = text.substring(0, cursorPosition);
    final match = RegExp(r'@([a-zA-Zа-яА-ЯёЁ0-9_]*)$').firstMatch(textBeforeCursor);

    if (match == null) {
      setState(() {
        showMentionUsers = false;
        mentionQuery = '';
      });
      return;
    }

    final query = match.group(1) ?? '';

    setState(() {
      mentionQuery = query;
      showMentionUsers = true;
    });

    _filterMentionUsers(query);
  }

  void _filterMentionUsers(String query) {
    final normalizedQuery = query.toLowerCase().trim();

    final filtered = mentionUsers.where((user) {
      final name = '${user.name} ${user.surname}'.toLowerCase();
      final username = user.username.toLowerCase();

      return normalizedQuery.isEmpty || name.contains(normalizedQuery) || username.contains(normalizedQuery);
    }).toList();

    setState(() {
      filteredMentionUsers = filtered;
    });
  }

  void _selectMentionUser(UserModel user) {
    final text = textController.text;
    final cursorPosition = textController.selection.baseOffset;

    if (cursorPosition < 0) return;

    final textBeforeCursor = text.substring(0, cursorPosition);
    final match = RegExp(r'@([a-zA-Zа-яА-ЯёЁ0-9_]*)$').firstMatch(textBeforeCursor);

    if (match == null) return;

    final start = match.start;
    final mentionText = '${user.name} ${user.surname}'.trim();
    final newText = '${text.substring(0, start)}''$mentionText ''${text.substring(cursorPosition)}';

    final mentionStart = start;
    final mentionEnd = start + mentionText.length;
    final newCursorPosition = mentionEnd + 1;

    textController.value = TextEditingValue(text: newText, selection: TextSelection.collapsed(offset: newCursorPosition));

    final mention = MentionDataModel(userId: user.id, text: mentionText, start: mentionStart, end: mentionEnd);

    setState(() {
      mentions.add(mention);
      (textController).mentions = List.from(mentions);
      showMentionUsers = false;
      mentionQuery = '';

      log('SELECTED MENTIONS: ${mentions.map((m) => m.toJson()).toList()}');
      log('CONTROLLER MENTIONS: ${textController.mentions.map((m) => m.toJson()).toList()}');
    });
  }

  void _cleanupMentions() {
    final text = textController.text;

    mentions.removeWhere((mention) {
      if (mention.start < 0 || mention.end > text.length) {
        return true;
      }

      final currentText = text.substring(mention.start, mention.end);

      return currentText != mention.text;
    });

    (textController).mentions = List.from(mentions);
  }

  void _closeEmojiPanel() {
    setState(() {
      showEmoji = false;
      _emojiDragOffset = 0;
    });
  }

  void _openStickerSearch() {

  }

  void _openFavoriteStickers() {
    Get.rawSnackbar(
      messageText: const Text('Нажмите и удерживайте стикер, чтобы добавить его в Избранное', style: TextStyle(color: ChatifyColors.white, fontSize: 14)),
      margin: const EdgeInsets.only(bottom: 48),
      snackPosition: SnackPosition.BOTTOM,
      borderRadius: 0,
      backgroundColor: context.isDarkMode ? ChatifyColors.youngNight : ChatifyColors.darkGrey,
      duration: const Duration(seconds: 2),
      animationDuration: const Duration(milliseconds: 200),
    );
  }

  void _createSticker() {

  }

  void _selectStickerPack(int index) {
    final pack = stickerPacks[index];

    setState(() {
      selectedStickerPack = index;
    });

    if (pack['source'] == 'yandex') {
      _loadYandexStickers(pack['packId']!);
    } else {
      _loadStickers(query: pack['query']!);
    }
  }

  Future<void> handleImagePicked(File image) async {
    setState(() => isUploading = true);

    try {
      await widget.chatTarget.sendImage(image);
    } finally {
      if (mounted) {
        setState(() => isUploading = false);
      }
    }
  }

  Future<void> sendGif(File file) async {
    setState(() => isUploading = true);

    try {
      await widget.chatTarget.sendImage(file, replyToMessageId: widget.replyMessage?.id);

      widget.onClearReply();
    } finally {
      if (mounted) {
        setState(() => isUploading = false);
      }
    }
  }

  Future<void> sendVideo(File file) async {
    setState(() => isUploading = true);

    try {
      await widget.chatTarget.sendVideo(file, replyToMessageId: widget.replyMessage?.id);

      widget.onClearReply();
    } finally {
      if (mounted) {
        setState(() => isUploading = false);
      }
    }
  }

  Future<void> playSendSound() async {
    try {
      await audioPlayer.play(AssetSource(ChatifySounds.sendMessage));
    } catch (e) {
      log('${S.of(context).errorPlayingSound}: $e');
    }
  }

  Future<void> sendMessage() async {
    if (!hasText) {
      Dialogs.showSnackbar(context, S.of(context).pleaseEnterTextMessage);

      return;
    }

    final text = textController.text.trim();
    final replyId = widget.replyMessage?.id;
    final messageMentions = List<MentionDataModel>.from(mentions);

    for (final mention in messageMentions) {
      log('Mention: userId=${mention.userId}, ''text=${mention.text}, ''start=${mention.start}, ''end=${mention.end}');
    }

    textController.clear();

    setState(() {
      mentions.clear();
      textController.mentions = [];
    });

    playSendSound();

    if (mounted) {
      setState(() {});
    }

    try {
      await widget.chatTarget.sendText(text, replyToMessageId: replyId, mentions: messageMentions);

      widget.onClearReply();
    } catch (error, stackTrace) {
      log('CHAT INPUT SEND ERROR: $error', stackTrace: stackTrace);
    }
  }

  Future<void> _loadLinkPreview(String url) async {
    if (!_isValidPreviewUrl(url)) {
      return;
    }

    if (_previewUrl != url) {
      return;
    }

    setState(() {
      isLoadingLinkPreview = true;
      _previewUrl = url;
    });

    final preview = await _linkPreviewService.fetchPreview(url);

    if (!mounted) return;

    if (_previewUrl != url) {
      return;
    }

    setState(() {
      _linkPreview = preview;
      isLoadingLinkPreview = false;
    });
  }

  Future<void> _loadMentionUsers() async {
    try {
      final userIds = await APIs.getMyUserIds();
      final users = <UserModel>[];

      for (final userId in userIds) {
        final user = await APIs.getUserById(userId);

        if (user != null) {
          users.add(user);
        }
      }

      for (final user in users) {
        await _loadMentionAvatar(user);
      }

      if (!mounted) return;

      setState(() {
        mentionUsers = users;
        filteredMentionUsers = users;
      });

    } catch (e, stackTrace) {
      log('LOAD MENTION USERS ERROR: $e\n''$stackTrace');
    }
  }

  Future<void> _loadMentionAvatar(UserModel user) async {
    if (user.image.trim().isEmpty) {
      return;
    }

    if (mentionAvatarUrls.containsKey(user.id)) {
      return;
    }

    try {
      final url = await APIs.getMediaUrl(user.image);

      if (url == null || url.isEmpty) {
        return;
      }

      if (!mounted) return;

      setState(() {
        mentionAvatarUrls[user.id] = url;
      });

    } catch (e, stackTrace) {
      log('AVATAR MEDIA ERROR\n''userId: ${user.id}\n''name: ${user.name}\n''image: ${user.image}\n''error: $e\n''$stackTrace');
    }
  }

  Future<void> _loadStickers({String query = ''}) async {
    setState(() {
      isLoadingStickers = true;
      stickerError = null;
    });

    try {
      final isTrending = query.isEmpty;

      final uri = Uri.https(
        'api.giphy.com',
        isTrending ? '/v1/stickers/trending' : '/v1/stickers/search',
        {
          'api_key': app_config.Config.giphyKey,
          'limit': '30',
          'rating': 'g',
          if (!isTrending) 'q': query,
        },
      );

      final response = await http.get(uri);

      if (response.statusCode != 200) {
        throw Exception('Не удалось загрузить стикеры');
      }

      final json = jsonDecode(response.body) as Map<String, dynamic>;
      final data = (json['data'] as List<dynamic>? ?? []);

      if (!mounted) return;

      setState(() {
        stickers = data.whereType<Map<String, dynamic>>().where((item) {
          final images = item['images'] as Map<String, dynamic>?;
          final image = images?['fixed_height'] as Map<String, dynamic>?;

          return image?['url'] != null;
        }).toList();
        isLoadingStickers = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        stickerError = 'Не удалось загрузить стикеры';
        isLoadingStickers = false;
      });
    }
  }

  Future<void> _loadYandexStickers(String packId) async {
    setState(() {
      isLoadingStickers = true;
      stickerError = null;
      stickers = [];
    });

    try {
      final response = await http.get(Uri.parse('${AppLinks.baseUrl}/api/stickers/packs/$packId'));

      if (response.statusCode != 200) {
        throw Exception('Ошибка загрузки стикеров: HTTP ${response.statusCode}');
      }

      final decoded = jsonDecode(response.body);

      if (decoded is! Map<String, dynamic>) {
        throw const FormatException('Ответ сервера не является JSON-объектом');
      }

      final data = decoded['data'];

      if (data is! Map<String, dynamic>) {
        throw const FormatException('Поле data отсутствует или имеет неверный формат');
      }

      final items = data['stickers'];

      if (items is! List) {
        throw const FormatException('Поле data.stickers не является списком');
      }

      final loadedStickers = <Map<String, dynamic>>[];

      for (var i = 0; i < items.length; i++) {
        final item = items[i];

        if (item is! Map) {
          continue;
        }

        final sticker = Map<String, dynamic>.from(item);
        final url = sticker['url'];

        if (url is! String || url.trim().isEmpty) {
          continue;
        }

        loadedStickers.add(sticker);
      }

      if (!mounted) return;

      setState(() {
        stickers = loadedStickers;
        isLoadingStickers = false;
      });

    } catch (e, stackTrace) {
      log('[Stickers] ❌ ERROR: $e');
      log('[Stickers] Stack trace: $stackTrace');

      if (!mounted) return;

      setState(() {
        stickerError = 'Не удалось загрузить стикеры: $e';
        isLoadingStickers = false;
      });
    }
  }

  Future<void> _loadYandexStickerPackPreviews() async {
    try {
      final response = await http.get(Uri.parse('${AppLinks.baseUrl}/api/stickers/packs'));

      if (response.statusCode != 200) {
        return;
      }

      final decoded = jsonDecode(response.body);
      if (decoded is! Map<String, dynamic>) return;

      final data = decoded['data'];
      if (data is! List) return;

      final previews = <String, String>{};

      for (final item in data) {
        if (item is! Map) continue;

        final packId = item['id'];
        final previewUrl = item['previewUrl'];

        if (packId is String && previewUrl is String && previewUrl.isNotEmpty) {
          previews[packId] = previewUrl;
        }
      }

      if (!mounted) return;

      setState(() {
        stickerPackPreviews.addAll(previews);
      });

    } catch (e) {
      log('[Stickers] Preview loading error: $e');
    }
  }

  Future<void> _loadStickerPackPreviews() async {
    for (final pack in stickerPacks) {
      final name = pack['name'] ?? '';
      final query = pack['query'] ?? '';

      try {
        final isTrending = query.isEmpty;
        final uri = Uri.https(
          'api.giphy.com',
          isTrending ? '/v1/stickers/trending' : '/v1/stickers/search',
          {
            'api_key': app_config.Config.giphyKey,
            'limit': '1',
            'rating': 'g',
            if (!isTrending) 'q': query,
          },
        );

        final response = await http.get(uri);

        if (response.statusCode != 200) continue;

        final json = jsonDecode(response.body) as Map<String, dynamic>;
        final data = json['data'] as List<dynamic>? ?? [];

        if (data.isEmpty) continue;

        final sticker = data.first as Map<String, dynamic>;
        final images = sticker['images'] as Map<String, dynamic>?;
        final still = images?['fixed_height_still'] as Map<String, dynamic>?;

        final url = still?['url'] as String?;

        if (url != null && mounted) {
          setState(() {
            stickerPackPreviews[name] = url;
          });
        }
      } catch (e) {
        log('Ошибка превью пака "$name": $e');
      }
    }
  }

  Future<void> _sendSticker(Map<String, dynamic> sticker) async {
    final url = (sticker['url'] as String?)?.trim();

    if (url == null || url.isEmpty) {
      log('Не удалось отправить стикер: URL отсутствует');
      return;
    }

    final filename = sticker['filename'] as String? ?? '';
    final rawFormat = sticker['format'] as String? ?? '';

    final uri = Uri.tryParse(url);
    final extension = filename.contains('.')
      ? filename.split('.').last.toLowerCase() : (uri?.pathSegments.isNotEmpty == true && uri!.pathSegments.last.contains('.'))
      ? uri.pathSegments.last.split('.').last.toLowerCase() : '';

    final format = rawFormat.isNotEmpty ? rawFormat.toLowerCase() : extension;

    if (!{'png', 'gif', 'webp'}.contains(format)) {
      log('Неподдерживаемый формат: $format; ''filename: $filename; url: $url');
      return;
    }

    log('Отправка стикера: format=$format, ''filename=$filename, url=$url');

    await ChatApi.sendChatSticker(widget.user, url);
  }


  @override
  Widget build(BuildContext context) {
    final hasTopContent = widget.isReplyVisible || isLoadingLinkPreview || _linkPreview != null;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (showMentionUsers)
          _buildMentionUsersPanel(context),
        if (_linkPreview != null || isLoadingLinkPreview)
          Padding(
            padding: EdgeInsets.only(left: 8, right: 14, top: widget.isReplyVisible ? 0 : 4),
            child: _buildLinkPreview(context),
          ),
          Padding(
            padding: EdgeInsets.only(left: 8, right: 14, top: (_linkPreview != null || isLoadingLinkPreview || widget.isReplyVisible || showMentionUsers) ? 0 : 4, bottom: 4),
            child: Row(
              children: [
                Expanded(
                  child: Card(
                    elevation: 0,
                    margin: EdgeInsets.only(left: 4, right: 4, top: 0, bottom: 4),
                    color: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(hasTopContent || showMentionUsers ? 0 : 25),
                        topRight: Radius.circular(hasTopContent || showMentionUsers ? 0 : 25),
                        bottomLeft: const Radius.circular(25),
                        bottomRight: const Radius.circular(25),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 2, right: 2),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          IconButton(
                            onPressed: toggleEmojiKeyboard,
                            icon: SvgPicture.asset(ChatifyVectors.emojiSticker, width: 24, height: 24, colorFilter: ColorFilter.mode(ChatifyColors.textSecondary, BlendMode.srcIn)),
                          ),
                          Expanded(
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(minHeight: 50, maxHeight: 120),
                              child: TextSelectionTheme(
                                data: TextSelectionThemeData(
                                  cursorColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                                  selectionColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                                  selectionHandleColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                                ),
                                child: TextField(
                                  controller: textController,
                                  focusNode: widget.focusNode,
                                  autofocus: false,
                                  keyboardType: TextInputType.multiline,
                                  maxLines: null,
                                  cursorColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                                  decoration: InputDecoration(
                                    hintText: S.of(context).message,
                                    hintStyle: TextStyle(color: ChatifyColors.textSecondary, fontSize: ChatifySizes.fontSizeLg, fontWeight: FontWeight.w400),
                                    border: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    contentPadding: EdgeInsets.only(top: 2)
                                  ),
                                  textCapitalization: TextCapitalization.sentences,
                                  style: TextStyle(color: context.isDarkMode ? ChatifyColors.grey : ChatifyColors.black, fontSize: ChatifySizes.fontSizeLg, fontWeight: FontWeight.w400, height: 1.2),
                                  onTap: () {
                                    if (showEmoji) {
                                      setState(() {
                                        showEmoji = false;
                                      });
                                    }
                                  },
                                  onSubmitted: (value) {
                                    if (sendWithEnter) {
                                      sendMessage();
                                    }
                                  },
                                ),
                              ),
                            ),
                          ),
                          ChatInputAttachments(
                            chatTarget: widget.chatTarget,
                            user: widget.user,
                            isUploading: isUploading,
                            setUploading: (value) {
                              setState(() {
                                isUploading = value;
                              });
                            },
                          ),
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 220),
                            reverseDuration: const Duration(milliseconds: 180),
                            switchInCurve: Curves.easeOutCubic,
                            switchOutCurve: Curves.easeInCubic,
                            transitionBuilder: (child, animation) {
                              final offsetAnimation = Tween<Offset>(begin: const Offset(0.6, 0), end: Offset.zero).animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic));

                              return FadeTransition(opacity: animation, child: SlideTransition(position: offsetAnimation, child: child));
                            },
                            child: hasText
                              ? const SizedBox(key: ValueKey('camera-hidden'), width: 0)
                              : CameraButton(key: const ValueKey('camera-visible'), onImagePicked: handleImagePicked, chatTarget: chatTarget),
                          )
                        ],
                      ),
                    ),
                  ),
              ),
              SizedBox(width: 8),
              GestureDetector(
                onPanStart: (_) {
                  _dragOffset = 0;
                },
                onPanUpdate: (details) {
                  if (!hasText) {
                    if (details.delta.dy < 0) {
                      _dragOffset += -details.delta.dy;
                    }
                  }
                },
                onPanEnd: (_) {
                  if (hasText) {
                    sendMessage();
                    return;
                  }

                  if (_dragOffset >= 80) {
                    _dragOffset = 0;

                    showVoiceRecordBottomSheetDialog(context, widget.chatTarget);

                    return;
                  }
                  _dragOffset = 0;
                  Dialogs.showSnackbarMargin(context, S.of(context).holdRecord, fontSize: ChatifySizes.fontSizeLm, margin: const EdgeInsets.only(bottom: 65, left: 10, right: 10));
                },
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: CircleAvatar(
                    backgroundColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                    radius: 24,
                    child: hasText ? Icon(Icons.send, color: context.isDarkMode ? ChatifyColors.black : ChatifyColors.white, size: 21) : const Icon(Icons.mic, color: ChatifyColors.black, size: 25),
                  ),
                ),
              ),
            ],
          ),
        ),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 280),
          reverseDuration: const Duration(milliseconds: 220),
          switchInCurve: Curves.easeOutCubic,
          switchOutCurve: Curves.easeInCubic,
          transitionBuilder: (child, animation) {
            return SlideTransition(position: Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero).animate(animation), child: child);
          },
          child: showEmoji
            ? GestureDetector(
                key: const ValueKey('emoji_panel'),
                behavior: HitTestBehavior.opaque,
                onVerticalDragUpdate: (details) {
                  if (details.delta.dy > 0) {
                    setState(() {
                      _emojiDragOffset += details.delta.dy;
                    });
                  }
                },
                onVerticalDragEnd: (details) {
                  if (_emojiDragOffset > 80 || details.velocity.pixelsPerSecond.dy > 700) {
                    _closeEmojiPanel();
                  } else {
                    setState(() {
                      _emojiDragOffset = 0;
                    });
                  }
                },
                child: Transform.translate(
                  offset: Offset(0, _emojiDragOffset),
                  child: Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height * 0.44,
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      color: context.isDarkMode ? ChatifyColors.nightGrey : ChatifyColors.white,
                      borderRadius: const BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25)),
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height: 12),
                        Container(
                          width: 36,
                          height: 4,
                          decoration: BoxDecoration(color: context.isDarkMode ? ChatifyColors.steelGrey : ChatifyColors.iconGrey, borderRadius: BorderRadius.circular(4)),
                        ),
                        const SizedBox(height: 18),
                        EmojiModeBottomBar(
                          selectedIndex: selectedEmojiMode,
                          onModeSelected: (index) {
                            setState(() => selectedEmojiMode = index);
                            emojiPageController.animateToPage(index, duration: const Duration(milliseconds: 250), curve: Curves.easeInOut);
                          },
                          onBackspace: () {
                            if (selectedEmojiMode == 0) {

                            } else if (selectedEmojiMode == 2) {}
                          },
                          onSearch: () {
                            if (selectedEmojiMode == 0) {

                            } else if (selectedEmojiMode == 2) {}
                          },
                        ),
                        const SizedBox(height: 8),
                        Expanded(
                          child: ScrollConfiguration(
                            behavior: NoGlowScrollBehavior(),
                            child: PageView(
                              controller: emojiPageController,
                              onPageChanged: (index) {
                                setState(() => selectedEmojiMode = index);
                              },
                              children: [
                                _buildEmojiPicker(),
                                _buildGifContent(),
                                _buildStickerContent(),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
          : const SizedBox.shrink(key: ValueKey('empty_panel')),
        )
      ],
    );
  }

  Widget _buildLinkPreview(BuildContext context) {
    if (_linkPreview == null && !isLoadingLinkPreview) {
      return const SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(left: 4, right: 60),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: isLoadingLinkPreview ? _buildLoadingLinkPreview(context) : _buildLinkPreviewContent(context),
          ),
          Positioned(
            top: -14,
            right: -12,
            child: IconButton(onPressed: _removeLinkPreview, icon: const Icon(Icons.close_rounded, size: 20)),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingLinkPreview(BuildContext context) {
    final isDark = context.isDarkMode;

    return Container(
      width: double.infinity,
      height: 68,
      decoration: BoxDecoration(color: isDark ? ChatifyColors.blackGrey : ChatifyColors.white, borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.antiAlias,
      child: Row(
        children: [
          Container(
            width: 68,
            height: 68,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), color: ChatifyColors.grey.withAlpha(40)),
            clipBehavior: Clip.antiAlias,
            child: Center(child: Icon(Icons.link_rounded, size: 26, color: ChatifyColors.textSecondary)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 140,
                  height: 14,
                  decoration: BoxDecoration(color: isDark ? ChatifyColors.grey.withAlpha(40) : ChatifyColors.grey, borderRadius: BorderRadius.circular(4)),
                ),
                const SizedBox(height: 7),
                Container(
                  width: 200,
                  height: 11,
                  decoration: BoxDecoration(color: isDark ? ChatifyColors.grey.withAlpha(40) : ChatifyColors.grey, borderRadius: BorderRadius.circular(4)),
                ),
                const SizedBox(height: 7),
                Container(
                  width: 70,
                  height: 11,
                  decoration: BoxDecoration(color: isDark ? ChatifyColors.grey.withAlpha(40) : ChatifyColors.grey, borderRadius: BorderRadius.circular(4)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLinkPreviewContent(BuildContext context) {
    final preview = _linkPreview!;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildLinkPreviewImage(preview),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 14),
                child: Text(
                  preview.title,
                  maxLines: 2,
                  style: TextStyle(color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black, fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w400),
                ),
              ),
              if (preview.description != null && preview.description!.isNotEmpty) ...[
                const SizedBox(height: 3),
                Text(preview.description!, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(color: ChatifyColors.textSecondary, fontSize: 13, fontWeight: FontWeight.w400)),
              ],
              Text(
                _formatPreviewUrl(preview.url),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: ChatifyColors.textSecondary, fontSize: 13, fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLinkPreviewImage(LinkPreviewModel preview) {
    final imageUrl = preview.imageUrl ?? preview.faviconUrl;

    return Container(
      width: 68,
      height: 68,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), color: ChatifyColors.grey.withAlpha(40)),
      clipBehavior: Clip.antiAlias,
      child: imageUrl != null
        ? Image.network(
            imageUrl,
            fit: BoxFit.cover,
            errorBuilder: (_, _, _) {
              return _buildDefaultLinkIcon();
            },
          )
        : _buildDefaultLinkIcon(),
    );
  }

  Widget _buildDefaultLinkIcon() {
    return const Center(child: Icon(Icons.link_rounded, size: 26, color: ChatifyColors.textSecondary));
  }

  Widget _buildMentionUsersPanel(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(left: 12, right: 74),
      decoration: BoxDecoration(
        color: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
      ),
      child: ScrollConfiguration(
        behavior: NoGlowScrollBehavior(),
        child: ListView.builder(
          shrinkWrap: true,
          padding: const EdgeInsets.only(top: 8),
          itemCount: filteredMentionUsers.length,
          itemBuilder: (context, index) {
            final user = filteredMentionUsers[index];

            return _buildMentionUserItem(context, user,);
          },
        ),
      ),
    );
  }

  Widget _buildMentionUserItem(BuildContext context, UserModel user) {
    return Material(
      color: ChatifyColors.transparent,
      child: InkWell(
        splashFactory: NoSplash.splashFactory,
        splashColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
        highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
        hoverColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
        onTap: () => _selectMentionUser(user),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(40),
                child: FutureBuilder<String?>(
                  future: APIs.getMediaUrl(user.image),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return _buildMentionAvatarPlaceholder(context);
                    }

                    final url = snapshot.data;

                    if (url == null || url.isEmpty) {
                      return _buildMentionAvatarPlaceholder(context);
                    }

                    return ClipRRect(
                      borderRadius: BorderRadius.circular(40),
                      child: CachedNetworkImage(
                        width: 40,
                        height: 40,
                        imageUrl: url,
                        fit: BoxFit.cover,
                        placeholder: (context, url) {
                          return _buildMentionAvatarPlaceholder(context);
                        },
                        errorWidget: (context, url, error) {
                          log('MENTION CACHED IMAGE ERROR\n''userId: ${user.id}\n''url: $url\n''error: $error');

                          return _buildMentionAvatarPlaceholder(context);
                        },
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${user.name} ${user.surname}'.trim(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black, fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400),
                    ),
                    if (user.username.isNotEmpty)
                      Text(
                        '@${user.username}',
                        maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(color: ChatifyColors.textSecondary, fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w400),
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

  Widget _buildMentionAvatarPlaceholder(BuildContext context) {
    return CircleAvatar(
      radius: 20,
      backgroundColor: colorsController.getColor(colorsController.selectedColorScheme.value),
      foregroundColor: ChatifyColors.white,
      child: SvgPicture.asset(ChatifyVectors.profile, width: 40, height: 40),
    );
  }

  Widget _buildEmojiPicker() {
    return SizedBox.expand(
      child: EmojiPicker(
        textEditingController: textController,
        config: Config(
          locale: Locale('ru'),
          checkPlatformCompatibility: true,
          viewOrderConfig: const ViewOrderConfig(top: EmojiPickerItem.emojiView, middle: EmojiPickerItem.categoryBar, bottom: EmojiPickerItem.searchBar),
          emojiViewConfig: EmojiViewConfig(
            columns: 8,
            emojiSizeMax: 32 * (defaultTargetPlatform == TargetPlatform.iOS ? 1.30 : 1.0),
            backgroundColor: context.isDarkMode ? ChatifyColors.nightGrey : ChatifyColors.white,
          ),
          categoryViewConfig: CategoryViewConfig(
            backgroundColor: context.isDarkMode ? ChatifyColors.nightGrey : ChatifyColors.white,
            iconColor: ChatifyColors.darkGrey,
            iconColorSelected: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black,
            indicatorColor: ChatifyColors.transparent,
            dividerColor: ChatifyColors.transparent,
          ),
          bottomActionBarConfig: BottomActionBarConfig(
            showBackspaceButton: false,
            showSearchViewButton: false,
            backgroundColor: context.isDarkMode ? ChatifyColors.nightGrey : ChatifyColors.white,
            buttonColor: ChatifyColors.transparent,
          ),
          skinToneConfig: SkinToneConfig(dialogBackgroundColor: context.isDarkMode ? ChatifyColors.youngNight : ChatifyColors.white),
          customBackspaceIcon: const Icon(Icons.backspace_outlined, size: 23, color: ChatifyColors.white),
          customSearchIcon: const Icon(Icons.search_rounded, size: 23),
        ),
      ),
    );
  }

  Widget _buildGifContent() {
    return GifGallery(
      onGifTap: (gifUrl) async {
        try {
          await ChatApi.sendMessage(widget.user, gifUrl, MessageType.gif);
        } catch (e, stackTrace) {
          log('Ошибка отправки GIF: $e', stackTrace: stackTrace);
        }
      },
    );
  }

  Widget _buildStickerContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 12, right: 12, top: 8, bottom: 12),
          child: Material(
            color: ChatifyColors.transparent,
            child: InkWell(
              splashFactory: NoSplash.splashFactory,
              borderRadius: BorderRadius.circular(12),
              splashColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
              highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
              hoverColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
              onTap: _createSticker,
              child: Container(
                width: 65,
                padding: const EdgeInsets.symmetric(vertical: 6),
                decoration: BoxDecoration(
                  color: ChatifyColors.transparent,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: context.isDarkMode ? ChatifyColors.lightSoftNight : ChatifyColors.iconGrey, width: 1),
                ),
                child: Column(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(color: colorsController.getColor(colorsController.selectedColorScheme.value), shape: BoxShape.circle),
                      alignment: Alignment.center,
                      child: Icon(Icons.edit_outlined, size: 19, color: ChatifyColors.black),
                    ),
                    const SizedBox(height: 4),
                    Text('Создать стикер', style: TextStyle(color: colorsController.getColor(colorsController.selectedColorScheme.value), fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w600, height: 1), textAlign: TextAlign.center),
                  ],
                ),
              ),
            ),
          ),
        ),
        Expanded(child: _buildStickerGrid(context.isDarkMode)),
        _buildStickerBottomBar(context.isDarkMode),
      ],
    );
  }

  Widget _buildStickerGrid(bool isDark) {
    if (isLoadingStickers) {
      return Center(
        child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(colorsController.getColor(colorsController.selectedColorScheme.value,)), strokeWidth: 3),
      );
    }

    if (stickerError != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(stickerError!, style: TextStyle(color: isDark ? ChatifyColors.white : ChatifyColors.black)),
            TextButton(onPressed: _loadStickers, child: const Text('Повторить')),
          ],
        ),
      );
    }

    if (stickers.isEmpty) {
      return Center(child: Text('Стикеров пока нет', style: TextStyle(color: isDark ? ChatifyColors.white : ChatifyColors.black)),);
    }

    return ScrollConfiguration(
      behavior: NoGlowScrollBehavior(),
      child: GridView.builder(
        padding: const EdgeInsets.all(8),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4, mainAxisSpacing: 8, crossAxisSpacing: 8),
        itemCount: stickers.length,
        itemBuilder: (context, index) {
          final sticker = stickers[index];
          String? url;

          if (sticker['images'] is Map) {
            final images = sticker['images'] as Map<String, dynamic>;
            final fixedHeight = images['fixed_height'];

            if (fixedHeight is Map) {
              url = fixedHeight['url'] as String?;
            }

            if (url == null || url.isEmpty) {
              final original = images['original'];
              if (original is Map) {
                url = original['url'] as String?;
              }
            }
          } else {
            url = sticker['url'] as String?;
          }

          final hasUrl = url != null && url.isNotEmpty;

          return InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: !hasUrl ? null : () => _sendSticker({...sticker, 'url': url}),
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: SizedBox(
                width: 64,
                height: 64,
                child: !hasUrl ? const Icon(Icons.broken_image_outlined) : Image.network(
                  url,
                  fit: BoxFit.contain,
                  errorBuilder: (_, _, _) =>
                  const Icon(Icons.broken_image_outlined),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildStickerBottomBar(bool isDark) {
    return SizedBox(
      height: 48,
      child: Row(
        children: [
          _buildStickerBarIcon(
            icon: Icons.access_time_outlined,
            isDark: isDark,
            onTap: _openStickerSearch,
          ),
          _buildStickerBarIcon(
            icon: Icons.star_border,
            isDark: isDark,
            iconColor: ChatifyColors.darkGrey,
            onTap: _openFavoriteStickers,
          ),
          Expanded(
            child: ScrollConfiguration(
              behavior: NoGlowScrollBehavior(),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.zero,
                itemCount: stickerPacks.length,
                itemBuilder: (context, index) {
                  return Material(
                    color: ChatifyColors.transparent,
                    child: InkWell(
                      splashFactory: NoSplash.splashFactory,
                      borderRadius: BorderRadius.circular(18),
                      splashColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
                      highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
                      hoverColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
                      onTap: () => _selectStickerPack(index),
                      child: Container(
                        width: 36,
                        height: 36,
                        margin: const EdgeInsets.symmetric(horizontal: 2),
                        decoration: BoxDecoration(shape: BoxShape.circle),
                        alignment: Alignment.center,
                        child: _buildStickerPackPreview(
                          previewUrl: _getStickerPackPreview(index),
                          isDark: isDark,
                          onAdd: () {
                            _openFavoriteStickers();
                          },
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          _buildStickerBarIcon(
            icon: ChatifyVectors.stickerAdd,
            isDark: isDark,
            iconColor: ChatifyColors.darkGrey,
            onTap: () {
              Navigator.push(context, createPageRoute(const StickersScreen()));
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStickerBarIcon({required dynamic icon, required bool isDark, required VoidCallback onTap, Color? iconColor}) {
    final color = iconColor ?? (isDark ? ChatifyColors.white : ChatifyColors.darkGrey);

    Widget iconWidget;

    if (icon is String) {
      iconWidget = SvgPicture.asset(icon, width: 25, height: 25, colorFilter: ColorFilter.mode(color, BlendMode.srcIn));
    } else if (icon is IconData) {
      iconWidget = Icon(icon, size: 25, color: color);
    } else {
      iconWidget = const SizedBox.shrink();
    }

    return SizedBox(
      width: 36,
      height: 36,
      child: Material(
        color: ChatifyColors.transparent,
        shape: const CircleBorder(),
        clipBehavior: Clip.antiAlias,
        child: InkWell(onTap: onTap, child: Center(child: iconWidget)),
      ),
    );
  }

  Widget _buildStickerPackPreview({required String? previewUrl, required bool isDark, required VoidCallback onAdd}) {
    final accentColor = colorsController.getColor(colorsController.selectedColorScheme.value);

    return SizedBox(
      width: 56,
      height: 56,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Align(
            alignment: Alignment.center,
            child: SizedBox(
              width: 48,
              height: 48,
              child: previewUrl != null
                ? Image.network(
                    previewUrl,
                    fit: BoxFit.contain,
                    errorBuilder: (_, _, _) => Icon(
                      Icons.emoji_emotions_outlined,
                      size: 30,
                      color: isDark ? ChatifyColors.white : ChatifyColors.darkGrey,
                    ),
                  )
                : Icon(
                    Icons.emoji_emotions_outlined,
                    size: 30,
                    color: isDark ? ChatifyColors.white : ChatifyColors.darkGrey,
                  ),
            ),
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: Material(
              color: accentColor,
              shape: CircleBorder(side: BorderSide(color: ChatifyColors.black, width: 1.4)),
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: onAdd,
                child: SizedBox(
                  width: 15,
                  height: 15,
                  child: Icon(Icons.add_rounded, size: 13, color: ChatifyColors.black),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
