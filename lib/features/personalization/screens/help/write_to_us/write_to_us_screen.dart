import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import '../../../../../../../../data/repositories/email/email_send_repository.dart';
import '../../../../../utils/constants/app_sizes.dart';
import '../../../widgets/buttons/support_button.dart';
import '../../../widgets/forms/write_to_us_form.dart';

class WriteToUsScreen extends StatefulWidget {
  const WriteToUsScreen({super.key, this.selectedImages});

  final List<AssetEntity>? selectedImages;

  @override
  WriteToUsScreenState createState() => WriteToUsScreenState();
}

class WriteToUsScreenState extends State<WriteToUsScreen> {
  TextEditingController helpController = TextEditingController();
  late List<AssetEntity> selectedImages;

  bool allFieldsFilled = false;

  void updateFieldsFilled(bool filled) {
    setState(() {
      allFieldsFilled = filled;
    });
  }

  Future<void> handleSendFeedback() async {
    List<Uint8List> imageBytes = [];

    for (AssetEntity image in selectedImages) {
      Uint8List? bytes = await image.originBytes;
      if (bytes != null) {
        imageBytes.add(bytes);
      }
    }
    bool success = await EmailSendRepository.instance.sendFeedback(
      context,
      suggestion: helpController.text.isEmpty ? null : helpController.text,
      images: imageBytes,
    );
    if (success) {
      setState(() {
        helpController.clear();
        selectedImages.clear();
        allFieldsFilled = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Text('Напишите нам', style: Theme.of(context).textTheme.headlineMedium),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: WriteToUsForm(
                selectedImages: widget.selectedImages,
                onFieldsFilledChanged: updateFieldsFilled,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Мы ответим вам в чате Chatify',
                  style: TextStyle(
                    fontSize: ChatifySizes.fontSizeSm,
                  ),
                ),
                const Spacer(),
                Align(
                  alignment: Alignment.center,
                  child: SizedBox(
                    child: SupportButton(
                      allFieldsFilled: allFieldsFilled,
                      handleSendFeedback: handleSendFeedback,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
