import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import '../../../components/widgets/custom_scaffold.dart';
import '../../../components/widgets/custom_text_form_field.dart';
import '../../../components/widgets/navigation_bar.dart';
import '../../../generated/l10n.dart';
import '../../../services/api_services.dart';
import '../../teacher_screens/home_screen.dart';
import 'signin_screen.dart';
import 'package:flutter_application_1/services/shared_preferences_service.dart';


class SignUpScreen extends StatefulWidget {
  final Function(Locale) updateLocale;

  final String languageCode;
  const SignUpScreen({super.key, required this.updateLocale, required this.languageCode});


  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formSignupKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _selectedRole;
  bool _isLoading = false;

  Future<void> _signup() async {
    if (!_formSignupKey.currentState!.validate() || _selectedRole == null) {
      if (_selectedRole == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please select a role.')),
        );
      }
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await ApiService.signup(
        email: _emailController.text.trim(),
        password: _passwordController.text,
        name: _nameController.text.trim(),
        role: _selectedRole!,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        final token = responseData['access_token'];
        final role = responseData['user']['role'];

        final prefs = SharedPreferencesService.instance;
        await prefs.setString('auth_token', token);
        await prefs.setString('user_role', role);
        await prefs.setBool('loggedIn', true);

        Widget homeScreen;
        if (role.toLowerCase() == 'teacher') {
          homeScreen = TeacherHomeScreen(updateLocale: widget.updateLocale);
        } else {
          homeScreen = Navigation_Bar(updateLocale: widget.updateLocale, isTeacher: false);
        }

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => homeScreen,
          ),
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
          Expanded(
            flex: 1,
            child: SizedBox(height: screenSize.height * 0.02),
          ),
          Expanded(
            flex: 7,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: screenSize.width * 0.06,
                vertical: screenSize.height * 0.03,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(shorterDimension * 0.08),
                  topRight: Radius.circular(shorterDimension * 0.08),
                ),
              ),
              child: SingleChildScrollView(
                child: Form(
                  key: _formSignupKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        S.of(context).signUpTitle,
                        style: TextStyle(
                          fontSize: shorterDimension * 0.09,
                          fontWeight: FontWeight.w900,
                          color: Colors.orange,
                        ),
                      ),
                      SizedBox(height: screenSize.height * 0.025),
                      CustomTextField(
                        controller: _nameController,
                        labelText: S.of(context).fullNameLabel,
                        hintText: S.of(context).fullNameHint,
                        isRequired: true,
                        keyboardType: TextInputType.multiline,
                      ),
                      SizedBox(height: screenSize.height * 0.025),
                      CustomTextField(
                        controller: _emailController,
                        labelText: S.of(context).emailLabel,
                        hintText: S.of(context).emailHint,
                        isRequired: true,
                        keyboardType: TextInputType.emailAddress,
                        isAuthField: true,
                      ),
                      SizedBox(height: screenSize.height * 0.03),
                      CustomTextField(
                        controller: _passwordController,
                        labelText: S.of(context).passwordLabel,
                        hintText: S.of(context).passwordHint,
                        isRequired: true,
                        keyboardType: TextInputType.visiblePassword,
                        isPassword: true,
                        isAuthField: true,
                      ),
                      SizedBox(height: screenSize.height * 0.02),
                      Text(
                        S.of(context).userTypeTitle,
                        style: TextStyle(
                          fontSize: shorterDimension * 0.055,
                          fontWeight: FontWeight.w600,
                          color: Colors.black54,
                        ),
                      ),
                      SizedBox(height: screenSize.height * 0.02),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ChoiceChip(
                            label: Text(S.of(context).teacherRole),
                            selected: _selectedRole == 'teacher',
                            onSelected: (selected) {
                              setState(() {
                                _selectedRole = selected ? 'teacher' : null;
                              });
                            },
                            selectedColor: Colors.orange,
                            backgroundColor: const Color.fromARGB(255, 255, 242, 220),
                            labelStyle: TextStyle(
                              color: _selectedRole == 'teacher' ? Colors.white : Colors.orange,
                              fontWeight: FontWeight.bold,
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            showCheckmark: true,
                            checkmarkColor: Colors.white,
                          ),
                          SizedBox(width: 16),
                          ChoiceChip(
                            label: Text(S.of(context).studentRole),
                            selected: _selectedRole == 'student',
                            onSelected: (selected) {
                              setState(() {
                                _selectedRole = selected ? 'student' : null;
                              });
                            },
                            selectedColor: Colors.orange,
                            backgroundColor: const Color.fromARGB(255, 255, 242, 220),
                            labelStyle: TextStyle(
                              color: _selectedRole == 'student' ? Colors.white : Colors.orange,
                              fontWeight: FontWeight.bold,
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            showCheckmark: true,
                            checkmarkColor: Colors.white,
                          ),
                        ],
                      ),
                      SizedBox(height: screenSize.height * 0.02),
                      SizedBox(
                        width: double.infinity,
                        height: screenSize.height * 0.065,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  shorterDimension * 0.02),
                            ),
                          ),
                          onPressed: _isLoading ? null : _signup,
                          child: _isLoading
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : Text(
                                  S.of(context).signUpButton,
                                  style: TextStyle(
                                    fontSize: shorterDimension * 0.055,
                                  ),
                                ),
                        ),
                      ),
                      SizedBox(height: screenSize.height * 0.03),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            S.of(context).signUpAlreadyHaveAccount,
                            style: TextStyle(
                              color: Colors.black45,
                              fontSize: shorterDimension * 0.035,
                            ),
                          ),
                          SizedBox(width: screenSize.width * 0.01),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (e) => SignInScreen(
                                    updateLocale: widget.updateLocale,
                                    languageCode: widget.languageCode,
                                  ),
                                ),
                              );
                            },
                            child: Text(
                              S.of(context).signUpSignInLink,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.orange,
                                fontSize: shorterDimension * 0.035,
                              ),
                            ),
                          ),
                        ],
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
}