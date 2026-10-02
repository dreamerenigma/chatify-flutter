import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatify/features/chat/models/user_model.dart';
import 'package:chatify/features/utils/widgets/dividers/custom_divider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get_utils/src/extensions/context_extensions.dart';
import '../../../../api/apis.dart';
import '../../../../api/chat_api.dart';
import '../../../../routes/custom_page_route.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../../utils/constants/app_vectors.dart';
import '../../../../utils/platforms/platform_utils.dart';
import '../../../chat/models/message_model.dart';
import '../../../chat/widgets/messages/message_meta.dart';
import '../../../chat/widgets/painters/triangle_painter.dart';
import '../../../personalization/widgets/dialogs/light_dialog.dart';
import '../../models/survey_model.dart';
import 'package:flutter/material.dart';
import '../../screens/data_survey_screen.dart';

class SurveyMessageCard extends StatefulWidget {
  final UserModel user;
  final MessageModel message;
  final SurveyModel survey;
  final bool isMe;
  final String conversationId;

  const SurveyMessageCard({
    super.key,
    required this.user,
    required this.message,
    required this.survey,
    required this.isMe,
    required this.conversationId,
  });

  @override
  State<SurveyMessageCard> createState() => _SurveyMessageCardState();
}

class _SurveyMessageCardState extends State<SurveyMessageCard> {
  final Map<String, UserModel> _voters = {};
  final Set<String> _loadingVoters = {};
  bool isLoadingProfileImage = false;
  String? profileImageUrl;

  Stream<QuerySnapshot<Map<String, dynamic>>> _votesStream() {
    return FirebaseFirestore.instance.collection('Chats').doc(widget.conversationId).collection('messages').doc(widget.message.id).collection('votes').snapshots();
  }

  @override
  void initState() {
    super.initState();
    _loadProfileImage();
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
        profileImageUrl = url;
        isLoadingProfileImage = false;
      });
    } catch (e, stackTrace) {
      log('PROFILE IMAGE URL ERROR: $e', stackTrace: stackTrace);

      if (!mounted) return;

      setState(() {
        profileImageUrl = null;
        isLoadingProfileImage = false;
      });
    }
  }

  Future<UserModel?> _loadVoter(String userId) async {
    if (_voters.containsKey(userId)) {
      return _voters[userId];
    }

    if (_loadingVoters.contains(userId)) {
      return null;
    }

    _loadingVoters.add(userId);

    try {
      final doc = await FirebaseFirestore.instance.collection('Users').doc(userId).get();

      if (!doc.exists || doc.data() == null) {
        return null;
      }

      final user = UserModel.fromJson(doc.data()!);

      if (mounted) {
        setState(() {
          _voters[userId] = user;
        });
      }

      return user;
    } catch (e, stackTrace) {
      log('LOAD VOTER ERROR [$userId]: $e', stackTrace: stackTrace);
      return null;
    } finally {
      _loadingVoters.remove(userId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isSender = widget.isMe;
    final messageColor = isSender
      ? context.isDarkMode ? ChatifyColors.popupColorDark : ChatifyColors.lightGrey
      : context.isDarkMode ? ChatifyColors.greenMessageBorderDark : ChatifyColors.greenMessageBubbleRecipient;
    final messageBorderColor = isSender
      ? context.isDarkMode ? ChatifyColors.mildNight : ChatifyColors.grey
      : context.isDarkMode ? ChatifyColors.greenMessageDivider : ChatifyColors.messageBubbleRecipientBorder;

    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: _votesStream(),
      builder: (context, snapshot) {
        final votesByUser = <String, List<String>>{};

        if (snapshot.hasData) {
          for (final doc in snapshot.data!.docs) {
            final data = doc.data();

            votesByUser[doc.id] = List<String>.from(data['selectedOptions'] ?? []);
          }
        }

        final currentUserId = FirebaseAuth.instance.currentUser?.uid;
        final mySelectedOptions = currentUserId == null ? <String>[] : votesByUser[currentUserId] ?? [];

        int getVoteCount(String option) {
          return votesByUser.values.where((selectedOptions) => selectedOptions.contains(option)).length;
        }

        final totalVotes = votesByUser.length;

        double getVoteProgress(String option) {
          if (totalVotes == 0) return 0;

          return getVoteCount(option) / totalVotes;
        }

        return Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: 320,
              margin: isWebOrWindows
                ? const EdgeInsets.symmetric(horizontal: 16, vertical: 6)
                : EdgeInsets.only(left: 16, right: 16, top: 5, bottom: widget.survey.reactions.isNotEmpty ? 12 : 5,
              ),
              decoration: BoxDecoration(
                color: isSender ? context.isDarkMode ? ChatifyColors.popupColorDark : ChatifyColors.lightGrey : messageColor,
                border: Border.all(color: isSender ? (context.isDarkMode ? ChatifyColors.mildNight : ChatifyColors.grey) : (messageBorderColor), width: 1),
                borderRadius: isSender
                  ? const BorderRadius.only(topRight: Radius.circular(15), bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15))
                  : const BorderRadius.only(topLeft: Radius.circular(15), bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15)),
                boxShadow: [BoxShadow(color: ChatifyColors.black.withAlpha(isSender ? 25 : 25), spreadRadius: 1, blurRadius: 2, offset: const Offset(0, 2))],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10, top: 8, bottom: 8),
                    child: Text(widget.survey.question, style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400, height: 1.3)),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      children: [
                        if (widget.survey.allowMultipleAnswers)
                          Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Container(
                                width: 13,
                                height: 13,
                                decoration: BoxDecoration(shape: BoxShape.circle, color: context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.white, border: Border.all(color: ChatifyColors.nightGrey, width: 0.5)),
                                child: Icon(Icons.check, size: 9, color: ChatifyColors.black),
                              ),
                              Positioned(
                                left: 8,
                                child: Container(
                                  width: 13,
                                  height: 13,
                                  decoration: BoxDecoration(shape: BoxShape.circle, color: context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.white, border: Border.all(color: ChatifyColors.nightGrey, width: 0.5)),
                                  child: Icon(Icons.check, size: 9, color: ChatifyColors.black),
                                ),
                              ),
                            ],
                          )
                        else
                          Container(
                            width: 13,
                            height: 13,
                            decoration: BoxDecoration(shape: BoxShape.circle, color: context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.white, border: Border.all(color: ChatifyColors.nightGrey, width: 0.5)),
                            child: Icon(Icons.check, size: 9, color: ChatifyColors.black),
                          ),
                        SizedBox(width: widget.survey.allowMultipleAnswers ? 14 : 8),
                        Expanded(
                          child: Text(
                            widget.survey.allowMultipleAnswers ? 'Выберите один или несколько вариантов' : 'Выберите один вариант',
                            style: TextStyle(color: ChatifyColors.darkGrey, fontSize: ChatifySizes.fontSizeLm, fontWeight: FontWeight.w400, height: 1.3),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...List.generate(
                    widget.survey.options.length, (index) {
                    final option = widget.survey.options[index];
                    final selected = mySelectedOptions.contains(option);
                    final voteCount = getVoteCount(option);
                    final progress = getVoteProgress(option);
                    final voteColor = colorsController.getColor(colorsController.selectedColorScheme.value);
                    final hasVotes = voteCount > 0;

                    return GestureDetector(
                      onTap: () async {
                        await ChatApi.voteForOption(
                          conversationId: widget.conversationId,
                          messageId: widget.message.id,
                          option: option,
                          allowMultipleAnswers:
                          widget.survey.allowMultipleAnswers,
                        );
                      },
                      child: Container(
                        width: double.infinity,
                        margin: const EdgeInsets.only(bottom: 12),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    selected ? Icons.check_circle_rounded : Icons.radio_button_unchecked,
                                    size: 24,
                                    color: selected ? colorsController.getColor(colorsController.selectedColorScheme.value) : ChatifyColors.grey,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(child: Text(option, style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400))),
                                  if (hasVotes) ...[
                                    _buildVoterAvatars(context, votesByUser.entries.where((entry) => entry.value.contains(option)).map((entry) => entry.key).toList()),
                                    const SizedBox(width: 10),
                                  ],
                                  Text('$voteCount', style: TextStyle(fontSize: 13, color: ChatifyColors.grey, fontWeight: FontWeight.w400)),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Padding(
                                padding: const EdgeInsets.only(left: 30),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: TweenAnimationBuilder<double>(
                                    tween: Tween<double>(begin: 0, end: hasVotes ? progress : 0),
                                    duration: const Duration(milliseconds: 500),
                                    curve: Curves.easeOutCubic,
                                    builder: (context, animatedProgress, child) {
                                      return LinearProgressIndicator(
                                        value: animatedProgress,
                                        minHeight: 8,
                                        backgroundColor: isSender
                                          ? context.isDarkMode ? ChatifyColors.softNight : ChatifyColors.softGrey
                                          : hasVotes ? (context.isDarkMode ? ChatifyColors.greenMessageBorderLight : ChatifyColors.lightGrey) : ChatifyColors.greenMessageBorderLight,
                                        valueColor: AlwaysStoppedAnimation(hasVotes ? voteColor : ChatifyColors.transparent),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ));
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: MessageMeta(message: widget.message, isWebOrWindows: isWebOrWindows, showCheck: true),
                  ),
                  CustomDivider(indent: 0, endIndent: 0, left: 0, right: 0, top: 4, bottom: 0, color: isSender ? ChatifyColors.popupColor : ChatifyColors.greenMessageButton),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        createPageRoute(
                          DataSurveyScreen(
                            conversationId: widget.conversationId,
                            messageId: widget.message.id,
                            survey: widget.survey,
                            selectedOption: mySelectedOptions.isNotEmpty ? mySelectedOptions.first : '',
                            user: widget.user,
                          ),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Center(
                        child: Text(
                          'Показать голоса',
                          style: TextStyle(
                            color: mySelectedOptions.isNotEmpty ? colorsController.getColor(colorsController.selectedColorScheme.value) : ChatifyColors.greenMessageButton,
                            fontSize: ChatifySizes.fontSizeMd,
                            fontWeight: FontWeight.w400,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 5.5,
              left: isSender ? 7 : null,
              right: isSender ? null : 7,
              child: Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()..scaleByDouble(isSender ? -1.0 : 1.0, 1.0, 1.0, 1.0),
                child: CustomPaint(size: const Size(10, 10), painter: TrianglePainter(fillColor: messageColor, borderColor: messageBorderColor)),
              ),
            ),
          ],
        );
      }
    );
  }

  Widget _buildVoterAvatars(BuildContext context, List<String> voterIds,) {

    final visibleVoterIds = voterIds.reversed.take(5).toList();

    final remainingCount = voterIds.length - visibleVoterIds.length;

    return SizedBox(
      height: 24,
      width: visibleVoterIds.length * 14.0 +
          (remainingCount > 0 ? 25 : 0),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Рисуем справа налево, чтобы левая аватарка
          // лежала поверх следующей справа.
          for (int i = visibleVoterIds.length - 1; i >= 0; i--)
            Positioned(
              left: i * 14.0,
              top: 1,
              child: _buildVoterAvatar(
                context,
                visibleVoterIds[i],
              ),
            ),

          if (remainingCount > 0)
            Positioned(
              left: visibleVoterIds.length * 14.0 + 3,
              top: 3,
              child: Text(
                '+$remainingCount',
                style: TextStyle(
                  fontSize: 12,
                  color: ChatifyColors.grey,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildVoterAvatar(BuildContext context, String userId) {
    final voter = _voters[userId];

    if (voter == null) {
      _loadVoter(userId);

      return Container(
        width: 22,
        height: 22,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: ChatifyColors.blackGrey,
          border: Border.all(color: context.isDarkMode ? ChatifyColors.popupColorDark : ChatifyColors.white, width: 1.5),
        ),
      );
    }

    return FutureBuilder<String?>(
      future: APIs.getMediaUrl(voter.image),
      builder: (context, snapshot) {
        final imageUrl = snapshot.data ?? '';

        return Container(
          width: 22,
          height: 22,
          decoration: BoxDecoration(shape: BoxShape.circle, color: ChatifyColors.blackGrey, border: Border.all(color: context.isDarkMode ? ChatifyColors.popupColorDark : ChatifyColors.white, width: 1.5)),
          child: ClipOval(
            child: imageUrl.isNotEmpty
              ? CachedNetworkImage(
                  imageUrl: imageUrl,
                  width: 22,
                  height: 22,
                  fit: BoxFit.cover,
                  errorWidget: (_, _, _) {
                    return SvgPicture.asset(ChatifyVectors.profile, width: 15, height: 15);
                  },
                )
              : SvgPicture.asset(ChatifyVectors.profile, width: 15, height: 15,
            ),
          ),
        );
      },
    );
  }
}
