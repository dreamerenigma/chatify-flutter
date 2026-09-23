import '../../../bot/models/info_app_model.dart';
import '../../../bot/models/support_model.dart';
import '../../../chat/models/user_model.dart';
import '../../../community/models/community_model.dart';
import '../../../group/models/group_model.dart';
import '../../../newsletter/models/newsletter_model.dart';

sealed class HomeItem {
  final String id;
  final int activityTime;

  const HomeItem({
    required this.id,
    required this.activityTime,
  });
}

class ChatHomeItem extends HomeItem {
  final UserModel user;

  ChatHomeItem({required this.user, required super.activityTime}) : super(id: user.id);
}

class GroupHomeItem extends HomeItem {
  final GroupModel group;

  GroupHomeItem({required this.group, required super.activityTime}) : super(id: group.id);
}

class CommunityHomeItem extends HomeItem {
  final CommunityModel community;

  CommunityHomeItem({required this.community, required super.activityTime}) : super(id: community.id);
}

class NewsletterHomeItem extends HomeItem {
  final NewsletterModel newsletter;

  NewsletterHomeItem({required this.newsletter, required super.activityTime}) : super(id: newsletter.id);
}

class SupportHomeItem extends HomeItem {
  final SupportAppModel support;

  SupportHomeItem({required this.support, required super.activityTime}) : super(id: support.id);
}

class InfoAppHomeItem extends HomeItem {
  final InfoAppModel info;

  InfoAppHomeItem({required this.info, required super.activityTime}) : super(id: info.id);
}
