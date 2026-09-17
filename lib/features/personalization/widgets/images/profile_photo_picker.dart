import 'dart:io';
import 'package:image_picker/image_picker.dart';
import '../../../../api/apis.dart';

Future<bool> handleContainerTap(int index,) async {
  final ImagePicker picker = ImagePicker();

  switch (index) {
    case 0:
      final XFile? image = await picker.pickImage(source: ImageSource.camera, imageQuality: 80,);

      if (image == null) {
        return false;
      }

      return await APIs.updateProfilePicture(File(image.path));
    case 1:
      final XFile? image = await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);

      if (image == null) {
        return false;
      }

      return await APIs.updateProfilePicture(File(image.path));
    case 2:
      return false;
    default:
      return false;
  }
}
