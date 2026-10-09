import 'package:flutter/material.dart';
import 'package:chatify/features/community/models/community_model.dart';
import '../../../../utils/platforms/platform_utils.dart';
import '../../../home/widgets/cards/home_community_card.dart';
import '../cards/community_card.dart';

class CommunityList extends StatelessWidget {
  final List<CommunityModel> communities;
  final bool isHomeScreen;
  final bool isValidDate;
  final String fileToSend;
  final bool isSelectionMode;
  final Set<String> selectedCommunityIds;
  final ValueChanged<CommunityModel> onCommunitySelected;
  final Color? cardColor;

  const CommunityList({
    super.key,
    required this.communities,
    this.isHomeScreen = false,
    this.isValidDate = false,
    this.fileToSend = '',
    required this.onCommunitySelected,
    this.isSelectionMode = false,
    this.selectedCommunityIds = const {},
    this.cardColor,
  });

  @override
  Widget build(BuildContext context) {
    if (communities.isEmpty) {
      return const SizedBox.shrink();
    }

    return SingleChildScrollView(
      child: ListView.builder(
        itemCount: communities.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          final community = communities[index];
          final isSelected = selectedCommunityIds.contains(community.id);

          return Padding(
            padding: EdgeInsets.only(bottom: isHomeScreen && index != communities.length - 1 ? 6 : isWindows ? 6 : 0),
            child: isHomeScreen
              ? HomeCommunityCard(
                  community: community,
                  isSelected: isSelected,
                  isSelectionMode: isSelectionMode,
                  isValidDate: isValidDate,
                  fileToSend: fileToSend,
                  onCommunitySelected: onCommunitySelected,
                )
              : CommunityCard(
                  onTap: () {},
                  community: community,
                  isValidDate: isValidDate,
                  fileToSend: fileToSend,
                  cardColor: cardColor,
                ),
          );
        },
      ),
    );
  }
}
