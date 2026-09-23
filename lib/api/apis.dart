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
import '../config/config.dart';
import '../core/enums/message_type.dart';
import '../core/services/media/media_service.dart';
import '../features/authentication/screens/add_account_screen.dart';
import '../features/authentication/widgets/dialogs/consent_dialog.dart';
import '../features/bot/models/info_app_model.dart';
import '../features/chat/models/user_model.dart';
import '../features/chat/models/user_status_model.dart';
import '../features/community/models/community_model.dart';
import '../features/home/screens/home_screen.dart';
import '../generated/l10n/l10n.dart';
import '../routes/custom_page_route.dart';
import '../utils/constants/app_links.dart';
import '../utils/constants/app_sounds.dart';
import '../utils/urls/url_utils.dart';
import 'access_firebase_token.dart';
import 'chat_api.dart';

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

  /// -- Accessing media service.
  static MediaService get mediaService => Get.find<MediaService>();

  /// -- .
  static Future<String?> getMediaUrl(String path) async {
    final mediaPath = path.trim();

    if (mediaPath.isEmpty) {
      return null;
    }

    return await mediaService.getUrl(mediaPath);
  }

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
            "image": ?imageUrl,
          },
          "data": {
            "click_action": "FLUTTER_NOTIFICATION_CLICK",
            "image": ?imageUrl,
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

      await firestore.collection('Users').doc(user.uid).collection('my_users').doc(data.docs.first.id).set({'archived': false}, SetOptions(merge: true));

      return true;
    } else {

      return false;
    }
  }

  /// -- Archive / unarchive a chat user.
  static Future<void> setChatArchived({required String userId, required bool archived}) async {
    await firestore.collection('Users').doc(user.uid).collection('my_users').doc(userId).set({'archived': archived}, SetOptions(merge: true));
  }

  /// -- Pin / unpin a chat user.
  static Future<void> setChatPinned({required String userId, required bool pinned}) async {
    await firestore.collection('Users').doc(user.uid).collection('my_users').doc(userId).set({'pinned': pinned}, SetOptions(merge: true));
  }

  /// -- Muted / unmuted a chat user.
  static Future<void> setChatMuted({required String userId, required bool muted, int duration = 0}) async {
    final mutedUntil = muted && duration > 0 ? Timestamp.fromDate(DateTime.now().add(Duration(hours: duration))) : null;

    await firestore.collection('Users').doc(user.uid).collection('my_users').doc(userId).set({'muted': muted, 'mutedDuration': muted ? duration : 0, 'mutedUntil': mutedUntil}, SetOptions(merge: true));
  }

  /// -- .
  static Future<int> getChatMutedDuration(String userId) async {
    final snapshot = await firestore.collection('Users').doc(user.uid).collection('my_users').doc(userId).get();
    final data = snapshot.data();

    return data?['mutedDuration'] as int? ?? 8;
  }

  /// -- Getting current user info.
  static Future<void> getSelfInfo() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      log("No user is logged in");
      return;
    }

    try {
      final userDoc = await firestore.collection('Users').doc(user.uid).get();

      if (userDoc.exists) {
        final data = userDoc.data();
        if (data != null) {
          me = UserModel.fromJson(data);
          await getFirebaseMessagingToken();
        } else {
          log("User data is null in Firestore");
        }
      } else {
        log("User data not found in Firestore");
      }
    } catch (e) {
      log("Error getting user info: $e");
    }
  }

  /// Returns the user by ID or null if not found.
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
    final now = DateTime.now();

    return UserModel(
      id: userData['id'] ?? '',
      name: userData['name'] ?? 'Неизвестный пользователь',
      surname: userData['surname'] ?? 'Неизвестный пользователь',
      username: userData['username'] ?? '',
      email: userData['email'] ?? '',
      phoneNumber: userData['phoneNumber'] ?? '',
      about: userData['about'] ?? 'Привет я использую Chatify!',
      status: userData['status'] ?? 'Онлайн',
      image: userData['image'] ?? '',
      createdAt: userData['createdAt'] ?? now,
      lastActive: userData['lastActive'] ?? now,
      isOnline: userData['isOnline'] ?? false,
      pushToken: userData['pushToken'] ?? '',
      isTyping: userData['isTyping'] ?? false,
      role: userData['role'] ?? 'User',
    );
  }

  /// -- Creating new user.
  static Future<void> createUserInFirestore(BuildContext context) async {
    final time = DateTime.now();
    final parts = user.displayName?.split(' ') ?? [''];
    final name = parts.isNotEmpty ? parts.first : '';
    final surname = parts.length > 1 ? parts.sublist(1).join(' ') : '';
    final username = parts.length > 1 ? parts.sublist(1).join(' ') : '';

    final chatUser = UserModel(
      id: user.uid,
      name: name,
      surname: surname,
      username: username,
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
      role: 'User',
    );

    return await firestore.collection('Users').doc(user.uid).set(chatUser.toJson());
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
    return firestore.collection('Users').doc(user.uid).collection('my_users').snapshots();
  }

  /// -- Getting all users from Firestore.
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUsers(List<String> userIds) {
    if (userIds.isEmpty) {
      return const Stream<QuerySnapshot<Map<String, dynamic>>>.empty();
    } else {
      return firestore.collection('Users').where('id', whereIn: userIds).snapshots();
    }
  }

  /// -- Adding an user to my user when first message in send.
  static Future<void> sendFirstMessage(UserModel chatUser, String msg, MessageType type) async {
    await firestore.collection('Users').doc(chatUser.id).collection('my_users').doc(user.uid).set({}, SetOptions(merge: true));
    await ChatApi.sendMessage(chatUser, msg, type);
  }

  /// -- Updating user info.
  static Future<void> updateUserInfo() async {
    await firestore.collection('Users').doc(user.uid).update({'name' : me.name, 'about' : me.about, 'status' : me.status, 'phone_number' : me.phoneNumber});
  }

  /// -- Load User Data From Firestore.
  static Future<UserModel?> loadUserDataFromFirestore() async {
    try {
      final firebaseUser = FirebaseAuth.instance.currentUser;

      if (firebaseUser == null) {
        return null;
      }

      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance.collection('Users').doc(firebaseUser.uid).get();

      if (userSnapshot.exists) {
        final userData = userSnapshot.data() as Map<String, dynamic>;

        return UserModel.fromJson(userData);
      } else {
        return null;
      }
    } catch (e) {
      log("Error loading user data from Firestore: $e");
      return null;
    }
  }

  /// -- Upload profile picture to Yandex Disk through backend.
  static Future<String?> uploadProfilePicture(File file) async {
    final requestId = DateTime.now().microsecondsSinceEpoch;

    log('PROFILE UPLOAD [$requestId]: started');

    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        throw Exception('User is not logged in');
      }

      log('PROFILE UPLOAD [$requestId]: file = ${file.path}');

      final ext = file.path.split('.').last.toLowerCase();
      final path = 'users/${user.uid}/profile_picture/profile.$ext';

      log('PROFILE UPLOAD [$requestId]: path = $path');

      final imagePath = await mediaService.uploadFile(file: file, path: path);

      log('PROFILE UPLOAD [$requestId]: result = $imagePath');

      return imagePath;
    } catch (e, stackTrace) {
      log('PROFILE UPLOAD [$requestId]: ERROR = $e', stackTrace: stackTrace);

      return null;
    }
  }

  /// -- Update profile picture of user.
  static Future<bool> updateProfilePicture(File file) async {
    try {
      log('UPDATE PROFILE: started');

      final imagePath = await uploadProfilePicture(file);

      log('UPDATE PROFILE: imagePath = $imagePath');

      if (imagePath == null || imagePath.isEmpty){
        log('UPDATE PROFILE: upload failed');
        return false;
      }

      me.image = imagePath;

      log('UPDATE PROFILE: updating Firestore...');
      log('UPDATE PROFILE: image = ${me.image}');

      await firestore.collection('Users').doc(user.uid).update({
        'image': me.image,
      });

      log('UPDATE PROFILE: Firestore updated');

      return true;
    } catch (e, stackTrace) {
      log('UPDATE PROFILE ERROR: $e');
      log('UPDATE PROFILE STACK: $stackTrace');

      return false;
    }
  }

  /// -- Getting specific user info.
  static Stream<DocumentSnapshot<Map<String, dynamic>>> getUserInfo(UserModel chatUser) {
    return firestore.collection('Users').doc(chatUser.id).snapshots();
  }

  /// -- Update online or last active status of user.
  static Future<void> updateActiveStatus(bool isOnline) async {
    try {
      await firestore.collection('Users').doc(user.uid).update({'is_online': isOnline, 'last_active': Timestamp.now(), 'push_token': me.pushToken});
    } catch (e) {
      log('PRESENCE ERROR → ${user.uid} | $e');
    }
  }

  /// -- Method to update current user's typing status.
  static Future<void> updateTypingStatus(bool isTyping) async {
    await firestore.collection('Users').doc(user.uid).update({'is_typing': isTyping});
  }

  /// -- Google Sign In (Android, iOS).
  static Future<UserCredential?> signInWithGoogle() async {
    try {
      final connected = kIsWeb ? true : await _hasInternetConnection();
      if (!connected) {
        throw Exception('Нет подключения к интернету');
      }

      final GoogleSignIn googleSignIn = GoogleSignIn.instance;

      await googleSignIn.initialize(clientId: Config.googleClientId);
      await googleSignIn.signOut();

      final GoogleSignInAccount googleUser = await googleSignIn.authenticate();
      final GoogleSignInAuthentication googleAuth = googleUser.authentication;
      final credential = GoogleAuthProvider.credential(idToken: googleAuth.idToken);
      final userCredential = await APIs.auth.signInWithCredential(credential);

      final userId = userCredential.user?.uid;
      if (userId != null) {
        await createInfoChat(userId);
      }

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

  /// -- Email Sign In.
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
      var clientId = auths.ClientId(Config.googleClientId, Config.googleClientSecret);
      var scopes = ['email'];
      var client = await auths.clientViaUserConsent(clientId, scopes, (url) => showConsentDialog(context, url));
      var googleAuth = client.credentials;

      String? accessToken = googleAuth.accessToken.data;
      String? idToken = googleAuth.idToken;

      if (idToken == null) {
        throw Exception("Failed to obtain tokens from Google Auth.");
      }

      final OAuthCredential credential = GoogleAuthProvider.credential(accessToken: accessToken, idToken: idToken);

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

      String authorizationUrl = AppLinks.googleAuthUrl;
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
  static Future<void> addStatus({required String mediaPath, required String type}) async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser == null) {
        log('Пользователь не авторизован.');
        return;
      }

      final userId = currentUser.uid;
      final doc = FirebaseFirestore.instance.collection('Users').doc(userId).collection('my_statuses').doc();
      final now = DateTime.now();
      final status = UserStatusModel(id: doc.id, mediaPath: mediaPath, type: type, createdAt: now, expiresAt: now.add(const Duration(hours: 24)));

      await doc.set(status.toMap());

      log('Статус успешно добавлен: ''Users/$userId/my_statuses/${doc.id}');
    } catch (e) {
      log('Ошибка при добавлении статуса: $e');
      rethrow;
    }
  }

  /// -- Get user status.
  static Future<UserStatusModel?> getUserStatus(String userId) async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('Users')
          .doc(userId)
          .collection('my_statuses')
          .where('expires_at', isGreaterThan: Timestamp.now()).orderBy('expires_at').limit(1).get();

      if (snapshot.docs.isEmpty) {
        return null;
      }

      return UserStatusModel.fromDocument(snapshot.docs.first);
    } catch (e) {
      log('Ошибка получения статуса пользователя: $e');
      return null;
    }
  }

  /// -- Upload status image to Yandex Disk through backend.
  static Future<String?> uploadStatusImage(File file) async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        throw Exception('User is not logged in');
      }

      final ext = file.path.split('.').last.toLowerCase();
      final path = 'users/${user.uid}/my_statuses/''${DateTime.now().millisecondsSinceEpoch}.$ext';
      final imagePath = await mediaService.uploadFile(file: file, path: path);

      if (imagePath == null) {
        log('Failed to upload status image: $path');
        return null;
      }

      log('Status image uploaded: $imagePath');

      return imagePath;
    } catch (e) {
      log('Error uploading status image: $e');
      return null;
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
        QuerySnapshot userChats = await firestore.collection('Chats').where('participants', arrayContains: user.uid).get();

        for (QueryDocumentSnapshot chat in userChats.docs) {
          await chat.reference.delete();
          log('Deleted chat: ${chat.id}');
        }

        DocumentReference userDocRef = firestore.collection('Users').doc(user.uid);
        await userDocRef.delete();
        log('Deleted user document: ${user.uid}');

        await GoogleSignIn.instance.signOut();
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

  /// -- Checks for an active internet connection.
  static Future<bool> _hasInternetConnection() async {
    if (kIsWeb) return true;

    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  /// -- Checks the contact list and returns those registered in Firestore.
  static Future<List<Map<String, dynamic>>> getRegisteredUsers(List<Map<String, dynamic>> contacts) async {
    final firestore = FirebaseFirestore.instance;

    List<Map<String, dynamic>> registeredUsers = [];

    for (var contact in contacts) {
      String formattedPhone = contact['phone_number'];
      var querySnapshot = await firestore.collection('Users').where('phone_number', isEqualTo: formattedPhone).get();

      if (querySnapshot.docs.isNotEmpty) {
        registeredUsers.add({'contact': contact['contact'], 'user': querySnapshot.docs.first.data()});
      }
    }

    return registeredUsers;
  }

  /// -- .
  static Future<bool> updateUsername(String username) async {
    try {
      final normalizedUsername = username.trim().toLowerCase();

      if (normalizedUsername.isEmpty) {
        return false;
      }

      await firestore.collection('Users').doc(user.uid).update({'username': normalizedUsername});

      me.username = normalizedUsername;

      return true;
    } catch (e) {
      log('UPDATE USERNAME: error = $e');
      return false;
    }
  }

  ///******************* Support APIs *******************
  /// --- Create new support chat.
  static Future<void> createSupportChat(String userId) async {
    final supportChatRef = FirebaseFirestore.instance.collection('SupportChats');
    final existingChats = await supportChatRef.where('userId', isEqualTo: userId).limit(1).get();

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

  /// -- Method to fetch support chat from Firestore.
  static Future<List<SupportAppModel>> getSupportChat() async {
    try {
      final uid = APIs.me.id;

      if (uid.isEmpty) {
        return [];
      }

      final querySnapshot = await firestore.collection('SupportChats').where('userId', isEqualTo: uid).get();

      final supports = querySnapshot.docs.map((doc) {
        return SupportAppModel.fromMap(doc.data());
      }).toList();

      return supports;
    } catch (e) {
      log('Error fetching support chat: $e');
      return [];
    }
  }

  /// -- Send message support chat.
  static Future<void> sendMessageSupportChat({required String supportId, required String chatId, required String text}) async {}

  ///******************* Infos App APIs *******************
  /// --- Create new info chat.
  static Future<void> createInfoChat(String userId) async {
    final infoChatRef = FirebaseFirestore.instance.collection('InfoChats');
    final existingChats = await infoChatRef.where('userId', isEqualTo: userId).limit(1).get();

    if (existingChats.docs.isNotEmpty) {
      return;
    }

    final newChatRef = infoChatRef.doc();

    await newChatRef.set({
      'id': newChatRef.id,
      'userId': userId,
      'name': 'Chatify',
      'description': 'Официальный аккаунт Chatify',
      'createdAt': FieldValue.serverTimestamp(),
      'lastMessage': 'Здравствуйте!👋 Благодарим вас за обращение...',
      'isAiHandled': true,
      'status': 'open',
      'isResolved': false,
    });
  }

  /// -- Method to fetch info from Firestore.
  static Future<List<InfoAppModel>> getInfoChat() async {
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;

      if (userId == null) {
        return [];
      }

      final querySnapshot = await firestore.collection('InfoChats').where('userId', isEqualTo: userId).limit(1).get();
      final infos = querySnapshot.docs.map((doc) {
        return InfoAppModel.fromMap(doc.data());
      }).toList();

      return infos;
    } catch (e) {
      log('Error fetching info chat: $e');
      return [];
    }
  }

  ///******************* Sounds app APIs *******************
  /// --- Play send sound
  static Future<void> playSendSound() async {
    final AudioPlayer audioPlayer = AudioPlayer();

    try {
      await audioPlayer.play(AssetSource(ChatifySounds.sendMessage));
      log('Playing sound: ${ChatifySounds.sendMessage}');
    } catch (e) {
      log('Error playing sound: $e');
    }
  }
}
