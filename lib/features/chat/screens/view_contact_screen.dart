import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_utils/src/extensions/context_extensions.dart';
import '../../../api/apis.dart';
import '../../../generated/l10n/l10n.dart';
import '../../../routes/custom_page_route.dart';
import '../../../utils/constants/app_colors.dart';
import '../../../utils/constants/app_sizes.dart';
import '../../../utils/constants/app_vectors.dart';
import '../../../utils/devices/device_utility.dart';
import '../../../utils/popups/dialogs.dart';
import '../../personalization/widgets/dialogs/light_dialog.dart';
import '../../utils/widgets/dividers/custom_divider.dart';
import '../models/user_model.dart';
import '../widgets/dialogs/edit_new_contact_bottom_sheet_dialog.dart';
import 'chat_screen.dart';

class ViewContactScreen extends StatefulWidget {
  final UserModel user;

  const ViewContactScreen({
    super.key,
    required this.user,
  });

  @override
  State<ViewContactScreen> createState() => _ViewContactScreenState();
}

class _ViewContactScreenState extends State<ViewContactScreen> {
  bool _isLoadingProfileImage = false;
  String? _profileImageUrl;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;

      Dialogs.showProgressBarDialog(context, title: 'Обработка...', message: S.of(context).pleaseWait, verticalLayout: true);

      await Future.delayed(const Duration(seconds: 2));

      if (!mounted) return;

      Navigator.of(context, rootNavigator: true).pop();
    });

    _loadProfileImage();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        elevation: 0,
        title: Text('Просмотр контакта', style: TextStyle(fontSize: ChatifySizes.fontSizeMg, fontWeight: FontWeight.w400)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, size: 25),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(DeviceUtils.getScreenHeight(context) * .068),
                  child: CachedNetworkImage(
                    width: DeviceUtils.getScreenHeight(context) * .068,
                    height: DeviceUtils.getScreenHeight(context) * .068,
                    imageUrl: _profileImageUrl ?? '',
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(width: DeviceUtils.getScreenHeight(context) * .1, height: DeviceUtils.getScreenHeight(context) * .1, color: ChatifyColors.blackGrey),
                    errorWidget: (context, url, error) {
                      return CircleAvatar(
                        backgroundColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                        child: SvgPicture.asset(ChatifyVectors.profile, width: DeviceUtils.getScreenHeight(context) * .068, height: DeviceUtils.getScreenHeight(context) * .068),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Text(widget.user.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: ChatifySizes.fontSizeBg, fontWeight: FontWeight.w400)),
                ),
                const SizedBox(width: 12),
                OutlinedButton(
                  onPressed: () {
                    showEditNewContactBottomSheetDialog(context, widget.user);
                  },
                  style: OutlinedButton.styleFrom(
                    splashFactory: NoSplash.splashFactory,
                    backgroundColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                    foregroundColor: ChatifyColors.black.withValues(alpha: 0.1),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    side: BorderSide.none,
                  ),
                  child: Text('Добавить', style: TextStyle(color: ChatifyColors.black, fontSize: 15, fontWeight: FontWeight.w400)),
                ),
              ],
            ),
          ),
          CustomDivider(indent: 0, endIndent: 0, left: 0, right: 0, top: 0, bottom: 0),
          _buildContactOption(index: 0, icon: Icons.phone_outlined, title: widget.user.phoneNumber, subtitle: 'Моб.'),
          _buildContactOption(index: 1, icon: Icons.alternate_email_rounded, title: '@${widget.user.username}', subtitle: 'Имя пользователя'),
        ],
      ),
    );
  }

  Widget _buildContactOption({required int index, required IconData icon, required String title, required String subtitle}) {
    return Material(
      color: ChatifyColors.transparent,
      child: InkWell(
        splashFactory: NoSplash.splashFactory,
        splashColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
        highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
        hoverColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
        onTap: () async {
          Dialogs.showProgressBarDialog(context, title: '', message: S.of(context).loading);

          await Future.delayed(const Duration(seconds: 1));

          if (!context.mounted) return;

          Navigator.of(context, rootNavigator: true).pop();

          Navigator.push(context, createPageRoute(ChatScreen(user: widget.user)));
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 13),
          child: Row(
            children: [
              Icon(icon, size: 25, color: colorsController.getColor(colorsController.selectedColorScheme.value)),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400)),
                    const SizedBox(height: 1),
                    Text(subtitle, style: TextStyle(fontSize: ChatifySizes.fontSizeSm, color: ChatifyColors.darkGrey, fontWeight: FontWeight.w400)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
