import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_utils/src/extensions/context_extensions.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../home/widgets/checkboxes/custom_checkbox.dart';
import '../../../newsletter/models/newsletter_model.dart';

class NewsletterCard extends StatelessWidget {
  final NewsletterModel newsletter;
  final ValueChanged<bool> onChanged;

  const NewsletterCard({
    super.key,
    required this.newsletter,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final RxList<bool> selectedOptions = <bool>[false, false, false].obs;

    return Container(
      height: 75,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(color: context.isDarkMode ? ChatifyColors.darkBackground : ChatifyColors.white, borderRadius: BorderRadius.circular(16)),
      child: Row(
        children: [
          ClipOval(
            child: CachedNetworkImage(
              imageUrl: newsletter.newsletterImage,
              width: 46,
              height: 46,
              fit: BoxFit.cover,
              errorWidget: (_, _, _) {
                return Container(
                  width: 46,
                  height: 46,
                  color: ChatifyColors.softGrey,
                  child: const Icon(Icons.campaign_outlined, color: ChatifyColors.darkGrey),
                );
              },
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(newsletter.members.toString(), maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400)),
                const SizedBox(height: 3),
                Text('Уже состоит в группе', maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: ChatifySizes.fontSizeSm, color: ChatifyColors.darkGrey)),
              ],
            ),
          ),
          CustomCheckbox(
            selectedOptions: selectedOptions,
            onChanged: (value) {},
          ),
        ],
      ),
    );
  }
}
