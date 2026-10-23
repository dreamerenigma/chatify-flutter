import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/context_extensions.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../../utils/platforms/platform_utils.dart';
import '../../../personalization/widgets/dialogs/light_dialog.dart';
import '../../models/channel_model.dart';

class ChannelCard extends StatelessWidget {
  final ChannelModel channel;
  final VoidCallback? onTap;
  final VoidCallback? onSubscribe;
  final bool isSubscribed;

  const ChannelCard({
    super.key,
    required this.channel,
    this.onTap,
    this.onSubscribe,
    this.isSubscribed = true,
  });

  String _formatSubscribers(int count) {
    if (count >= 1000000) {
      return '${(count / 1000000).toStringAsFixed(1).replaceAll('.', ',')}М';
    }

    if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1).replaceAll('.', ',')}К';
    }

    return count.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(left: isWindows ? 16 : 8, right: isWindows ? 15 : 8, bottom: 6),
      elevation: 0.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      color: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.lightBackground,
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        splashFactory: NoSplash.splashFactory,
        splashColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha(38) : ChatifyColors.grey,
        highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha(38) : ChatifyColors.grey,
        hoverColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha(38) : ChatifyColors.grey,
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: Row(
            children: [
              CircleAvatar(
                radius: 25,
                backgroundColor: context.isDarkMode ? ChatifyColors.youngNight : ChatifyColors.grey,
                child: ClipOval(
                  child: channel.image.isNotEmpty
                    ? Image.network(
                        channel.image,
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(Icons.campaign_outlined, size: 25);
                        },
                      )
                    : const Icon(Icons.campaign_outlined, size: 25,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(channel.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400)),
                    const SizedBox(height: 5),
                    Text(
                      isSubscribed ? (channel.lastMessage?.msg ?? 'Нет сообщений') : 'Подписчики ${_formatSubscribers(channel.subscribersCount)}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: ChatifyColors.darkGrey, fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
              ),
              if (!isSubscribed && onSubscribe != null) ...[
                const SizedBox(width: 8),
                OutlinedButton(
                  onPressed: onSubscribe,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    side: BorderSide.none,
                    splashFactory: NoSplash.splashFactory,
                    backgroundColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  ),
                  child: Text('Подписаться', style: TextStyle(color: ChatifyColors.black, fontSize: 15, fontWeight: FontWeight.w400)),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
