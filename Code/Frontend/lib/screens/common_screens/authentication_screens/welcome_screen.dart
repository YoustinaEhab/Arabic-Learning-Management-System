import 'package:flutter/material.dart';
import '../../../components/widgets/custom_scaffold.dart';
import '../../../components/widgets/welcome_button.dart';
import '../../../generated/l10n.dart';
import 'signin_screen.dart';
import 'signup_screen.dart';

class WelcomeScreen extends StatelessWidget {
  final Function(Locale) updateLocale;

  const WelcomeScreen({super.key, required this.updateLocale});

  @override
  Widget build(BuildContext context) {

    Locale currentLocale = Localizations.localeOf(context);
    String languageCode = currentLocale.languageCode;

    return CustomScaffold(
      child: Column(
        children: [
          Flexible(
              flex: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 0,
                  horizontal: 40.0,
                ),
                child: Center(
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: [
                        TextSpan(
                            text: S.of(context).welcomeTitle,
                            style: TextStyle(
                              fontSize: languageCode == "ar" ? 50 : 45,
                              fontWeight: FontWeight.bold,
                            )),
                        TextSpan(
                            text:
                                S.of(context).welcomeSubtitle,
                            style: TextStyle(
                              fontSize: languageCode == "ar" ? 27 : 20,
                              fontWeight: languageCode == "ar" ? FontWeight.w300 : FontWeight.normal,
                            ))
                      ],
                    ),
                  ),
                ),
              )),
          Flexible(
            flex: 1,
            child: Align(
              alignment: Alignment.bottomRight,
              child: Row(
                children: [
                  Expanded(
                    child: WelcomeButton(
                      buttonText: S.of(context).welcomeSignInButton,
                      onTap: SignInScreen(updateLocale: updateLocale, languageCode: languageCode),
                      color: Colors.transparent,
                      textColor: Colors.white,
                    ),
                  ),
                  Expanded(
                    child: WelcomeButton(
                      buttonText: S.of(context).welcomeSignUpButton,
                      onTap: SignUpScreen(updateLocale: updateLocale, languageCode: languageCode),
                      color: Colors.white,
                      textColor: Colors.orange,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
