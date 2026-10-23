import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatify/features/utils/widgets/scrolls/no_glow_scroll_behavior.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../../api/apis.dart';
import '../../../../core/enums/custom_sheet_item_type.dart';
import '../../../../generated/l10n/l10n.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_images.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../../utils/constants/app_vectors.dart';
import '../../../../utils/helper/date_util.dart';
import '../../../../utils/popups/dialogs.dart';
import '../../../chat/models/user_model.dart';
import '../../../utils/dialogs/custom_bottom_sheet_dialog.dart';
import '../../../utils/widgets/dialogs/items/custom_sheet_item.dart';
import '../../widgets/dialogs/light_dialog.dart';
import '../../widgets/painters/about_bubble_painter.dart';

class ProfileIntelligenceScreen extends StatefulWidget {
  final UserModel user;

  const ProfileIntelligenceScreen({
    super.key,
    required this.user,
  });

  @override
  State<ProfileIntelligenceScreen> createState() => ProfileIntelligenceScreenState();
}

class ProfileIntelligenceScreenState extends State<ProfileIntelligenceScreen> {
  final TextEditingController textController = TextEditingController(text: '');
  final FocusNode focusNode = FocusNode();
  final storage = GetStorage();
  bool showRecommendations = true;
  bool isLoadingProfileImage = false;
  int maxCharacters = 139;
  String about = '';
  String selectedEmoji = '';
  String? _profileImageUrl;
  String selectedVisibility = 'myContacts';
  String selectedDuration = 'oneDay';
  List<String> customIntelligenceTexts = [];
  Set<String> selectedExcludedUsers = <String>{};
  DateTime? statusExpiresAt;

  final List<Map<String, String>> intelligenceTexts = [
    {'emoji': '💼', 'text': 'На работе'},
    {'emoji': '🌴', 'text': 'Нет на месте, оставьте сообщение'},
    {'emoji': '😴', 'text': 'Сплю'},
    {'emoji': '✈️', 'text': 'Путешествую'},
    {'emoji': '🏋️', 'text': 'В спортзале'},
    {'emoji': '🎮', 'text': 'Играю'},
  ];

  String get visibilityLabel {
    switch (selectedVisibility) {
      case 'all':
        return 'Все';
      case 'myContacts':
        return 'Мои контакты';
      case 'myContactsExcept':
        return 'Мои контакты, кроме';
      case 'nobody':
        return 'Никто';
      default:
        return 'Мои контакты';
    }
  }

  DateTime calculateExpiration(String duration) {
    final now = DateTime.now();

    switch (duration) {
      case 'oneHour':
        return now.add(const Duration(hours: 1));
      case 'eightHours':
        return now.add(const Duration(hours: 8));
      case 'oneDay':
        return now.add(const Duration(days: 1));
      case 'twoDay':
        return now.add(const Duration(days: 2));
      case 'oneWeek':
        return now.add(const Duration(days: 7));
      case 'myOwnVersion':
        return now.add(const Duration(days: 7));
      default:
        return now.add(const Duration(hours: 1));
    }
  }

  @override
  void initState() {
    super.initState();
    customIntelligenceTexts = List<String>.from(storage.read<List<dynamic>>('customIntelligenceTexts') ?? []);
    about = storage.read<String>('about') ?? '';

    if (about.isNotEmpty) {
      final savedAbout = about.trimLeft();

      String? matchedEmoji;

      for (final item in intelligenceTexts) {
        final emoji = item['emoji']!;

        if (savedAbout.startsWith('$emoji ')) {
          matchedEmoji = emoji;
          break;
        }
      }

      if (matchedEmoji != null) {
        selectedEmoji = matchedEmoji;
        textController.text = savedAbout.substring(matchedEmoji.length).trimLeft();
      } else {
        textController.text = about;
        selectedEmoji = '';
      }

      textController.selection = TextSelection.collapsed(
        offset: textController.text.length,
      );
    }
    _loadProfileImage();
  }

  @override
  void dispose() {
    textController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (intelligenceTexts.isEmpty && customIntelligenceTexts.isEmpty) {
      customIntelligenceTexts = [S.of(context).helloProfile];
    }

    if (about.isEmpty && customIntelligenceTexts.isNotEmpty) {
      about = customIntelligenceTexts.first;
      textController.text = about;
    }
  }

  void addIntelligenceText(String text) {
    setState(() {
      customIntelligenceTexts.add(text);
      storage.write('customIntelligenceTexts', customIntelligenceTexts);
    });
  }

  void selectText(String text, String emoji) {
    setState(() {
      selectedEmoji = emoji;
      textController.value = TextEditingValue(text: text, selection: TextSelection.collapsed(offset: text.length));
      about = '$emoji $text';
    });

    FocusScope.of(context).unfocus();
  }

  void clearIntelligenceTexts() {
    setState(() {
      intelligenceTexts.clear();
    });
  }

  Future<void> saveSelectedInfo() async {
    final text = textController.text.trim();
    if (text.isEmpty) return;

    final savedAbout = selectedEmoji.isEmpty ? text : '$selectedEmoji $text';

    try {
      await Dialogs.showCustomDialog(context: context, message: S.of(context).update, duration: const Duration(seconds: 1));

      setState(() {
        about = savedAbout;
        storage.write('about', savedAbout);
        APIs.me.about = savedAbout;
      });

      await APIs.updateUserInfo();
    } catch (e) {
      log('${S.of(context).errorUpdatingUserInfo}: $e');
    }
  }

  Future<void> _loadProfileImage() async {
    final imagePath = widget.user.image.trim();

    if (imagePath.isEmpty) {
      return;
    }

    if (mounted) {
      setState(() {
        isLoadingProfileImage = true;
      });
    }

    try {
      final url = await APIs.getMediaUrl(imagePath);

      if (!mounted) return;

      setState(() {
        _profileImageUrl = url;
        isLoadingProfileImage = false;
      });
    } catch (e, stackTrace) {
      log('PROFILE IMAGE URL ERROR: $e', stackTrace: stackTrace);

      if (!mounted) return;

      setState(() {
        _profileImageUrl = null;
        isLoadingProfileImage = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration: BoxDecoration(
            color: ChatifyColors.white,
            boxShadow: [BoxShadow(color: ChatifyColors.black.withAlpha((0.1 * 255).toInt()), spreadRadius: 1, blurRadius: 3, offset: const Offset(0, 1))],
          ),
          child: AppBar(
            backgroundColor: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.white,
            titleSpacing: 0,
            elevation: 0,
            title: Text(S.of(context).info, style: TextStyle(fontSize: ChatifySizes.fontSizeMg, fontWeight: FontWeight.w400)),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_rounded, size: 25),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: TextSelectionTheme(
                    data: TextSelectionThemeData(
                      cursorColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                      selectionColor: colorsController.getColor(colorsController.selectedColorScheme.value).withAlpha((0.3 * 255).toInt()),
                      selectionHandleColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                    ),
                    child: TextField(
                      controller: textController,
                      focusNode: focusNode,
                      maxLength: maxCharacters,
                      keyboardType: TextInputType.multiline,
                      onChanged: (value) {
                        (context as Element).markNeedsBuild();
                      },
                      decoration: InputDecoration(
                        counterText: '',
                        isDense: true,
                        hintText: 'Прямо сейчас я...',
                        hintStyle: TextStyle(color: ChatifyColors.darkGrey, fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: ChatifyColors.youngNight, width: 1.5)),
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: ChatifyColors.youngNight, width: 1.5)),
                        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: colorsController.getColor(colorsController.selectedColorScheme.value), width: 1.5)),
                        prefixIcon: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 1),
                          child: Center(
                            widthFactor: 1,
                            child: selectedEmoji.isEmpty
                              ? Icon(Icons.emoji_emotions_outlined, size: 25, color: colorsController.getColor(colorsController.selectedColorScheme.value))
                              : Text(selectedEmoji, style: const TextStyle(fontSize: 23),
                            ),
                          ),
                        ),
                        suffixIcon: textController.text.isEmpty
                          ? null
                          : IconButton(
                              onPressed: () {
                                textController.clear();
                                setState(() {
                                  about = '';
                                  selectedEmoji = '';
                                });
                              },
                              icon: const Icon(CupertinoIcons.clear_circled, size: 22),
                            ),
                      ),
                      style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400),
                      textCapitalization: TextCapitalization.sentences,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: Material(
                      color: ChatifyColors.transparent,
                      child: InkWell(
                        splashFactory: NoSplash.splashFactory,
                        borderRadius: BorderRadius.circular(30),
                        splashColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
                        highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
                        hoverColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
                        onTap: () {
                          showCustomSheetBottomDialog(
                            context: context,
                            title: 'Продолжительность',
                            initialRadioValue: selectedDuration,
                            actionText: 'Установить',
                            height: 0.58,
                            items: const [
                              CustomBottomSheetItem(title: '1 час', value: 'oneHour', type: CustomSheetItemType.radio),
                              CustomBottomSheetItem(title: '8 часов', value: 'eightHours', type: CustomSheetItemType.radio),
                              CustomBottomSheetItem(title: '1 день', value: 'oneDay', type: CustomSheetItemType.radio),
                              CustomBottomSheetItem(title: '2 дня', value: 'twoDay', type: CustomSheetItemType.radio),
                              CustomBottomSheetItem(title: '1 неделя', value: 'oneWeek', type: CustomSheetItemType.radio),
                              CustomBottomSheetItem(title: 'Свой вариант', value: 'myOwnVersion', type: CustomSheetItemType.radio),
                            ],
                            onSaveRadioValue: (value) {
                              setState(() {
                                selectedDuration = value;
                                statusExpiresAt = calculateExpiration(value);
                              });
                            },
                            onAction: () {
                              Navigator.pop(context);
                            },
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(color: context.isDarkMode ? ChatifyColors.youngNight : ChatifyColors.grey, width: 1),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.access_time_outlined, size: 21),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  statusExpiresAt == null
                                    ? 'Выберите продолжительность'
                                    : '${statusExpiresAt!.day.toString().padLeft(2, '0')} '
                                      '${DateUtil.getMonth(statusExpiresAt!, context)} '
                                      'в ${statusExpiresAt!.hour.toString().padLeft(2, '0')}:'
                                      '${statusExpiresAt!.minute.toString().padLeft(2, '0')}',
                                  style: TextStyle(fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w400), maxLines: 1, overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const Icon(Icons.arrow_drop_down, size: 20),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Material(
                      color: ChatifyColors.transparent,
                      child: InkWell(
                        splashFactory: NoSplash.splashFactory,
                        borderRadius: BorderRadius.circular(30),
                        splashColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
                        highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
                        hoverColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
                        onTap: () {
                          showCustomSheetBottomDialog(
                            context: context,
                            title: 'Кто видит информацию обо мне',
                            initialRadioValue: selectedVisibility,
                            actionText: 'Готово',
                            height: 0.45,
                            items: [
                              const CustomBottomSheetItem(title: 'Все', value: 'all', type: CustomSheetItemType.radio),
                              const CustomBottomSheetItem(title: 'Мои контакты', value: 'myContacts', type: CustomSheetItemType.radio),
                              CustomBottomSheetItem(title: 'Мои контакты, кроме', value: 'myContactsExcept', type: CustomSheetItemType.radio, excludedUsersCount: selectedExcludedUsers.length),
                              const CustomBottomSheetItem(title: 'Никто', value: 'nobody', type: CustomSheetItemType.radio),
                            ],
                            onSaveRadioValue: (value) {
                              setState(() {
                                selectedVisibility = value;
                              });
                            },
                            onAction: () {
                              Navigator.pop(context);
                            },
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(color: context.isDarkMode ? ChatifyColors.youngNight : ChatifyColors.grey, width: 1),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.contacts_outlined, size: 18),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(visibilityLabel, style: TextStyle(fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w400), maxLines: 1, overflow: TextOverflow.ellipsis),
                              ),
                              const Icon(Icons.arrow_drop_down, size: 20),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
              child: Text('Рекомендации', style: TextStyle(color: ChatifyColors.darkGrey, fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w400)),
            ),
            Expanded(
              child: ScrollConfiguration(
                behavior: NoGlowScrollBehavior(),
                child: ListView.builder(
                  itemCount: intelligenceTexts.length,
                  itemBuilder: (context, index) {
                    final item = intelligenceTexts[index];
                    final emoji = item['emoji']!;
                    final text = item['text']!;
                    final isSelected = about == '$emoji $text' || about == text;

                    return Material(
                      color: ChatifyColors.transparent,
                      child: InkWell(
                        splashFactory: NoSplash.splashFactory,
                        splashColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
                        highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
                        hoverColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
                        onTap: () => selectText(text, emoji),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          child: Row(
                            children: [
                              Text(emoji, style: const TextStyle(fontSize: 23, fontWeight: FontWeight.w400)),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Text(
                                  text,
                                  style: TextStyle(color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black, fontSize: 17, fontWeight: FontWeight.w400, overflow: TextOverflow.ellipsis), maxLines: 1,
                                ),
                              ),
                              const SizedBox(width: 12),
                              if (isSelected)
                                Icon(Icons.check_rounded, size: 25, color: colorsController.getColor(colorsController.selectedColorScheme.value)),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: context.isDarkMode ? ChatifyColors.deepNight : ChatifyColors.white,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),
                border: Border(top: BorderSide(color: context.isDarkMode ? ChatifyColors.youngNight : ChatifyColors.grey, width: 1)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 5, right: 5, top: 5, bottom: !showRecommendations ? 0 : 5),
                    child: Material(
                      color: ChatifyColors.transparent,
                      child: InkWell(
                        splashFactory: NoSplash.splashFactory,
                        borderRadius: BorderRadius.circular(18),
                        splashColor: context.isDarkMode ? ChatifyColors.steelGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
                        highlightColor: context.isDarkMode ? ChatifyColors.steelGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
                        hoverColor: context.isDarkMode ? ChatifyColors.lightSoftNight.withAlpha((0.15 * 255).toInt()) : ChatifyColors.steelGrey,
                        onTap: () {
                          setState(() {
                            showRecommendations = !showRecommendations;
                          });
                        },
                        child: Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'Предпросмотр',
                                      style: TextStyle(color: context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.black, fontSize: ChatifySizes.fontSizeMd),
                                    ),
                                    const SizedBox(width: 6),
                                    Icon(
                                      showRecommendations ? Icons.keyboard_arrow_down_rounded : Icons.keyboard_arrow_up_rounded,
                                      size: 22,
                                      color: ChatifyColors.darkGrey,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 12),
                              child: Material(
                                color: ChatifyColors.transparent,
                                child: InkWell(
                                  customBorder: const CircleBorder(),
                                  onTap: saveSelectedInfo,
                                  child: CircleAvatar(
                                    radius: 20,
                                    backgroundColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                                    child: Icon(Icons.check_rounded, size: 23, color: ChatifyColors.black),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  AnimatedSize(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    alignment: Alignment.topCenter,
                    child: showRecommendations
                      ? const SizedBox(width: double.infinity, height: 0)
                      : SizedBox(
                          width: double.infinity,
                          height: 160,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 12, right: 12, top: 6, bottom: 12),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Stack(
                                clipBehavior: Clip.hardEdge,
                                children: [
                                  Positioned.fill(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        border: Border(
                                          left: BorderSide(color: context.isDarkMode ? ChatifyColors.mildNight : ChatifyColors.grey),
                                          right: BorderSide(color: context.isDarkMode ? ChatifyColors.mildNight : ChatifyColors.grey),
                                          bottom: BorderSide(color: context.isDarkMode ? ChatifyColors.mildNight : ChatifyColors.grey),
                                        ),
                                      ),
                                      child: Image.asset(ChatifyImages.wallpaperDarkV3, fit: BoxFit.cover, width: double.infinity, height: double.infinity),
                                    ),
                                  ),
                                  Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.only(left: 30, right: 16, top: 8, bottom: 8),
                                    color: ChatifyColors.darkBackground,
                                    child: Row(
                                      children: [
                                        ClipOval(
                                          child: CachedNetworkImage(
                                            width: 45,
                                            height: 45,
                                            imageUrl: _profileImageUrl ?? '',
                                            fit: BoxFit.cover,
                                            errorWidget: (context, url, error) => CircleAvatar(
                                              backgroundColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                                              foregroundColor: ChatifyColors.white,
                                              child: SvgPicture.asset(ChatifyVectors.profile, width: 45, height: 45),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                APIs.me.name,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(color: ChatifyColors.white, fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400),
                                              ),
                                              Text(
                                                'Как другие видят вашу информацию профиля',
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(color: ChatifyColors.grey, fontSize: 13, fontWeight: FontWeight.w400),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  /// -- Cloud --
                                  Positioned(
                                    top: 30,
                                    left: 7,
                                    child: Stack(
                                      clipBehavior: Clip.none,
                                      children: [
                                        _buildAboutBubble(
                                          about: about,
                                          borderColor: context.isDarkMode ? ChatifyColors.softNight : ChatifyColors.grey,
                                          backgroundColor: context.isDarkMode ? ChatifyColors.youngNight : ChatifyColors.white,
                                          textColor: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black,
                                        ),
                                        Positioned(
                                          top: 12,
                                          left: 27,
                                          child: Container(
                                            width: 7,
                                            height: 7,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: context.isDarkMode ? ChatifyColors.youngNight : ChatifyColors.white,
                                              border: Border.all(color: context.isDarkMode ? ChatifyColors.softNight : ChatifyColors.grey, width: 1),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAboutBubble({required String? about, required Color borderColor, required Color backgroundColor, required Color textColor}) {
    return Padding(
      padding: const EdgeInsets.only(top: 24),
      child: CustomPaint(
        painter: AboutBubblePainter(borderColor: borderColor, backgroundColor: backgroundColor, radius: 24, circleRadius: 9, circleCenterX: 25, circleCenterY: 5),
        child: ConstrainedBox(
          constraints: const BoxConstraints(minWidth: 40, maxWidth: 400),
          child: Container(
            padding: const EdgeInsets.only(left: 12, right: 12, top: 7, bottom: 7),
            child: Text(
              about?.trim().isNotEmpty == true ? about! : 'Информация отсутствует',
              style: TextStyle(color: textColor, fontSize: 13, fontWeight: FontWeight.w400, overflow: TextOverflow.ellipsis),
              maxLines: 1,
            ),
          ),
        ),
      ),
    );
  }
}
