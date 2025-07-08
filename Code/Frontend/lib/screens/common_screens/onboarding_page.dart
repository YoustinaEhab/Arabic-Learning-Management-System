import 'package:concentric_transition/concentric_transition.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/generated/l10n.dart';
import 'package:flutter_application_1/components/choose_language_menu.dart';
import 'package:flutter_application_1/components/models/dashboard_item_model.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_application_1/services/shared_preferences_service.dart';

class OnboardingPage extends StatefulWidget {
  final Function(Locale) updateLocale;

  const OnboardingPage({super.key, required this.updateLocale});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {

  @override
  Widget build(BuildContext context) {
   final data = [
      CardPlanetData(
      title: S.of(context).onBoardingTitle1,
      subtitle: S.of(context).onBoardingSubTitle1,
      image: LottieBuilder.asset("assets/animation/Animation1.json"),
      backgroundColor: Colors.white,
      titleColor: const Color.fromARGB(255, 77, 202, 169),
      subtitleColor: const Color.fromARGB(255, 0, 0, 0),
      background: LottieBuilder.asset("assets/animation/bg-2.json"),
    ),
      CardPlanetData(
      title: S.of(context).onBoardingTitle2,
      subtitle: S.of(context).onBoardingSubTitle2,
      image: LottieBuilder.asset("assets/animation/Animation6.json"),
      backgroundColor: const Color.fromARGB(255, 114, 114, 114),
      titleColor:  Colors.orange,
      subtitleColor: Colors.white,
      background: LottieBuilder.asset("assets/animation/bg-1.json"),
    ),
    CardPlanetData(
      title: S.of(context).onBoardingTitle3,
      subtitle: S.of(context).onBoardingSubTitle3,
      image: LottieBuilder.asset("assets/animation/Animation5.json"),
      backgroundColor: const Color.fromARGB(255, 244, 167, 51),
      titleColor: const Color.fromARGB(255, 69, 68, 68),
      subtitleColor: Colors.white,
      background: LottieBuilder.asset("assets/animation/bg-3.json"),
    ),
  ];
    return Scaffold(
      body: Stack(
        children: [
          ConcentricPageView(
            colors: data.map((e) => e.backgroundColor).toList(),
            itemCount: data.length,
            direction: Axis.vertical,
            nextButtonBuilder: (context) => Icon(
                Icons.keyboard_arrow_down_rounded,
                size: 40,
                ),
            itemBuilder: (int index) {
              return CardPlanet(data: data[index]);
            },
            onFinish: () async {
              final prefs = SharedPreferencesService.instance;
              await prefs.setBool("showHome",  true);
              ChooseLanguageScreen.showLanguageModal(context, widget.updateLocale, true, true);
            },
          ),
        ],
      ),
    );
  }
}
