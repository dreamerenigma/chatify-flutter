import 'dart:developer';
import 'package:chatify/features/personalization/screens/chats/select_wallpaper_screen.dart';
import 'package:chatify/features/personalization/widgets/sliders/custom_slider.dart';
import 'package:chatify/routes/custom_page_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../../generated/l10n/l10n.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_images.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../../utils/constants/app_vectors.dart';
import '../../widgets/dialogs/light_dialog.dart';

class WallpaperScreen extends StatefulWidget {
  final String imagePath;

  const WallpaperScreen({super.key, required this.imagePath});

  @override
  State<WallpaperScreen> createState() => _WallpaperScreenState();
}

class _WallpaperScreenState extends State<WallpaperScreen> {
  double sliderValue = 0;
  final box = GetStorage();
  late String imagePath;

  @override
  void initState() {
    super.initState();
    final storedImagePath = box.read('backgroundImagePath') ?? widget.imagePath ?? '';
    setState(() {
      imagePath = storedImagePath;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final storedImagePath = box.read('backgroundImagePath') ?? widget.imagePath ?? '';
    setState(() {
      imagePath = storedImagePath;
    });
  }

  void checkStoredData() {
    final storedImagePath = box.read('backgroundImagePath');
    log("Stored data check: $storedImagePath");
  }

  @override
  Widget build(BuildContext context) {
    final backgroundImage = (imagePath.isNotEmpty) ? imagePath : (context.isDarkMode ? ChatifyImages.chatBackgroundDark : ChatifyImages.chatBackgroundLight);
    final Color overlayColor = context.isDarkMode ? Color.fromRGBO(0, 0, 0, sliderValue) : Color.fromRGBO(255, 255, 255, sliderValue);

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Text(context.isDarkMode ? S.of(context).wallpaperDarkTheme : S.of(context).wallpaperLightTheme, style: TextStyle(fontSize: ChatifySizes.fontSizeMg, fontWeight: FontWeight.w400)),
      ),
      body: ScrollbarTheme(
        data: ScrollbarThemeData(thumbColor: WidgetStateProperty.all(ChatifyColors.darkerGrey)),
        child: Scrollbar(
          thickness: 4,
          thumbVisibility: false,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () async {
                    final selectedImagePath = await Navigator.pushReplacement(context, createPageRoute(const SelectWallpaperScreen(imagePath: '')));

                    if (selectedImagePath != null) {
                      setState(() {
                        imagePath = selectedImagePath;
                        box.write('selectedWallpaper', selectedImagePath);
                      });
                    }
                  },
                  child: Center(
                    child: Container(
                      width: 210,
                      height: 400,
                      decoration: BoxDecoration(border: Border.all(color: ChatifyColors.popupColor, width: 1), borderRadius: BorderRadius.circular(16)),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Stack(
                          children: [
                            ColorFiltered(
                              colorFilter: ColorFilter.mode(overlayColor, BlendMode.srcOver),
                              child: Image.asset(backgroundImage, fit: BoxFit.cover, width: 210, height: 400),
                            ),
                            Positioned(
                              top: 0,
                              left: 0,
                              right: 0,
                              child: Container(
                                height: 30,
                                color: context.isDarkMode ? ChatifyColors.greyBlue : ChatifyColors.softGrey,
                                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Row(
                                  children: [
                                    SvgPicture.asset(ChatifyVectors.profile, width: 20, height: 20),
                                    const SizedBox(width: 8.0),
                                    Text(S.of(context).contactName, style: TextStyle(color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black, fontSize: 10)),
                                  ],
                                ),
                              ),
                            ),
                            Positioned(
                              top: 40,
                              left: 60,
                              child: Center(
                                child: Container(
                                  width: 90,
                                  height: 30,
                                  decoration: BoxDecoration(
                                    color: context.isDarkMode ? ChatifyColors.popupColorDark : ChatifyColors.softGrey,
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                )
                              )
                            ),
                            Positioned(
                              top: 80,
                              left: 10,
                              child: Center(
                                child: Container(
                                  width: 190,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    color: context.isDarkMode ? ChatifyColors.popupColorDark : ChatifyColors.softGrey,
                                    borderRadius: const BorderRadius.only(topRight: Radius.circular(12), bottomLeft: Radius.circular(12), bottomRight: Radius.circular(12)),
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              top: 150,
                              left: 10,
                              child: Center(
                                child: Container(
                                  width: 190,
                                  height: 60,
                                  decoration: const BoxDecoration(
                                    color: ChatifyColors.ascentBlue,
                                    borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12), bottomLeft: Radius.circular(12)),
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 5,
                              left: 5,
                              child: Row(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(color: context.isDarkMode ? ChatifyColors.greyBlue : ChatifyColors.softGrey, borderRadius: BorderRadius.circular(12)),
                                    padding: const EdgeInsets.only(left: 6, right: 6, top: 6, bottom: 6),
                                    child: const Row(
                                      children: [
                                        Icon(Icons.emoji_emotions_outlined, color: ChatifyColors.darkGrey, size: 20),
                                        SizedBox(width: 80),
                                        Icon(Icons.attach_file, color: ChatifyColors.darkGrey, size: 18),
                                        SizedBox(width: 8.0),
                                        Icon(Icons.camera_alt_outlined, color: ChatifyColors.darkGrey, size: 20),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Container(
                                    width: 35,
                                    height: 35,
                                    decoration: BoxDecoration(color: colorsController.getColor(colorsController.selectedColorScheme.value), shape: BoxShape.circle),
                                    child: const Icon(Icons.mic, color: ChatifyColors.white),
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
                const SizedBox(height: 25),
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(context, createPageRoute(const SelectWallpaperScreen(imagePath: '')));
                  },
                  child: Center(
                    child: Text(S.of(context).change,
                      style: TextStyle(color: colorsController.getColor(colorsController.selectedColorScheme.value), fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Divider(),
                const SizedBox(height: 12),
                Padding(padding: EdgeInsets.symmetric(horizontal: 25), child: Text(S.of(context).darkeningWallpaper)),
                const SizedBox(height: 16.0),
                Row(
                  children: [
                    Expanded(
                      child: CustomSlider(
                        value: sliderValue,
                        onChanged: (value) {
                          setState(() {
                            sliderValue = value;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(S.of(context).changeWallpaperLightTheme, style: TextStyle(color: ChatifyColors.darkGrey, fontSize: ChatifySizes.fontSizeSm), textAlign: TextAlign.center),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
