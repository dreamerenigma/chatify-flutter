import 'package:flutter/material.dart';
import 'package:chatify/features/community/models/community_model.dart';
import '../../../home/widgets/cards/home_community_card.dart';
import '../cards/community_card.dart';

class CommunityList extends StatefulWidget {
  final List<CommunityModel> communities;
  final bool isHomeScreen;
  final bool isValidDate;
  final String fileToSend;
  final Function(CommunityModel) onCommunitySelected;
  final CommunityModel? selectedCommunity;

  const CommunityList({
    super.key,
    required this.communities,
    this.isHomeScreen = false,
    this.isValidDate = false,
    this.fileToSend = '',
    required this.onCommunitySelected,
    this.selectedCommunity,
  });

  @override
  State<CommunityList> createState() => _CommunityListState();
}

class _CommunityListState extends State<CommunityList> {
  int? selectedIndex;

  @override
  void initState() {
    super.initState();
    if (widget.selectedCommunity != null) {
      selectedIndex = widget.communities.indexWhere((c) => c.id == widget.selectedCommunity!.id);
    }
  }

  @override
  void didUpdateWidget(covariant CommunityList oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.selectedCommunity?.id != oldWidget.selectedCommunity?.id) {
      setState(() {
        selectedIndex = widget.selectedCommunity != null ? widget.communities.indexWhere((c) => c.id == widget.selectedCommunity!.id) : null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.communities.isEmpty ? const SizedBox.shrink() : SingleChildScrollView(
      child: ListView.builder(
        itemCount: widget.communities.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          final community = widget.communities[index];
          final isSelected = selectedIndex == index;

          return widget.isHomeScreen
            ? HomeCommunityCard(
                community: community,
                isSelected: isSelected,
                isValidDate: widget.isValidDate,
                fileToSend: widget.fileToSend,
                onCommunitySelected: (_) {
                  setState(() {
                    selectedIndex = index;
                  });
                  widget.onCommunitySelected(community);
                },
              )
            : CommunityCard(
                onTap: () {},
                community: community,
                isValidDate: widget.isValidDate,
                fileToSend: widget.fileToSend,
              );
        },
      ),
    );
  }
}
