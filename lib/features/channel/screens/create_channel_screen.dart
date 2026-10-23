import 'package:chatify/features/utils/widgets/dialogs/edit_image_bottom_dialog.dart';
import 'package:chatify/features/utils/widgets/scrolls/no_glow_scroll_behavior.dart';
import 'package:chatify/utils/constants/app_vectors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get_utils/src/extensions/context_extensions.dart';
import '../../../core/enums/custom_scale_button_type.dart';
import '../../../utils/constants/app_colors.dart';
import '../../../utils/constants/app_sizes.dart';
import '../../chat/models/user_model.dart';
import '../../personalization/widgets/dialogs/light_dialog.dart';
import '../../utils/widgets/buttons/custom_scale_button.dart';

class CreateChannelScreen extends StatefulWidget {
  final UserModel user;

  const CreateChannelScreen({
    super.key,
    required this.user,
  });

  @override
  State<CreateChannelScreen> createState() => _CreateChannelScreenState();
}

class _CreateChannelScreenState extends State<CreateChannelScreen> {
  final TextEditingController _channelNameController = TextEditingController();

  @override
  void dispose() {
    _channelNameController.dispose();
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
            boxShadow: [BoxShadow(color: ChatifyColors.black.withAlpha((0.1 * 255).toInt()), spreadRadius: 1, blurRadius: 3, offset: const Offset(0, 1))],
          ),
          child: AppBar(
            title: Text('Создать канал', style: TextStyle(fontSize: ChatifySizes.fontSizeMg, fontWeight: FontWeight.w400)),
            titleSpacing: 0,
            elevation: 0,
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
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ScrollConfiguration(
                behavior: NoGlowScrollBehavior(),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Center(
                        child: SizedBox(
                          width: 112,
                          height: 112,
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  showEditImageBottomDialog(
                                    context,
                                    title: 'Картинка канала',
                                    onImageSelected: (String value) {},
                                    onEmojiSelected: (Color color, String emoji) {},
                                    onDeletePressed: () {},
                                  );
                                },
                                child: Container(
                                  width: 112,
                                  height: 112,
                                  decoration: BoxDecoration(shape: BoxShape.circle, color: context.isDarkMode ? ChatifyColors.mildNight : ChatifyColors.grey.withAlpha(35)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(28),
                                    child: SvgPicture.asset(ChatifyVectors.channel, width: 34, height: 34, colorFilter: ColorFilter.mode(ChatifyColors.darkGrey, BlendMode.srcIn)),
                                  ),
                                ),
                              ),
                              Positioned(
                                right: -2,
                                bottom: -2,
                                child: Container(
                                  width: 38,
                                  height: 38,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: colorsController.getColor(colorsController.selectedColorScheme.value),
                                    border: Border.all(color: context.isDarkMode ? ChatifyColors.black : ChatifyColors.white, width: 1.5),
                                  ),
                                  child: IconButton(
                                    padding: EdgeInsets.zero,
                                    onPressed: () {
                                      showEditImageBottomDialog(
                                        context,
                                        title: 'Картинка канала',
                                        onImageSelected: (String value) {},
                                        onEmojiSelected: (Color color, String emoji) {},
                                        onDeletePressed: () {},
                                      );
                                    },
                                    icon: Icon(Icons.camera_alt_outlined, size: 24),
                                    color: context.isDarkMode ? ChatifyColors.black : ChatifyColors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 50),
                      TextSelectionTheme(
                        data: TextSelectionThemeData(
                          cursorColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                          selectionColor: colorsController.getColor(colorsController.selectedColorScheme.value).withAlpha((0.3 * 255).toInt()),
                          selectionHandleColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                        ),
                        child: TextField(
                          controller: _channelNameController,
                          textCapitalization: TextCapitalization.sentences,
                          maxLength: 100,
                          style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400),
                          onChanged: (_) {
                            setState(() {});
                          },
                          decoration: InputDecoration(
                            labelText: 'Название канала',
                            counterText: '',
                            suffixIcon: _channelNameController.text.isNotEmpty
                              ? Padding(
                                  padding: const EdgeInsets.only(right: 8),
                                  child: Center(
                                    widthFactor: 1,
                                    child: Text(
                                      '${100 - _channelNameController.text.length}',
                                      style: TextStyle(color: ChatifyColors.darkGrey, fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w400),
                                    ),
                                  ),
                                )
                              : null,
                            floatingLabelStyle: TextStyle(color: ChatifyColors.darkGrey, fontSize: 15, fontWeight: FontWeight.w400),
                            labelStyle: TextStyle(color: context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.grey, fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400),
                            border: const UnderlineInputBorder(),
                            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: colorsController.getColor(colorsController.selectedColorScheme.value), width: 1)),
                            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: ChatifyColors.darkerGrey, width: 1)),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextSelectionTheme(
                        data: TextSelectionThemeData(
                          cursorColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                          selectionColor: colorsController.getColor(colorsController.selectedColorScheme.value).withAlpha((0.3 * 255).toInt()),
                          selectionHandleColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                        ),
                        child: TextField(
                          textCapitalization: TextCapitalization.sentences,
                          minLines: 4,
                          maxLines: 4,
                          maxLength: 255,
                          style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400),
                          decoration: InputDecoration(
                            hintText: 'Опишите ваш канал. Описание канала будет полезным для ваших подписчиков.',
                            hintStyle: TextStyle(color: context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.grey, fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400),
                            alignLabelWithHint: true,
                            border: const UnderlineInputBorder(),
                            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: colorsController.getColor(colorsController.selectedColorScheme.value), width: 1)),
                            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: ChatifyColors.darkerGrey, width: 1)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(25, 12, 25, 16),
              child: SizedBox(
                width: double.infinity,
                child: CustomScaleButton(
                  onPressed: () {},
                  type: CustomScaleButtonType.filled,
                  label: Text('Создать канал', style: TextStyle(color: ChatifyColors.black, fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
