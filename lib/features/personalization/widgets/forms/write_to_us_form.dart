import 'dart:developer';
import 'dart:typed_data';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import '../../../../../../../data/repositories/email/email_send_repository.dart';
import '../../../../routes/custom_page_route.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../screens/help/help_center_screen.dart';
import '../dialogs/light_dialog.dart';
import '../input/write_to_us_input.dart';

class WriteToUsForm extends StatefulWidget {
  const WriteToUsForm({super.key, this.selectedImages, required this.onFieldsFilledChanged});

  final List<AssetEntity>? selectedImages;
  final void Function(bool) onFieldsFilledChanged;

  @override
  WriteToUsFormState createState() => WriteToUsFormState();
}

class WriteToUsFormState extends State<WriteToUsForm> {
  TextEditingController helpController = TextEditingController();
  late List<AssetEntity> selectedImages;
  bool allFieldsFilled = false;

  @override
  void initState() {
    super.initState();
    helpController.addListener(checkFieldsFilled);
    Future.delayed(Duration.zero, checkFieldsFilled);
    selectedImages = widget.selectedImages ?? [];
  }

  @override
  void dispose() {
    helpController.dispose();
    super.dispose();
  }

  void checkFieldsFilled() {
    final filled = helpController.text.isNotEmpty;
    if (filled != allFieldsFilled) {
      setState(() {
        allFieldsFilled = filled;
      });
      widget.onFieldsFilledChanged(allFieldsFilled);
    }
  }

  Future<void> handleSendFeedback() async {
    log('handleSendFeedback called');

    List<Uint8List> imageBytes = [];

    for (AssetEntity image in selectedImages) {
      Uint8List? bytes = await image.originBytes;
      if (bytes != null) {
        imageBytes.add(bytes);
      }
    }

    log('Image bytes length: ${imageBytes.length}');

    bool success = await EmailSendRepository.instance.sendFeedback(
      context,
      suggestion: helpController.text.isEmpty ? null : helpController.text,
      images: imageBytes,
    );

    log('Feedback sent status: $success');

    if (success) {
      setState(() {
        helpController.clear();
        selectedImages.clear();
        allFieldsFilled = false;
      });
      widget.onFieldsFilledChanged(allFieldsFilled);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        WriteToUsInput(controller: helpController, hintText: 'Чем мы можем вам помочь?'),
        const SizedBox(height: 20),
        RichText(
          text: TextSpan(
            children: [
              const TextSpan(
                text: 'Нажимая "Далее", вы даете согласие Chatify на проверку информации о диагностике и технических характеристиках устройства, а также на проверку метаданных, связанных с вашим аккаунтом, с целью поиска и устранения указанной проблемы. ',
                style: TextStyle(
                  color: ChatifyColors.darkGrey,
                  height: 1.5,
                ),
              ),
              TextSpan(
                text: ' Подробнее',
                style: TextStyle(
                  color: colorsController.getColor(colorsController.selectedColorScheme.value),
                  decoration: TextDecoration.none,
                  height: 1.5,
                ),
                recognizer: TapGestureRecognizer()..onTap = () async {
                  Navigator.push(context, createPageRoute(const HelpCenterScreen()));
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
