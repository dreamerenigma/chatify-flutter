import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../../api/apis.dart';
import '../../../../generated/l10n/l10n.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../../utils/popups/dialogs.dart';
import '../../widgets/dialogs/add_intelligence_bottom_dialog.dart';
import '../../widgets/dialogs/delete_all_intelligence_dialog.dart';
import '../../widgets/dialogs/light_dialog.dart';

class ProfileIntelligenceScreen extends StatefulWidget {
  const ProfileIntelligenceScreen({super.key});

  @override
  State<ProfileIntelligenceScreen> createState() => ProfileIntelligenceScreenState();
}

class ProfileIntelligenceScreenState extends State<ProfileIntelligenceScreen> {
  final storage = GetStorage();
  List<String> intelligenceTexts = [];
  String status = '';

  @override
  void initState() {
    super.initState();
    intelligenceTexts = List<String>.from(storage.read<List<dynamic>>('intelligenceTexts') ?? [S.of(context).helloProfile]);
    status = storage.read<String>('status') ?? (intelligenceTexts.isNotEmpty ? intelligenceTexts.first : '');
  }

  void addIntelligenceText(String text) {
    setState(() {
      intelligenceTexts.add(text);
      storage.write('intelligenceTexts', intelligenceTexts);
    });
  }

  void selectText(String text) async {
    try {
      await Dialogs.showCustomDialog(context: context, message: S.of(context).update, duration: const Duration(seconds: 1));

      setState(() {
        status = text;
        storage.write('status', text);
        APIs.me.status = text;
      });

      await APIs.updateUserInfo();
    } catch (e) {
      log('${S.of(context).errorUpdatingUserInfo}: $e');
    }
  }

  void clearIntelligenceTexts() {
    setState(() {
      intelligenceTexts.clear();
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
            backgroundColor: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.white,
            titleSpacing: 0,
            title: Text(S.of(context).intelligence, style: TextStyle(fontSize: ChatifySizes.fontSizeMg, fontWeight: FontWeight.w400)),
            elevation: 1,
            actions: [
              IconButton(
                icon: const Icon(Icons.more_vert, color: ChatifyColors.white),
                onPressed: () {
                  showMenu(
                    context: context,
                    color: context.isDarkMode ? ChatifyColors.darkSlate : ChatifyColors.white,
                    position: const RelativeRect.fromLTRB(50, 75, 0, 0),
                    items: [
                      PopupMenuItem(
                        value: 1,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                        child: Text(S.of(context).deleteAll, style: TextStyle(fontSize: ChatifySizes.fontSizeMd, color: ChatifyColors.white)),
                        onTap: () {
                          showDeleteAllIntelligenceDialog(context, clearIntelligenceTexts);
                        },
                      ),
                    ],
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 12),
                child: Text(S.of(context).currentInfo, style: TextStyle(fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.normal, color: ChatifyColors.darkGrey)),
              ),
              InkWell(
                onTap: () => showAddIntelligenceBottomSheet(context, status, addIntelligenceText),
                splashColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey,
                highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(status, style: TextStyle(fontSize: ChatifySizes.fontSizeMd, color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black)),
                      Icon(Icons.edit_outlined, size: 24, color: colorsController.getColor(colorsController.selectedColorScheme.value)),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Divider(height: 1, thickness: 1, color: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.grey),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(S.of(context).selectDetails, style: TextStyle(fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.normal, color: ChatifyColors.darkGrey)),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: intelligenceTexts.length,
              itemBuilder: (context, index) {
                final text = intelligenceTexts[index];
                return InkWell(
                  onTap: () => selectText(text),
                  splashColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(text, style: TextStyle(fontSize: ChatifySizes.fontSizeMd, color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black)),
                        if (status == text) Icon(Icons.check, color: colorsController.getColor(colorsController.selectedColorScheme.value), size: 24),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
