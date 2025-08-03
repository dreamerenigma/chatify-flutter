import 'dart:io';
import 'package:chatify/api/apis.dart';
import 'package:chatify/features/community/controllers/photo_community_controller.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:get/get.dart';
import '../../../generated/l10n/l10n.dart';
import '../../../routes/custom_page_route.dart';
import '../../../utils/constants/app_colors.dart';
import '../../../utils/constants/app_sizes.dart';
import '../../personalization/widgets/dialogs/light_dialog.dart';
import '../models/community_model.dart';
import '../widgets/dialogs/edit_image_community_bottom_dialog.dart';
import 'community_screen.dart';
import 'emoji_sticker_screen.dart';

class NewCommunityScreen extends StatefulWidget {
  final ValueChanged<CommunityModel> onCommunitySelected;

  const NewCommunityScreen({super.key, required this.onCommunitySelected});

  @override
  NewCommunityScreenState createState() => NewCommunityScreenState();
}

class NewCommunityScreenState extends State<NewCommunityScreen> {
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  int charCount = 0;
  final int maxCharCount = 100;
  late final RxString imageRx;
  late final PhotoCommunityController communityController;
  Color _selectedColor = Colors.grey[200]!;
  String _selectedEmoji = '';
  String? imagePath;

  @override
  void initState() {
    super.initState();
    imageRx = RxString('');
    nameController.addListener(_updateCharCount);
    communityController = Get.put(PhotoCommunityController(image: imageRx));
  }

  void _updateCharCount() {
    setState(() {
      charCount = nameController.text.length;
    });
  }

  Future<void> selectEmoji() async {
    final result = await Navigator.push(
      context,
      createPageRoute(EmojiStickerScreen(initialColor: _selectedColor, initialEmoji: _selectedEmoji)),
    );

    if (result != null && result is Map) {
      setState(() {
        _selectedColor = result['color'];
        _selectedEmoji = result['emoji'];
      });
    }
  }

  void updateImagePath(String? path) {
    setState(() {
      imagePath = path;
      communityController.image.value = path ?? '';
    });
  }

  @override
  void dispose() {
    nameController.removeListener(_updateCharCount);
    nameController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration: BoxDecoration(
            color: ChatifyColors.white,
            boxShadow: [
              BoxShadow(
                color: ChatifyColors.black.withAlpha((0.1 * 255).toInt()),
                spreadRadius: 1,
                blurRadius: 3,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: AppBar(
            titleSpacing: 0,
            backgroundColor: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.white,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            title: Text(S.of(context).newCommunity, style: TextStyle(fontSize: ChatifySizes.fontSizeLg)),
            elevation: 1,
            iconTheme: IconThemeData(
              color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              child: Row(
                children: [
                  Expanded(
                    child: Center(
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: S.of(context).viewExamples,
                              style: TextStyle(fontSize: ChatifySizes.fontSizeSm, color: colorsController.getColor(colorsController.selectedColorScheme.value)),
                              recognizer: TapGestureRecognizer()..onTap = () {},
                            ),
                            TextSpan(text: S.of(context).differentCommunities, style: const TextStyle(fontSize: 14, color: ChatifyColors.grey)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(),
            const SizedBox(height: 16),
            Center(
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      const communityId = 'temporaryId';
                      final imageUrl = imagePath ?? '';

                      showEditImageCommunityBottomDialog(
                        context,
                        updateImagePath, () {
                          APIs.deleteCommunityPicture(communityId, imageUrl);
                        },
                        communityId,
                        imageUrl,
                        updateImagePath,
                      );
                    },
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            color: ChatifyColors.darkerGrey,
                            borderRadius: BorderRadius.circular(25),
                            image: imagePath != null ? DecorationImage(image: FileImage(File(imagePath!)), fit: BoxFit.cover) : null,
                          ),
                          child: imagePath == null ? const Icon(MdiIcons.accountGroup, size: 70) : null,
                        ),
                        Positioned(
                          bottom: -5,
                          right: -7,
                          child: Container(
                            decoration: BoxDecoration(
                              color: colorsController.getColor(colorsController.selectedColorScheme.value),
                              shape: BoxShape.circle,
                              border: Border.all(color: ChatifyColors.black, width: 2),
                            ),
                            padding: const EdgeInsets.all(4),
                            child: const Icon(Icons.refresh, size: 24, color: ChatifyColors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(S.of(context).changePhoto, style: TextStyle(fontSize: ChatifySizes.fontSizeSm, color: ChatifyColors.darkGrey)),
                ],
              ),
            ),
            const SizedBox(height: 24),
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
                      maxLength: maxCharCount,
                      cursorColor: Colors.blue,
                      style: TextStyle(fontSize: ChatifySizes.fontSizeMd),
                      decoration: InputDecoration(
                        hintText: S.of(context).communityName,
                        labelText: S.of(context).communityName,
                        hintStyle: TextStyle(fontSize: ChatifySizes.fontSizeMd),
                        border: const OutlineInputBorder(borderSide: BorderSide.none),
                        enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: ChatifyColors.grey)),
                        focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: colorsController.getColor(colorsController.selectedColorScheme.value))),
                        counterText: '',
                      ),
                      textCapitalization: TextCapitalization.sentences,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text('${charCount.toString()}/${maxCharCount.toString()}', style: const TextStyle(color: ChatifyColors.grey)),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
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
                      maxLines: 4,
                      cursorColor: Colors.blue,
                      textCapitalization: TextCapitalization.sentences,
                      style: TextStyle(fontSize: ChatifySizes.fontSizeMd),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: ChatifyColors.darkerGrey,
                        contentPadding: const EdgeInsets.all(16),
                        hintText: S.of(context).welcomeCommunity,
                        hintStyle: TextStyle(fontSize: ChatifySizes.fontSizeMd),
                        border: const OutlineInputBorder(borderSide: BorderSide.none),
                        enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: ChatifyColors.grey)),
                        focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: colorsController.getColor(colorsController.selectedColorScheme.value))),
                      ),
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
            );

            final success = await APIs.createCommunity(context, community, File(imagePath!));

            if (success) {
              nameController.clear();
              descriptionController.clear();
              setState(() {
                charCount = 0;
              });

              Navigator.pop(context);
              Navigator.pushReplacement(context, createPageRoute(CommunityScreen(user: APIs.me)));
            }
          },
          backgroundColor: colorsController.getColor(colorsController.selectedColorScheme.value),
          foregroundColor: ChatifyColors.white,
          child: const Icon(Icons.arrow_forward_rounded),
        ),
      ),
    );
  }
}
