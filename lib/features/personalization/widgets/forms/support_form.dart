import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import '../../../../../../../data/repositories/email/email_send_repository.dart';
import '../../../../generated/l10n/l10n.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../images/support_image_selector.dart';
import '../input/support_input.dart';

class SupportForm extends StatefulWidget {
  final List<AssetEntity>? selectedImages;
  final void Function(bool) onFieldsFilledChanged;

  const SupportForm({
    super.key,
    this.selectedImages,
    required this.onFieldsFilledChanged,
  });

  @override
  SupportFormState createState() => SupportFormState();
}

class SupportFormState extends State<SupportForm> {
  TextEditingController problemController = TextEditingController();
  late List<AssetEntity> selectedImages;
  bool allFieldsFilled = false;

  @override
  void initState() {
    super.initState();
    problemController.addListener(checkFieldsFilled);
    Future.delayed(Duration.zero, checkFieldsFilled);
    selectedImages = widget.selectedImages ?? [];
  }

  @override
  void dispose() {
    problemController.dispose();
    super.dispose();
  }

  void checkFieldsFilled() {
    final filled = problemController.text.isNotEmpty;
    if (filled != allFieldsFilled) {
      setState(() {
        allFieldsFilled = filled;
      });
      widget.onFieldsFilledChanged(allFieldsFilled);
    }
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
      suggestion: problemController.text.isEmpty ? null : problemController.text,
      images: imageBytes,
    );

    if (success) {
      setState(() {
        problemController.clear();
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
        SupportInput(controller: problemController, hintText: S.of(context).describeProblem),
        const SizedBox(height: 30),
        Text(S.of(context).screenshotsOptional, style: TextStyle(fontSize: ChatifySizes.fontSizeSm)),
        SizedBox(height: 6),
        Text(S.of(context).addScreenshots, style: TextStyle(fontSize: ChatifySizes.fontSizeSm)),
        const SizedBox(height: 20),
        SupportImageSelector(
          selectedImages: selectedImages,
          onRemoveImage: (index) => setState(() => selectedImages.removeAt(index)),
          onAddImage: (images) => setState(() => selectedImages = images),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
