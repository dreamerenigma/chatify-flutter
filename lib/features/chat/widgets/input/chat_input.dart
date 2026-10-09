import 'dart:async';
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
import '../../../../../api/apis.dart';
import '../../../../../generated/l10n/l10n.dart';
import '../../../../../utils/constants/app_colors.dart';
import '../../../../../utils/constants/app_sizes.dart';
import '../../../../../utils/constants/app_sounds.dart';
import '../../../../../utils/popups/dialogs.dart';
import '../../../../core/enums/message_bubble_type.dart';
import '../../../../core/services/links/link_preview_service.dart';
import '../../../../domain/entities/chat_target.dart';
import '../../../personalization/widgets/dialogs/light_dialog.dart';
import '../../controllers/mention_text_editing_controller.dart';
import '../../models/link_preview_model.dart';
import '../../models/mention_data_model.dart';
import '../../models/user_model.dart';
import '../dialogs/voice_record_bottom_sheet_dialog.dart';
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
  final textController = MentionTextEditingController();
  final LinkPreviewService _linkPreviewService = LinkPreviewService();
  final AudioPlayer audioPlayer = AudioPlayer();
  final Map<String, String> mentionAvatarUrls = {};
  final List<MentionDataModel> mentions = [];
  late final ValueChanged<bool> setUploading;
  bool showEmoji = false;
  bool isUploading = false;
  bool sendWithEnter = false;
  bool isTyping = false;
  bool showVideoToast = false;
  bool isLoadingLinkPreview = false;
  bool showMentionUsers = false;
  bool isLoadingProfileImage = false;
  double _dragOffset = 0;
  String? _previewUrl;
  String mentionQuery = '';
  Timer? typingTimer;
  Timer? linkPreviewDebounce;
  UserModel? replyUser;
  List<MessageModel> list = [];
  List<UserModel> mentionUsers = [];
  List<UserModel> filteredMentionUsers = [];
  LinkPreviewModel? _linkPreview;

  bool get hasText => textController.text.trim().isNotEmpty;

  ChatTarget get chatTarget => widget.chatTarget;

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
  }

  @override
  void dispose() {
    textController.removeListener(_handleTyping);
    textController.removeListener(_onTextChanged);
    widget.focusNode.removeListener(_onFocusChanged);
    typingTimer?.cancel();
    textController.dispose();
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

    log('REPLY MESSAGE ID: ${widget.replyMessage?.id}');
    log('REPLY MESSAGE TEXT: ${widget.replyMessage?.msg}');

    textController.clear();
    playSendSound();

    if (mounted) {
      setState(() {});
    }

    try {
      await widget.chatTarget.sendText(text, replyToMessageId: replyId);

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
      log('========== LOAD MENTION USERS START ==========');

      final userIds = await APIs.getMyUserIds();

      log('MENTION USER IDS: $userIds');

      final users = <UserModel>[];

      for (final userId in userIds) {
        final user = await APIs.getUserById(userId);

        if (user != null) {
          users.add(user);

          log('USER ADDED: ''${user.name} | ''${user.id} | ''image="${user.image}"');
        }
      }

      log('MENTION USERS: ${users.length}');

      for (final user in users) {
        log('CALLING AVATAR LOADER: ''${user.name} | ${user.id}');

        await _loadMentionAvatar(user);

        log(
          'AVATAR LOADER FINISHED: '
              '${user.name} | ${user.id}',
        );
      }

      log(
        'MENTION AVATARS FINAL: ${mentionAvatarUrls.length}',
      );

      if (!mounted) return;

      setState(() {
        mentionUsers = users;
        filteredMentionUsers = users;
      });

      log('========== LOAD MENTION USERS END ==========');
    } catch (e, stackTrace) {
      log('LOAD MENTION USERS ERROR: $e\n''$stackTrace');
    }
  }

  Future<void> _loadMentionAvatar(UserModel user) async {
    log('AVATAR LOAD START\n''userId: ${user.id}\n''name: ${user.name}\n''image: "${user.image}"');

    if (user.image.trim().isEmpty) {
      log('AVATAR LOAD SKIP\n''userId: ${user.id}\n''reason: image is empty');
      return;
    }

    if (mentionAvatarUrls.containsKey(user.id)) {
      log('AVATAR LOAD CACHE\n''userId: ${user.id}');
      return;
    }

    try {
      final url = await APIs.getMediaUrl(user.image);

      log('AVATAR MEDIA URL\n''userId: ${user.id}\n''path: ${user.image}\n''url: $url');

      if (url == null || url.isEmpty) {
        log('AVATAR URL EMPTY\n''userId: ${user.id}');
        return;
      }

      if (!mounted) return;

      setState(() {
        mentionAvatarUrls[user.id] = url;
      });

      log('AVATAR SAVED\n''userId: ${user.id}\n''mapLength: ${mentionAvatarUrls.length}');
    } catch (e, stackTrace) {
      log('AVATAR MEDIA ERROR\n''userId: ${user.id}\n''name: ${user.name}\n''image: ${user.image}\n''error: $e\n''$stackTrace');
    }
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
        if (showEmoji)
          EmojiPicker(
            textEditingController: textController,
            config: Config(
              height: MediaQuery.of(context).size.height * 0.35,
              checkPlatformCompatibility: true,
              emojiViewConfig: EmojiViewConfig(
                columns: 8,
                emojiSizeMax: 32 * (defaultTargetPlatform == TargetPlatform.iOS ? 1.30 : 1.0),
                backgroundColor: context.isDarkMode ? ChatifyColors.nightGrey : ChatifyColors.white,
              ),
              categoryViewConfig: CategoryViewConfig(backgroundColor: context.isDarkMode ? ChatifyColors.nightGrey : ChatifyColors.white),
              bottomActionBarConfig: BottomActionBarConfig(backgroundColor: context.isDarkMode ? ChatifyColors.nightGrey : ChatifyColors.white, buttonColor: ChatifyColors.transparent),
              skinToneConfig: SkinToneConfig(dialogBackgroundColor: context.isDarkMode ? ChatifyColors.youngNight : ChatifyColors.white),
              customBackspaceIcon: Icon(Icons.backspace_outlined, size: 24, color: ChatifyColors.white),
            ),
          ),
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
      margin: const EdgeInsets.only(left: 12, right: 75),
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
                      style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w500, color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black),
                    ),
                    if (user.username.isNotEmpty)
                      Text('@${user.username}', maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: ChatifySizes.fontSizeSm, color: ChatifyColors.textSecondary)),
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
}
