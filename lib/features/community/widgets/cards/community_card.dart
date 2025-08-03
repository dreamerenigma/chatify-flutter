import 'package:chatify/features/community/screens/community_info_screen.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatify/features/community/models/community_model.dart';
import 'package:get/get.dart';
import '../../../../../utils/constants/app_sizes.dart';
import '../../../../generated/l10n/l10n.dart';
import '../../../../routes/custom_page_route.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../personalization/widgets/dialogs/light_dialog.dart';

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

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      color: ChatifyColors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            createPageRoute(CommunityInfoScreen(community: widget.community, isValidDate: (date) => widget.isValidDate, fileToSend: widget.fileToSend)),
          );
        },
        splashColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey,
        highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              InkWell(
                onTap: () {},
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(23),
                  child: CachedNetworkImage(
                    imageUrl: widget.community.image.isNotEmpty && Uri.tryParse(widget.community.image)?.hasAbsolutePath == true ? widget.community.image : '',
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => CircleAvatar(
                      backgroundColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                      foregroundColor: ChatifyColors.white,
                      child: const Icon(Icons.groups),
                    ),
                    errorWidget: (context, url, error) => CircleAvatar(
                      backgroundColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                      foregroundColor: ChatifyColors.white,
                      child: const Icon(Icons.groups),
                    ),
                  ),
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
    );
  }
}
