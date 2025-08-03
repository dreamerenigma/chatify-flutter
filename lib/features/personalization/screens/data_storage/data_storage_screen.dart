import 'package:carbon_icons/carbon_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../../../generated/l10n/l10n.dart';
import '../../../../../utils/constants/app_colors.dart';
import '../../../../../utils/constants/app_sizes.dart';
import '../../../utils/widgets/no_glow_scroll_behavior.dart';
import '../../widgets/dialogs/autoloaded_media_dialog.dart';
import '../../widgets/dialogs/light_dialog.dart';
import '../../widgets/dialogs/quality_loaded_media_dialog.dart';

class DataStorageScreen extends StatefulWidget {
  const DataStorageScreen({super.key});

  @override
  State<DataStorageScreen> createState() => _DataStorageScreenState();
}

class _DataStorageScreenState extends State<DataStorageScreen> {
  final GetStorage storage = GetStorage();
  bool isDataSavings = false;
  String selectedQuality = 'standard';
  Set<String> selectedAutoLoadedMedia = {'Фото'};

  @override
  void initState() {
    super.initState();
    final storedQuality = storage.read<String>('selectedQuality');
    if (storedQuality != null) {
      selectedQuality = storedQuality;
    }
  }

  void _updateQuality(String quality) {
    setState(() {
      selectedQuality = quality;
    });
    storage.write('selectedQuality', quality);
  }

  void _updateAutoLoadedMedia(Set<String> media) {
    setState(() {
      selectedAutoLoadedMedia = media;
    });
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
            title: Text(S.of(context).dataStorage, style: TextStyle(fontSize: ChatifySizes.fontSizeMg, fontWeight: FontWeight.w400)),
            titleSpacing: 0,
            backgroundColor: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.white,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ),
      ),
      body: ScrollConfiguration(
        behavior: NoGlowScrollBehavior(),
        child: ScrollbarTheme(
          data: ScrollbarThemeData(thumbColor: WidgetStateProperty.all(ChatifyColors.darkerGrey)),
          child: Scrollbar(
            thickness: 4,
            thumbVisibility: false,
            child: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: ListView(
                children: [
                  InkWell(
                    onTap: () {},
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Row(
                        children: [
                          Icon(Icons.folder_outlined, color: colorsController.getColor(colorsController.selectedColorScheme.value)),
                          const SizedBox(width: 20),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Управление хранилищем', style: TextStyle(fontSize: ChatifySizes.fontSizeMd)),
                                Text('1,5 ГБ', style: TextStyle(fontSize: ChatifySizes.fontSizeSm, color: ChatifyColors.darkGrey)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Divider(),
                  InkWell(
                    onTap: () {},
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Row(
                        children: [
                          Icon(CarbonIcons.network_3_reference, color: colorsController.getColor(colorsController.selectedColorScheme.value)),
                          const SizedBox(width: 20),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Использование сети', style: TextStyle(fontSize: ChatifySizes.fontSizeMd)),
                                const SizedBox(height: 4),
                                Text('Отправлено: 500,2 МБ   •   Получено: 2,2 ГБ', style: TextStyle(fontSize: ChatifySizes.fontSizeSm, color: ChatifyColors.darkGrey)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        isDataSavings = !isDataSavings;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 65, right: 20, top: 10, bottom: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Экономия данных', style: TextStyle(fontSize: ChatifySizes.fontSizeMd)),
                          Switch(
                            value: isDataSavings,
                            onChanged: (bool value) {
                              setState(() {
                                isDataSavings = value;
                              });
                            },
                            activeColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                            activeTrackColor: colorsController.getColor(colorsController.selectedColorScheme.value).withAlpha((0.5 * 255).toInt()),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),
                  InkWell(
                    onTap: () {},
                    child: Padding(
                      padding: const EdgeInsets.only(left: 65, right: 20, top: 10, bottom: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Прокси-сервер', style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.bold)),
                              Text('Выкл.', style: TextStyle(fontSize: ChatifySizes.fontSizeSm, color: ChatifyColors.darkGrey)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Divider(),
                  InkWell(
                    onTap: () async {
                      final result = await showQualityLoadedMediaDialog(context, selectedQuality);
                      if (result != null) {
                        _updateQuality(result);
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        children: [
                          Icon(Icons.hd_outlined, color: colorsController.getColor(colorsController.selectedColorScheme.value)),
                          const SizedBox(width: 20),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Качество загрузки медиафайлов', style: TextStyle(fontSize: ChatifySizes.fontSizeMd)),
                                const SizedBox(height: 4),
                                Text(
                                  selectedQuality == 'standard' ? 'Стандартное качество' : 'HD-качество',
                                  style: TextStyle(fontSize: ChatifySizes.fontSizeSm, color: ChatifyColors.darkGrey),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Divider(),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Автозагрузка медиа', style: TextStyle(fontSize: ChatifySizes.fontSizeSm, color: ChatifyColors.darkGrey, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        Text('Голосовые сообщения всегда загружаются автоматически.', style: TextStyle(fontSize: ChatifySizes.fontSizeSm, color: ChatifyColors.darkGrey)),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () async {
                      final result = await showAutoLoadedMediaDialog(context, selectedAutoLoadedMedia);
                      if (result != null) {
                        _updateAutoLoadedMedia(result);
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 65, right: 20, top: 10, bottom: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Мобильная сеть', style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.bold)),
                              Text(
                                selectedAutoLoadedMedia.isEmpty ? 'Фото' : selectedAutoLoadedMedia.join(', '),
                                style: TextStyle(fontSize: ChatifySizes.fontSizeSm, color: ChatifyColors.darkGrey),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () async {
                      final result = await showAutoLoadedMediaDialog(context, selectedAutoLoadedMedia);
                      if (result != null) {
                        _updateAutoLoadedMedia(result);
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 65, right: 20, top: 10, bottom: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Wi-Fi', style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.bold)),
                              Text(
                                selectedAutoLoadedMedia.isEmpty ? 'Фото' : selectedAutoLoadedMedia.join(', '),
                                style: TextStyle(fontSize: ChatifySizes.fontSizeSm, color: ChatifyColors.darkGrey),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 25),
                    child: InkWell(
                      onTap: () async {
                        final result = await showAutoLoadedMediaDialog(context, selectedAutoLoadedMedia);
                        if (result != null) {
                          _updateAutoLoadedMedia(result);
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(left: 65, right: 20, top: 10, bottom: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('В роуминге', style: TextStyle(fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.bold)),
                                Text(
                                  selectedAutoLoadedMedia.isEmpty ? 'Фото' : selectedAutoLoadedMedia.join(', '),
                                  style: TextStyle(fontSize: ChatifySizes.fontSizeSm, color: ChatifyColors.darkGrey),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
