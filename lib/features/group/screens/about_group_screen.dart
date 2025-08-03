import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatify/routes/custom_page_route.dart';
import 'package:chatify/utils/constants/app_sizes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:icon_forest/system_uicons.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/mdi.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../generated/l10n/l10n.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../api/apis.dart';
import '../../../utils/constants/app_vectors.dart';
import '../../../utils/devices/device_utility.dart';
import '../../../utils/popups/dialogs.dart';
import '../../chat/models/user_model.dart';
import '../../community/screens/add_user_screen.dart';
import '../models/group_model.dart';
import '../../utils/widgets/no_glow_scroll_behavior.dart';
import '../../personalization/widgets/dialogs/add_new_contact_bottom_dialog.dart';
import '../../personalization/widgets/dialogs/exit_group_dialog.dart';
import '../../personalization/widgets/dialogs/image_group_bottom_dialog.dart';
import '../../personalization/widgets/dialogs/light_dialog.dart';
import '../../personalization/widgets/dialogs/report_group_dialog.dart';
import '../../personalization/widgets/dialogs/select_list_bottom_dialog.dart';
import 'description_group_screen.dart';
import 'group_chat_screen.dart';

class AboutGroupScreen extends StatefulWidget {
  final GroupModel group;
  final List<String> members;
  final Map<String, UserModel> user;

  const AboutGroupScreen({
    super.key,
    required this.group,
    required this.members,
    required this.user,
  });

  @override
  State<AboutGroupScreen> createState() => AboutGroupScreenState();
}

class AboutGroupScreenState extends State<AboutGroupScreen> {
  late List<String> mediaThumbnails;
  List<GroupModel> groups = [];
  bool isCloseChatEnabled = false;
  final storage = GetStorage();
  Map<String, UserModel> user = {};
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    isCloseChatEnabled = storage.read<bool>('isCloseChatEnabled') ?? false;
    mediaThumbnails = [];
    loadUsers(widget.members);
  }

  void saveSwitchState(bool value) {
    storage.write('isCloseChatEnabled', value);
  }

  Future<void> loadUsers(List<String> memberIds) async {
    final querySnapshot = await FirebaseFirestore.instance
      .collection('Users')
      .where(FieldPath.documentId, whereIn: memberIds)
      .get();

    for (var doc in querySnapshot.docs) {
      final userId = doc.id;
      final userData = doc.data();
      widget.user[userId] = APIs.createChatUserFromData(userData);
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var mq = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(width: mq.width, height: mq.height * .03),
            Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(color: context.isDarkMode ? ChatifyColors.blackGrey.withAlpha((0.7 * 255).toInt()) : ChatifyColors.grey),
                child: Row(
                  children: [
                    IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.pop(context)),
                    const Spacer(),
                    PopupMenuButton<int>(
                      position: PopupMenuPosition.under,
                      color: context.isDarkMode ? ChatifyColors.darkSlate : ChatifyColors.white,
                      icon: const Icon(Icons.more_vert),
                      onSelected: (value) {
                        if (value == 1) {
                          final double maxHeight = MediaQuery.of(context).size.height * 0.62;
                          showAddNewContactBottomSheetDialog(context, maxHeight);
                        } else if (value == 2) {

                        }
                      },
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: 1,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(S.of(context).addParticipants, style: TextStyle(fontSize: ChatifySizes.fontSizeMd)),
                        ),
                        PopupMenuItem(
                          value: 2,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(S.of(context).changeGroupName, style: TextStyle(fontSize: ChatifySizes.fontSizeMd)),
                        ),
                        PopupMenuItem(
                          value: 3,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(S.of(context).groupPermissions, style: TextStyle(fontSize: ChatifySizes.fontSizeMd)),
                        ),
                      ],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: ScrollConfiguration(
                behavior: NoGlowScrollBehavior(),
                child: ScrollbarTheme(
                  data: ScrollbarThemeData(thumbColor: WidgetStateProperty.all(ChatifyColors.darkerGrey)),
                  child: Scrollbar(
                    thickness: 4,
                    thumbVisibility: false,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          buildProfileInfo(widget.group, context),
                          _buildAddInfo(),
                          _buildMedia(),
                          _buildInfo(),
                          _buildChat(),
                          _buildAddGroupCommunity(),
                          _buildGroupUsers(),
                          _buildModerationUser(),
                          const SizedBox(height: 10),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildProfileInfo(GroupModel group, BuildContext context) {
    var mq = MediaQuery.of(context).size;

    List<Widget> profileInfoWidgets = [];

    profileInfoWidgets.add(
      GestureDetector(
        onTap: () {
          showImageGroupBottomSheet(context);
        },
        child: Center(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(MediaQuery.of(context).size.height * .1),
            child: CachedNetworkImage(
              width: MediaQuery.of(context).size.height * .15,
              height: MediaQuery.of(context).size.height * .15,
              fit: BoxFit.cover,
              imageUrl: group.groupImage,
              errorWidget: (context, url, error) => CircleAvatar(
                backgroundColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                foregroundColor: ChatifyColors.white,
                child: const Icon(CupertinoIcons.person),
              ),
            ),
          ),
        ),
      ),
    );
    profileInfoWidgets.add(SizedBox(height: mq.height * .02));
    profileInfoWidgets.add(Center(child: Text(group.groupName, style: TextStyle(fontSize: ChatifySizes.fontSizeMg))));
    profileInfoWidgets.add(SizedBox(height: mq.height * .01));
    profileInfoWidgets.add(
      Center(child:  Text('${S.of(context).aboutGroups} • ${widget.members.length} ${S.of(context).aboutGroups}', style: TextStyle(fontSize: ChatifySizes.fontSizeMd, color: ChatifyColors.darkGrey))),
    );
    profileInfoWidgets.add(SizedBox(height: mq.height * .02));

    profileInfoWidgets.add(
      Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 80,
              height: 80,
              child: OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  minimumSize: Size.zero,
                  padding: const EdgeInsets.all(0),
                  side: const BorderSide(color: ChatifyColors.popupColor),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.call_outlined, color: colorsController.getColor(colorsController.selectedColorScheme.value), size: 26),
                    const SizedBox(height: 8),
                    Text(S.of(context).audio, style: TextStyle(
                      fontSize: ChatifySizes.fontSizeSm,
                      color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black,
                    )),
                  ],
                ),
              ),
            ),
            SizedBox(width: mq.width * 0.03),
            SizedBox(
              width: 80,
              height: 80,
              child: OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  minimumSize: Size.zero,
                  padding: const EdgeInsets.all(0),
                  side: const BorderSide(color: ChatifyColors.popupColor),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.videocam_outlined, color: colorsController.getColor(colorsController.selectedColorScheme.value), size: 32),
                    const SizedBox(height: 8),
                    Text(S.of(context).video, style: TextStyle(
                      fontSize: ChatifySizes.fontSizeSm,
                      color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black,
                    )),
                  ],
                ),
              ),
            ),
            SizedBox(width: mq.width * 0.03),
            SizedBox(
              width: 80,
              height: 80,
              child: OutlinedButton(
                onPressed: () {
                  Navigator.push(context, createPageRoute(const AddUserScreen()));
                },
                style: OutlinedButton.styleFrom(
                  minimumSize: Size.zero,
                  padding: const EdgeInsets.all(0),
                  side: const BorderSide(color: ChatifyColors.popupColor),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.person_add_alt_outlined, color: colorsController.getColor(colorsController.selectedColorScheme.value), size: 26),
                    const SizedBox(height: 8),
                    Text(S.of(context).add, style: TextStyle(
                      fontSize: ChatifySizes.fontSizeSm,
                      color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black,
                    )),
                  ],
                ),
              ),
            ),
            SizedBox(width: mq.width * 0.03),
            SizedBox(
              width: 80,
              height: 80,
              child: OutlinedButton(
                onPressed: () {
                  Navigator.push(context, createPageRoute(
                    GroupChatScreen(
                      group: widget.group,
                      groupName: '',
                      members: const [],
                      groupImage: '',
                      createdAt: DateTime.now(),
                      groupId: '',
                    ),
                  ));
                },
                style: OutlinedButton.styleFrom(
                  minimumSize: Size.zero,
                  padding: const EdgeInsets.all(0),
                  side: const BorderSide(color: ChatifyColors.popupColor),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.search, color: colorsController.getColor(colorsController.selectedColorScheme.value), size: 28),
                    const SizedBox(height: 8),
                    Text(S.of(context).search, style: TextStyle(fontSize: ChatifySizes.fontSizeMd, color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(color: context.isDarkMode ? ChatifyColors.blackGrey.withAlpha((0.7 * 255).toInt()) : ChatifyColors.grey),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: profileInfoWidgets,
      ),
    );
  }

  Widget _buildAddInfo() {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: InkWell(
        onTap: () {
          Navigator.push(context, createPageRoute(const DescriptionGroupScreen()));
        },
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(color: context.isDarkMode ? ChatifyColors.blackGrey.withAlpha((0.7 * 255).toInt()) : ChatifyColors.grey),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  S.of(context).addGroupDescription,
                  style: TextStyle(color: colorsController.getColor(colorsController.selectedColorScheme.value), fontSize: ChatifySizes.fontSizeMd),
                ),
                SizedBox(height: DeviceUtils.getScreenHeight(context) * 0.015),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: S.of(context).groupCreatedByYou,
                        style: TextStyle(color: context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.black, fontSize: ChatifySizes.fontSizeSm),
                      ),
                      TextSpan(
                        text: DateFormat('dd.MM.yyyy').format(widget.group.createdAt),
                        style: TextStyle(color: context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.black, fontSize: ChatifySizes.fontSizeSm),
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

  Widget _buildMedia() {
    if (mediaThumbnails.isEmpty) {
      return const SizedBox();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(color: context.isDarkMode ? ChatifyColors.blackGrey.withAlpha((0.7 * 255).toInt()) : ChatifyColors.grey),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(S.of(context).mediaLinksAndDocuments, style: TextStyle(color: ChatifyColors.darkGrey, fontSize: ChatifySizes.fontSizeSm)),
                  const Icon(Icons.arrow_forward_ios_rounded, color: ChatifyColors.darkGrey, size: 16),
                ],
              ),
              const SizedBox(height: 10),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: mediaThumbnails.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {},
                    child: Image.network(mediaThumbnails[index], fit: BoxFit.cover),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfo() {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(color: context.isDarkMode ? ChatifyColors.blackGrey.withAlpha((0.7 * 255).toInt()) : ChatifyColors.grey),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: () {},
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Row(
                  children: [
                    const Icon(Icons.notifications_none, color: ChatifyColors.darkGrey),
                    const SizedBox(width: 25),
                    Text(S.of(context).notifications, style: TextStyle(fontSize: ChatifySizes.fontSizeLg, color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black)),
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {},
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Row(
                  children: [
                    const Icon(Icons.image_outlined, color: ChatifyColors.darkGrey),
                    const SizedBox(width: 25),
                    Text(S.of(context).mediaVisibility, style: TextStyle(fontSize: ChatifySizes.fontSizeLg, color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChat() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(color: context.isDarkMode ? ChatifyColors.blackGrey.withAlpha((0.7 * 255).toInt()) : ChatifyColors.grey),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: () {},
              child: Padding(
                padding: const EdgeInsets.only(left: 24, right: 25, top: 12, bottom: 12),
                child: Row(
                  children: [
                    const Icon(Icons.lock_outlined, color: ChatifyColors.darkGrey, size: 25),
                    const SizedBox(width: 25),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(S.of(context).encryption, style: TextStyle(fontSize: ChatifySizes.fontSizeLg, color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black)),
                          Text(S.of(context).messagesCallsProtectedEndToEndEncryption, style: TextStyle(fontSize: ChatifySizes.fontSizeSm, color: context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.grey)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 5),
            InkWell(
              onTap: () {},
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                child: Row(
                  children: [
                    const Icon(HugeIcons.strokeRoundedTimeQuarterPass, color: ChatifyColors.darkGrey),
                    const SizedBox(width: 25),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(S.of(context).disappearingMessages, style: TextStyle(fontSize: ChatifySizes.fontSizeMd, color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black)),
                          Text(S.of(context).off, style: TextStyle(fontSize: ChatifySizes.fontSizeSm, color: context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.grey)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 5),
            InkWell(
              onTap: () {
                setState(() {
                  isCloseChatEnabled = !isCloseChatEnabled;
                  saveSwitchState(isCloseChatEnabled);
                });
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                child: Row(
                  children: [
                    const Iconify(Mdi.message_text_lock_outline, color: ChatifyColors.darkGrey),
                    const SizedBox(width: 25),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(S.of(context).closingChat, style: TextStyle(fontSize: ChatifySizes.fontSizeMd, color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black)),
                          Text(S.of(context).closeAndHideChatDevice, style: TextStyle(fontSize: ChatifySizes.fontSizeSm, color: context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.grey)),
                        ],
                      ),
                    ),
                    Switch(
                      value: isCloseChatEnabled,
                      onChanged: (value) {
                        setState(() {
                          isCloseChatEnabled = value;
                          saveSwitchState(isCloseChatEnabled);
                        });
                      },
                      activeColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                      activeTrackColor: colorsController.getColor(colorsController.selectedColorScheme.value).withAlpha((0.5 * 255).toInt()),
                    ),
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {},
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                child: Row(
                  children: [
                    const Icon(Icons.settings_outlined, color: ChatifyColors.darkGrey),
                    const SizedBox(width: 25),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(S.of(context).groupPermissions, style: TextStyle(fontSize: ChatifySizes.fontSizeMd, color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddGroupCommunity() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(color: context.isDarkMode ? ChatifyColors.blackGrey.withAlpha((0.7 * 255).toInt()) : ChatifyColors.grey),
        child: InkWell(
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(7),
                  decoration: BoxDecoration(color: colorsController.getColor(colorsController.selectedColorScheme.value), borderRadius: BorderRadius.circular(12)),
                  child: const Icon(Icons.groups_rounded, color: ChatifyColors.black, size: 28),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(S.of(context).addGroupToCommunity, style: TextStyle(fontSize: ChatifySizes.fontSizeMd)),
                      const SizedBox(height: 2),
                      Text(S.of(context).combineParticipantsThematicGroups, style: TextStyle(fontSize: ChatifySizes.fontSizeSm, color: ChatifyColors.darkGrey)),
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

  Widget _buildGroupUsers() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(color: context.isDarkMode ? ChatifyColors.blackGrey.withAlpha((0.7 * 255).toInt()) : ChatifyColors.grey),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('${widget.members.length} ${S.of(context).participant}', style: TextStyle(fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.normal, color: ChatifyColors.darkGrey)),
                  IconButton(icon: const Icon(Icons.search, color: ChatifyColors.darkGrey), onPressed: () {}),
                ],
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.push(context, createPageRoute(const AddUserScreen()));
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(7),
                      decoration: BoxDecoration(color: colorsController.getColor(colorsController.selectedColorScheme.value), borderRadius: BorderRadius.circular(25)),
                      child: const Icon(Icons.person_add_alt_1_sharp, color: ChatifyColors.black, size: 28),
                    ),
                    const SizedBox(width: 16),
                    Text(S.of(context).addParticipants, style: TextStyle(fontSize: ChatifySizes.fontSizeMd)),
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.push(context, createPageRoute(const AddUserScreen()));
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(7),
                      decoration: BoxDecoration(color: colorsController.getColor(colorsController.selectedColorScheme.value), borderRadius: BorderRadius.circular(25)),
                      child: const Icon(Icons.link, color: ChatifyColors.black, size: 28),
                    ),
                    const SizedBox(width: 16),
                    Text(S.of(context).inviteViaLink, style: TextStyle(fontSize: ChatifySizes.fontSizeMd)),
                  ],
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: widget.members.map((id) {
                final member = widget.user[id] ?? APIs.createChatUserFromData({});

                return InkWell(
                  onTap: () {},
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    child: Row(
                      children: [
                        CachedNetworkImage(
                          imageUrl: member.image,
                          placeholder: (context, url) => Shimmer.fromColors(
                            baseColor: Colors.grey.shade300,
                            highlightColor: Colors.grey.shade100,
                            child: CircleAvatar(radius: 25, backgroundColor: Colors.grey.shade300),
                          ),
                          errorWidget: (context, url, error) => SvgPicture.asset(ChatifyVectors.profile, width: 45, height: 45),
                          imageBuilder: (context, imageProvider) => CircleAvatar(radius: 25, backgroundImage: imageProvider),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(member.name, style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w500)),
                              const SizedBox(height: 4),
                              Text(member.about, style: TextStyle(fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w400, color: ChatifyColors.darkGrey)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModerationUser() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(color: context.isDarkMode ? ChatifyColors.blackGrey.withAlpha((0.7 * 255).toInt()) : ChatifyColors.grey),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () {
              setState(() {
                isFavorite = !isFavorite;
              });
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Row(
                children: [
                  isFavorite ? SvgPicture.asset(ChatifyVectors.deleteFavorite, width: 23, height: 23, color: ChatifyColors.darkGrey)
                  : const Icon(Icons.favorite_outline_outlined, color: ChatifyColors.darkGrey, size: 26),
                  const SizedBox(width: 25),
                  Text(
                    isFavorite ? S.of(context).removeFromFavorites : S.of(context).addToFavorites,
                    style: TextStyle(fontSize: ChatifySizes.fontSizeMd),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 5),
          InkWell(
            onTap: () {
              showSelectListBottomSheetDialog(context);
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Row(
                children: [
                  const Icon(Icons.library_add_outlined, color: ChatifyColors.darkGrey),
                  const SizedBox(width: 25),
                  Text(S.of(context).addToList, style: TextStyle(fontSize: ChatifySizes.fontSizeMd)),
                ],
              ),
            ),
          ),
          InkWell(
            onTap: () {
              Dialogs.showCustomDialog(context: context, message: S.of(context).pleaseWait, duration: const Duration(seconds: 1));

              Future.delayed(const Duration(seconds: 1), () {

                Future.delayed(const Duration(milliseconds: 300), () {
                  showExitGroupDialog(context, widget.group);
                });
              });
            },

            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 20),
              child: Row(
                children: [
                  const SystemUicons(SystemUicons.exit_right, color: ChatifyColors.red, height: 30),
                  const SizedBox(width: 23),
                  Text(S.of(context).leaveGroup, style: TextStyle(fontSize: ChatifySizes.fontSizeMd, color: ChatifyColors.red)),
                ],
              ),
            ),
          ),
          InkWell(
            onTap: () {
              Dialogs.showProgressBarDialog(context, title: S.of(context).submittingComplaint, message: S.of(context).pleaseWait);

              Future.delayed(const Duration(seconds: 1), () {
                Navigator.pop(context);
                showReportGroupDialog(context);
              });
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 20),
              child: Row(
                children: [
                  const Icon(Icons.thumb_down_alt_outlined, color: ChatifyColors.red),
                  const SizedBox(width: 25),
                  Text(S.of(context).reportGroup, style: TextStyle(fontSize: ChatifySizes.fontSizeMd, color: ChatifyColors.red)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
