import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatify/features/personalization/screens/account/edit_phone_screen.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../../../api/apis.dart';
import '../../../../../generated/l10n/l10n.dart';
import '../../../../../utils/constants/app_colors.dart';
import '../../../../routes/custom_page_route.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../../utils/constants/app_vectors.dart';
import '../../../../utils/devices/device_utility.dart';
import '../../../chat/models/user_model.dart';
import '../../controllers/user_controller.dart';
import '../../screens/profile/links_screen.dart';
import '../../screens/profile/profile_intelligence_screen.dart';
import '../../screens/profile/photo_profile_screen.dart';
import '../dialogs/enter_name_bottom_dialog.dart';
import '../dialogs/light_dialog.dart';
import '../dialogs/profile_bottom_dialog.dart';

class ProfileForm extends StatefulWidget {
  final UserModel user;
  final String? image;
  final Function(String?) onImagePicked;
  final GlobalKey<FormState> formKey;
  final String status;

  const ProfileForm({
    super.key,
    required this.user,
    required this.image,
    required this.onImagePicked,
    required this.formKey,
    required this.status,
  });

  @override
  State<ProfileForm> createState() => ProfileFormState();
}

class ProfileFormState extends State<ProfileForm> {
  late UserController userController;
  bool _isVisible = false;
  double _scale = 1.3;

  @override
  void initState() {
    super.initState();
    userController = Get.find<UserController>();
    Future.delayed(const Duration(milliseconds: 700), () {
      setState(() {
        _isVisible = true;
      });
    });
  }

  void _navigateToProfileScreen() async {
    setState(() {
      _scale = 0;
      _isVisible = false;
    });

    await Future.delayed(const Duration(milliseconds: 300));
    await Navigator.push(context, createPageRoute(PhotoProfileScreen(image: widget.user.image, user: widget.user)));

    setState(() {
      _scale = 1.3;
      _isVisible = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: widget.formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(width: DeviceUtils.getScreenWidth(context), height: DeviceUtils.getScreenHeight(context) * .03),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Ink(
                      decoration: BoxDecoration(
                        color: ChatifyColors.darkGrey,
                        shape: BoxShape.circle,
                        border: Border.all(color: ChatifyColors.darkerGrey.withAlpha((0.2 * 255).toInt()), width: 1),
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        clipBehavior: Clip.none,
                        children: [
                          widget.image != null
                            ? ClipRRect(
                              borderRadius: BorderRadius.circular(DeviceUtils.getScreenHeight(context) * .1),
                              child: Image.file(File(widget.image!), width: DeviceUtils.getScreenHeight(context) * .18, height: DeviceUtils.getScreenHeight(context) * .18, fit: BoxFit.cover),
                            )
                            : ClipRRect(
                              borderRadius: BorderRadius.circular(DeviceUtils.getScreenHeight(context) * .1),
                              child: widget.user.image.isNotEmpty
                                ? CachedNetworkImage(
                                  width: DeviceUtils.getScreenHeight(context) * .18,
                                  height: DeviceUtils.getScreenHeight(context) * .18,
                                  fit: BoxFit.cover,
                                  imageUrl: widget.user.image,
                                  errorWidget: (context, url, error) => CircleAvatar(
                                    radius: DeviceUtils.getScreenHeight(context) * .075,
                                    backgroundColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                                    foregroundColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                                    child: SvgPicture.asset(
                                      ChatifyVectors.profile,
                                      width: DeviceUtils.getScreenHeight(context) * .2,
                                      height: DeviceUtils.getScreenHeight(context) * .2,
                                    ),
                                  ),
                                )
                                : CircleAvatar(
                                  radius: DeviceUtils.getScreenHeight(context) * .1,
                                  backgroundColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                                  foregroundColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                                  child: SvgPicture.asset(ChatifyVectors.profile, width: DeviceUtils.getScreenHeight(context) * .2, height: DeviceUtils.getScreenHeight(context) * .2),
                                ),
                              ),
                              Material(
                                color: ChatifyColors.transparent,
                                child: InkWell(
                                  onTap: () {
                                    final hasAvatar = widget.image != null || widget.user.image.isNotEmpty;

                                    if (hasAvatar) {
                                      _navigateToProfileScreen();
                                    } else {
                                      showProfileBottomSheet(context, widget.onImagePicked);
                                    }
                                  },
                                  borderRadius: BorderRadius.circular(80),
                                  splashColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey,
                                  highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey,
                                  child: Container(
                                    width: DeviceUtils.getScreenHeight(context) * .2,
                                    height: DeviceUtils.getScreenHeight(context) * .2,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(80),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: -6,
                                right: -15,
                                child: AnimatedScale(
                                  scale: _scale,
                                  duration: const Duration(milliseconds: 500),
                                  curve: Curves.easeInOut,
                                  child: AnimatedOpacity(
                                    opacity: _isVisible ? 1 : 0,
                                    duration: const Duration(milliseconds: 500),
                                    curve: Curves.easeInOut,
                                    child: MaterialButton(
                                      elevation: 1,
                                      onPressed: () {
                                        showProfileBottomSheet(context, widget.onImagePicked);
                                      },
                                      shape: const CircleBorder(),
                                      color: colorsController.getColor(colorsController.selectedColorScheme.value),
                                      padding: const EdgeInsets.all(8),
                                      child: const Icon(Icons.camera_alt_outlined, color: Colors.white, size: 20),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                    ),
                  ],
                ),
                SizedBox(height: 18),
                _buildProfileInfo(Icons.person_outline_rounded, 'Имя', APIs.me.name, null, () {
                  showEnterNameBottomDialog(
                    context,
                    APIs.me.name,
                    (newName) {
                      setState(() {
                        APIs.me.name = newName;
                      });
                    },
                  );
                }),
                // TextSelectionTheme(
                //   data: TextSelectionThemeData(
                //     cursorColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                //     selectionColor: colorsController.getColor(colorsController.selectedColorScheme.value).withAlpha((0.3 * 255).toInt()),
                //     selectionHandleColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                //   ),
                //   child: TextFormField(
                //     initialValue: widget.user.name,
                //     onSaved: (val) => APIs.me.name = val ?? '',
                //     validator: (val) => val != null && val.isNotEmpty ? null : S.of(context).requiredField,
                //     textCapitalization: TextCapitalization.sentences,
                //     decoration: InputDecoration(
                //       prefixIcon: Icon(Icons.person, color: colorsController.getColor(colorsController.selectedColorScheme.value)),
                //       border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                //       hintText: S.of(context).hintName,
                //       hintStyle: const TextStyle(color: ChatifyColors.darkGrey),
                //       labelText: S.of(context).name,
                //       focusedBorder: OutlineInputBorder(
                //         borderRadius: BorderRadius.circular(15),
                //         borderSide: BorderSide(color: colorsController.getColor(colorsController.selectedColorScheme.value), width: 2.0),
                //       ),
                //       enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: const BorderSide(color: Colors.grey, width: 1.0)),
                //     ),
                //   ),
                // ),
                // TextSelectionTheme(
                //   data: TextSelectionThemeData(
                //     cursorColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                //     selectionColor: colorsController.getColor(colorsController.selectedColorScheme.value).withAlpha((0.3 * 255).toInt()),
                //     selectionHandleColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                //   ),
                //   child: TextFormField(
                //     initialValue: widget.user.about,
                //     onSaved: (val) => APIs.me.about = val ?? '',
                //     validator: (val) => val != null && val.isNotEmpty ? null : S.of(context).requiredField,
                //     decoration: InputDecoration(
                //       prefixIcon: Icon(Icons.info_outline, color: colorsController.getColor(colorsController.selectedColorScheme.value)),
                //       border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                //       hintText: S.of(context).hintAbout,
                //       hintStyle: const TextStyle(color: ChatifyColors.darkGrey),
                //       label: Text(S.of(context).aboutField),
                //       focusedBorder: OutlineInputBorder(
                //         borderRadius: BorderRadius.circular(15),
                //         borderSide: BorderSide(color: colorsController.getColor(colorsController.selectedColorScheme.value), width: 2.0),
                //       ),
                //       enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: const BorderSide(color: Colors.grey, width: 1.0)),
                //     ),
                //     cursorColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                //     textCapitalization: TextCapitalization.sentences,
                //   ),
                // ),
                _buildProfileInfo(Icons.info_outline, 'Сведения', APIs.me.about, null, () {
                  Navigator.push(context, createPageRoute(ProfileIntelligenceScreen()));
                }),
                // TextSelectionTheme(
                //   data: TextSelectionThemeData(
                //     cursorColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                //     selectionColor: colorsController.getColor(colorsController.selectedColorScheme.value).withAlpha((0.3 * 255).toInt()),
                //     selectionHandleColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                //   ),
                //   child: GestureDetector(
                //     onTap: () {
                //       Navigator.push(context, createPageRoute(const ProfileIntelligenceScreen()));
                //     },
                //     child: AbsorbPointer(
                //       child: TextFormField(
                //         enabled: false,
                //         initialValue: widget.user.status,
                //         onSaved: (val) => APIs.me.status = val ?? '',
                //         validator: (val) => val != null && val.isNotEmpty ? null : S.of(context).requiredField,
                //         decoration: InputDecoration(
                //           prefixIcon: Icon(FluentIcons.status_16_filled, color: colorsController.getColor(colorsController.selectedColorScheme.value)),
                //           border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                //           hintText: S.of(context).hintStatus,
                //           labelText: S.of(context).status,
                //           focusedBorder: OutlineInputBorder(
                //             borderRadius: BorderRadius.circular(15),
                //             borderSide: BorderSide(color: colorsController.getColor(colorsController.selectedColorScheme.value), width: 2.0),
                //           ),
                //           disabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: const BorderSide(color: Colors.grey, width: 1.0)),
                //           enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: const BorderSide(color: Colors.grey, width: 1.0)),
                //         ),
                //         cursorColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                //         textCapitalization: TextCapitalization.sentences,
                //         style: TextStyle(color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black),
                //       ),
                //     ),
                //   ),
                // ),
                _buildProfileInfo(FluentIcons.status_16_filled, 'Статус', APIs.me.status, null, () {
                  Navigator.push(context, createPageRoute(ProfileIntelligenceScreen()));
                }),
                // TextSelectionTheme(
                //   data: TextSelectionThemeData(
                //     cursorColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                //     selectionColor: colorsController.getColor(colorsController.selectedColorScheme.value).withAlpha((0.3 * 255).toInt()),
                //     selectionHandleColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                //   ),
                //   child: TextFormField(
                //     initialValue: widget.user.phoneNumber,
                //     onSaved: (val) => APIs.me.phoneNumber = val ?? '',
                //     validator: (val) => val != null && val.isNotEmpty ? null : S.of(context).requiredField,
                //     inputFormatters: [PhoneNumberInputFormatter()],
                //     keyboardType: TextInputType.phone,
                //     decoration: InputDecoration(
                //       prefixIcon: Icon(Icons.phone_android, color: colorsController.getColor(colorsController.selectedColorScheme.value)),
                //       border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                //       hintText: S.of(context).hintPhoneNumber,
                //       hintStyle: const TextStyle(color: ChatifyColors.darkGrey),
                //       labelText: S.of(context).phoneNumber,
                //       focusedBorder: OutlineInputBorder(
                //         borderRadius: BorderRadius.circular(15),
                //         borderSide: BorderSide(color: colorsController.getColor(colorsController.selectedColorScheme.value), width: 2.0),
                //       ),
                //       enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: const BorderSide(color: Colors.grey, width: 1.0)),
                //     ),
                //     cursorColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                //   ),
                // ),
                _buildProfileInfo(Icons.phone_android, 'Телефон', APIs.me.phoneNumber, null, () {
                  Navigator.push(context, createPageRoute(EditPhoneScreen()));
                }),
                _buildProfileInfo(Icons.alternate_email_outlined, 'Почта', widget.user.email, null, () {
                  Clipboard.setData(ClipboardData(text: widget.user.email));
                  Get.snackbar('Скопированно', S.of(context).emailCopied);
                }),
                _buildProfileInfo(Icons.link, 'Ссылки', 'Добавьте сссылки', colorsController.getColor(colorsController.selectedColorScheme.value), () {
                  Navigator.push(context, createPageRoute(LinksScreen()));
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileInfo(IconData icon, String title, String subtitle, Color? color, VoidCallback? onTap) {
    return InkWell(
      onTap: onTap,
      splashColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey,
      highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Row(
          children: [
            Icon(icon, size: 26, color: colorsController.getColor(colorsController.selectedColorScheme.value)),
            const SizedBox(width: 25),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                SizedBox(
                  width: MediaQuery.of(context).size.width - 100,
                  child: Text(
                    subtitle,
                    style: TextStyle(fontSize: ChatifySizes.fontSizeSm, color: color),
                    softWrap: true,
                    overflow: TextOverflow.visible,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
