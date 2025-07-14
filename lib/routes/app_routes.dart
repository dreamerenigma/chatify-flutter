import 'package:chatify/features/authentication/screens/add_account_screen.dart';
import 'package:chatify/features/authentication/screens/login_screen.dart';
import 'package:chatify/features/community/screens/community_screen.dart';
import 'package:chatify/features/group/screens/new_group_screen.dart';
import 'package:chatify/features/splash_screen/screens/splash_screen.dart';
import 'package:chatify/features/status/screens/status_screen.dart';
import 'package:chatify/routes/routes.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart';
import '../api/apis.dart';
import '../features/calls/screens/calls_screen.dart';
import '../features/home/screens/home_screen.dart';
import '../features/home/screens/new_newsletter_screen.dart';
import '../features/personalization/screens/account/account_screen.dart';
import '../features/personalization/screens/chats/chats_screen.dart';
import '../features/personalization/screens/favorite/favorite_message_screen.dart';
import '../features/personalization/screens/help/support/screens/support_screen.dart';
import '../features/personalization/screens/send/send_file_screen.dart';

class AppRoutes {
  static final pages = [
    GetPage(name: ChatifyRoutes.splash, page: () => const SplashScreen(), transition: Transition.fade,),
    GetPage(name: ChatifyRoutes.signIn, page: () => const LoginScreen()),
    GetPage(name: ChatifyRoutes.home, page: () => HomeScreen(user: APIs.me)),
    GetPage(name: ChatifyRoutes.addAccount, page: () => AddAccountScreen(isFromSplashScreen: true)),
    GetPage(name: ChatifyRoutes.support, page: () => SupportScreen()),
    GetPage(name: ChatifyRoutes.calls, page: () => CallsScreen(user: APIs.me)),
    GetPage(name: ChatifyRoutes.chat, page: () => const ChatsScreen()),
    GetPage(name: ChatifyRoutes.community, page: () => CommunityScreen(user: APIs.me)),
    GetPage(name: ChatifyRoutes.status, page: () => StatusScreen(user: APIs.me)),
    GetPage(name: ChatifyRoutes.newGroup, page: () => const NewGroupScreen()),
    GetPage(name: ChatifyRoutes.newNewsletter, page: () => const NewNewsletterScreen(selectedUsers: [])),
    GetPage(name: ChatifyRoutes.favorite, page: () => const FavoriteMessageScreen()),
    GetPage(name: ChatifyRoutes.account, page: () => AccountScreen(user: APIs.me)),
    GetPage(name: ChatifyRoutes.sendFile, page: () => const SendFileScreen(fileToSend: '', linkToSend: '')),
  ];
}
