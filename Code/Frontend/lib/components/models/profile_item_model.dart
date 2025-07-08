import 'package:flutter/material.dart';

class ProfileOption extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color iconColor;
  final Color textColor;
  final bool isLogout;
  final VoidCallback onTap;
  final Color containerColor;

  const ProfileOption({
    super.key, 
    required this.icon,
    required this.text,
    required this.iconColor,
    required this.textColor,
    required this.onTap,
    this.isLogout = false,
    required this.containerColor, 
  });

  @override
  Widget build(BuildContext context) {

    Locale currentLocale = Localizations.localeOf(context);
    String languageCode = currentLocale.languageCode;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          color: containerColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: ListTile(
          leading: Icon(icon, color: iconColor),
          title: Text(
            text,
            style: TextStyle(
              fontSize: languageCode == 'ar' ? 18 : 16,
              fontWeight: FontWeight.w500,
              color: textColor,
            ),
          ),
          trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.orange),
          onTap: onTap,
        ),
      ),
    );
  }
}