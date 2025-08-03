import 'package:get/get.dart';
import '../../chat/models/user_model.dart';

class CallController extends GetxController {
  RxBool isIncomingCall = false.obs;
  Rx<UserModel> callingUser = UserModel(
    id: '',
    image: '',
    about: '',
    status: '',
    phoneNumber: '',
    name: '',
    surname: '',
    createdAt: DateTime.now(),
    isOnline: false,
    lastActive: DateTime.now(),
    pushToken: '',
    email: '',
    isTyping: false,
    role: 'User',
  ).obs;

  void startIncomingCall(UserModel user) {
    callingUser.value = user;
    isIncomingCall.value = true;
  }

  void acceptCall() {
    isIncomingCall.value = false;
  }

  void rejectCall() {
    isIncomingCall.value = false;
  }
}
