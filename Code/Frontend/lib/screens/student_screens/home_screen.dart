import 'package:flutter/material.dart';
import 'package:flutter_application_1/generated/l10n.dart';
import '../../components/widgets/custom_app_bar.dart';
import '../../services/api_services.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'explore_screen.dart';
import 'quiz_attempts_screen.dart';

class StudentHomeScreen extends StatefulWidget {
  final Function(Locale) updateLocale;

  const StudentHomeScreen({super.key, required this.updateLocale});

  @override
  State<StudentHomeScreen> createState() => _StudentHomeScreenState();
}

class _StudentHomeScreenState extends State<StudentHomeScreen> {
  List<Map<String, dynamic>> _quizzes = [];
  List<Map<String, dynamic>> _pdfs = [];
  bool _isLoading = true;
  String? _error;

  // For static progress
  final double _progress = 0.72;
  String _studentName = '';
  String get _studentFirstName => _studentName.split(' ').first;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final quizzes = await ApiService.getUploadedQuizzes();
      final profile = await ApiService.getProfile();
      final pdfs = await ApiService.getUploadedPdfs();
      final userName = profile?['name'] ?? '';
      setState(() {
        _quizzes = quizzes;
        _studentName = userName;
        _pdfs = pdfs;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context);
    final screenWidth = size.width;

    return Scaffold(
      appBar: CustomAppBar(
        title: S.of(context).studentHomeAppBarTitle,
        leading: Padding(
          padding: EdgeInsets.all(screenWidth * 0.02),
          child: const CircleAvatar(
            backgroundImage: AssetImage('assets/images/Arabic lms(1)(1).png'),
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.orange,))
          : _error != null
              ? Center(child: Text(_error!))
              : SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(size.width * 0.04),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Personalized Greeting
                        Text(
                          S.of(context).studentHomeTitle + (_studentName.isNotEmpty ? ' $_studentFirstName' : ''),
                          style: TextStyle(
                            fontSize: size.width * 0.065,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: size.height * 0.025),
                        // Dashboard Row
                        Row(
                          children: [
                            // Progress Card
                            Expanded(
                              child: Card(
                                elevation: 2,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(vertical: size.height * 0.025),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        height: size.width * 0.18,
                                        width: size.width * 0.18,
                                        child: Stack(
                                          fit: StackFit.expand,
                                          children: [
                                            CircularProgressIndicator(
                                              value: _progress,
                                              strokeWidth: 7,
                                              backgroundColor: Colors.grey[200],
                                              valueColor: const AlwaysStoppedAnimation<Color>(Colors.orange),
                                            ),
                                            Center(
                                              child: Text(
                                                '${(_progress * 100).toInt()}%',
                                                style: TextStyle(
                                                  fontSize: size.width * 0.05,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        S.of(context).studentProgressTitle,
                                        style: theme.textTheme.bodyMedium,
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: size.width * 0.04),
                            // Next Task Card
                            Expanded(
                              child: Card(
                                elevation: 2,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(vertical: size.height * 0.025, horizontal: size.width * 0.03),
                                  child: _quizzes.isEmpty
                                      ? Text(S.of(context).noQuizzesText)
                                      : Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const Icon(Icons.assignment_turned_in, color: Colors.blue),
                                            const SizedBox(height: 8),
                                            Text(
                                              _quizzes.first['quiz_name'] ?? 'Quiz',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: size.width * 0.045,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              _quizzes.first['date'] ?? '',
                                              style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: size.width * 0.035,
                                              ),
                                            ),
                                          ],
                                        ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: size.height * 0.03),
                        // Quick Actions Row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildQuickAction(
                              icon: Icons.travel_explore,
                              label: S.of(context).explore,
                              color: Colors.orange,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ExploreScreen(updateLocale: widget.updateLocale),
                                  ),
                                );
                              },
                            ),
                            _buildQuickAction(
                              icon: Icons.bar_chart,
                              label: S.of(context).quizScoresTitle,
                              color: Colors.blue,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => QuizResultsScreen(updateLocale: widget.updateLocale),
                                  ),
                                );
                              },
                            ),
                            _buildQuickAction(
                              icon: Icons.file_download,
                              label: S.of(context).materialsDownloadTitle,
                              color: Colors.green,
                              onTap: _showDownloadDialog,
                            ),
                          ],
                        ),
                        SizedBox(height: size.height * 0.03),
                        // Upcoming Tasks Section
                        Text(
                          S.of(context).studentUpcomingTasks,
                          style: TextStyle(
                            fontSize: size.width * 0.05,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: size.height * 0.015),
                        SizedBox(
                          height: size.height * 0.22,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: _quizzes.length,
                            separatorBuilder: (context, index) => SizedBox(width: size.width * 0.03),
                            itemBuilder: (context, index) {
                              final quiz = _quizzes[index];
                              final title = quiz['quiz_name'] ?? 'Quiz';
                              final subtitle = quiz['description'] ?? '';
                              final date = quiz['date'] ?? '';
                              final color = Colors.primaries[index % Colors.primaries.length].withOpacity(0.7);
                              return _buildTaskCard(
                                title,
                                subtitle,
                                date,
                                color,
                                size,
                                context,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
    );
  }

  Widget _buildQuickAction({required IconData icon, required String label, required Color color, required VoidCallback onTap}) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.all(16),
            child: Icon(icon, color: color, size: 28),
          ),
        ),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
      ],
    );
  }

  Widget _buildTaskCard(
    String title,
    String subtitle,
    String date,
    Color color,
    Size size,
    BuildContext context,
  ) {
    return Container(
      width: size.width * 0.45,
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 6),
            Text(
              subtitle,
              style: const TextStyle(fontSize: 13, color: Colors.black54),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 14, color: Colors.orange),
                const SizedBox(width: 4),
                Text(date, style: const TextStyle(fontSize: 12)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showDownloadDialog() async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(S.of(context).selectPdfTitle),
          content: _pdfs.isEmpty
              ? Text(S.of(context).noMaterialsText)
              : SizedBox(
                  width: double.maxFinite,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: _pdfs.length,
                    itemBuilder: (context, index) {
                      final pdf = _pdfs[index];
                      final fileName = pdf['filename'] ?? 'Unknown';
                      return ListTile(
                        title: Text(fileName),
                        onTap: () {
                          Navigator.of(context).pop();
                          _downloadMaterial(fileName);
                        },
                      );
                    },
                  ),
                ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(S.of(context).cancelButton, style: TextStyle(color: Colors.orange),),
            ),
          ],
        );
      },
    );
  }

  void _downloadMaterial(String fileName) async {
    try {
      // Show loading indicator
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(S.of(context).downloadingText)),
      );

      // Request storage permission (needed for Android < 10)
      if (!await Permission.storage.isGranted) {
        await Permission.storage.request();
      }

      // Set the public Downloads directory path
      final publicDir = Directory('/storage/emulated/0/Download');
      if (!await publicDir.exists()) {
        await publicDir.create(recursive: true);
      }

      // Download the file
      final response = await http.get(
        Uri.parse('${ApiService.baseUrl}/pdfs/$fileName'),
      );

      if (response.statusCode == 200) {
        // Save to public Downloads
        final file = File('${publicDir.path}/$fileName');
        await file.writeAsBytes(response.bodyBytes);

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(S.of(context).successDownloadingText)),
        );
      } else {
        throw Exception('Download failed: \\${response.statusCode}');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: \\${e.toString()}')),
      );
    }
  }
}