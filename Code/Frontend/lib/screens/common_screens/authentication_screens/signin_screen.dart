import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:flutter_application_1/services/shared_preferences_service.dart';
import '../../../components/widgets/custom_scaffold.dart';
import '../../../components/widgets/custom_text_form_field.dart';
import '../../../components/widgets/navigation_bar.dart';
import '../../../generated/l10n.dart';
import '../../../services/api_services.dart';
import '../../teacher_screens/home_screen.dart';
import 'signup_screen.dart';

class SignInScreen extends StatefulWidget {
  final Function(Locale) updateLocale;
  final String languageCode;

  const SignInScreen({super.key, required this.updateLocale, required this.languageCode});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {

  final _formSignInKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _login() async {
    if (!_formSignInKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await ApiService.login(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final token = responseData['access_token'];
        final role = responseData['user']['role'];

        final prefs = SharedPreferencesService.instance;
        await prefs.setString('auth_token', token);
        await prefs.setString('user_role', role);
        await prefs.setString('user_email', _emailController.text.trim());
        await prefs.setBool('loggedIn', true);

        Widget homeScreen;
        if (role.toLowerCase() == 'teacher') {
          homeScreen = TeacherHomeScreen(updateLocale: widget.updateLocale);
        } else {
          homeScreen = Navigation_Bar(updateLocale: widget.updateLocale, isTeacher: false);
        }

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => homeScreen),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(S.of(context).AuthFailed)),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final shorterDimension = screenSize.width < screenSize.height
        ? screenSize.width
        : screenSize.height;

    return CustomScaffold(
      child: Column(
        children: [
          const Expanded(
            flex: 1,
            child: SizedBox(
              height: 10,
            ),
          ),
          Expanded(
            flex: 7,
            child: Container(
              padding: const EdgeInsets.fromLTRB(25.0, 30.0, 25.0, 20.0),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40.0),
                  topRight: Radius.circular(40.0),
                ),
              ),
              child: SingleChildScrollView(
                child: Form(
                  key: _formSignInKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        S.of(context).signInWelcome,
                        style: const TextStyle(
                          fontSize: 30.0,
                          fontWeight: FontWeight.w900,
                          color: Colors.orange,
                        ),
                      ),
                      const SizedBox(
                        height: 30.0,
                      ),
                      CustomTextField(
                        controller: _emailController,
                        labelText: S.of(context).emailLabel,
                        hintText: S.of(context).emailHint,
                        isRequired: true,
                        keyboardType: TextInputType.emailAddress,
                        isAuthField: true,
                      ),
                      const SizedBox(
                        height: 25.0,
                      ),
                      CustomTextField(
                        controller: _passwordController,
                        labelText: S.of(context).passwordLabel,
                        hintText: S.of(context).passwordHint,
                        isRequired: true,
                        keyboardType: TextInputType.multiline,
                        isPassword: true,
                        isAuthField: true,
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Spacer(),
                          GestureDetector(
                            onTap: _showResetPasswordDialog,
                            child: Text(
                              S.of(context).forgotPassword,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.orange,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      SizedBox(
                        width: double.infinity,
                        height: screenSize.height * 0.065,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange, // Background color
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  shorterDimension * 0.02),
                            ),
                          ),
                          onPressed: _isLoading ? null : _login,
                          child: _isLoading
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : Text(S.of(context).signInButton,
                            style: TextStyle(
                            fontSize: shorterDimension * 0.055,
                          ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 15.0,
                      ),
                      // don't have an account
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            S.of(context).signInNoAccount,
                            style: const TextStyle(
                              color: Colors.black45,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (e) => SignUpScreen(updateLocale: widget.updateLocale, languageCode: '',),
                                ),
                              );
                            },
                            child: Text(
                              S.of(context).signInSignUpLink,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.orange,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  void _showResetPasswordDialog() {
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();
    final _formKey = GlobalKey<FormState>();
    bool obscureNewPassword = true;
    bool obscureConfirmPassword = true;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              title: Text(
                S.of(context).forgotPassword,
                style: const TextStyle(color: Colors.orange, fontWeight: FontWeight.w500),
              ),
              content: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: newPasswordController,
                      obscureText: obscureNewPassword,
                      cursorColor: Colors.orange,
                      decoration: InputDecoration(
                        labelText: S.of(context).newPasswordLabel,
                        hintText: S.of(context).newPasswordHint,
                        hintStyle: const TextStyle(color: Colors.black26),
                        labelStyle: const TextStyle(color: Colors.orange),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.orange),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.orange),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            obscureNewPassword ? Icons.visibility_off : Icons.visibility,
                            color: Colors.grey,
                          ),
                          onPressed: () {
                            setState(() {
                              obscureNewPassword = !obscureNewPassword;
                            });
                          },
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return S.of(context).requiredField;
                        } else if (value.length < 6) {
                          return S.of(context).passwordTooShort;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: confirmPasswordController,
                      obscureText: obscureConfirmPassword,
                      cursorColor: Colors.orange,
                      decoration: InputDecoration(
                        labelText: S.of(context).confirmPasswordLabel,
                        hintText: S.of(context).confirmPasswordHint,
                        hintStyle: const TextStyle(color: Colors.black26),
                        labelStyle: const TextStyle(color: Colors.orange),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.orange),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.orange),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
                            color: Colors.grey,
                          ),
                          onPressed: () {
                            setState(() {
                              obscureConfirmPassword = !obscureConfirmPassword;
                            });
                          },
                        ),
                      ),
                      validator: (value) {
                        if (value != newPasswordController.text) {
                          return S.of(context).passwordsDoNotMatch;
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    S.of(context).cancelButton,
                    style: const TextStyle(color: Colors.orange),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Handle password reset logic here
                      // _resetPassword(newPasswordController.text);
                    }
                  },
                  child: Text(S.of(context).resetButton),
                ),
              ],
            );
          },
        );
      },
    );
  }
}