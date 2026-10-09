import 'package:chatify/features/utils/widgets/scrolls/no_glow_scroll_behavior.dart';
import 'package:flutter/material.dart';
import '../../../../api/apis.dart';
import '../../../../api/community_api.dart';
import '../../../../core/enums/tooltip_position_type.dart';
import '../../../../generated/l10n/l10n.dart';
import '../../../../routes/custom_page_route.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/popups/custom_tooltip.dart';
import '../../../chat/models/user_model.dart';
import '../../../community/models/community_model.dart';
import '../../../community/screens/created_community_screen.dart';
import '../../../community/widgets/cards/new_community_card.dart';
import '../../../community/widgets/community_widget.dart';
import '../../../community/widgets/lists/community_list.dart';

class CommunitiesWidget extends StatefulWidget {
  final UserModel user;

  const CommunitiesWidget({
    super.key,
    required this.user,
  });

  @override
  State<CommunitiesWidget> createState() => _CommunitiesWidgetState();
}

class _CommunitiesWidgetState extends State<CommunitiesWidget> {
  final GlobalKey _addButtonKey = GlobalKey();
  bool _isLoading = true;
  DateTime? createdAt;
  List<CommunityModel> list = [];

  bool isValidDate(DateTime date) {
    return date.isAfter(DateTime(2000)) && date.isBefore(DateTime.now());
  }

  @override
  void initState() {
    super.initState();
    _loadCommunities();
  }

  Future<void> _loadCommunities() async {
    try {
      final communities = await CommunityApi.getCommunity();

      if (!mounted) return;

      setState(() {
        list = communities;
        createdAt = communities.isNotEmpty ? communities.first.createdAt : null;
        APIs.community = communities.isNotEmpty ? communities.first : null;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        list = [];
        createdAt = null;
        APIs.community = null;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 18, bottom: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(S.of(context).communities, style: const TextStyle(fontSize: 21, fontWeight: FontWeight.w500)),
              CustomTooltip(
                message: S.of(context).createNewCommunity,
                horizontalOffset: -50,
                verticalOffset: -35,
                position: TooltipPositionType.bottom,
                child: IconButton(
                  key: _addButtonKey,
                  icon: const Icon(Icons.add_circle_outline_rounded),
                  onPressed: () {},
                ),
              ),
            ],
          ),
        ),
        NewCommunityCard(
          onTap: () {
            Navigator.push(context, createPageRoute(CreatedCommunityScreen(onCommunitySelected: (community) {})));
          },
        ),
        const SizedBox(height: 2),
        Expanded(
          child: ScrollConfiguration(
            behavior: NoGlowScrollBehavior(),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  CommunityList(communities: list, onCommunitySelected: (community) {}, cardColor: ChatifyColors.deepNight),
                  if (list.isNotEmpty)
                    CommunityWidgets(isValidDate: isValidDate, showAllButton: true, community: list.first, user: APIs.me),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
