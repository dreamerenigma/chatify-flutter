import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../../../api/apis.dart';
import '../../../../../generated/l10n/l10n.dart';
import '../../../../../utils/constants/app_colors.dart';
import '../../../../../utils/constants/app_sizes.dart';
import '../../../../../utils/constants/app_vectors.dart';
import '../../../../../utils/helper/file_util.dart';
import '../../../../../utils/popups/dialogs.dart';
import '../../../../chat/models/user_model.dart';
import '../../../../chat/widgets/dialogs/items/menu_item.dart';
import '../../../../chat/widgets/dialogs/select_message_dialog.dart';
import '../../../../personalization/controllers/user_controller.dart';
import '../../../../personalization/widgets/dialogs/light_dialog.dart';
import '../../input/edit_text_input.dart';
import '../confirmation_dialog.dart';
import '../edit_profile_image_dialog.dart';

class ProfileOptionWidget extends StatefulWidget {
  final UserModel user;
  final OverlayEntry overlayEntry;

  const ProfileOptionWidget({super.key, required this.user, required this.overlayEntry});

  @override
  State<ProfileOptionWidget> createState() => _ProfileOptionWidgetState();
}

class _ProfileOptionWidgetState extends State<ProfileOptionWidget> with TickerProviderStateMixin {
  final userController = Get.find<UserController>();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController intelligenceController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  late Worker _userListener;
  late Future<void> Function(File) onImageSelected;
  bool isHovered = false;
  bool isEditingUsername = false;
  bool isEditingIntelligence = false;
  bool isPressedLogout = false;
  bool isHoveredLogout = false;

  @override
  void initState() {
    super.initState();
    usernameController.text = widget.user.name.isNotEmpty ? widget.user.name : S.of(context).username;

    _userListener = ever(userController.user, (UserModel updatedUser) {
      if (!isEditingUsername && mounted) {
        usernameController.text = updatedUser.name;
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    usernameController.text = widget.user.name.isNotEmpty ? widget.user.name : S.of(context).username;
    intelligenceController.text = S.of(context).howAreYou;
  }

  @override
  void dispose() {
    _userListener.dispose();
    usernameController.dispose();
    intelligenceController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _updateProfileImage(File file) async {
    await APIs.updateProfilePicture(file);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MouseRegion(
            onEnter: (_) {
              setState(() {
                isHovered = true;
              });
            },
            onExit: (_) {
              setState(() {
                isHovered = false;
              });
            },
            child: GestureDetector(
              onTap: () async {
                if (userController.currentUser.image.isEmpty) {
                  final String initialDirectory = "C:\\Users\\${await FileUtil.getUserName()}\\Pictures";
                  final List<PlatformFile> result = await FilePicker.pickFiles(type: FileType.image, initialDirectory: initialDirectory);

                  if (result.isEmpty) {
                    return;
                  }

                  final String filePath = result.single.path!;
                  final File selectedFile = File(filePath);

                  await onImageSelected(selectedFile);
                } else {
                  showEditProfileImageDialog(context, this, _updateProfileImage);
                }
              },
              child: Stack(
                alignment: Alignment.center,
                children: [
                  ClipOval(
                    child: CachedNetworkImage(
                      width: 100,
                      height: 100,
                      imageUrl: widget.user.image,
                      fit: BoxFit.cover,
                      errorWidget: (context, url, error) => CircleAvatar(
                        backgroundColor: context.isDarkMode ? ChatifyColors.softNight : ChatifyColors.grey,
                        foregroundColor:  context.isDarkMode ? ChatifyColors.softNight : ChatifyColors.grey,
                        child: SvgPicture.asset(ChatifyVectors.avatar, width: 28, height: 28, colorFilter: ColorFilter.mode(context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.iconGrey, BlendMode.srcIn)),
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: AnimatedOpacity(
                      opacity: isHovered ? 0.5 : 0.0,
                      duration: Duration(milliseconds: 200),
                      child: Container(decoration: BoxDecoration(color: ChatifyColors.black, borderRadius: BorderRadius.circular(80))),
                    ),
                  ),
                  AnimatedOpacity(
                    opacity: isHovered ? 1.0 : 0.0,
                    duration: Duration(milliseconds: 200),
                    child: SvgPicture.asset(ChatifyVectors.pencil, width: 20, height: 20, colorFilter: ColorFilter.mode( ChatifyColors.white, BlendMode.srcIn)),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 22),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: isEditingUsername
                  ? EditTextInput(
                      controller: usernameController,
                      focusNode: _focusNode,
                      fontSize: ChatifySizes.fontSizeBg,
                      contentPadding: EdgeInsets.symmetric(horizontal: 6, vertical: 15),
                      onUnFocus: () async {
                        String updatedName = usernameController.text.trim();

                        if (updatedName.isEmpty) {
                          showConfirmationDialog(
                            context: context,
                            width: 410,
                            title: S.of(context).unableChangeYourName,
                            description: S.of(context).yourNameCannotEmpty,
                            cancelText: S.of(context).ok,
                            cancelButtonColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                            cancelTextColor: ChatifyColors.black,
                            cancelButtonWidth: 180,
                            confirmButton: true,
                            onConfirm: () {
                              setState(() {
                                isEditingUsername = false;
                              });
                            },
                          );
                        } else {
                          final updatedUser = userController.currentUser.copyWith(name: updatedName);

                          await userController.updateUser(updatedUser);
                          usernameController.text = updatedName;

                          Future.delayed(Duration(milliseconds: 100), () {
                            setState(() {
                              isEditingUsername = false;
                            });
                          });
                        }
                      },
                    )
                  : Theme(
                      data: Theme.of(context).copyWith(
                        textSelectionTheme: TextSelectionThemeData(selectionColor: ChatifyColors.info, selectionHandleColor: colorsController.getColor(colorsController.selectedColorScheme.value)),
                      ),
                      child: Obx(() {
                        final name = userController.user.value.name;
                        usernameController.value = usernameController.value.copyWith(text: name);

                        return SelectableText(userController.user.value.name, style: TextStyle(fontSize: ChatifySizes.fontSizeBg, fontWeight: FontWeight.w400, fontFamily: 'Roboto'));
                      }),
                ),
              ),
              if (!isEditingUsername)
              Material(
                color: ChatifyColors.transparent,
                child: InkWell(
                  onTap: () {
                    setState(() {
                      isEditingUsername = true;
                      _focusNode.requestFocus();
                    });
                  },
                  mouseCursor: SystemMouseCursors.basic,
                  splashColor: ChatifyColors.transparent,
                  highlightColor: context.isDarkMode ? ChatifyColors.mildNight : ChatifyColors.grey,
                  hoverColor: context.isDarkMode ? ChatifyColors.softNight : ChatifyColors.grey.withAlpha((0.6 * 255).toInt()),
                  borderRadius: BorderRadius.circular(8),
                  child: Padding(padding: const EdgeInsets.all(8), child: SvgPicture.asset(ChatifyVectors.pencil, width: 18, height: 18, colorFilter: ColorFilter.mode(ChatifyColors.white, BlendMode.srcIn))),
                ),
              ),
            ],
          ),
          SizedBox(height: isEditingUsername ? 0 : 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(S.of(context).intelligence, style: TextStyle(fontSize: ChatifySizes.fontSizeSm, color: context.isDarkMode ? ChatifyColors.grey : ChatifyColors.darkBackground, fontWeight: FontWeight.w200, height: 1.2)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: isEditingIntelligence
                      ? EditTextInput(
                          controller: intelligenceController,
                          focusNode: _focusNode,
                          fontSize: 15,
                          contentPadding: EdgeInsets.symmetric(horizontal: 6, vertical: 17),
                          onUnFocus: () {
                            if (intelligenceController.text.trim().isEmpty) {
                              showConfirmationDialog(
                                context: context,
                                title: S.of(context).unableEditYourDetails,
                                description: S.of(context).informationCannotEmpty,
                                cancelText: S.of(context).ok,
                                confirmButton: true,
                                onConfirm: () {
                                  setState(() {
                                    isEditingIntelligence = false;
                                  });
                                },
                              );
                            } else {
                              final updatedStatus = intelligenceController.text.trim();

                              final updatedUser = userController.currentUser.copyWith(status: updatedStatus);
                              userController.updateUser(updatedUser);

                              Future.delayed(Duration(milliseconds: 100), () {
                                setState(() {
                                  isEditingIntelligence = false;
                                });
                              });
                            }
                          },
                        )
                      : Theme(
                          data: Theme.of(context).copyWith(
                            textSelectionTheme: TextSelectionThemeData(selectionColor: ChatifyColors.info, selectionHandleColor: colorsController.getColor(colorsController.selectedColorScheme.value)),
                          ),
                          child: Obx(() {
                            intelligenceController.text = userController.user.value.status;
                            return SelectableText(userController.user.value.status, style: TextStyle(fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w400, fontFamily: 'Roboto'));
                          }),
                        ),
                  ),
                  if (!isEditingIntelligence)
                  Material(
                    color: ChatifyColors.transparent,
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          isEditingIntelligence = true;
                          _focusNode.requestFocus();
                        });
                      },
                      mouseCursor: SystemMouseCursors.basic,
                      splashColor: ChatifyColors.transparent,
                      highlightColor: context.isDarkMode ? ChatifyColors.mildNight : ChatifyColors.grey,
                      hoverColor: context.isDarkMode ? ChatifyColors.softNight : ChatifyColors.grey.withAlpha((0.6 * 255).toInt()),
                      borderRadius: BorderRadius.circular(8),
                      child: Padding(padding: const EdgeInsets.all(8), child: SvgPicture.asset(ChatifyVectors.pencil, width: 18, height: 18, colorFilter: ColorFilter.mode( ChatifyColors.white, BlendMode.srcIn))),
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: isEditingIntelligence ? 0 : 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                S.of(context).phoneNumber,
                style: TextStyle(
                  fontSize: ChatifySizes.fontSizeSm,
                  color: context.isDarkMode ? ChatifyColors.grey : ChatifyColors.darkBackground,
                  fontWeight: FontWeight.w200,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 5),
              GestureDetector(
                onSecondaryTapDown: (details) {
                  showSelectMessageDialog(
                    context: context,
                    position: details.globalPosition,
                    items: [
                      MenuItem(
                        icon: Icons.copy,
                        iconSize: 17,
                        text: S.of(context).copy,
                        trailingText: 'Ctrl+C',
                        onTap: () {
                          Clipboard.setData(ClipboardData(text: widget.user.phoneNumber));
                        },
                      ),
                      MenuItem(
                        text: S.of(context).selectAll,
                        trailingText: 'Ctrl+A',
                        onTap: () {},
                      ),
                    ],
                  );
                },
                child: Theme(
                  data: Theme.of(context).copyWith(
                    textSelectionTheme: TextSelectionThemeData(
                    selectionColor: ChatifyColors.info,
                    selectionHandleColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                    ),
                  ),
                  child: SelectableText(
                    widget.user.phoneNumber,
                    style: TextStyle(
                      fontSize: ChatifySizes.fontSizeSm,
                      color: context.isDarkMode ? ChatifyColors.grey : ChatifyColors.darkBackground,
                      fontWeight: FontWeight.w300,
                      fontFamily: 'Roboto',
                      height: 1.2,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 15),
          Divider(thickness: 1, color: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.5 * 255).toInt()) : ChatifyColors.grey),
          SizedBox(height: 15),
          GestureDetector(
            onLongPress: () {
              setState(() {
                isPressedLogout = true;
              });
            },
            onLongPressEnd: (_) {
              setState(() {
                isPressedLogout = false;
              });
            },
            onLongPressUp: () {
              setState(() {
                isPressedLogout = false;
              });
            },
            child: MouseRegion(
              onEnter: (_) {
                setState(() {
                  isHoveredLogout = true;
                });
              },
              onExit: (_) {
                setState(() {
                  isHoveredLogout = false;
                });
              },
              child: ElevatedButton(
                onPressed: () async {
                  setState(() {
                    isPressedLogout = true;
                  });
                  showConfirmationDialog(
                    context: context,
                    width: 420,
                    title: S.of(context).confirmExit,
                    description: S.of(context).areYouSureYouLogout,
                    confirmButtonColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                    reverseButtons: false,
                    onConfirm: () async {
                      widget.overlayEntry.remove();

                      Dialogs.showProgressBarDialog(context, title: 'Выход', message: 'Не закрывайте это окно', verticalLayout: true, maxWidth: 400, maxHeight: 250);

                      await Future.delayed(const Duration(seconds: 2));

                      APIs.signOut();

                      if (context.mounted) Navigator.of(context).pop();
                    },
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                  backgroundColor: isPressedLogout ? (context.isDarkMode ? ChatifyColors.mildNight : ChatifyColors.grey.withAlpha(100)) : isHoveredLogout
                    ? (context.isDarkMode ? ChatifyColors.lightSoftNight.withAlpha((0.8 * 255).toInt()) : ChatifyColors.black.withAlpha((0.3 * 255).toInt()))
                    : (context.isDarkMode ? ChatifyColors.softNight : ChatifyColors.white),
                  foregroundColor: context.isDarkMode ? ChatifyColors.steelGrey : ChatifyColors.darkGrey,
                  side: BorderSide(color: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey, width: 1),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                  elevation: 0,
                ).copyWith(
                  splashFactory: NoSplash.splashFactory,
                  shadowColor: WidgetStateProperty.all(ChatifyColors.transparent),
                  mouseCursor: WidgetStateProperty.all(SystemMouseCursors.basic),
                  elevation: WidgetStateProperty.all(0),
                ),
                child: Text(
                  '${S.of(context).signOut[0].toUpperCase()}${S.of(context).signOut.substring(1)}',
                  style: TextStyle(fontSize: ChatifySizes.fontSizeSm, color: ChatifyColors.error, fontWeight: FontWeight.w400),
                ),
              ),
            ),
          ),
          SizedBox(height: 10),
          Text(S.of(context).chatHistoryComputerClearedSignOut, style: TextStyle(fontSize: ChatifySizes.fontSizeLm, color: context.isDarkMode ? ChatifyColors.grey : ChatifyColors.darkBackground, fontWeight: FontWeight.w200, height: 1.2)),
        ],
      ),
    );
  }
}
