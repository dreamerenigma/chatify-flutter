import '../../chat/models/user_model.dart';

class ChatStorageDataModel {
  final UserModel user;
  final String size;

  const ChatStorageDataModel({
    required this.user,
    required this.size,
  });
}
