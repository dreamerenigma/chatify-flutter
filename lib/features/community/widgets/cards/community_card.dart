import 'package:chatify/features/community/screens/community_info_screen.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatify/features/community/models/community_model.dart';
import 'package:get/get.dart';
import '../../../../../utils/constants/app_sizes.dart';
import '../../../../api/apis.dart';
import '../../../../generated/l10n/l10n.dart';
import '../../../../routes/custom_page_route.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../personalization/widgets/dialogs/light_dialog.dart';
import '../../screens/edit_community_screen.dart';

class CommunityCard extends StatefulWidget {
  final CommunityModel community;
  final VoidCallback? onTap;
  final bool isValidDate;
  final String fileToSend;

  const CommunityCard({
    super.key,
    this.onTap,
    required this.community,
    required this.isValidDate,
    required this.fileToSend,
  });

  @override
  State<CommunityCard> createState() => _CommunityCardState();
}

class _CommunityCardState extends State<CommunityCard> {
  bool isSelected = false;
  String? _communityImageUrl;

  @override
  void initState() {
    super.initState();
    _loadCommunityImage();
  }

  Future<void> _loadCommunityImage() async {
    final imagePath = widget.community.image.trim();

    if (imagePath.isEmpty) return;

    try {
      final imageUrl = await APIs.mediaService.getUrl(imagePath);

      if (!mounted) return;

      setState(() {
        _communityImageUrl = imageUrl;
      });
    } catch (e) {
      debugPrint('Ошибка загрузки изображения сообщества: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      color: context.isDarkMode ? ChatifyColors.darkBackground : ChatifyColors.white,
      child: Material(
        color: ChatifyColors.transparent,
        child: InkWell(
          splashFactory: NoSplash.splashFactory,
          splashColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
          highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
          hoverColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
          onTap: () {
            Navigator.push(context, createPageRoute(CommunityInfoScreen(community: widget.community, isValidDate: (date) => widget.isValidDate, fileToSend: widget.fileToSend)));
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Material(
                  color: ChatifyColors.transparent,
                  child: InkWell(
                    splashFactory: NoSplash.splashFactory,
                    splashColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
                    highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
                    hoverColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
                    onTap: () {
                      Navigator.push(context, createPageRoute(EditCommunityScreen(community: widget.community)));
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(40),
                      child: SizedBox(
                        width: 50,
                        height: 50,
                        child: _communityImageUrl == null
                          ? CircleAvatar(
                              backgroundColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                              foregroundColor: ChatifyColors.white,
                              child: const Icon(Icons.groups, size: 26, color: ChatifyColors.black),
                            )
                          : _communityImageUrl!.trim().isNotEmpty
                            ? CachedNetworkImage(
                                imageUrl: _communityImageUrl!,
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                                placeholder: (context, url) => CircleAvatar(
                                  backgroundColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                                  foregroundColor: ChatifyColors.white,
                                  child: const Icon(Icons.groups, size: 26, color: ChatifyColors.black),
                                ),
                                errorWidget: (context, url, error) => CircleAvatar(
                                  backgroundColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                                  foregroundColor: ChatifyColors.white,
                                  child: const Icon(Icons.groups, size: 26, color: ChatifyColors.black),
                                ),
                              )
                            : CircleAvatar(
                                backgroundColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                                foregroundColor: ChatifyColors.white,
                                child: const Icon(Icons.groups, size: 26, color: ChatifyColors.black),
                              ),
                      ),
                    )
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.community.name.isNotEmpty ? widget.community.name : S.of(context).unnamedCommunity,
                        style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        widget.community.description.isNotEmpty ? widget.community.description : S.of(context).noDescription,
                        style: TextStyle(fontSize: ChatifySizes.fontSizeSm),
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
  }
}
