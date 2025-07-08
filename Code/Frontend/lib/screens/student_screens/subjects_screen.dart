import 'package:flutter/material.dart';

import '../../generated/l10n.dart';
import '../../components/widgets/custom_app_bar.dart';
import 'subject_details_screen.dart';

class SubjectsScreen extends StatefulWidget {
  final Function(Locale) updateLocale;

  const SubjectsScreen({super.key, required this.updateLocale});

  @override
  _SubjectsScreenState createState() => _SubjectsScreenState();
}

class _SubjectsScreenState extends State<SubjectsScreen> {

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> subjects = [
      {'name': S.of(context).mathematics, 'color': [Colors.blue, Colors.purple]},
      {'name': S.of(context).chemistry, 'color': [Colors.red, Colors.orange]},
      {'name': S.of(context).english, 'color': [Colors.green, Colors.cyan]},
      {'name': S.of(context).geography, 'color': [Colors.pink, Colors.grey]},
      {'name': S.of(context).physics, 'color': [Colors.deepPurple, Colors.purpleAccent]},
      {'name': S.of(context).history, 'color': [Colors.brown, Colors.grey]},
    ];

    return Scaffold(
      appBar: CustomAppBar(
        title: S.of(context).subjectsTitle,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.2,
                ),
                itemCount: subjects.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SubjectDetailPage(updateLocale: widget.updateLocale),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        gradient: LinearGradient(
                          colors: subjects[index]['color'],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          subjects[index]['name'],
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

