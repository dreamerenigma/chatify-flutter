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
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '../api/apis.dart';
import '../bindings/general_bindings.dart';
import '../config/config.dart';
import '../features/personalization/controllers/language_controller.dart';
import '../features/personalization/controllers/themes_controller.dart';
import '../features/splash/screens/main_window_screen.dart';
import '../features/utils/windows/window_util_desktop.dart';
import 'package:chatify/utils/theme/theme.dart';
import '../generated/l10n/l10n.dart';
import '../routes/routes.dart';

Future<void> initApp() async {
  /// -- Widget Binding
  WidgetsFlutterBinding.ensureInitialized();

  /// -- System Ui mode
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  /// -- Initialize LocalStorage
  await ChatifyLocalStorage.init('chatify_bucket');

  /// -- Initialize bindings here to ensure they're ready
  GeneralBindings().dependencies();

  /// -- Set setting orientation to portrait only
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  /// -- Activate Firebase App Check
  if (!kIsWeb && defaultTargetPlatform != TargetPlatform.windows) {
    await FirebaseAppCheck.instance.activate(providerWeb: ReCaptchaV3Provider(Config.recaptchaV3Key));
  }

  /// -- System Ui mode
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);

  /// -- Set system UI status bar color globally
  DeviceUtils.setStatusBarColor(ChatifyColors.transparent);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(statusBarColor: ChatifyColors.transparent, statusBarIconBrightness: Brightness.light));

  /// -- Set setting orientation to portrait only
  DeviceUtils.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

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
}

class App extends StatelessWidget {
  const App({super.key});

  static final ValueNotifier<bool> backButtonNotifier = ValueNotifier<bool>(false);
  static final ValueNotifier<String?> currentRouteNotifier = ValueNotifier<String?>(null);
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    final LanguagesController languagesController = Get.find<LanguagesController>();
    final ThemesController themesController = Get.find<ThemesController>();

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
          locale: Locale(languagesController.selectedLanguage.value),
          localizationsDelegates: const [AppLocalizationDelegate(), ...GlobalMaterialLocalizations.delegates, GlobalWidgetsLocalizations.delegate],
          supportedLocales: const [Locale('ru'), Locale('en'), Locale('es')],
          initialRoute: ChatifyRoutes.splash,
          navigatorKey: navigatorKey,
          navigatorObservers: [RouteNotifierObserver(currentRouteNotifier), BackButtonObserver(backButtonNotifier)],
          builder: (context, child) {
            if (kIsWeb) {
              return child ?? Container();
            }
            else if (Platform.isWindows) {
              return MainWindow(backButtonNotifier: backButtonNotifier, currentRouteNotifier: currentRouteNotifier, child: child ?? Container());
            } else {
              return child ?? Container();
            }
          },
        );
      }),
    );
  }
}
