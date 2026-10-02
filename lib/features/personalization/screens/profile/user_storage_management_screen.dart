import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatify/features/utils/widgets/scrolls/no_glow_scroll_behavior.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_utils/src/extensions/context_extensions.dart';
import '../../../../api/apis.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../../utils/constants/app_vectors.dart';
import '../../../chat/models/user_model.dart';
import '../../widgets/dialogs/light_dialog.dart';
import '../../widgets/dialogs/sort_bottom_sheet_dialog.dart';
import '../../widgets/items/chat_media_item.dart';
import '../../widgets/media/chat_media_preview.dart';

class UserStorageManagementScreen extends StatefulWidget {
  final UserModel user;
  final Stream<List<ChatMediaItem>> mediaStream;

  const UserStorageManagementScreen({
    super.key,
    required this.user,
    required this.mediaStream,
  });

  @override
  State<UserStorageManagementScreen> createState() => _UserStorageManagementScreenState();
}

class _UserStorageManagementScreenState extends State<UserStorageManagementScreen> {
  String? _profileImageUrl;
  bool _isLoadingProfileImage = false;

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
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration: BoxDecoration(
            color: ChatifyColors.white,
            boxShadow: [BoxShadow(color: ChatifyColors.black.withAlpha((0.1 * 255).toInt()), spreadRadius: 1, blurRadius: 3, offset: const Offset(0, 1))],
          ),
          child: AppBar(
            titleSpacing: 0,
            elevation: 0,
            backgroundColor: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.white,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_rounded, size: 25),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            title: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(21),
                  child: CachedNetworkImage(
                    imageUrl: _profileImageUrl ?? '',
                    width: 38,
                    height: 38,
                    fit: BoxFit.cover,
                    errorWidget: (context, url, error) {
                      return CircleAvatar(
                        backgroundColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                        child: SvgPicture.asset(ChatifyVectors.profile, width: 42, height: 42),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.user.username.trim().isNotEmpty ? '@${widget.user.username}' : '${widget.user.name} ${widget.user.surname}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black, fontSize: ChatifySizes.fontSizeLg, fontWeight: FontWeight.w400),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '20,2 МБ',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: ChatifyColors.darkGrey, fontSize: 15, fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: GestureDetector(
                    onTap: () {
                      showSortBottomSheetDialog(context);
                    },
                    child: SvgPicture.asset(ChatifyVectors.sort, width: 22, height: 22, colorFilter: ColorFilter.mode(context.isDarkMode ? ChatifyColors.white : ChatifyColors.black, BlendMode.srcIn)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            child: Row(
              children: [
                Text('РАЗМЕР', style: TextStyle(color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black, fontSize: 13, fontWeight: FontWeight.w500)),
                const Spacer(),
                Text('Выбрать все', style: TextStyle(color: ChatifyColors.darkGrey, fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w400)),
                const SizedBox(width: 8),
                SizedBox(
                  width: 20,
                  height: 20,
                  child: Checkbox(
                    value: false,
                    onChanged: (value) {},
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    side: BorderSide(color: ChatifyColors.darkGrey, width: 1.5),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<List<ChatMediaItem>>(
              stream: widget.mediaStream,
              builder: (context, snapshot) {
                final media = snapshot.data ?? [];

                if (media.isEmpty) {
                  return const SizedBox.shrink();
                }

                return ScrollConfiguration(
                  behavior: NoGlowScrollBehavior(),
                  child: GridView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: media.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 2, mainAxisSpacing: 2, childAspectRatio: 1),
                    itemBuilder: (context, index) {
                      return ChatMediaPreview(media: media[index], borderRadius: 0);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
