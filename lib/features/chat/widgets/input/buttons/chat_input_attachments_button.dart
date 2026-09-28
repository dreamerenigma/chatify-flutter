import 'dart:developer';
import 'dart:io';
import 'dart:math' as math;
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../../utils/constants/app_colors.dart';
import '../../../../../utils/constants/app_vectors.dart';
import '../../../models/user_model.dart';
import '../../../../../domain/entities/chat_target.dart';
import '../../dialogs/edit_image_bottom_sheet_dialog.dart';

class ChatInputAttachments extends StatefulWidget {
  final ChatTarget chatTarget;
  final UserModel user;
  final bool isUploading;
  final ValueChanged<bool> setUploading;

  const ChatInputAttachments({
    super.key,
    required this.chatTarget,
    required this.user,
    required this.isUploading,
    required this.setUploading,
  });

  @override
  State<ChatInputAttachments> createState() => _ChatInputAttachmentsState();
}

class _ChatInputAttachmentsState extends State<ChatInputAttachments> {
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

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        showEditBottomSheetDialog(
          context,
          chatTarget: widget.chatTarget,
          user:widget. user,
          isUploading: widget.isUploading,
          setUploading: widget.setUploading,
        );
      },
      icon: Transform.rotate(
        angle: -45 * math.pi / 180,
        child: SvgPicture.asset(
          ChatifyVectors.attach,
          width: 25,
          height: 25,
          colorFilter: const ColorFilter.mode(ChatifyColors.textSecondary, BlendMode.srcIn),
        ),
      ),
    );
  }
}
