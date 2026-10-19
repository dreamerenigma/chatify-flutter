import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_utils/src/extensions/context_extensions.dart';
import '../../../api/apis.dart';
import '../../../api/chat_api.dart';
import '../../../utils/constants/app_colors.dart';
import '../../../utils/constants/app_sizes.dart';
import '../../../utils/constants/app_vectors.dart';
import '../../../utils/devices/device_utility.dart';
import '../../home/widgets/checkboxes/custom_checkbox.dart';
import '../../personalization/widgets/dialogs/light_dialog.dart';
import '../../utils/widgets/dividers/custom_divider.dart';
import '../models/user_model.dart';

class SendContactScreen extends StatefulWidget {
  final List<UserModel> users;
  final UserModel user;

  const SendContactScreen({
    super.key,
    required this.users,
    required this.user,
  });

  @override
  State<SendContactScreen> createState() => _SendContactScreenState();
}

class _SendContactScreenState extends State<SendContactScreen> {
  final RxList<bool> _selectedOptions = [true, true].obs;
  bool _isLoadingProfileImage = false;
  String? _profileImageUrl;

  bool get _hasSelectedContactOptions => _selectedOptions.any((selected) => selected);

  Map<String, dynamic> _buildContactPayload() {
    final payload = <String, dynamic>{
      'type': 'contact',
      'userId': widget.user.id,
      'name': widget.user.name,
    };

    if (_selectedOptions[0]) {
      payload['phoneNumber'] = widget.user.phoneNumber;
    }

    if (_selectedOptions[1]) {
      payload['username'] = widget.user.username;
    }

    return payload;
  }

  @override
  void initState() {
    super.initState();
    _loadProfileImage();
  }

  void _toggleContactOption(int index) {
    _selectedOptions[index] = !_selectedOptions[index];
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
        title: Text('Отправить контакт', style: TextStyle(fontSize: ChatifySizes.fontSizeXl, fontWeight: FontWeight.w400)),
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
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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
                  child: Text(
                    widget.user.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: ChatifySizes.fontSizeBg, fontWeight: FontWeight.w400),
                  ),
                ),
              ],
            ),
          ),
          CustomDivider(indent: 0, endIndent: 0, left: 0, right: 0, top: 0, bottom: 0),
          _buildContactOption(index: 0, icon: Icons.phone_outlined, title: widget.user.phoneNumber, subtitle: 'Моб.'),
          _buildContactOption(index: 1, icon: Icons.alternate_email_rounded, title: '@${widget.user.username}', subtitle: 'Имя пользователя'),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 5),
        child: FloatingActionButton(
          heroTag: 'sendContact',
          onPressed: () async {
            if (!_hasSelectedContactOptions) {
              return;
            }

            final contactPayload = _buildContactPayload();

            try {
              for (final chatUser in widget.users) {
                await ChatApi.sendChatContact(chatUser, widget.user, includePhone: _selectedOptions[0], includeUsername: _selectedOptions[1]);
              }

              log('CONTACT PAYLOAD: $contactPayload');

              if (!mounted) return;
              Navigator.pop(context);
            } catch (e, stackTrace) {
              log('SEND CONTACT ERROR: $e', stackTrace: stackTrace);
            }
          },
          backgroundColor: colorsController.getColor(colorsController.selectedColorScheme.value),
          foregroundColor: ChatifyColors.white,
          child: Padding(
            padding: const EdgeInsets.only(left: 4),
            child: Icon(Icons.send, size: 25, color: ChatifyColors.black),
          ),
        ),
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
        onTap: () => _toggleContactOption(index),
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
              CustomCheckbox(
                index: index,
                selectedOptions: _selectedOptions,
                onChanged: (value) {
                  _selectedOptions[index] = value;
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
