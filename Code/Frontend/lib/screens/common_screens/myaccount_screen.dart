import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_application_1/services/shared_preferences_service.dart';
import '../../../generated/l10n.dart';
import '../../services/api_services.dart';
import '../../components/widgets/custom_app_bar.dart';
import '../../components/widgets/custom_text_form_field.dart';

class MyaccountScreen extends StatefulWidget {
  const MyaccountScreen({super.key});

  @override
  State<MyaccountScreen> createState() => _MyaccountScreenState();
}

class _MyaccountScreenState extends State<MyaccountScreen> {
  final formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isPasswordHidden = true;
  bool _isLoading = false;
  File? _imageFile;

  @override
  void initState() {
    super.initState();
    _loadProfile();
    _loadProfileImage();
  }

  Future<void> _loadProfile() async {
    try {
      final data = await ApiService.getProfile();
      if (data != null) {
        setState(() {
          _nameController.text = data['name'] ?? '';
          _emailController.text = data['email'] ?? '';
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load profile: $e')),
      );
    }
  }

  Future<void> _loadProfileImage() async {
    final prefs = SharedPreferencesService.instance;
    final path = prefs.getString("profile_image_path");
    if (path != null && File(path).existsSync()) {
      setState(() => _imageFile = File(path));
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => _imageFile = File(picked.path));
      final prefs = SharedPreferencesService.instance;
      await prefs.setString("profile_image_path", picked.path);
    }
  }

  Future<void> _saveProfile() async {
    if (!formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final success = await ApiService.updateProfile(
        name: _nameController.text.trim(),
        password: _passwordController.text.trim(),
      );

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(S.of(context).profileUpdated)),
        );
        _passwordController.clear();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(S.of(context).updateFailed)),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDarkMode ? Colors.black : Colors.white;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: CustomAppBar(
          title: S.of(context).myAccount,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 30),
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundImage: _imageFile != null
                          ? FileImage(_imageFile!)
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
                          icon: const Icon(Icons.camera_alt, color: Colors.orange),
                          onPressed: _pickImage,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              Form(
                key: formKey,
                child: Center(
                  child: Column(
                    children: [
                      SizedBox(
                        width: 350,
                        child: CustomTextField(
                          controller: _nameController,
                          labelText: S.of(context).fullNameLabel,
                          hintText: S.of(context).fullNameHint,
                          isRequired: true,
                        ),
                      ),
                      const SizedBox(height: 15),
                      SizedBox(
                        width: 350,
                        child: CustomTextField(
                          controller: _emailController,
                          labelText: S.of(context).emailLabel,
                          hintText: S.of(context).emailHint,
                          isRequired: false,
                          keyboardType: TextInputType.emailAddress,
                          enabled: false,
                        ),
                      ),
                      const SizedBox(height: 15),
                      SizedBox(
                        width: 350,
                        child: CustomTextField(
                          controller: _passwordController,
                          labelText: S.of(context).passwordLabel,
                          hintText: S.of(context).passwordHint,
                          isPassword: true,
                          isRequired: true,
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _isLoading ? null : _saveProfile,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: _isLoading
                            ? const CircularProgressIndicator(color: Colors.white)
                            : Text(
                          S.of(context).saveButton,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
