import 'dart:developer';
import 'dart:io';
import 'package:chatify/routes/observers.dart';
import 'package:chatify/utils/constants/app_colors.dart';
import 'package:chatify/utils/devices/device_utility.dart';
import 'package:flutter/foundation.dart';
import 'package:chatify/provider/wallpaper_provider.dart';
import 'package:chatify/routes/app_routes.dart';
import 'package:chatify/utils/local_storage/storage_utility.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'api/apis.dart';
import 'bindings/general_bindings.dart';
import 'config.dart';
import 'features/personalization/controllers/language_controller.dart';
import 'features/personalization/controllers/themes_controller.dart';
import 'features/splash_screen/screens/main_window_screen.dart';
import 'features/utils/windows/window_util_desktop.dart';
import 'firebase_options.dart';
import 'package:chatify/utils/theme/theme.dart';
import 'generated/l10n/l10n.dart';

bool get isWindows => !kIsWeb && Platform.isWindows;
bool get isDesktop => !kIsWeb && (Platform.isWindows || Platform.isMacOS || Platform.isLinux);

/// -- Initialize application dependencies and services
Future<void> initApp() async {
  /// -- Widget Binding
  WidgetsFlutterBinding.ensureInitialized();

  /// -- System Ui mode
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  /// -- GetX Local Storage
  await GetStorage.init();

  /// -- Initialize LocalStorage
  await ChatifyLocalStorage.init('chatify_bucket');

  /// -- Set setting orientation to portrait only
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  /// -- Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform).then(
    (FirebaseApp value) {}
  );

  /// -- Activate Firebase App Check
  if (!kIsWeb && defaultTargetPlatform != TargetPlatform.windows) {
    await FirebaseAppCheck.instance.activate(
      webProvider: ReCaptchaV3Provider(Config.recaptchaV3Key),
    );
  }

  /// -- Initialize bindings here to ensure they're ready
  GeneralBindings().dependencies();

  /// -- Set system UI status bar color globally
  DeviceUtils.setStatusBarColor(ChatifyColors.transparent);

  /// -- Initialize user data
  try {
    await APIs.getSelfInfo();
  } catch (e) {
    log('Error initializing user data: $e');
  }

  /// -- Create app directories
  await APIs.createDirectories();

  /// -- Size window app
  setupWindow();

  String timestamp = "1723669526894";
  DateTime date = DateTime.fromMillisecondsSinceEpoch(int.parse(timestamp));
  String formattedDate = DateFormat('MMMM d, yyyy ' 'at h:mm:ss a').format(date);
  String finalFormattedDate = '$formattedDate UTC+4';
  log(finalFormattedDate);
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final LanguageController languageController = Get.find<LanguageController>();
    final ThemesController themesController = Get.find<ThemesController>();
    final backButtonNotifier = ValueNotifier<bool>(false);
    final currentRouteNotifier = ValueNotifier<String?>(null);
    final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => WallpaperProvider()),
      ],
      child: Obx(() {
        return GetMaterialApp(
          initialBinding: GeneralBindings(),
          debugShowCheckedModeBanner: false,
          themeMode: themesController.getThemeMode(),
          theme: ChatifyAppTheme.getLightTheme(),
          darkTheme: ChatifyAppTheme.getDarkTheme(),
          getPages: AppRoutes.pages,
          locale: Locale(languageController.selectedLanguage.value),
          localizationsDelegates: const [
            AppLocalizationDelegate(),
            ...GlobalMaterialLocalizations.delegates,
          ],
          supportedLocales: const [
            Locale('ru'),
            Locale('en'),
            Locale('es'),
          ],
          initialRoute: '/splash',
          navigatorKey: navigatorKey,
          navigatorObservers: [
            RouteNotifierObserver(currentRouteNotifier),
            BackButtonObserver(backButtonNotifier)
          ],
          builder: (context, child) {
            if (kIsWeb) {
              return child ?? Container();
            }
            else if (Platform.isWindows) {
              return MainWindow(
                backButtonNotifier: backButtonNotifier,
                currentRouteNotifier: currentRouteNotifier,
                child: child ?? Container(),
              );
            } else {
              return child ?? Container();
            }
          },
        );
      }),
    );
  }
}
