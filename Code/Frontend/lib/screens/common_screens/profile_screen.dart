import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_application_1/services/shared_preferences_service.dart';
import '../../components/choose_language_menu.dart';
import 'package:flutter_application_1/generated/l10n.dart';
import '../../components/widgets/custom_app_bar.dart';
import '../../components/models/profile_item_model.dart';
import 'myaccount_screen.dart';
import 'authentication_screens/welcome_screen.dart';
import 'package:path_provider/path_provider.dart';

class ProfileScreen extends StatefulWidget {
  final Function(Locale) updateLocale;

  const ProfileScreen({super.key, required this.updateLocale});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File? _profileImage;

  @override
  void initState() {
    super.initState();
    _loadProfileImage();
  }

  Future<void> _loadProfileImage() async {
    final prefs = SharedPreferencesService.instance;
    final imagePath = prefs.getString('profile_image_path');
    if (imagePath != null && File(imagePath).existsSync()) {
      setState(() {
        _profileImage = File(imagePath);
      });
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked != null) {
      final appDir = await getApplicationDocumentsDirectory();
      final savedImage = await File(picked.path).copy('${appDir.path}/profile_image.png');

      final prefs = SharedPreferencesService.instance;
      await prefs.setString('profile_image_path', savedImage.path);

      setState(() {
        _profileImage = savedImage;
      });
    }
  }

  Future<void> _logout() async {
    final prefs = SharedPreferencesService.instance;
    await prefs.remove("auth_token");
    await prefs.remove("user_role");
    await prefs.setBool('loggedIn', false);

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => WelcomeScreen(updateLocale: widget.updateLocale),
      ),
          (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDarkMode ? Colors.black : Colors.white;
    final greyContainerColor = isDarkMode ? Colors.grey[800]! : Colors.grey[100]!;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: CustomAppBar(
        title: S.of(context).profileTitle,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundImage: _profileImage != null
                        ? FileImage(_profileImage!)
                        : const AssetImage('assets/images/sapiens.png') as ImageProvider,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      decoration: BoxDecoration(
                        color: backgroundColor,
                        shape: BoxShape.circle,
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.grey,
                            spreadRadius: 2,
                            blurRadius: 3,
                          ),
                        ],
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.camera_alt, color: Colors.orange,),
                        onPressed: _pickImage,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            ProfileOption(
              icon: Icons.person_outline,
              text: S.of(context).myAccount,
              textColor: Colors.orange,
              iconColor: Colors.orange,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MyaccountScreen()),
              ),
              containerColor: greyContainerColor,
            ),
            ProfileOption(
              icon: Icons.language,
              text: S.of(context).changeLanguage,
              iconColor: Colors.orange,
              textColor: Colors.orange,
              onTap: () {
                ChooseLanguageScreen.showLanguageModal(
                  context,
                  widget.updateLocale,
                  true,
                  false,
                );
              },
              containerColor: greyContainerColor,
            ),
            ProfileOption(
              icon: Icons.logout,
              text: S.of(context).logOut,
              iconColor: Colors.red,
              textColor: Colors.red,
              onTap: _logout,
              isLogout: true,
              containerColor: greyContainerColor,
            ),
          ],
        ),
      ),
    );
  }
}