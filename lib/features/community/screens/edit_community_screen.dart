import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatify/api/apis.dart';
import 'package:chatify/features/community/controllers/photo_community_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:get/get.dart';
import '../../../api/community_api.dart';
import '../../../generated/l10n/l10n.dart';
import '../../../routes/custom_page_route.dart';
import '../../../utils/constants/app_colors.dart';
import '../../../utils/constants/app_sizes.dart';
import '../../personalization/widgets/dialogs/light_dialog.dart';
import '../models/community_model.dart';
import '../widgets/dialogs/edit_image_community_bottom_dialog.dart';
import 'communities_screen.dart';
import 'emoji_sticker_screen.dart';

class EditCommunityScreen extends StatefulWidget {
  final CommunityModel community;

  const EditCommunityScreen({
    super.key,
    required this.community,
  });

  @override
  EditCommunityScreenState createState() => EditCommunityScreenState();
}

class EditCommunityScreenState extends State<EditCommunityScreen> {
  final TextEditingController nameController = TextEditingController();
  final nameFocusNode = FocusNode();
  final descriptionFocusNode = FocusNode();
  final int maxCharCount = 100;
  final descriptionController = TextEditingController();
  late final RxString imageRx;
  late final PhotoCommunityController communityController;
  int charCount = 0;
  int descriptionLength = 0;
  Color _selectedColor = Colors.grey[200]!;
  String _selectedEmoji = '';
  String? imagePath;
  String? _communityImageUrl;

  @override
  void initState() {
    super.initState();
    nameController.text = widget.community.name;
    nameController.addListener(_updateCharCount);
    imageRx = RxString('');
    communityController = Get.put(PhotoCommunityController(image: imageRx));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        nameFocusNode.requestFocus();
      }
    });
    _loadCommunityImage();
  }

  @override
  void dispose() {
    nameController.removeListener(_updateCharCount);
    nameController.dispose();
    descriptionController.dispose();
    super.dispose();
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

  void _hideKeyboard() {
    nameFocusNode.unfocus();
    descriptionFocusNode.unfocus();
    FocusManager.instance.primaryFocus?.unfocus();
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

  Future<void> _loadCommunityImage() async {
    final imagePath = widget.community.image.trim();

    if (imagePath.isEmpty) return;

    try {
      final imageUrl = await APIs.mediaService.getUrl(imagePath);

      if (!mounted) return;

      setState(() {
        _communityImageUrl = imageUrl;
      });
    } catch (e) {
      debugPrint('Ошибка загрузки изображения сообщества: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
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
            title: Text(S.of(context).changeCommunity, style: TextStyle(fontSize: ChatifySizes.fontSizeXl, fontWeight: FontWeight.w400)),
            iconTheme: IconThemeData(color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 35),
            Center(
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      const communityId = 'temporaryId';
                      final imageUrl = imagePath ?? '';

                      showEditImageCommunityBottomDialog(
                        context,
                        communityId,
                        imageUrl,
                        () => CommunityApi.deleteCommunityPicture(communityId, imageUrl),
                        updateImagePath,
                        updateImagePath,
                        (color, emoji) {
                          setState(() {
                            _selectedColor = color;
                            _selectedEmoji = emoji;
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
                          decoration: BoxDecoration(color: ChatifyColors.darkerGrey, borderRadius: BorderRadius.circular(25)),
                          clipBehavior: Clip.antiAlias,
                          child: _communityImageUrl != null && _communityImageUrl!.trim().isNotEmpty
                            ? CachedNetworkImage(
                                imageUrl: _communityImageUrl!,
                                width: 115,
                                height: 115,
                                fit: BoxFit.cover,
                                placeholder: (context, url) {
                                  return const Center(child: Icon(MdiIcons.accountGroup, size: 75, color: ChatifyColors.grey));
                                },
                                errorWidget: (context, url, error) {
                                  return const Center(child: Icon(MdiIcons.accountGroup, size: 75, color: ChatifyColors.grey));
                                },
                              )
                            : const Center(child: Icon(MdiIcons.accountGroup, size: 75, color: ChatifyColors.grey),
                          ),
                        ),
                        Positioned(
                          bottom: -10,
                          right: -7,
                          child: Container(
                            width: 37,
                            height: 37,
                            decoration: BoxDecoration(color: colorsController.getColor(colorsController.selectedColorScheme.value), shape: BoxShape.circle, border: Border.all(color: ChatifyColors.black, width: 2.0)),
                            padding: const EdgeInsets.all(4),
                            child: const Icon(Icons.camera_alt_outlined, size: 21, color: ChatifyColors.black),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.all(16.0),
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
                    padding: const EdgeInsets.only(left: 8, right: 12, top: 4, bottom: 8),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text('${charCount.toString()}/${maxCharCount.toString()}', style: TextStyle(color: ChatifyColors.darkGrey, fontSize: 13, fontWeight: FontWeight.w400)),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
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
                      cursorColor: ChatifyColors.blue,
                      textCapitalization: TextCapitalization.sentences,
                      style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400),
                      decoration: InputDecoration(
                        counterText: '',
                        contentPadding: const EdgeInsets.all(16),
                        hintText: S.of(context).welcomeCommunity,
                        hintStyle: TextStyle(color: ChatifyColors.darkGrey, fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400),
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: ChatifyColors.darkerGrey)),
                        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: colorsController.getColor(colorsController.selectedColorScheme.value))),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8, right: 12, top: 4, bottom: 8),
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
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 5),
        child: FloatingActionButton(
          heroTag: 'newCommunity',
          onPressed: () async {
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
          child: Icon(Icons.check, color: ChatifyColors.black),
        ),
      ),
    );
  }
}
