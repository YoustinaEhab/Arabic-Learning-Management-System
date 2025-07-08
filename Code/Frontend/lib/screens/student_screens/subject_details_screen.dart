import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../components/models/take_quiz_model.dart';
import '../../generated/l10n.dart';
import '../../services/api_services.dart';
import '../common_screens/pdf_viewer_screen.dart';
import 'take_quiz_screen.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../../components/widgets/custom_app_bar.dart';

class SubjectDetailPage extends StatefulWidget {
  final Function(Locale) updateLocale;
  
  const SubjectDetailPage({super.key, required this.updateLocale});

  @override
  State<SubjectDetailPage> createState() => _SubjectDetailPageState();
}

class _SubjectDetailPageState extends State<SubjectDetailPage> {
  List<Map<String, dynamic>> _materials = [];
  List<Quiz> _quizzes = [];
  bool _materialsLoading = true;
  bool _quizzesLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchMaterials();
    _fetchQuizzes();
  }

  Future<void> _fetchMaterials() async {
    try {
      final pdfs = await ApiService.getUploadedPdfs();
      setState(() {
        _materials = pdfs;
        _materialsLoading = false;
      });
    } catch (e) {
      setState(() {
        _materialsLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(S.of(context).failedToLoadPDFs(e.toString()))),
      );
    }
  }

    Future<void> _fetchQuizzes() async {
    try {
      final quizzes = await ApiService.getUploadedQuizzes();
      setState(() {
        _quizzes = quizzes.map((quiz) => Quiz.fromJson(quiz)).toList();
        _quizzesLoading = false;
      });
    } catch (e) {
      setState(() {
        _quizzesLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(S.of(context).failedToLoadQuizzes(e.toString()))),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDarkMode ? Colors.black : Colors.white;
    final textColor = isDarkMode ? Colors.white : Colors.black;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: CustomAppBar(
        title: S.of(context).subjectDetailTitle,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: Colors.white),
            onPressed: (){
              setState(() {
                _materialsLoading = true;
                _quizzesLoading = true;
                _materials = [];
                _quizzes = [];
              });
              _fetchMaterials();
              _fetchQuizzes();
            },
          ),
        ],
      ),
      body: _materialsLoading || _quizzesLoading
          ? Center(child: CircularProgressIndicator(color: Colors.orange))
          : SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle(S.of(context).materialsSectionTitle, context),
                  SizedBox(height: 8),
                  _buildMaterialsList(),
                  SizedBox(height: 24),
                  _buildSectionTitle(S.of(context).quizzesSectionTitle, context),
                  SizedBox(height: 8),
                  _buildQuizzesList(),
                ],
              ),
            ),
    );
  }

  Widget _buildSectionTitle(String title, BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.orange,
      ),
    );
  }

  Widget _buildMaterialsList() {
    if (_materialsLoading) {
    return const Center(child: CircularProgressIndicator(color: Colors.orange));
  }

    if (_materials.isEmpty) {
      return Center(
        child: Text(
          S.of(context).noMaterialsText,
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: _materials.length,
      itemBuilder: (context, index) {
        final material = _materials[index];
        return InkWell(
          onTap: (){
                      Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PDFViewerScreen(
                pdfUrl: '${ApiService.baseUrl}/pdfs/${material['filename']}',
                pdfName: material['filename'] ?? 'Untitled PDF',
              ),
            ),
          );
          },
          child: Card(
            margin: EdgeInsets.symmetric(vertical: 4),
            color: Colors.grey[100],
            child: ListTile(
              leading: Icon(Icons.picture_as_pdf, color: Colors.red),
              title: Text(material['filename'] ?? 'Untitled Material'),
              trailing: IconButton(
                icon: Icon(Icons.download, color: Colors.orange),
                onPressed: () => _downloadMaterial(material['filename']),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildQuizzesList() {
    if (_quizzesLoading) {
    return const Center(child: CircularProgressIndicator(color: Colors.orange));
  }

    if (_quizzes.isEmpty) {
      return Center(
        child: Text(
          S.of(context).noQuizzesText,
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: _quizzes.length,
      itemBuilder: (context, index) {
        final quiz = _quizzes[index];
        return InkWell(
          onTap: (){
            _showStartQuizConfirmation(context, quiz);
          },
          child: Card(
            margin: EdgeInsets.symmetric(vertical: 4),
            color: Colors.white,
            child: ListTile(
              leading: Icon(Icons.quiz, color: Colors.blue),
              title: Text(quiz.title),
            ),
          ),
        );
      },
    );
  }

  void _downloadMaterial(String filename) async {
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
      Uri.parse('${ApiService.baseUrl}/pdfs/$filename'),
    );

    if (response.statusCode == 200) {
      // Save to public Downloads
      final file = File('${publicDir.path}/$filename');
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
      SnackBar(content: Text(S.of(context).failedDownloadingText)),
    );
  }
}

  void _showStartQuizConfirmation(BuildContext context, Quiz quiz) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.grey[100],
        title: Text(S.of(context).startQuizTitle),
        content: Text(S.of(context).startQuizMessage),
        actions: <Widget>[
          TextButton(
            child: Text(S.of(context).startQuizCancel, style: TextStyle(color: Colors.orange),),
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
          ),
          TextButton(
            child: Text(S.of(context).startQuizConfirm, style: TextStyle(color: Colors.orange),),
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TakeQuizScreen(
                    quiz: quiz,
                    updateLocale: widget.updateLocale,
                    customTimeLimitMinutes: quiz.timeLimitMinutes ?? 10,
                  ),
                ),
              );
            },
          ),
        ],
      );
    },
  );

}
}