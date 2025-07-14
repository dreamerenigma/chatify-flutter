import 'package:chatify/features/community/screens/community_info_screen.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatify/features/community/models/community_model.dart';
import 'package:get/get.dart';
import '../../../../../utils/constants/app_sizes.dart';
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
      margin: EdgeInsets.only(left: MediaQuery.of(context).size.width * .04, right: MediaQuery.of(context).size.width * .04),
      elevation: isSelected ? 4 : 0.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      color: isSelected ? Colors.blue.withAlpha((0.1 * 255).toInt()) : null,
      child: Ink(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.grey),
        child: InkWell(
          borderRadius: BorderRadius.circular(15),
          onTap: () {
            Navigator.push(
              context,
              createPageRoute(CommunityInfoScreen(community: widget.community, isValidDate: (date) => widget.isValidDate, fileToSend: widget.fileToSend)),
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {},
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(23),
                    child: CachedNetworkImage(
                      imageUrl: widget.community.image.isNotEmpty && Uri.tryParse(widget.community.image)?.hasAbsolutePath == true
                        ? widget.community.image
                        : '',
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
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.community.name.isNotEmpty ? widget.community.name : 'Unnamed Community',
                        style: TextStyle(
                          fontSize: ChatifySizes.fontSizeMd,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        widget.community.description.isNotEmpty ? widget.community.description : 'No description',
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

