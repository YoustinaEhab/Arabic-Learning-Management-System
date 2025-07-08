import 'package:flutter/material.dart';
import 'package:flutter_application_1/generated/l10n.dart';
import 'package:flutter_application_1/screens/common_screens/onboarding_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../screens/common_screens/authentication_screens/welcome_screen.dart';

class ChooseLanguageScreen extends StatelessWidget {
  final Function(Locale) updateLocale;
  final bool isTeacher;
  final bool isFirstTime;

  const ChooseLanguageScreen({
    super.key,
    required this.updateLocale,
    required this.isTeacher,
    this.isFirstTime = false,
  });

  static Future<void> showLanguageModal(
    BuildContext context,
    Function(Locale) updateLocale,
    bool isTeacher,
    bool isFirstTime, // Add this parameter
  ) async {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final buttonWidth = screenWidth * 0.5;
    final buttonHeight = screenHeight * 0.08;
    final modalHeight = screenHeight * 0.3;
    final titleFontSize = screenWidth * 0.06;
    final buttonFontSize = screenWidth * 0.05;

    await showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: modalHeight,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  S.of(context).chooseLangTitle,
                  style: TextStyle(
                    fontSize: titleFontSize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),
                SizedBox(
                  width: buttonWidth,
                  height: buttonHeight,
                  child: ElevatedButton(
                    onPressed: () async {
                      final prefs = await SharedPreferences.getInstance();
                      await prefs.setString('selected_locale', 'en');

                      updateLocale(const Locale('en'));

                      if (isFirstTime == false) {
                        Navigator.pop(context);
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => WelcomeScreen(updateLocale: updateLocale)),
                        );
                      }
                    },

                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                    child: Text(
                      "English",
                      style: TextStyle(
                        fontSize: buttonFontSize,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.01),
                SizedBox(
                  width: buttonWidth,
                  height: buttonHeight,
                  child: ElevatedButton(
                    onPressed: () async {
                      final prefs = await SharedPreferences.getInstance();
                      await prefs.setString('selected_locale', 'ar');

                      updateLocale(const Locale('ar'));

                      if (isFirstTime == false) {
                        Navigator.pop(context);
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => WelcomeScreen(updateLocale: updateLocale)),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      padding: EdgeInsets.symmetric(vertical: 15),
                    ),
                    child: Text(
                      "العربية",
                      style: TextStyle(
                        fontSize: buttonFontSize,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Container();
  }

//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     final screenHeight = MediaQuery.of(context).size.height;
//     final buttonWidth = screenWidth * 0.5;
//     final buttonHeight = screenHeight * 0.06;
//     final buttonFontSize = screenWidth * 0.04;

//     return Scaffold(
//       body: SafeArea(
//         child: Center(
//           child: SizedBox(
//             width: buttonWidth,
//             height: buttonHeight,
//             child: ElevatedButton(
//               onPressed: () {
//                 ChooseLanguageScreen.showLanguageModal(context, updateLocale, isTeacher);
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.blue,
//               ),
//               child: Text(
//                 S.of(context).chooseLanguage,
//                 style: TextStyle(
//                   fontSize: buttonFontSize,
//                   color: Colors.white,
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
}