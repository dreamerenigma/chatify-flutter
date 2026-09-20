import 'dart:io';
import 'dart:math';
import 'package:chatify/api/apis.dart';
import 'package:chatify/features/community/controllers/photo_community_controller.dart';
import 'package:chatify/features/utils/widgets/scrolls/no_glow_scroll_behavior.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../api/community_api.dart';
import '../../../data/emoji_data.dart';
import '../../../generated/l10n/l10n.dart';
import '../../../routes/custom_page_route.dart';
import '../../../utils/constants/app_colors.dart';
import '../../../utils/constants/app_sizes.dart';
import '../../../utils/constants/app_vectors.dart';
import '../../personalization/widgets/dialogs/light_dialog.dart';
import '../../utils/widgets/dividers/custom_divider.dart';
import '../models/community_model.dart';
import '../widgets/dialogs/edit_image_community_bottom_dialog.dart';
import 'communities_screen.dart';
import 'emoji_sticker_screen.dart';

class NewCommunityScreen extends StatefulWidget {
  final ValueChanged<CommunityModel> onCommunitySelected;

  const NewCommunityScreen({super.key, required this.onCommunitySelected});

  @override
  NewCommunityScreenState createState() => NewCommunityScreenState();
}

class NewCommunityScreenState extends State<NewCommunityScreen> {
  final List<List<String>> emojiCategories = [peopleEmojis, animalEmojis, foodEmojis, sportEmojis];
  final nameFocusNode = FocusNode();
  final descriptionFocusNode = FocusNode();
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final int maxCharCount = 100;
  late final RxString imageRx;
  late final PhotoCommunityController communityController;
  bool _descriptionInitialized = false;
  int charCount = 0;
  int descriptionLength = 0;
  Color _selectedColor = Colors.grey[200]!;
  Color? _generatedEmojiBackground;
  String _selectedEmoji = '';
  String? imagePath;
  String? _generatedEmoji;

  String getRandomEmoji() {
    final random = Random();
    final category = emojiCategories[random.nextInt(emojiCategories.length)];

    return category[random.nextInt(category.length)];
  }

  @override
  void initState() {
    super.initState();
    imageRx = RxString('');
    nameController.addListener(_updateCharCount);
    communityController = Get.put(PhotoCommunityController(image: imageRx));
    descriptionController.addListener(_updateDescriptionLength);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      nameFocusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    nameController.removeListener(_updateCharCount);
    descriptionController.removeListener(_updateDescriptionLength);
    nameController.dispose();
    descriptionController.dispose();
    nameFocusNode.dispose();
    descriptionFocusNode.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_descriptionInitialized) {
      descriptionController.text = S.of(context).welcomeCommunity;
      _descriptionInitialized = true;
    }
  }

  Future<void> selectEmoji() async {
    final result = await Navigator.push(context, createPageRoute(EmojiStickerScreen(initialColor: _selectedColor, initialEmoji: _selectedEmoji)));

    if (result != null && result is Map) {
      setState(() {
        _selectedColor = result['color'];
        _selectedEmoji = result['emoji'];
      });
    }
  }

  void _updateCharCount() {
    setState(() {
      charCount = nameController.text.length;
    });
  }

  void updateImagePath(String? path) {
    setState(() {
      imagePath = path;
      communityController.image.value = path ?? '';
    });
  }

  void _generateRandomCommunityAvatar() {
    final random = Random();

    setState(() {
      _generatedEmoji = getRandomEmoji();

      _generatedEmojiBackground = ChatifyColors.containerColorsLight[
        random.nextInt( ChatifyColors.containerColorsLight.length)
      ];
    });
  }

  void _updateDescriptionLength() {
    setState(() {
      descriptionLength = descriptionController.text.length;
    });
  }

  void _hideKeyboard() {
    nameFocusNode.unfocus();
    descriptionFocusNode.unfocus();
    FocusManager.instance.primaryFocus?.unfocus();
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
            titleSpacing: 0,
            elevation: 1,
            backgroundColor: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.white,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_rounded, size: 24),
              onPressed: () {
                _hideKeyboard();

                if (!mounted) return;

                Navigator.pop(context);
              },
            ),
            title: Text(S.of(context).newCommunity, style: TextStyle(fontSize: ChatifySizes.fontSizeXl, fontWeight: FontWeight.w400)),
            iconTheme: IconThemeData(color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black),
          ),
        ),
      ),
      body: ScrollConfiguration(
        behavior: NoGlowScrollBehavior(),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Center(
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: S.of(context).viewExamples,
                                  style: TextStyle(color: colorsController.getColor(colorsController.selectedColorScheme.value), fontSize: 15, fontWeight: FontWeight.w600),
                                  recognizer: TapGestureRecognizer()..onTap = () {},
                                ),
                                TextSpan(text: S.of(context).differentCommunities, style: TextStyle(color: ChatifyColors.darkGrey, fontSize: 15, fontWeight: FontWeight.w400)),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              CustomDivider(indent: 0, endIndent: 0, left: 0, right: 0, top: 6),
              const SizedBox(height: 16),
              Center(
                child: Column(
                  children: [
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        GestureDetector(
                          onTap: () {
                            final imageUrl = imagePath ?? '';
                            const communityId = 'temporaryId';

                            nameFocusNode.unfocus();
                            descriptionFocusNode.unfocus();

                            showEditImageCommunityBottomDialog(
                              context,
                              imageUrl,
                              communityId,
                              () => CommunityApi.deleteCommunityPicture(communityId, imageUrl),
                              updateImagePath,
                              updateImagePath,
                              (color, emoji) {
                                setState(() {
                                  _generatedEmojiBackground = color;
                                  _generatedEmoji = emoji;
                                  imagePath = null;
                                });
                              },
                            );
                          },
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Container(
                                width: 115,
                                height: 115,
                                decoration: BoxDecoration(
                                  color: _generatedEmojiBackground ?? ChatifyColors.darkerGrey,
                                  borderRadius: BorderRadius.circular(30),
                                  image: imagePath != null ? DecorationImage(image: FileImage(File(imagePath!)), fit: BoxFit.cover) : null,
                                ),
                                child: imagePath == null ? _generatedEmoji != null
                                  ? Center(child: Text(_generatedEmoji!, style: const TextStyle(fontSize: 55)))
                                  : const Icon(MdiIcons.accountGroup, size: 70) : null,
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          bottom: -5,
                          right: -7,
                          child: GestureDetector(
                            onTap: _generateRandomCommunityAvatar,
                            child: Container(
                              decoration: BoxDecoration(
                                color: colorsController.getColor(colorsController.selectedColorScheme.value),
                                shape: BoxShape.circle,
                                border: Border.all(color: ChatifyColors.black, width: 2),
                              ),
                              padding: const EdgeInsets.all(4),
                              child: SvgPicture.asset(ChatifyVectors.refresh, width: 19, height: 19, colorFilter: ColorFilter.mode(ChatifyColors.black, BlendMode.srcIn)),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(S.of(context).changePhoto, style: TextStyle(color: ChatifyColors.darkGrey, fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w400)),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    TextSelectionTheme(
                      data: TextSelectionThemeData(
                        cursorColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                        selectionColor: colorsController.getColor(colorsController.selectedColorScheme.value).withAlpha((0.3 * 255).toInt()),
                        selectionHandleColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                      ),
                      child: TextField(
                        controller: nameController,
                        focusNode: nameFocusNode,
                        maxLength: maxCharCount,
                        textCapitalization: TextCapitalization.sentences,
                        style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400),
                        decoration: InputDecoration(
                          counterText: '',
                          hintText: S.of(context).communityName,
                          labelText: S.of(context).communityName,
                          hintStyle: TextStyle(color: ChatifyColors.darkGrey, fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400),
                          labelStyle: TextStyle(color: ChatifyColors.darkGrey, fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400),
                          floatingLabelStyle: TextStyle(color: ChatifyColors.darkGrey, fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400),
                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: ChatifyColors.darkerGrey)),
                          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: colorsController.getColor(colorsController.selectedColorScheme.value))),
                          suffixIcon: nameController.text.isNotEmpty ? IconButton(onPressed: () => nameController.clear(), icon: const Icon(Icons.close, size: 20)) : null,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8, right: 12, top: 8, bottom: 8),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text('${charCount.toString()}/${maxCharCount.toString()}', style: const TextStyle(color: ChatifyColors.darkGrey, fontSize: 13, fontWeight: FontWeight.w400)),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextSelectionTheme(
                      data: TextSelectionThemeData(
                        cursorColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                        selectionColor: colorsController.getColor(colorsController.selectedColorScheme.value).withAlpha((0.3 * 255).toInt()),
                        selectionHandleColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                      ),
                      child: TextField(
                        controller: descriptionController,
                        focusNode: descriptionFocusNode,
                        maxLines: 4,
                        maxLength: 2048,
                        textCapitalization: TextCapitalization.sentences,
                        style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400),
                        decoration: InputDecoration(
                          counterText: '',
                          contentPadding: const EdgeInsets.all(16),
                          hintText: 'Чему посвящено это сообщество? Рекомендуем установить правила для участников.',
                          hintStyle: TextStyle(color: ChatifyColors.darkGrey, fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400),
                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: ChatifyColors.darkerGrey)),
                          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: colorsController.getColor(colorsController.selectedColorScheme.value))),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8, right: 12, top: 8, bottom: 8),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text('$descriptionLength/2048', style: TextStyle(color: ChatifyColors.darkGrey, fontSize: 13, fontWeight: FontWeight.w400)),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 5),
        child: FloatingActionButton(
          heroTag: 'newCommunity',
          onPressed: () async {
            FocusManager.instance.primaryFocus?.unfocus();

            await Future<void>.delayed(Duration.zero);

            final name = nameController.text;
            final description = descriptionController.text.isNotEmpty ? descriptionController.text : S.of(context).welcomeCommunity;

            if (imagePath == null) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(S.of(context).pleaseSelectImageCommunity)));
              return;
            }

            final community = CommunityModel(
              id: '',
              name: name,
              image: '',
              description: description,
              createdAt: DateTime.now(),
              creatorName: '${APIs.me.name}${APIs.me.surname.isNotEmpty ? ' ${APIs.me.surname}' : ''}',
              creatorId: APIs.me.id,
              members: [APIs.me.id],
            );

            final success = await CommunityApi.createCommunity(context, community, File(imagePath!));

            if (success) {
              nameController.clear();
              descriptionController.clear();
              setState(() {
                charCount = 0;
              });

              Navigator.pop(context);
              Navigator.pushReplacement(context, createPageRoute(CommunitiesScreen(user: APIs.me)));
            }
          },
          backgroundColor: colorsController.getColor(colorsController.selectedColorScheme.value),
          foregroundColor: ChatifyColors.white,
          child: Icon(Icons.arrow_forward_rounded, size: 26, color: ChatifyColors.black),
        ),
      ),
    );
  }
}
