import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:chatify/features/bot/models/support_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis_auth/auth_io.dart' as auths;
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import '../config.dart';
import '../features/authentication/screens/add_account_screen.dart';
import '../features/chat/models/user_model.dart';
import '../features/chat/models/message_model.dart';
import '../features/community/models/community_model.dart';
import '../features/group/models/group_model.dart';
import '../features/home/screens/home_screen.dart';
import '../features/newsletter/models/newsletter.dart';
import '../generated/l10n/l10n.dart';
import '../routes/custom_page_route.dart';
import '../utils/constants/app_sounds.dart';
import '../utils/popups/dialogs.dart';
import '../utils/urls/url_utils.dart';
import '../utils/urls/urls.dart';
import 'access_firebase_token.dart';
import 'package:path/path.dart' as path;

class APIs {
  /// -- Authentication.
  static FirebaseAuth auth = FirebaseAuth.instance;

  /// -- Accessing cloud Firestore Database.
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  /// -- Accessing Firebase Storage.
  static FirebaseStorage storage = FirebaseStorage.instance;

  /// -- Storing self information user.
  static late UserModel me;

  /// -- Storing self information community.
  static CommunityModel? community;

  /// -- Return current user.
  static User get user => auth.currentUser!;

  /// -- Accessing Firebase Messaging (Push Notification).
  static FirebaseMessaging fMessaging = FirebaseMessaging.instance;

  ///******************* User Related APIs *******************

  /// -- Getting Firebase Messaging token.
  static Future<void> getFirebaseMessagingToken() async {
    try {
      if (Platform.isAndroid || Platform.isIOS) {
        await fMessaging.requestPermission();

        await fMessaging.getToken().then((t) {
          if (t != null) {
            me.pushToken = t;
          }
        });
      } else {
        log("Firebase Messaging не поддерживается на этой платформе.");
      }
    } catch (e) {
      log("Ошибка при получении Firebase токена: $e");
    }
  }

  /// -- Sending push notification.
  static Future<void> sendPushNotification(UserModel chatUser, String msg, {String? imageUrl}) async {
    final logger = Logger();
    try {
      AccessFirebaseToken accessToken = AccessFirebaseToken();
      String bearerToken = await accessToken.getAccessToken();

      final body = {
        "message": {
          "token": chatUser.pushToken,
          "notification": {
            "title": me.name,
            "body": msg,
            if (imageUrl != null) "image": imageUrl,
          },
          "data": {
            "click_action": "FLUTTER_NOTIFICATION_CLICK",
            if (imageUrl != null) "image": imageUrl,
          },
        },
      };

      var res = await post(
        Uri.parse('https://fcm.googleapis.com/v1/projects/chatify-6fdfb/messages:send'),
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'Bearer $bearerToken',
        },
        body: jsonEncode(body),
      );

      logger.d("Response statusCode: ${res.statusCode}");
      logger.d("Response body: ${res.body}");

      if (res.statusCode != 200) {
        throw Exception('Failed to send push notification');
      }
    } catch (e) {
      logger.d("\nsendPushNotification: $e");
    }
  }

  /// -- Sending OTP.
  static Future<void> sendOTP({required String phoneNumber, required Function(String verificationId, int? resendToken) onCodeSent, required Function(FirebaseAuthException e) onError,}) async {
    try {
      await auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        timeout: const Duration(seconds: 60),
        verificationCompleted: (PhoneAuthCredential credential) async {
          await auth.signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          onError(e);
        },
        codeSent: onCodeSent,
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } catch (e) {
      onError(FirebaseAuthException(
        message: e.toString(),
        code: 'otp-error',
      ));
    }
  }

  /// -- Verify OTP.
  static Future<void> verifyOTP(String verificationId, String otp) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: verificationId, smsCode: otp);

      await FirebaseAuth.instance.signInWithCredential(credential);
      log('User signed in successfully');
    } catch (e) {
      log('Failed to sign in: $e');
    }
  }

  /// -- Checking if user exists or not?
  static Future<bool> userExists() async {
    return (await firestore.collection('Users').doc(user.uid).get()).exists;
  }

  /// -- Adding an chat user for our conversation.
  static Future<bool> addChatUser(String email) async {
    final data = await firestore.collection('Users').where('email', isEqualTo: email).get();

    log('data: ${data.docs}');

    if (data.docs.isNotEmpty && data.docs.first.id != user.uid) {

      log('user exists ${data.docs.first.data()}');

      firestore
        .collection('Users')
        .doc(user.uid)
        .collection('my_users')
        .doc(data.docs.first.id)
        .set({});

      return true;
    } else {

      return false;
    }
  }

  /// -- Getting current user info.
  static Future<void> getSelfInfo() async {
    final userDoc = await firestore.collection('Users').doc(user.uid).get();

    if (userDoc.exists) {
      me = UserModel.fromJson(userDoc.data()!);
      await getFirebaseMessagingToken();
      APIs.updateActiveStatus(true);
    } else {
      log("User data not found in Firestore");
    }
  }

  static Future<UserModel?> getUserById(String userId) async {
    try {
      final userDoc = await firestore.collection('Users').doc(userId).get();

      if (userDoc.exists) {
        return UserModel.fromJson(userDoc.data()!);
      }
    } catch (e) {
      log('Error fetching user by ID: $e');
    }

    return null;
  }

  /// -- Getting current user info.
  static Future<bool> checkIfUserExists(String id) async {
    try {
      final doc = await FirebaseFirestore.instance.collection('Users').doc(id).get();
      return doc.exists;
    } catch (e) {
      log('Error checking if user exists: $e');
      return false;
    }
  }

  /// -- Creating a new ChatUser object.
  static UserModel createChatUserFromData(Map<String, dynamic> userData) {
    return UserModel(
      id: userData['id'] ?? '',
      name: userData['name'] ?? 'Неизвестный пользователь',
      surname: userData['surname'] ?? 'Неизвестный пользователь',
      email: userData['email'] ?? '',
      phoneNumber: userData['phoneNumber'] ?? '',
      about: userData['about'] ?? 'Привет я использую Chatify!',
      status: userData['status'] ?? 'Онлайн',
      image: userData['image'] ?? '',
      createdAt: userData['createdAt'] ?? '',
      isOnline: userData['isOnline'] ?? false,
      lastActive: userData['lastActive'] ?? '',
      pushToken: userData['pushToken'] ?? '',
      isTyping: userData['isTyping'] ?? false,
    );
  }

  /// -- Creating new user.
  static Future<void> createUserInFirestore(BuildContext context) async {
    final time = DateTime.now();
    final parts = user.displayName?.split(' ') ?? [''];
    final name = parts.isNotEmpty ? parts.first : '';
    final surname = parts.length > 1 ? parts.sublist(1).join(' ') : '';

    final chatUser = UserModel(
      id: user.uid,
      name: name,
      surname: surname,
      email: user.email.toString(),
      phoneNumber: user.phoneNumber?.isNotEmpty == true ? user.phoneNumber! : '',
      about: S.of(context).aboutText,
      status: S.of(context).statusText,
      image: user.photoURL.toString(),
      createdAt: time,
      isOnline: false,
      lastActive: time,
      pushToken: '',
      isTyping: false,
    );

    return await firestore
      .collection('Users')
      .doc(user.uid)
      .set(chatUser.toJson());
  }

  /// -- Method to fetch username Firestore.
  static Future<Map<String, String>> fetchUserNames(List<String> userIds, {bool shortenNames = false}) async {
    final userNames = <String, String>{};

    try {
      final snapshot = await FirebaseFirestore.instance.collection('Users').where(FieldPath.documentId, whereIn: userIds).get();
      final currentUserId = FirebaseAuth.instance.currentUser?.uid;

      for (var doc in snapshot.docs) {
        final data = doc.data();
        final userId = doc.id;
        var userName = (userId == currentUserId) ? 'Вы' : (data['name'] ?? 'Unknown User');

        if (shortenNames && userName.length > 7) {
          userName = userName.substring(0, 7);
        }

        userNames[userId] = userName;
      }
    } catch (e) {
      log('Error fetching user names: $e');
    }

    return userNames;
  }

  /// -- Getting all users from Firestore.
  static Stream<QuerySnapshot<Map<String, dynamic>>> getMyUsersId() {
    return firestore
      .collection('Users')
      .doc(user.uid)
      .collection('my_users')
      .snapshots();
  }

  /// -- Getting all users from Firestore.
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUsers(List<String> userIds) {
    if (userIds.isEmpty) {
      return const Stream<QuerySnapshot<Map<String, dynamic>>>.empty();
    } else {
      return firestore
        .collection('Users')
        .where('id', whereIn: userIds)
        .snapshots();
    }
  }

  /// -- Adding an user to my user when first message in send.
  static Future<void> sendFirstMessage(UserModel chatUser, String msg, Type type) async {
    await firestore
      .collection('Users')
      .doc(chatUser.id)
      .collection('my_users')
      .doc(user.uid)
      .set({}).then((value) => sendMessage(chatUser, msg, type));
  }

  /// -- Updating user info.
  static Future<void> updateUserInfo() async {
    await firestore.collection('Users').doc(user.uid).update({
      'name' : me.name,
      'about' : me.about,
      'status' : me.status,
      'phone_number' : me.phoneNumber,
    });
  }

  /// -- Load User Data From Firestore.
  static Future<UserModel?> loadUserDataFromFirestore() async {
    try {
      final firebaseUser = FirebaseAuth.instance.currentUser;

      if (firebaseUser == null) {
        return null;
      }

      log("Logged in user UID: ${firebaseUser.uid}");

      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance.collection('Users').doc(firebaseUser.uid).get();

      if (userSnapshot.exists) {
        log("User data from Firestore: ${userSnapshot.data()}");

        final userData = userSnapshot.data() as Map<String, dynamic>;
        log("Parsed user data: $userData");

        return UserModel.fromJson(userData);
      } else {
        log("User not found in Firestore");
        return null;
      }
    } catch (e) {
      log("Error loading user data from Firestore: $e");
      return null;
    }
  }

  /// -- Update profile picture of user.
  static Future<void> updateProfilePicture(File file) async {
    final ext = file.path.split('.').last;
    log('Extension: $ext');

    final ref = storage.ref().child('profile_pictures/${user.uid}.$ext');

    await ref
      .putFile(file, SettableMetadata(contentType: 'image/$ext'))
      .then((p0) {
        log('Data Transferred: ${p0.bytesTransferred / 1000} kb');
    });

    me.image = await ref.getDownloadURL();
    await firestore
      .collection('Users')
      .doc(user.uid)
      .update({'image': me.image});
  }

  /// -- Getting specific user info.
  static Stream<DocumentSnapshot<Map<String, dynamic>>> getUserInfo(UserModel chatUser) {
    return firestore.collection('Users').doc(chatUser.id).snapshots();
  }

  /// -- Update online or last active status of user.
  static Future<void> updateActiveStatus(bool isOnline) async {
    log("Updating online status to: $isOnline");
    firestore.collection('Users').doc(user.uid).update({
      'is_online': isOnline,
      'last_active': Timestamp.now(),
      'push_token': me.pushToken,
    });
  }

  /// -- Method to update print status.
  static Future<void> updateTypingStatus(String userId, bool isTyping) async {
    await firestore.collection('Users').doc(userId).update({
      'is_typing': isTyping,
    });
  }

  /// -- Google Sign In (Android, iOS).
  static Future<UserCredential?> signInWithGoogle() async {
    try {
      final connected = await _hasInternetConnection();
      if (!connected) {
        throw Exception('Нет подключения к интернету');
      }
      log('Интернет-соединение успешно установлено.');

      final GoogleSignIn googleSignIn = GoogleSignIn();
      log('GoogleSignIn инициализирован.');

      await googleSignIn.signOut();
      log('Пользователь успешно вышел из Google.');

      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        log('Пользователь отменил вход.');
        return null;
      }

      log('GoogleSignInAccount получен: ${googleUser.email}');

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      log('GoogleSignInAuthentication успешно получен.');

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      log('GoogleSignInCredential успешно создан.');

      final userCredential = await APIs.auth.signInWithCredential(credential);
      log('Вход в Firebase успешно выполнен для пользователя: ${userCredential.user?.email}');

      return userCredential;
    } catch (e) {
      if (e is FirebaseAuthException) {
        log('FirebaseAuthException: ${e.message}');
      } else if (e is PlatformException) {
        log('PlatformException: ${e.message}');
      } else {
        log('Unknown error: $e');
      }
      rethrow;
    }
  }

  /// -- Email Sign In
  static Future<void> signInWithEmailAndPassword(BuildContext context, String email, String password) async {
    try {
      log('Попытка входа: email = $email, password = ${'*' * password.length}');

      final UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      log('Вход успешен: ${userCredential.user?.uid}');

      Navigator.pushReplacement(context, createPageRoute(HomeScreen(user: APIs.me)));

      Get.snackbar('Успешно', 'Вход успешен!');
    } on FirebaseAuthException catch (e) {
      log('Ошибка входа: ${e.code} - ${e.message}');

      Get.snackbar('Ошибка при входе', e.message ?? e.code);
    } catch (e) {
      log('Неизвестная ошибка при входе: $e');

      Get.snackbar('Ошибка', 'Неизвестная ошибка при входе');
    }
  }

  /// -- Google Sign In for Windows (MacOS, Linux).
  static Future<void> signInWithGoogleForWindows(BuildContext context) async {
    try {
      var clientId = auths.ClientId(
        Config.googleClientId,
        Config.googleClientSecret,
      );
      var scopes = ['email'];
      var client = await auths.clientViaUserConsent(clientId, scopes, prompt);
      var googleAuth = client.credentials;

      String? accessToken = googleAuth.accessToken.data;
      String? idToken = googleAuth.idToken;

      if (idToken == null) {
        throw Exception("Failed to obtain tokens from Google Auth.");
      }

      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: accessToken,
        idToken: idToken,
      );

      UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);

      if (userCredential.user != null) {
        log("User signed in: ${userCredential.user}");

        await getSelfInfo();

        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => HomeScreen(user: APIs.me),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
          ),
        );
      }
    } catch (e) {
      log("Error signing in with Google: $e");

      String authorizationUrl = AppUrls.googleAuthUrl;
      await UrlUtils.launchURL(authorizationUrl);

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please complete the authentication in the browser.")));
    }
  }

  /// -- This method prompts the user to visit a URL for consent.
  static void prompt(String url) {
    log("Please visit this URL to authorize: $url");
  }

  /// -- Sign In QR-code.
  Future<void> authenticateWithQrCode(String qrCodeData) async {
    try {
      final response = await http.post(
        Uri.parse('http://localhost:3000/authenticate'),
        headers: {'Content-Type': 'application/json'},
        body: '{"qrCodeData": "$qrCodeData"}',
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        String token = data['token'];

        await FirebaseAuth.instance.signInWithCustomToken(token);
        log('User authenticated successfully');
      } else {
        log('Failed to authenticate');
      }
    } catch (e) {
      log('Error during authentication: $e');
    }
  }

  /// -- Get content type for document.
  static String getContentType(String ext) {
    switch (ext) {
      case 'pdf':
        return 'application/pdf';
      case 'doc':
        return 'application/msword';
      case 'docx':
        return 'application/vnd.openxmlformats-officedocument.wordprocessingml.document';
      case 'xls':
        return 'application/vnd.ms-excel';
      case 'xlsx':
        return 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet';
      case 'apk':
        return 'application/vnd.android.package-archive';
      case 'zip':
        return 'application/zip';
      case 'rar':
        return 'application/x-rar-compressed';
      default:
        return 'application/octet-stream';
    }
  }

  /// -- Add new user status.
  static Future<void> addStatus(String imageUrl, String text, DateTime date) async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser != null) {
        DocumentReference userDoc = FirebaseFirestore.instance.collection('Users').doc(currentUser.uid);

        await userDoc.update({
          'my_status': FieldValue.arrayUnion([
            {
              'imageUrl': imageUrl,
              'text': text,
              'date': date,
            }
          ])
        });

        log('Статус успешно добавлен.');
      } else {
        log('Пользователь не авторизован.');
      }
    } catch (e) {
      log('Ошибка при добавлении статуса: $e');
    }
  }

  /// Upload image status to Firestore.
  static Future<String> uploadImage(File imageFile) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('User is not logged in');
      }

      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      String fileExtension = imageFile.path.split('.').last;

      Reference storageReference = FirebaseStorage.instance
        .ref()
        .child('status_images')
        .child('${user.uid}_$fileName.$fileExtension');

      UploadTask uploadTask = storageReference.putFile(imageFile);
      TaskSnapshot taskSnapshot = await uploadTask;

      String imageUrl = await taskSnapshot.ref.getDownloadURL();
      return imageUrl;
    } catch (e) {
      log('Error uploading image: $e');
      rethrow;
    }
  }

  /// Create app directories.
  static Future<void> createDirectories() async {
    if (kIsWeb) {
      return;
    }

    Directory? baseDir;

    if (defaultTargetPlatform == TargetPlatform.windows) {
      baseDir = await getApplicationDocumentsDirectory();
    } else {
      baseDir = await getExternalStorageDirectory();
    }

    if (baseDir != null) {
      String mediaPath = path.join(baseDir.path, 'Android', 'media', 'com.chatify', 'Chatify', 'Media');

      List<String> directories = [
        'WallPaper',
        'Chatify Audio',
        'Chatify Documents',
        'Chatify Images',
        'Chatify Profile Photos',
        'Chatify Stickers',
        'Chatify Video',
      ];

      for (String dirName in directories) {
        String dirPath = path.join(mediaPath, dirName);
        Directory directory = Directory(dirPath);

        if (!(await directory.exists())) {
          await directory.create(recursive: true);
          log('Создан каталог: $dirPath');
        }
      }
    }
  }

  /// Sign out account.
  static Future<void> signOut() async {
    try {
      await auth.signOut();
      Get.off(() => const AddAccountScreen(isFromSplashScreen: true, showBackButton: false));
    } catch (e) {
      log('Ошибка выхода: $e');
      Get.snackbar('Ошибка', 'Не удалось выйти из аккаунта.');
    }
  }

  /// -- Delete account.
  static Future<void> deleteAccount() async {
    try {
      User? user = auth.currentUser;

      if (user != null) {
        QuerySnapshot userChats = await firestore
            .collection('Chats')
            .where('participants', arrayContains: user.uid)
            .get();

        for (QueryDocumentSnapshot chat in userChats.docs) {
          await chat.reference.delete();
          log('Deleted chat: ${chat.id}');
        }

        DocumentReference userDocRef = firestore.collection('Users').doc(user.uid);
        await userDocRef.delete();
        log('Deleted user document: ${user.uid}');

        await GoogleSignIn().signOut();
        await auth.signOut();
        await user.delete();

        log('Deleted user from Firebase Auth: ${user.uid}');
        log('Account and related data deleted successfully');
      } else {
        log('No user is currently signed in.');
      }
    } catch (e) {
      log('Failed to delete account: $e');
    }
  }

  static Future<bool> _hasInternetConnection() async {
    if (kIsWeb) {
      try {
        final response = await http.get(Uri.parse('https://clients3.google.com/generate_204')).timeout(Duration(seconds: 5));
        log("Status Code: ${response.statusCode}");
        return response.statusCode == 204;
      } catch (e) {
        log("Error during web connection check: $e");
        return false;
      }
    } else {
      try {
        final result = await InternetAddress.lookup('google.com');
        return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
      } catch (e) {
        log("Error during native connection check: $e");
        return false;
      }
    }
  }

  ///******************* Chat Screen Related APIs *******************

  /// -- Useful for getting conversation id.
  static String getConversationId(String id) => user.uid.hashCode <= id.hashCode ? '${user.uid}_$id' : '${id}_${user.uid}';

  /// -- Getting all message of a specific conversation from Firestore Database.
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllMessages(UserModel user) {
    return firestore
      .collection('Chats/${getConversationId(user.id)}/messages/')
      .orderBy('sent', descending: true)
      .snapshots();
  }

  /// -- Sending message.
  static Future<void> sendMessage(UserModel chatUser, String msg, Type type, {String? fileName, String? fileSize, String? imageUrl}) async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();

    final MessageModel message = MessageModel(
      toId: chatUser.id,
      msg: msg,
      read: '',
      type: type,
      fromId: user.uid,
      sent: time,
      documentName: fileName,
      fileSize: fileSize,
      deletedBy: [],
      reaction: '',
      deletedAt: null,
    );

    final ref = firestore.collection('Chats/${getConversationId(chatUser.id)}/messages/');
    await ref.doc(time).set(message.toJson()).then((value) =>
        sendPushNotification(chatUser, type == Type.text ? msg : 'image', imageUrl: imageUrl));
  }

  /// -- Update read status of message.
  static Future<void> updateMessageReadStatus(MessageModel message) async {
    firestore
      .collection('Chats/${getConversationId(message.fromId)}/messages/')
      .doc(message.sent)
      .update({'read': DateTime.now().millisecondsSinceEpoch.toString()});
  }

  /// -- Get only last message of a specific chat.
  static Stream<QuerySnapshot<Map<String, dynamic>>> getLastMessage(UserModel user) {
   return firestore
     .collection('Chats/${getConversationId(user.id)}/messages/')
     .orderBy('sent', descending: true)
     .limit(1)
     .snapshots();
  }

  /// -- Send chat image.
  static Future<void> sendChatImage(UserModel chatUser, File file) async {
    final ext = file.path.split('.').last.toLowerCase();
    final isGif = ext == 'gif';

    final ref = storage.ref().child(
      'images/${getConversationId(chatUser.id)}/${DateTime.now().millisecondsSinceEpoch}.$ext');

    final contentType = isGif ? 'image/gif' : 'image/$ext';

    try {
      final uploadTask = ref.putFile(file, SettableMetadata(contentType: contentType));

      await uploadTask.then((taskSnapshot) async {
        final imageUrl = await ref.getDownloadURL();

        if (isGif) {
          await sendMessage(chatUser, imageUrl, Type.gif);
        } else {
          await sendMessage(chatUser, imageUrl, Type.image);
        }
      });
    } catch (e) {
      log('Error uploading image: $e');
    }
  }

  /// -- Send chat video.
  static Future<void> sendChatVideo(UserModel chatUser, File file) async {
    final ext = file.path.split('.').last.toLowerCase();
    log('Extension: $ext');

    final ref = storage.ref().child(
        'videos/${getConversationId(chatUser.id)}/${DateTime.now().millisecondsSinceEpoch}.$ext');
    final contentType = 'video/$ext';

    await ref.putFile(file, SettableMetadata(contentType: contentType)).then((p0) async {
      log('Data Transferred: ${p0.bytesTransferred / 100000} kb');

      final videoUrl = await ref.getDownloadURL();
      await sendMessage(chatUser, videoUrl, Type.video);
    });
  }

  /// -- Send chat audio.
  static Future<void> sendChatAudio(UserModel chatUser, File file, String fileName) async {
    final ext = file.path.split('.').last.toLowerCase();
    log('Extension: $ext');

    final ref = storage.ref().child(
        'audio/${getConversationId(chatUser.id)}/$fileName');
    final contentType = 'audio/$ext';

    await ref.putFile(file, SettableMetadata(contentType: contentType)).then((p0) async {
      log('Data Transferred: ${p0.bytesTransferred / 100000} kb');

      final audioUrl = await ref.getDownloadURL();
      await sendMessage(chatUser, audioUrl, Type.audio);
    });
  }

  /// -- Send chat document.
  static Future<void> sendChatDocument(UserModel chatUser, File file) async {
    final ext = file.path.split('.').last.toLowerCase();
    log('Extension: $ext');

    final ref = FirebaseStorage.instance.ref().child(
        'documents/${getConversationId(chatUser.id)}/${DateTime.now().millisecondsSinceEpoch}.$ext');

    final contentType = getContentType(ext);
    log('Content Type: $contentType');

    try {
      final uploadTask = ref.putFile(file, SettableMetadata(contentType: contentType));
      await uploadTask.whenComplete(() async {
        final documentUrl = await ref.getDownloadURL();
        log('Document URL: $documentUrl');

        await sendMessage(
          chatUser,
          documentUrl,
          Type.document,
          fileName: file.path.split('/').last,
        );
      });
    } on FirebaseException catch (e) {
      if (e.code == 'object-not-found') {
        log('File not found at the specified reference.');
      } else {
        log('Unknown error occurred.');
      }
    } catch (e) {
      log('An unexpected error occurred: $e');
    }
  }

  /// -- Update message.
  static Future<void> updateMessage(MessageModel message, String updateMsg) async {
    await firestore
      .collection('Chats/${getConversationId(message.toId)}/messages/')
      .doc(message.sent)
      .update({'msg': updateMsg});
  }

  /// -- Delete message.
  static Future<void> deleteMessage(MessageModel message, {bool deleteForEveryone = false}) async {
    final docRef = firestore.collection('Chats/${getConversationId(message.toId)}/messages/').doc(message.sent);

    try {
      log('Deleting message with ID: ${message.sent}, deleteForEveryone: $deleteForEveryone');

      if (deleteForEveryone) {
        await docRef.update({
          'deletedForEveryone': true,
        });
        log('Message marked as deleted for everyone.');
      } else {
        await docRef.update({
          'deletedBy': FieldValue.arrayUnion([APIs.user.uid]),
        });
        log('Message marked as deleted by user: ${APIs.user.uid}');
      }

      if (message.type == Type.image && deleteForEveryone) {
        await storage.refFromURL(message.msg).delete();
        log('Image deleted from storage.');
      }
    } catch (e) {
      log('Error deleting message with ID ${message.sent}: $e');
    }
  }

  /// -- Delete profile photo.
  static Future<void> deleteProfilePhoto(String userId, String imageUrl) async {
    try {
      await storage.refFromURL(imageUrl).delete();

      await FirebaseFirestore.instance.collection('Users').doc(userId).update({
        'image': null,
      });
    } catch (e) {
      log('Error deleting profile photo: $e');
    }
  }

  /// -- Update message reaction.
  static Future<void> updateMessageReaction(MessageModel message, String reaction) async {
    try {
      final messageRef = FirebaseFirestore.instance
        .collection('Chats/${getConversationId(message.toId)}/messages')
        .doc(message.sent);

      await messageRef.update({
        'reaction': reaction,
      });
    } catch (e) {
      debugPrint('Error updating message reaction: $e');
    }
  }

  /// -- Delete chat.
  static Future<void> deleteChat(String chatId) async {
    final messagesCollection = firestore.collection('Chats/$chatId/messages');

    final messagesSnapshot = await messagesCollection.get();

    for (final doc in messagesSnapshot.docs) {
      final message = MessageModel.fromJson(doc.data());
      await deleteMessage(message);
    }

    await firestore.collection('Chats').doc(chatId).delete();
  }

  /// -- Communicate Often Users.
  static Future<List<UserModel>> getCommunicateOftenUsers(UserModel user) async {
    final currentUserId = user.id;
    final snapshot = await FirebaseFirestore.instance
      .collection('Chats/${getConversationId(currentUserId)}/messages/')
      .where('fromId', isEqualTo: currentUserId)
      .get();

    final Map<String, int> messageCount = {};

    for (var doc in snapshot.docs) {
      final toId = doc['toId'];
      messageCount[toId] = (messageCount[toId] ?? 0) + 1;
    }

    final sortedUserIds = messageCount.entries.toList()..sort((a, b) => b.value.compareTo(a.value));

    final topUserIds = sortedUserIds.take(5).map((e) => e.key).toList();

    final users = <UserModel>[];
    for (var userId in topUserIds) {
      final userDoc = await FirebaseFirestore.instance.collection('Users').doc(userId).get();
      if (userDoc.exists) {
        users.add(UserModel.fromDocument(userDoc));
      }
    }
    return users;
  }

  /// -- Audio recordings message.
  static Future<void> audioRecording() async {

  }

  /// -- Adding a user to the archive.
  static Future<void> archiveUser(String userId, UserModel user) async {
    try {
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(userId)
          .collection('my_archived_users')
          .doc(user.id)
          .set({
        'id': user.id,
        'name': user.name,
        'image': user.image,
        'archivedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      log("Error archiving user: $e");
    }
  }

  /// -- // Get all archived users.
  static Future<List<UserModel>> getArchivedUsers(String userId) async {
    try {
      final snapshot = await FirebaseFirestore.instance.collection('Users').doc(userId).collection('my_archived_users').get();

      return snapshot.docs.map((doc) => UserModel.fromJson(doc.data())).toList();
    } catch (e) {
      log("Error getting archived users: $e");
      return [];
    }
  }

  ///******************* Group Screen Related APIs *******************

  /// -- Useful for getting conversation id.
  static String getGroupConversationId(String id) {
    if (user.uid.isEmpty || id.isEmpty) {
      log('Error: user.uid or groupId is empty! user.uid: ${user.uid}, groupId: $id');
    }
    final conversationId = user.uid.hashCode <= id.hashCode ? '${user.uid}_$id' : '${id}_${user.uid}';
    log('Generated conversationId: $conversationId');
    return conversationId;
  }

  /// -- Getting all message of a specific conversation from Firestore Database
  static Stream<QuerySnapshot<Map<String, dynamic>>> getGroupAllMessages(GroupModel group) {
    final conversationId = getGroupConversationId(group.groupId);
    if (conversationId.isEmpty) {
      log('Error: conversationId is empty!');
      return Stream.empty();
    }
    final path = 'Groups/$conversationId/messages/';
    if (path.contains('//')) {
      log('Error: Path contains //: $path');
      return Stream.empty();
    }
    log('Firestore path: $path');
    return firestore.collection(path).orderBy('sent', descending: true).snapshots();
  }

  /// -- Creating new group.
  static Future<bool> createGroup(BuildContext context, GroupModel group, File? imageFile) async {
    try {
      final user = auth.currentUser!;
      final groupId = firestore.collection('Groups').doc().id;
      group.groupId = groupId;
      group.createdAt = DateTime.now();

      group.creatorName = user.displayName ?? 'Неизвестный пользователь';
      group.members = [user.uid];

      await firestore.collection('Groups').doc(groupId).set(group.toMap());

      await firestore
        .collection('Users')
        .doc(user.uid)
        .collection('my_group')
        .doc(groupId)
        .set({'groupId': groupId});

      if (imageFile != null) {
        final imageUrl = await uploadGroupImageToFirebaseStorage(groupId, imageFile);
        if (imageUrl != null) {
          group.groupImage = imageUrl;

          await firestore.collection('Groups').doc(groupId).update({'groupImage': imageUrl});
        } else {
          Dialogs.showSnackbar(context, 'Не удалось загрузить изображение.');
          return false;
        }
      }

      Dialogs.showSnackbar(context, 'Группа успешно создана');
      return true;
    } catch (e) {
      Dialogs.showSnackbar(context, 'Ошибка при создании группы');
      return false;
    }
  }

  /// -- Method to fetch group from Firestore.
  static Future<List<GroupModel>> getGroups() async {
    try {
      final querySnapshot = await firestore.collection('Groups').get();

      return querySnapshot.docs.map((doc) => GroupModel.fromJson(doc.data())).toList();
    } catch (e) {
      log('Error fetching group: $e');
      return [];
    }
  }

  /// -- Method to fetch a single group from Firestore by ID.
  static Future<GroupModel> getGroupById(String groupId) async {
    try {
      final docSnapshot = await firestore.collection('Groups').doc(groupId).get();

      if (docSnapshot.exists && docSnapshot.data() != null) {
        return GroupModel.fromJson(docSnapshot.data()!);
      } else {
        throw Exception('Group with ID $groupId not found');
      }
    } catch (e) {
      log('Error fetching group by ID: $e');
      rethrow;
    }
  }

  /// -- Send group message.
  static Future<void> sendGroupMessage(GroupModel group, String msg, Type type, {String? fileName, String? fileSize, String? imageUrl}) async {
    if (group.groupId.isEmpty) {
      log('Error: groupId is empty!');
      return;
    }

    log('Sending message to group with groupId: ${group.groupId}');

    final time = DateTime.now().millisecondsSinceEpoch.toString();

    final message = MessageModel(
      toId: group.groupId,
      msg: msg,
      read: '',
      type: type,
      fromId: user.uid,
      sent: time,
      documentName: fileName,
      fileSize: fileSize,
      deletedBy: [],
      reaction: '',
      deletedAt: null,
    );

    final ref = firestore.collection('Groups/${group.groupId}/messages/');
    log('Firestore path for messages: ${ref.path}');

    try {
      await ref.doc(time).set(message.toJson()).then((value) => sendGroupPushNotification(group, type == Type.text ? msg : 'image', imageUrl: imageUrl));
      await firestore.collection('Groups').doc(group.groupId).update({
        'lastMessageTimestamp': int.parse(time),
      });
    } catch (e) {
      log('Error sending group message: $e');
    }
  }

  /// -- Getting group message of a specific conversation from Firestore Database.
  static Stream<QuerySnapshot<Map<String, dynamic>>> getGroupMessages(GroupModel group) {
    final conversationId = getGroupConversationId(group.groupId);
    assert(conversationId.isNotEmpty, 'Conversation ID cannot be empty.');
    final path = 'Groups/$conversationId/messages/';
    log('Firestore collection path: $path');
    return firestore.collection(path).orderBy('sent', descending: true).snapshots();
  }

  /// -- Send group image.
  static Future<void> sendGroupImage(GroupModel group, File file) async {
    final ext = file.path.split('.').last.toLowerCase();
    final isGif = ext == 'gif';
    final ref = storage.ref().child('group_images/${group.groupId}/${DateTime.now().millisecondsSinceEpoch}.$ext');
    final contentType = isGif ? 'image/gif' : 'image/$ext';
    final uploadTask = ref.putFile(file, SettableMetadata(contentType: contentType));

    await uploadTask.then((taskSnapshot) async {
      final imageUrl = await ref.getDownloadURL();

      if (isGif) {
        await sendGroupMessage(group, imageUrl, Type.gif);
      } else {
        await sendGroupMessage(group, imageUrl, Type.image);
      }
    });
  }

  /// -- Send group video.
  static Future<void> sendGroupVideo(GroupModel group, List<String> members, File file) async {
    final ext = file.path.split('.').last.toLowerCase();
    log('Extension: $ext');

    final ref = storage.ref().child(
      'videos/${getGroupConversationId(group.groupId)}/${DateTime.now().millisecondsSinceEpoch}.$ext');

    final contentType = 'video/$ext';

    await ref.putFile(file, SettableMetadata(contentType: contentType)).then((p0) async {
      log('Data Transferred: ${p0.bytesTransferred / 100000} kb');

      final videoUrl = await ref.getDownloadURL();
      await sendGroupMessage(group, videoUrl, Type.video);
    });
  }

  /// -- Send chat audio.
  static Future<void> sendGroupAudio(GroupModel group, File file, String fileName) async {
    final ext = file.path.split('.').last.toLowerCase();
    log('Extension: $ext');

    final ref = storage.ref().child(
        'audio/${getConversationId(group.groupId)}/$fileName');
    final contentType = 'audio/$ext';

    await ref.putFile(file, SettableMetadata(contentType: contentType)).then((p0) async {
      log('Data Transferred: ${p0.bytesTransferred / 100000} kb');

      final audioUrl = await ref.getDownloadURL();

      await sendGroupMessage(group, audioUrl, Type.audio);
    });
  }

  /// -- Send group document.
  static Future<void> sendGroupDocument(GroupModel group, List<String> members, File file) async {
    final ext = file.path.split('.').last.toLowerCase();
    log('Extension: $ext');

    final ref = FirebaseStorage.instance.ref().child(
        'documents/${getGroupConversationId(group.groupId)}/${DateTime.now().millisecondsSinceEpoch}.$ext');

    final contentType = getContentType(ext);
    log('Content Type: $contentType');

    try {
      final uploadTask = ref.putFile(file, SettableMetadata(contentType: contentType));
      await uploadTask.whenComplete(() async {
        final documentUrl = await ref.getDownloadURL();
        log('Document URL: $documentUrl');

        await sendGroupMessage(group, documentUrl, Type.document, fileName: file.path.split('/').last,
        );
      });
    } on FirebaseException catch (e) {
      if (e.code == 'object-not-found') {
        log('File not found at the specified reference.');
      } else {
        log('Unknown error occurred.');
      }
    } catch (e) {
      log('An unexpected error occurred: $e');
    }
  }

  /// -- Sending push notification.
  static Future<void> sendGroupPushNotification(GroupModel groupId, String msg, {String? imageUrl}) async {
    final logger = Logger();
    try {
      AccessFirebaseToken accessToken = AccessFirebaseToken();
      String bearerToken = await accessToken.getAccessToken();

      final body = {
        "message": {
          "token": groupId.pushToken,
          "notification": {
            "title": me.name,
            "body": msg,
            "image": imageUrl,
          },
          "data": {
            "click_action": "FLUTTER_NOTIFICATION_CLICK",
            "image": imageUrl,
          },
        },
      };

      var res = await post(
        Uri.parse('https://fcm.googleapis.com/v1/projects/chatify-6fdfb/messages:send'),
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'Bearer $bearerToken',
        },
        body: jsonEncode(body),
      );

      logger.d("Response statusCode: ${res.statusCode}");
      logger.d("Response body: ${res.body}");

      if (res.statusCode != 200) {
        throw Exception('Failed to send push notification');
      }
    } catch (e) {
      logger.d("\nsendPushNotification: $e");
    }
  }

  /// -- Method to upload an image to Firebase Storage.
  static Future<String?> uploadGroupImageToFirebaseStorage(String groupId, File file) async {
    try {
      final ext = file.path.split('.').last;
      log('Uploading file: ${file.path}, extension: $ext');

      final ref = FirebaseStorage.instance.ref().child('group_pictures/$groupId.$ext');
      await ref.putFile(file, SettableMetadata(contentType: 'image/$ext'));

      final downloadURL = await ref.getDownloadURL();
      log('Image uploaded successfully. URL: $downloadURL');
      return downloadURL;
    } catch (e, stackTrace) {
      log('Error uploading image to Firebase Storage: $e');
      log('StackTrace: $stackTrace');
      return null;
    }
  }

  /// -- Update group picture.
  static Future<void> updateGroupPicture(String groupId, File file) async {
    final ext = file.path.split('.').last;
    log('Extension: $ext');

    final ref = storage.ref().child('group_pictures/$groupId.$ext');

    await ref
      .putFile(file, SettableMetadata(contentType: 'image/$ext'))
      .then((p0) {
      log('Data Transferred: ${p0.bytesTransferred / 1000} kb');
    });

    String downloadURL = await ref.getDownloadURL();
    await firestore
      .collection('Groups')
      .doc(groupId)
      .update({'image': downloadURL});
  }

  /// -- Delete group picture.
  static Future<void> deleteGroupPicture(String groupId, String imageUrl) async {
    try {
      await storage.refFromURL(imageUrl).delete();

      await FirebaseFirestore.instance.collection('Groups').doc(groupId).update({
        'image': null,
      });
    } catch (e) {
      log('Error deleting group picture: $e');
    }
  }

  ///******************* Community Screen Related APIs *******************

  /// -- Creating new community.
  static Future<bool> createCommunity(BuildContext context, CommunityModel community, File? imageFile) async {
    try {
      final user = auth.currentUser!;
      final communityId = firestore.collection('Communities').doc().id;
      community.id = communityId;
      community.createdAt = DateTime.now();

      if (imageFile != null) {
        final imageUrl = await uploadCommunityImageToFirebaseStorage(communityId, imageFile);
        if (imageUrl != null) {
          community.image = imageUrl;
        } else {
          Dialogs.showSnackbar(context, 'Failed to upload image.');
          return false;
        }
      }

      await firestore.collection('Communities').doc(communityId).set(community.toMap());

      await firestore
        .collection('Users')
        .doc(user.uid)
        .collection('my_community')
        .doc(communityId)
        .set({'communityId': communityId});

      Dialogs.showSnackbar(context, S.of(context).communityCreatedSuccessfully);
      return true;
    } catch (e) {
      Dialogs.showSnackbar(context, S.of(context).communityCreationFailed);
      return false;
    }
  }

  /// -- Method to upload an image to Firebase Storage.
  static Future<String?> uploadCommunityImageToFirebaseStorage(String communityId, File file) async {
    try {
      final ext = file.path.split('.').last;
      final ref = storage.ref().child('community_pictures/$communityId.$ext');
      await ref.putFile(file, SettableMetadata(contentType: 'image/$ext'));
      return await ref.getDownloadURL();
    } catch (e) {
      log('Error uploading image to Firebase Storage: $e');
      return null;
    }
  }

  /// -- Method to fetch community from Firestore.
  static Future<List<CommunityModel>> getCommunity() async {
    try {
      final querySnapshot = await firestore.collection('Communities').get();
      final communities = querySnapshot.docs.map((doc) => CommunityModel.fromJson(doc.data())).toList();

      return communities;
    } catch (e) {
      log('Error fetching community: $e');
      return [];
    }
  }

  /// -- Update community informations.
  static Future<void> updateCommunityInfo(String communityId, File file) async {
    final ext = file.path.split('.').last;
    log('Extension: $ext');

    final ref = storage.ref().child('community_pictures/$communityId.$ext');

    await ref
      .putFile(file, SettableMetadata(contentType: 'image/$ext'))
      .then((p0) {
      log('Data Transferred: ${p0.bytesTransferred / 1000} kb');
    });

    String downloadURL = await ref.getDownloadURL();
    await firestore
      .collection('Communities')
      .doc(communityId)
      .update({'image': downloadURL});
  }

  /// -- Update community picture.
  static Future<void> updateCommunityPicture(String communityId, File file) async {
    final ext = file.path.split('.').last;
    log('Extension: $ext');

    final ref = storage.ref().child('community_pictures/$communityId.$ext');

    await ref.putFile(file, SettableMetadata(contentType: 'image/$ext')).then((p0) {
      log('Data Transferred: ${p0.bytesTransferred / 1000} kb');
    });

    String downloadURL = await ref.getDownloadURL();
    await firestore.collection('Communities').doc(communityId).update({'image': downloadURL});
  }

  /// -- Delete community picture.
  static Future<void> deleteCommunityPicture(String communityId, String imageUrl) async {
    try {
      await storage.refFromURL(imageUrl).delete();

      await FirebaseFirestore.instance.collection('Communities').doc(communityId).update({
        'image': null,
      });
    } catch (e) {
      log('Error deleting community picture: $e');
    }
  }

  /// -- Send message community chat.
  static Future<void> sendMessageCommunityChat({required String communityId, required String chatId, required String text}) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null || text.trim().isEmpty) return;

    final messageRef = FirebaseFirestore.instance
      .collection('Communities')
      .doc(communityId)
      .collection('Chats')
      .doc(chatId)
      .collection('messages')
      .doc();

    final messageData = {
      'id': messageRef.id,
      'text': text,
      'senderId': currentUser.uid,
      'timestamp': FieldValue.serverTimestamp(),
      'type': 'text',
    };

    try {
      await messageRef.set(messageData);
    } catch (e) {
      log('Ошибка при отправке сообщения: $e');
    }
  }

  ///******************* Newsletter Screen Related APIs *******************

  /// -- Creating new newsletter.
  static Future<bool> createNewsletter(BuildContext context, NewsletterModel newsletter) async {
    try {
      final user = auth.currentUser!;
      final newsletterId = firestore.collection('Newsletters').doc().id;
      newsletter.id = newsletterId;
      newsletter.createdAt = DateTime.now().millisecondsSinceEpoch.toString();

      await firestore.collection('Newsletters').doc(newsletterId).set(newsletter.toMap());

      await firestore
        .collection('Users')
        .doc(user.uid)
        .collection('my_newsletter')
        .doc(newsletterId)
        .set({'newsletterId': newsletterId});

      Dialogs.showSnackbar(context, 'Рассылка успешно создана');
      return true;
    } catch (e) {
      Dialogs.showSnackbar(context, 'Ошибка при создании рассылки');
      return false;
    }
  }

  /// -- Method to fetch newsletter from Firestore.
  static Future<List<NewsletterModel>> getNewsletter() async {
    try {
      final querySnapshot = await firestore.collection('Newsletters').get();

      return querySnapshot.docs.map((doc) => NewsletterModel.fromDocument(doc)).toList();
    } catch (e) {
      log('Error fetching newsletter: $e');
      return [];
    }
  }

  /// -- Update newsletter picture.
  static Future<void> updateNewsletterPicture(String newsletterId, File file) async {
    final ext = file.path.split('.').last;
    log('Extension: $ext');

    final ref = storage.ref().child('newsletter_pictures/$newsletterId.$ext');

    await ref
        .putFile(file, SettableMetadata(contentType: 'image/$ext'))
        .then((p0) {
      log('Data Transferred: ${p0.bytesTransferred / 1000} kb');
    });

    String downloadURL = await ref.getDownloadURL();
    await firestore.collection('Newsletters').doc(newsletterId).update({'image': downloadURL});
  }

  /// -- Delete newsletter picture.
  static Future<void> deleteNewsletterPicture(String newsletterId, String imageUrl) async {
    try {
      await storage.refFromURL(imageUrl).delete();

      await FirebaseFirestore.instance.collection('Newsletters').doc(newsletterId).update({
        'image': null,
      });
    } catch (e) {
      log('Error deleting newsletter picture: $e');
    }
  }

  /// -- Send message newsletter chat.
  static Future<void> sendMessageNewsletterChat({required String newsletterId, required String chatId, required String text}) async {

  }

  ///******************* Sounds app APIs *******************

  /// --- Play send sound.
  static Future<void> playSendSound() async {
    final AudioPlayer audioPlayer = AudioPlayer();

    try {
      await audioPlayer.play(AssetSource(ChatifySounds.sendMessage));
      log('Playing sound: ${ChatifySounds.sendMessage}');
    } catch (e) {
      log('Error playing sound: $e');
    }
  }

  ///******************* Support APIs *******************

  /// --- Create new support chat.
  static Future<void> createSupportChat(String userId) async {
    final supportChatRef = FirebaseFirestore.instance.collection('SupportChats');

    final existingChats = await supportChatRef
        .where('userId', isEqualTo: userId)
        .limit(1)
        .get();

    if (existingChats.docs.isNotEmpty) {
      return;
    }

    final newChatRef = supportChatRef.doc();

    await newChatRef.set({
      'id': newChatRef.id,
      'userId': userId,
      'name': 'Chatify',
      'surname': 'Support',
      'description': 'Поддержка пользователей Chatify',
      'phoneNumber': '+7 (999) 194-0398',
      'createdAt': FieldValue.serverTimestamp(),
      'lastMessage': 'Здравствуйте!👋 Благодарим вас за обращение...',
      'isAiHandled': true,
      'status': 'open',
      'isResolved': false,
    });

    await newChatRef.collection('messages').add({
      'fromId': 'support_bot',
      'toId': userId,
      'message': 'Здравствуйте!👋 Благодарим вас за обращение в Службу поддержки Chatify. Чем мы можем помочь?',
      'timestamp': FieldValue.serverTimestamp(),
      'type': 'text',
    });
  }

  /// -- Method to fetch support from Firestore.
  static Future<List<SupportAppModel>> getSupportChat() async {
    try {
      final querySnapshot = await firestore.collection('SupportChats').get();

      final supports = querySnapshot.docs.map((doc) {
        log('Support from Firestore: ${doc.data()}');
        return SupportAppModel.fromMap(doc.data());
      }).toList();

      return supports;
    } catch (e) {
      log('Error fetching support chat: $e');
      return [];
    }
  }

  /// -- Send message support chat.
  static Future<void> sendMessageSupportChat({required String supportId, required String chatId, required String text}) async {

  }
}
