import 'dart:io';
import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../../../generated/l10n/l10n.dart';
import '../../../../../routes/custom_page_route.dart';
import '../../../../../utils/constants/app_colors.dart';
import '../../../../../utils/constants/app_sizes.dart';
import '../../../../../utils/constants/app_vectors.dart';
import '../../../../status/widgets/images/camera_screen.dart';
import '../../../models/user_model.dart';
import '../../../screens/contact_seeding_screen.dart';
import '../../../screens/create_survey_screen.dart';
import '../../../../../domain/entities/chat_target.dart';
import '../../dialogs/add_geolocation_dialog.dart';
import 'circle_split_painter.dart';

class ChatInputAttachments extends StatelessWidget {
  final UserModel user;
  final ChatTarget chatTarget;
  final bool isUploading;
  final ValueChanged<bool> setUploading;

  const ChatInputAttachments({
    super.key,
    required this.user,
    required this.chatTarget,
    required this.isUploading,
    required this.setUploading,
  });

  Future<void> sendGif(File file) async {
    setUploading(true);
    await chatTarget.sendImage(file);
    setUploading(false);
  }

  Future<void> sendVideo(File file) async {
    setUploading(true);
    await chatTarget.sendVideo(file);
    setUploading(false);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: () async {
            showDialog(
              context: context,
              barrierColor: ChatifyColors.transparent,
              builder: (context) => Align(
                alignment: const Alignment(0, 0.70),
                child: Material(
                  type: MaterialType.transparency,
                  child: Container(
                    padding: const EdgeInsets.only(left: 16, right: 25, top: 24, bottom: 24),
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [BoxShadow(color: ChatifyColors.black.withAlpha((0.1 * 255).toInt()), spreadRadius: 1, blurRadius: 2, offset: const Offset(0, 1))],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildIconButton(
                              context,
                              icon: Icon(BootstrapIcons.file_earmark, color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black, size: 30),
                              color1: ChatifyColors.violetDark,
                              color2: ChatifyColors.violet,
                              label: S.of(context).documents,
                              onTap: () async {
                                final result = await FilePicker.pickFiles(type: FileType.custom, allowedExtensions: ['pdf', 'doc', 'docx', 'xls', 'xlsx', 'apk', 'zip', 'rar']);
                                if (result.isNotEmpty) {
                                  setUploading(true);

                                  for (var file in result) {
                                    if (file.path == null) continue;

                                    final documentFile = File(file.path!);
                                    await chatTarget.sendDocument(documentFile);
                                  }

                                  setUploading(false);
                                }

                                Navigator.pop(context);
                              },
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: _buildIconButton(
                                context,
                                icon: Icon(Icons.videocam, color: ChatifyColors.white, size: 30),
                                color1: ChatifyColors.pinkDark,
                                color2: ChatifyColors.pink,
                                label: S.of(context).camera,
                                onTap: () {
                                  Navigator.push(context, createPageRoute(CameraScreen(user: user)));
                                },
                              ),
                            ),
                            _buildIconButton(
                              context,
                              icon: Icon(Icons.image, color: ChatifyColors.white, size: 30),
                              color1: ChatifyColors.purpleDark,
                              color2: ChatifyColors.purple,
                              label: S.of(context).gallery,
                              onTap: () async {
                                final result = await FilePicker.pickFiles(type: FileType.custom, allowedExtensions: ['gif', 'jpg', 'jpeg', 'png']);

                                if (result.isNotEmpty) {
                                  for (var file in result) {
                                    final filePath = file.path!;
                                    if (file.extension == 'gif') {
                                      await sendGif(File(filePath));
                                    } else {
                                      setUploading(true);
                                      await chatTarget.sendImage(File(filePath));
                                      setUploading(false);
                                    }
                                  }
                                }
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 20),
                              child: _buildIconButton(
                                context,
                                icon: Icon(Icons.headphones, color: ChatifyColors.white, size: 30),
                                color1: ChatifyColors.orangeDark,
                                color2: ChatifyColors.orange,
                                label: S.of(context).audio,
                                onTap: () async {
                                  final result = await FilePicker.pickFiles(type: FileType.custom, allowedExtensions: ['mp3', 'aac', 'wav', 'm4a', 'ogg', 'flac', 'wma']);

                                  if (result.isNotEmpty) {
                                    setUploading(true);
                                    for (var file in result) {
                                      final documentFile = File(file.path!);
                                      final originalFileName = file.name;

                                      await chatTarget.sendAudio(documentFile, originalFileName);
                                    }
                                    setUploading(false);
                                  }
                                  Navigator.pop(context);
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: _buildIconButton(
                                context,
                                icon: Icon(Icons.location_on, color: ChatifyColors.white, size: 30),
                                color1: ChatifyColors.greenDark,
                                color2: ChatifyColors.green,
                                label: S.of(context).location,
                                onTap: () {
                                  Navigator.pop(context);
                                  showAddGeolocationDialog(context);
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: _buildIconButton(
                                context,
                                icon: Icon(Icons.person, color: ChatifyColors.white, size: 30),
                                color1: ChatifyColors.lightBlueDark,
                                color2: ChatifyColors.lightBlue,
                                label: S.of(context).contact,
                                onTap: () {
                                  Navigator.pop(context);
                                  Navigator.push(context, createPageRoute(const ContactsSendingScreen(selectedUsers: [])));
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.only(left: 30),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              _buildIconButton(
                                context,
                                icon: SvgPicture.asset(ChatifyVectors.list, width: 30, height: 30, colorFilter: ColorFilter.mode(ChatifyColors.white, BlendMode.srcIn)),
                                color1: ChatifyColors.blueGreenDark,
                                color2: ChatifyColors.blueGreen,
                                label: S.of(context).survey,
                                onTap: () {
                                  Navigator.pop(context);
                                  Navigator.push(context, createPageRoute(const CreateSurveyScreen()));
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
          icon: Icon(Icons.attach_file, color: ChatifyColors.textSecondary, size: 26),
        ),
      ],
    );
  }

  Widget _buildIconButton(BuildContext context, {required Widget icon, required Color color1, required Color color2, required String label, required VoidCallback onTap}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: onTap,
          child: CustomPaint(
            painter: CircleSplitPainter(color1: color1, color2: color2),
            child: SizedBox(width: 60, height: 60, child: Center(child: icon)),
          ),
        ),
        const SizedBox(height: 8),
        Text(label, style: TextStyle(fontSize: ChatifySizes.fontSizeSm, color: ChatifyColors.darkGrey), textAlign: TextAlign.center),
      ],
    );
  }
}
