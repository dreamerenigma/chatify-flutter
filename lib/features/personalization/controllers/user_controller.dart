import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../chat/models/user_model.dart';
import 'package:flutter/material.dart';

class UserController extends GetxController {
  Rx<UserModel> user = Rx<UserModel>(UserModel(
    name: '',
    surname: '',
    image: '',
    id: '',
    about: '',
    status: '',
    phoneNumber: '',
    createdAt: DateTime.now(),
    isOnline: false,
    lastActive: DateTime.now(),
    pushToken: '',
    email: '',
    isTyping: false,
    role: 'User',
  ));

  RxBool isDataLoaded = false.obs;
  final box = GetStorage();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void onInit() {
    super.onInit();
    log('UserController onInit called');
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final firebaseUser = FirebaseAuth.instance.currentUser;

    if (firebaseUser == null) {
      log("No Firebase user found");
      return;
    }

    try {
      final snapshot = await _firestore.collection('Users').doc(firebaseUser.uid).get();

      if (snapshot.exists) {
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
        log("Data fetched from Firestore: $data");

        user.value = UserModel(
          id: snapshot.id,
          name: data['name'] ?? '',
          surname: data['surname'] ?? '',
          image: data['image'] ?? '',
          about: data['about'] ?? '',
          status: data['status'] ?? '',
          phoneNumber: data['phone_number'] ?? '',
          createdAt: (data['created_at'] as Timestamp).toDate(),
          isOnline: data['is_online'] ?? false,
          lastActive: (data['last_active'] as Timestamp).toDate(),
          pushToken: data['push_token'] ?? '',
          email: data['email'] ?? '',
          isTyping: data['is_typing'] ?? false,
          role: data['is_typing'] ?? 'User',
        );

        isDataLoaded.value = true;

        Get.lazyPut(() => TextEditingController(text: user.value.name));
      }
    } catch (e) {
      log("Error loading user data from Firestore: $e");
    }
  }

  void updateUser(UserModel newUser) {
    final oldUser = user.value;
    user.value = newUser;
    _saveUserDataToFirestore(newUser, oldUser);
    update();
  }

  Future<void> _saveUserDataToFirestore(UserModel newUser, UserModel oldUser) async {
    try {
      if (newUser.id.isEmpty) {
        final firebaseUser = FirebaseAuth.instance.currentUser;
        if (firebaseUser != null) {
          newUser = newUser.copyWith(id: firebaseUser.uid);
          log("User ID был пустой. Присвоили из FirebaseAuth: '${newUser.id}'");
        } else {
          log("Ошибка: не удалось присвоить ID — FirebaseUser = null");
          return;
        }
      }

      log("Saving user with id: '${newUser.id}'");

      Map<String, dynamic> updatedFields = {};

      if (newUser.name.isNotEmpty && newUser.name != oldUser.name) {
        updatedFields['name'] = newUser.name;
      }
      if (newUser.image.isNotEmpty && newUser.image != oldUser.image) {
        updatedFields['image'] = newUser.image;
      }
      if (newUser.about.isNotEmpty && newUser.about != oldUser.about) {
        updatedFields['about'] = newUser.about;
      }
      if (newUser.status.isNotEmpty && newUser.status != oldUser.status) {
        updatedFields['status'] = newUser.status;
      }
      if (newUser.phoneNumber.isNotEmpty && newUser.phoneNumber != oldUser.phoneNumber) {
        updatedFields['phone_number'] = newUser.phoneNumber;
      }
      if (newUser.pushToken.isNotEmpty && newUser.pushToken != oldUser.pushToken) {
        updatedFields['push_token'] = newUser.pushToken;
      }

      if (updatedFields.isNotEmpty) {
        log("Saving updated fields: $updatedFields");
        await _firestore.collection('Users').doc(newUser.id).update(updatedFields);
        log("User data updated in Firestore");
      } else {
        log("No fields to update");
      }

    } catch (e) {
      log("Error saving user data to Firestore: $e");
    }
  }

  UserModel get currentUser => user.value;

  void clearUserImage() {
    user.update((val) {
      val?.image = '';
    });
  }

  void updateUserImage(String newImageUrl) {
    if (newImageUrl.isNotEmpty) {
      final oldUser = user.value;
      final updatedUser = user.value.copyWith(image: newImageUrl);

      user.value = updatedUser;

      _saveUserDataToFirestore(updatedUser, oldUser);
      log("Image updated: $newImageUrl");
    } else {
      log("Invalid image URL: $newImageUrl");
    }
  }
}
