import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/teacher_screens/home_screen.dart';
import '../../generated/l10n.dart';
import '../../screens/common_screens/profile_screen.dart';
import '../../screens/student_screens/home_screen.dart';
import '../../screens/student_screens/subjects_screen.dart';

class Navigation_Bar extends StatefulWidget {
  //final Function(bool) toggleTheme;
  final Function(Locale) updateLocale;
  final bool isTeacher;

  const Navigation_Bar({Key? key, required this.updateLocale, required this.isTeacher}) : super(key: key);

  @override
  State<Navigation_Bar> createState() => _Navigation_BarState();
}

class _Navigation_BarState extends State<Navigation_Bar> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      widget.isTeacher? TeacherHomeScreen(updateLocale: widget.updateLocale):StudentHomeScreen(updateLocale: widget.updateLocale),
      SubjectsScreen(updateLocale: widget.updateLocale),
      ProfileScreen(updateLocale: widget.updateLocale),
    ];

    return Scaffold(
      extendBody: true,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.grey[900]!
              : Colors.orange[50],
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          child: Material(
            elevation: 0,
            color: Colors.transparent,
            child: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              showUnselectedLabels: true,
              backgroundColor: const Color.fromARGB(255, 255, 242, 220),
              selectedItemColor: Colors.orange,
              unselectedItemColor: Colors.grey,
              elevation: 0,
              currentIndex: index,
              items: [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home_outlined,),
                  label: S.of(context).navHome,
                  activeIcon: Icon(Icons.home, color: Colors.orange, size: 25,),
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.book_outlined),
                  label: S.of(context).navSubjects,
                  activeIcon: Icon(Icons.book, color: Colors.orange, size: 25,),
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person_outline),
                  label: S.of(context).navProfile,
                  activeIcon: Icon(Icons.person, color: Colors.orange, size: 25,),
                ),
              ],
              onTap: (selectedIndex) {
                setState(() {
                  index = selectedIndex;
                });
              },
            ),
          ),
        ),
      ),
      body: pages[index],
    );
  }
}