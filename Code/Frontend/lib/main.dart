import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/screens/common_screens/authentication_screens/welcome_screen.dart';
import 'package:easy_splash/easy_splash.dart';
import './screens/common_screens/onboarding_page.dart';
import 'package:flutter_application_1/generated/l10n.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import'package:flutter_application_1/screens/teacher_screens/home_screen.dart';
import 'package:flutter_application_1/services/shared_preferences_service.dart';
import 'components/widgets/navigation_bar.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreferencesService.init();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  final prefs = SharedPreferencesService.instance;
  final showHome = prefs.getBool("showHome") ?? false;
  final token = prefs.getString("auth_token");
  final role = (prefs.getString("user_role") ?? "").toLowerCase();
  final langCode = prefs.getString("selected_locale") ?? 'ar';

  runApp(MyApp(
    showHome: showHome,
    token: token,
    role: role,
    initialLocale: Locale(langCode),
  ));
}

class MyApp extends StatefulWidget {
  final bool showHome;
  final String? token;
  final String? role;
  final Locale initialLocale;

  const MyApp({
    super.key,
    required this.showHome,
    required this.token,
    required this.role,
    required this.initialLocale,

  });

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Locale _locale;

  @override
  void initState() {
    super.initState();
    _locale = widget.initialLocale;
  }

  void updateLocale(Locale newLocale) {
    final prefs = SharedPreferencesService.instance;
    prefs.setString('selected_locale', newLocale.languageCode);
    setState(() {
      _locale = newLocale;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget nextScreen;

    if (widget.token != null && widget.role != null) {
      if (widget.role == 'teacher') {
        nextScreen = TeacherHomeScreen(updateLocale: updateLocale);
      } else if (widget.role == 'student') {
        nextScreen = Navigation_Bar(updateLocale: updateLocale, isTeacher: false);
      } else {
        nextScreen = WelcomeScreen(updateLocale: updateLocale);
      }
    } else {
      nextScreen = widget.showHome
          ? WelcomeScreen(updateLocale: updateLocale)
          : OnboardingPage(updateLocale: updateLocale);
    }

    return MaterialApp(
      title: 'Arabic LMS',
      locale: _locale,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: EasySplash(
        seconds: 5,
        nextScreen: nextScreen,

        indicatorHeight: 7,
        imgType: ImgType.assetImage, 
        image: "assets/animation/Arabic lms.gif",
        hasIndicator: true,
        indicatorColor: Colors.orange,
      ),
      debugShowCheckedModeBanner: false,
      localizationsDelegates: [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
    );
  }
}