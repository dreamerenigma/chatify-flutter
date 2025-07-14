import 'dart:io';

class StatusModel {
  static File? statusImageFile;
  static DateTime? statusDate;

  static void setStatus(File image, DateTime date) {
    statusImageFile = image;
    statusDate = date;
  }

  static void clearStatus() {
    statusImageFile = null;
    statusDate = null;
  }
}
