import 'dart:developer';
import 'package:chatify/features/utils/widgets/scrolls/no_glow_scroll_behavior.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_utils/src/extensions/context_extensions.dart';
import '../../../../api/apis.dart';
import '../../../../routes/custom_page_route.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../../utils/constants/app_vectors.dart';
import '../../../chat/models/user_model.dart';
import '../../../utils/widgets/dividers/custom_divider.dart';
import '../../widgets/dialogs/light_dialog.dart';
import '../../widgets/items/storage_chat_item.dart';
import '../../widgets/tiles/settings_action_tile.dart';
import 'disappearing_messages_screen.dart';
import 'manage_download_files_screen.dart';

class StorageManagementScreen extends StatefulWidget {
  const StorageManagementScreen({super.key});

  @override
  State<StorageManagementScreen> createState() => _StorageManagementScreenState();
}

class _StorageManagementScreenState extends State<StorageManagementScreen> {
  List<UserModel> chatUsers = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadChats();
  }

  Future<void> _loadChats() async {
    try {
      final snapshot = await APIs.getMyUsersId().first;
      final userIds = snapshot.docs.map((doc) => doc.id).toList();

      if (userIds.isEmpty) {
        if (!mounted) return;

        setState(() {
          chatUsers = [];
          isLoading = false;
        });

        return;
      }

      final usersSnapshot =
      await APIs.getAllUsers(userIds).first;

      final loadedUsers = usersSnapshot.docs.map((doc) => UserModel.fromJson(doc.data())).toList();

      if (!mounted) return;

      setState(() {
        chatUsers = loadedUsers;
        isLoading = false;
      });
    } catch (e, stackTrace) {
      log('STORAGE CHATS ERROR: $e', stackTrace: stackTrace);

      if (!mounted) return;

      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    const double usedProgress = 0.9;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration: BoxDecoration(
            color: ChatifyColors.white,
            boxShadow: [BoxShadow(color: ChatifyColors.black.withAlpha((0.1 * 255).toInt()), spreadRadius: 1, blurRadius: 3, offset: const Offset(0, 1))],
          ),
          child: AppBar(
            title: Text('Управление хранилищем', style: TextStyle(fontSize: ChatifySizes.fontSizeMg, fontWeight: FontWeight.w400)),
            titleSpacing: 0,
            backgroundColor: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.white,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_rounded, size: 25),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ),
      ),
      body: ScrollConfiguration(
        behavior: NoGlowScrollBehavior(),
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(top: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildStorageHeader(),
              const SizedBox(height: 10),
              _buildStorageProgress(usedProgress),
              const SizedBox(height: 20),
              _buildStorageItem(context: context, color: ChatifyColors.green, title: 'Chatify', size: '600 МБ'),
              const SizedBox(height: 12),
              _buildStorageItem(context: context, color: ChatifyColors.yellow, title: 'Другие приложения', size: '51 ГБ'),
              const SizedBox(height: 20),
              CustomDivider(indent: 0, endIndent: 0, left: 0, right: 0, top: 10, bottom: 10),
              _buildChatsHeader(context),
              const SizedBox(height: 10),
              _buildChatsList(context),
              const SizedBox(height: 10),
              CustomDivider(indent: 0, endIndent: 0, left: 0, right: 0, top: 5, bottom: 10),
              SettingsActionTile(
                icon: SvgPicture.asset(ChatifyVectors.timerOutline, width: 24, height: 24, colorFilter: ColorFilter.mode(colorsController.getColor(colorsController.selectedColorScheme.value), BlendMode.srcIn)),
                title: 'Включить исчезающие сообщения',
                description: 'Дополнительная конфиденциальность ваших чатов и больше свободного места в хранилище.',
                onTap: () {
                  Navigator.push(context, createPageRoute(DisappearingMessagesScreen()));
                },
              ),
              SettingsActionTile(
                icon: Icon(Icons.settings_outlined, size: 24, color: colorsController.getColor(colorsController.selectedColorScheme.value)),
                title: 'Управление скачанными файлами',
                description: 'Сэкономьте место в хранилище, удалив скачанные приложением файлы, которыми вы не пользуетесь.',
                onTap: () {
                  Navigator.push(context, createPageRoute(const ManageDownloadFilesScreen()));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStorageHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(text: '600', style: TextStyle(color: ChatifyColors.softGrey, fontSize: 26, fontWeight: FontWeight.w500)),
                      TextSpan(text: ' МБ', style: TextStyle(color: ChatifyColors.softGrey, fontSize: ChatifySizes.fontSizeLg, fontWeight: FontWeight.w400)),
                    ],
                  ),
                ),
                Text('Использовано', style: TextStyle(color: ChatifyColors.darkGrey, fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w400, height: 1.3)),
                SizedBox(height: 8),
              ],
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(text: '4,8', style: TextStyle(color: ChatifyColors.darkGrey, fontSize: 26, fontWeight: FontWeight.w500)),
                      TextSpan(text: ' ГБ', style: TextStyle(color: ChatifyColors.darkGrey, fontSize: ChatifySizes.fontSizeLg, fontWeight: FontWeight.w400)),
                    ],
                  ),
                ),
                Text('Свободно', style: TextStyle(color: ChatifyColors.darkGrey, fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w400, height: 1.3)),
                SizedBox(height: 8),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStorageProgress(double progress) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        height: 13,
        width: double.infinity,
        decoration: BoxDecoration(color: Colors.transparent, borderRadius: BorderRadius.circular(8), border: Border.all(color: ChatifyColors.darkGrey, width: 1)),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Align(alignment: Alignment.centerLeft, child: FractionallySizedBox(widthFactor: progress, child: Container(color: ChatifyColors.yellow))),
        ),
      ),
    );
  }

  Widget _buildStorageItem({required BuildContext context, required Color color, required String title, required String size}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: color, borderRadius: BorderRadius.circular(8),
              border: Border.all(color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black, width: 1),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(child: Text(title, style: TextStyle(color: ChatifyColors.darkGrey, fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w400))),
          Text(size, style: TextStyle(color: ChatifyColors.darkGrey, fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w400)),
        ],
      ),
    );
  }

  Widget _buildChatsHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Text('Чаты', style: TextStyle(color: ChatifyColors.darkGrey, fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w400)),
          const Spacer(),
          Material(
            color: ChatifyColors.transparent,
            child: InkWell(
              onTap: () {},
              borderRadius: BorderRadius.circular(30),
              child: Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(shape: BoxShape.circle, color: context.isDarkMode ? ChatifyColors.mildNight : ChatifyColors.grey),
                child: const Icon(Icons.search_rounded, size: 19),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatsList(BuildContext context) {
    if (chatUsers.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Text(
            'Нет чатов',
            style: TextStyle(color: ChatifyColors.darkGrey, fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w400),
          ),
        ),
      );
    }

    return Column(
      children: [
        for (final user in chatUsers)
          StorageChatItem(user: user, storageSize: '1,8 МБ'),
        const SizedBox(height: 16),
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              '1 чат не отображается, потому-что он занимает мало места в хранилище.',
              textAlign: TextAlign.center,
              style: TextStyle(color: ChatifyColors.darkGrey, fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w400),
            ),
          ),
        ),
      ],
    );
  }
}
