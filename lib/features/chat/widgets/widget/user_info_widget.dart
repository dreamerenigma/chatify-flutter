import 'dart:developer';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatify/api/apis.dart';
import 'package:chatify/utils/constants/app_colors.dart';
import 'package:chatify/utils/constants/app_sizes.dart';
import 'package:chatify/utils/constants/app_vectors.dart';
import 'package:chatify/utils/helper/avatar_color_util.dart';
import 'package:chatify/utils/helper/date_util.dart';
import 'package:chatify/utils/devices/device_utility.dart';
import 'package:chatify/generated/l10n/l10n.dart';
import 'package:chatify/routes/custom_page_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get_utils/src/extensions/context_extensions.dart';
import '../../../personalization/screens/profile/view_profile_screen.dart';
import '../../models/user_model.dart';
import '../dialogs/chat_settings_dialog.dart';

class UserInfoWidget extends StatefulWidget {
  final UserModel user;
  final bool showStatusText;

  const UserInfoWidget({
    super.key,
    required this.user,
    required this.showStatusText,
  });

  @override
  State<UserInfoWidget> createState() => _UserInfoWidgetState();
}

class _UserInfoWidgetState extends State<UserInfoWidget>  with TickerProviderStateMixin {
  late final AnimationController _lastSeenController;
  late final Animation<Offset> _dateSlideAnimation;
  late final Animation<double> _timeFadeAnimation;
  late Stream<DocumentSnapshot<Map<String, dynamic>>> _userStream;
  bool _isLoadingProfileImage = false;
  bool _lastSeenAnimationStarted = false;
  int _statusPhase = 0;
  String? _profileImageUrl;
  Map<String, dynamic>? _lastUserData;

  String _formatLastSeenTime(dynamic lastActive) {
    if (lastActive == null) return '';

    DateTime? dateTime;

    if (lastActive is Timestamp) {
      dateTime = lastActive.toDate();
    } else if (lastActive is DateTime) {
      dateTime = lastActive;
    } else if (lastActive is int) {
      dateTime = DateTime.fromMillisecondsSinceEpoch(lastActive);
    }

    if (dateTime == null) return '';

    final hours = dateTime.hour.toString().padLeft(2, '0');
    final minutes = dateTime.minute.toString().padLeft(2, '0');

    return '$hours:$minutes';
  }

  String _getLastActiveText(BuildContext context, dynamic lastActive) {
    if (lastActive is Timestamp) {
      return DateUtil.getLastActiveTime(context: context, lastActive: lastActive, addWasPrefix: true);
    }

    if (lastActive is String) {
      final millis = int.tryParse(lastActive);

      if (millis != null) {
        final timestamp = Timestamp.fromMillisecondsSinceEpoch(millis);

        return DateUtil.getLastActiveTime(context: context, lastActive: timestamp, addWasPrefix: true);
      }
    }

    return S.of(context).lastSeenNotAvailable;
  }

  @override
  void initState() {
    super.initState();
    _userStream = APIs.firestore.collection('Users').doc(widget.user.id).snapshots();
    _lastSeenController = AnimationController(vsync: this, duration: const Duration(milliseconds: 1800));
    _dateSlideAnimation = Tween<Offset>(begin: Offset.zero, end: const Offset(-1.0, 0),).animate(CurvedAnimation(parent: _lastSeenController, curve: Curves.linear));
    _timeFadeAnimation = CurvedAnimation(parent: _lastSeenController, curve: const Interval(0.92, 1.0, curve: Curves.easeIn));
    _loadProfileImage();
    _startStatusSequence();
  }

  @override
  void dispose() {
    _lastSeenController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant UserInfoWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.user.id != widget.user.id) {
      _userStream = APIs.firestore.collection('Users').doc(widget.user.id).snapshots();
      _lastUserData = null;
    }

    if (oldWidget.user.image != widget.user.image) {
      _profileImageUrl = null;
      _loadProfileImage();
    }
  }

  void _startLastSeenAnimation() {
    _lastSeenController.forward(from: 0);
  }

  void _startLastSeenAnimationOnce() {
    if (_lastSeenAnimationStarted || !mounted) return;

    _lastSeenAnimationStarted = true;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _startLastSeenAnimation();
    });
  }

  Future<void> _loadProfileImage() async {
    final imagePath = widget.user.image.trim();

    if (imagePath.isEmpty) {
      return;
    }

    if (mounted) {
      setState(() {
        _isLoadingProfileImage = true;
      });
    }

    try {
      final url = await APIs.getMediaUrl(imagePath);

      if (!mounted) return;

      setState(() {
        _profileImageUrl = url;
        _isLoadingProfileImage = false;
      });
    } catch (e, stackTrace) {
      log('PROFILE IMAGE URL ERROR: $e', stackTrace: stackTrace);

      if (!mounted) return;

      setState(() {
        _profileImageUrl = null;
        _isLoadingProfileImage = false;
      });
    }
  }

  Future<void> _startStatusSequence() async {
    await Future.delayed(const Duration(seconds: 4));

    if (!mounted) return;

    setState(() {
      _statusPhase = 1;
    });

    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    setState(() {
      _statusPhase = 2;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: ChatifyColors.transparent,
      child: InkWell(
        mouseCursor: SystemMouseCursors.basic,
        splashFactory: NoSplash.splashFactory,
        borderRadius: BorderRadius.circular(8),
        splashColor: context.isDarkMode ? ChatifyColors.steelGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
        highlightColor: context.isDarkMode ? ChatifyColors.steelGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
        hoverColor: context.isDarkMode ? ChatifyColors.lightSoftNight.withAlpha((0.15 * 255).toInt()) : ChatifyColors.steelGrey,
        onTap: () {
          if (Platform.isWindows) {
            final renderBox = context.findRenderObject() as RenderBox;
            final position = renderBox.localToGlobal(Offset.zero);

            showChatSettingsDialog(context, widget.user, position, initialIndex: 0);
          } else {
            Navigator.push(context, createPageRoute(ViewProfileScreen(user: widget.user)));
          }
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildAvatar(context),
              SizedBox(width: Platform.isWindows ? 14 : 10),
              Flexible(child: _buildUserText(context)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar(BuildContext context) {
    final avatarColors = AvatarColorUtil.get(widget.user.id);

    return ClipRRect(
      borderRadius: BorderRadius.circular(DeviceUtils.getScreenHeight(context) * .04),
      child: CachedNetworkImage(
        width: 40,
        height: 40,
        imageUrl: _profileImageUrl ?? '',
        fit: BoxFit.cover,
        placeholder: (context, url) {
          return Container(width: 40, height: 40, color: ChatifyColors.blackGrey);
        },
        errorWidget: (context, url, error) {
          return Container(
            width: 40,
            height: 40,
            color: avatarColors.background,
            alignment: Alignment.center,
            child: SvgPicture.asset(ChatifyVectors.profile, width: 40, height: 40),
          );
        },
      ),
    );
  }

  Widget _buildUserText(BuildContext context) {
    final isCurrentUser = widget.user.id == FirebaseAuth.instance.currentUser?.uid;
    final displayName = isCurrentUser ? '@${widget.user.username} (Вы)' : '${widget.user.name}${widget.user.surname.isNotEmpty ? ' ${widget.user.surname}' : ''}';
    final nameStyle = TextStyle(fontSize: Platform.isWindows ? ChatifySizes.fontSizeSm : ChatifySizes.fontSizeLg, fontWeight: Platform.isWindows ? FontWeight.w600 : FontWeight.w400, height: 1.2);

    const nameHeight = 22.0;
    const statusHeight = 20.0;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOut,
      height: _statusPhase == 0 ? nameHeight : nameHeight + statusHeight,
      child: ClipRect(
        child: Stack(
          clipBehavior: Clip.hardEdge,
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: nameHeight,
              child: Align(
                alignment: _statusPhase == 0 ? Alignment.centerLeft : Alignment.topLeft,
                child: Text(displayName, maxLines: 1, softWrap: false, overflow: TextOverflow.ellipsis, style: nameStyle),
              ),
            ),
            if (_statusPhase >= 1)
              Positioned(
                top: nameHeight,
                left: 0,
                right: 0,
                height: statusHeight,
                child: _buildStatus(context),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatus(BuildContext context) {
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: _userStream,
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data!.exists) {
          final data = snapshot.data!.data();

          if (data != null) {
            _lastUserData = data;
          }
        }

        final userData = _lastUserData;
        final isSelfChat = widget.user.id == APIs.me.id;
        final bool isTyping = userData?['is_typing'] ?? false;
        final bool isOnline = userData?['is_online'] ?? false;
        final lastActive = userData?['last_active'];
        final lastActiveText = _getLastActiveText(context, lastActive);
        final timeText = _formatLastSeenTime(lastActive);
        final String statusText = userData == null ? S.of(context).contactDetails : isSelfChat ? 'Сообщение для себя' : isTyping ? S.of(context).printing : isOnline ? S.of(context).online : lastActiveText;

        if (_statusPhase == 0) {
          return const SizedBox.shrink();
        }

        final displayedText = _statusPhase == 1 ? S.of(context).contactDetails : statusText;
        final isLastSeen = _statusPhase == 2 && userData != null && !isSelfChat && !isTyping && !isOnline;

        if (isLastSeen && _statusPhase == 2) {
          _startLastSeenAnimationOnce();
        }

        final textStyle = TextStyle(fontSize: 13, fontWeight: FontWeight.w400, color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.darkGrey, height: 1.2);

        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 450),
          reverseDuration: const Duration(milliseconds: 300),
          switchInCurve: Curves.easeInOut,
          switchOutCurve: Curves.easeInOut,
          transitionBuilder: (child, animation) {
            return FadeTransition(opacity: animation, child: child);
          },
          child: SizedBox(
            key: ValueKey(isLastSeen ? 'last_seen_$timeText' : '${_statusPhase}_$displayedText'),
            width: double.infinity,
            height: 20,
            child: Align(
              alignment: Alignment.centerLeft,
              child: isLastSeen
                ? _buildLastSeenAnimation(dateText: lastActiveText, timeText: timeText, style: textStyle)
                : Text(displayedText, style: textStyle, overflow: TextOverflow.ellipsis, maxLines: 1),
            ),
          ),
        );
      },
    );
  }

  Widget _buildLastSeenAnimation({
    required String dateText,
    required String timeText,
    required TextStyle style,
  }) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: dateText,
        style: style,
      ),
      maxLines: 1,
      textDirection: Directionality.of(context),
    )..layout();

    final double dateWidth = textPainter.width;
    textPainter.dispose();

    return SizedBox(
      height: 20,
      width: double.infinity,
      child: ClipRect(
        child: AnimatedBuilder(
          animation: _lastSeenController,
          builder: (context, child) {
            final progress = _lastSeenController.value;

            return Stack(
              alignment: Alignment.centerLeft,
              children: [
                Transform.translate(
                  offset: Offset(-(dateWidth + 12) * progress, 0),
                  child: Text(
                    dateText,
                    style: style,
                    maxLines: 1,
                    softWrap: false,
                    overflow: TextOverflow.visible,
                  ),
                ),
                FadeTransition(
                  opacity: _timeFadeAnimation,
                  child: Text(
                    timeText,
                    style: style,
                    maxLines: 1,
                    softWrap: false,
                    overflow: TextOverflow.visible,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
