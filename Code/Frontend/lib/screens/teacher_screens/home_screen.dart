import 'package:flutter/material.dart';
import 'package:flutter_application_1/generated/l10n.dart';
import 'package:flutter_application_1/screens/teacher_screens/upload_materials_screen.dart';
import '../../services/api_services.dart';
import '../common_screens/profile_screen.dart';
import 'question_generation_screen.dart';
import 'quiz_preview_screen.dart';
import '../common_screens/pdf_viewer_screen.dart';
import '../../components/widgets/custom_app_bar.dart';
import 'quiz_scores_screen.dart';

class TeacherHomeScreen extends StatefulWidget {
  final Function(Locale) updateLocale;

  const TeacherHomeScreen({super.key, required this.updateLocale});

  @override
  State<TeacherHomeScreen> createState() => _TeacherHomeScreenState();
}

class _TeacherHomeScreenState extends State<TeacherHomeScreen> {
  List<Map<String, dynamic>> _uploadedPdfs = [];
  List<Map<String, dynamic>> _uploadedQuizzes = [];
  bool _pdfIsLoading = true;
  bool _quizIsLoading = true;
  String _teacherName = '';
  String get _teacherFirstName => _teacherName.split(' ').first;

  @override
  void initState() {
    super.initState();
    _fetchUploadedPdfs();
    _fetchUploadedQuizzes();
    _fetchProfile();
  }

  Future<void> _fetchProfile() async {
    try {
      final profile = await ApiService.getProfile();
      setState(() {
        _teacherName = profile?['name'] ?? '';
      });
    } catch (e) {
      // Optionally handle error
    }
  }

  Future<void> _fetchUploadedPdfs() async {
    try {
      final pdfs = await ApiService.getUploadedPdfs();
      setState(() {
        _uploadedPdfs = pdfs;
        _pdfIsLoading = false;
      });
    } catch (e) {
      setState(() {
        _pdfIsLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load PDFs: $e')),
      );
    }
  }

    Future<void> _fetchUploadedQuizzes() async {
    try {
      final quizzes = await ApiService.getUploadedQuizzes();
      setState(() {
        _uploadedQuizzes = quizzes;
        _quizIsLoading = false;
      });
    } catch (e) {
      setState(() {
        _quizIsLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load Quizzes: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    

    return Scaffold(
      appBar: CustomAppBar(
        title: S.of(context).studentHomeAppBarTitle,
        leading: SizedBox(
          child: Padding(
            padding: EdgeInsets.all(screenWidth * 0.02),
            child: const CircleAvatar(
              backgroundImage: AssetImage('assets/images/Arabic lms(1)(1).png'),
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfileScreen(updateLocale: widget.updateLocale),
                ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(screenWidth * 0.04),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: screenHeight * 0.03),
                if (_teacherName.isNotEmpty)
                  Text(
                    S.of(context).teacherHomeTitle + ' ' + _teacherFirstName,
                    style: TextStyle(
                      fontSize: screenWidth * 0.065,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                if (_teacherName.isEmpty)
                  Text(
                    S.of(context).teacherHomeTitle,
                    style: TextStyle(
                      fontSize: screenWidth * 0.06,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                SizedBox(height: screenHeight * 0.03),
                Row(
                  children: [
                    Expanded(
                      child: _buildQuickActionButton(
                        context,
                        icon: Icons.upload,
                        label: S.of(context).teacherHomeUploadButton,
                        onPressed: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UploadMaterialScreen(),
                          ),
                        );

                        if (result == true) {
                          _fetchUploadedPdfs();
                        }
                      },

                      ),
                    ),
                    SizedBox(width: screenWidth * 0.03),
                    Expanded(
                      child: _buildQuickActionButton(
                        context,
                        icon: Icons.quiz,
                        label: S.of(context).teacherHomeGenerateButton,
                        onPressed: () async{
                          bool? quizSaved = await Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => GenerateQuizScreen()),
                          );
                          if (quizSaved == true) {
                            _fetchUploadedQuizzes();
                          }
                        },
                      ),
                    ),
                    SizedBox(width: screenWidth * 0.03),
                    Expanded(
                      child: _buildQuickActionButton(
                        context,
                        icon: Icons.analytics,
                        label: S.of(context).teacherHomeViewButton,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const QuizResultsScreen(),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: screenHeight * 0.03),
        
                Text(
                  S.of(context).teacherHomeSubtitle1,
                  style: TextStyle(
                    fontSize: screenWidth * 0.05,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),
                _buildUploadedMaterialsList(context),
        
                SizedBox(height: screenHeight * 0.03),
        
                Text(
                  S.of(context).teacherHomeSubtitle2,
                  style: TextStyle(
                    fontSize: screenWidth * 0.05,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),
                _buildGeneratedQuizzesList(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActionButton(
    BuildContext context, {
      required IconData icon,
      required String label,
      required VoidCallback onPressed,})
    {
    Locale currentLocale = Localizations.localeOf(context);
    String languageCode = currentLocale.languageCode;

    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.03),
        iconColor: Colors.orange,
        foregroundColor: Colors.orange,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: MediaQuery.of(context).size.width * 0.08),
          SizedBox(height: MediaQuery.of(context).size.height * 0.01),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.width * 0.035,
              fontWeight: languageCode == 'ar'? FontWeight.bold: FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUploadedMaterialsList(BuildContext context) {
  if (_pdfIsLoading) {
    return const Center(child: CircularProgressIndicator(color: Colors.orange));
  }

  if (_uploadedPdfs.isEmpty) {
    return Center(
      child: Text(
        S.of(context).teacherNoMaterials,
        style: TextStyle(
          fontSize: MediaQuery.of(context).size.width * 0.04,
        ),
      ),
    );
  }

  return ListView.builder(
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    itemCount: _uploadedPdfs.length,
    itemBuilder: (context, index) {
      final pdf = _uploadedPdfs[index];
      return InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PDFViewerScreen(
                pdfUrl: '${ApiService.baseUrl}/pdfs/${pdf['filename']}',
                pdfName: pdf['filename'] ?? 'Untitled PDF',
              ),
            ),
          );
        },
        child: Card(
          margin: EdgeInsets.symmetric(
            vertical: MediaQuery.of(context).size.height * 0.01),
          child: ListTile(
            leading: Icon(Icons.picture_as_pdf, 
                size: MediaQuery.of(context).size.width * 0.06,
                color: Colors.red),
            title: Text(
              pdf['filename'] ?? 'Untitled PDF',
              style: TextStyle(
                fontSize: MediaQuery.of(context).size.width * 0.04,
              ),
            ),
            trailing: IconButton(
              icon: Icon(Icons.delete, 
                  size: MediaQuery.of(context).size.width * 0.06, 
                  color: Colors.red),
              onPressed:  () async {
                final confirmed = await _showDeleteConfirmationDialog(pdf['filename']);
                if (confirmed) {
                  await _deletePdf(pdf['filename']);
                }
              },
            ),
          ),
        ),
      );
    },
  );
}

  Widget _buildGeneratedQuizzesList(BuildContext context) {

    if (_quizIsLoading) {
    return const Center(child: CircularProgressIndicator(color: Colors.orange));
    }

    if (_uploadedQuizzes.isEmpty) {
      return Center(
        child: Text(
          S.of(context).noQuizzesText,
          style: TextStyle(
            fontSize: MediaQuery.of(context).size.width * 0.04,
          ),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _uploadedQuizzes.length,
      itemBuilder: (context, index) {
        final quiz = _uploadedQuizzes[index];
        return InkWell(
          onTap: () {
            Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TeacherQuizPreviewScreen(
                quiz: quiz,
                updateLocale: widget.updateLocale,
              ),
            ),
          );
          },
          child: Card(
            margin: EdgeInsets.symmetric(
              vertical: MediaQuery.of(context).size.height * 0.01),
          child: ListTile(
            leading: Icon(Icons.quiz, size: MediaQuery.of(context).size.width * 0.06),
            title: Text(
              quiz['quiz_name'],
              style: TextStyle(
                fontSize: MediaQuery.of(context).size.width * 0.04,
              ),
            ),
            trailing: IconButton(
              icon: Icon(Icons.delete, size: MediaQuery.of(context).size.width * 0.06, color: Colors.red,),
              onPressed: () async {
                final confirmed = await _showDeleteConfirmationDialog(quiz['quiz_name']);
                if (confirmed) {
                  await _deleteQuiz(quiz['quiz_name']);
                }
              },
            ),
          ),
          )
        );
      },
    );
  }

Future<bool> _showDeleteConfirmationDialog(String contentName) async {
  return await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(S.of(context).deleteConfirmationTitle),
      content: Text(S.of(context).deleteConfirmationQuest(contentName)),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(S.of(context).deleteConfirmationCancle, style: TextStyle(color: Colors.orange)),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(S.of(context).deleteConfirmationDelete, style: TextStyle(color: Colors.orange)),
        ),
      ],
    ),
  ) ?? false; // Return false if dialog is dismissed
}

Future<void> _deleteQuiz(String quizName) async {
  try {
    final success = await ApiService.deleteQuiz(quizName);
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(S.of(context).deleteConfirmationSuccess( quizName))),
      );
      _fetchUploadedQuizzes();
    }
  } catch (e) { 
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(S.of(context).deleteConfirmationError)),
    );
  }
}

Future<void> _deletePdf(String pdfName) async {
  try {
    final success = await ApiService.deletePdf(pdfName);
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(S.of(context).deleteConfirmationSuccess( pdfName))),
      );
      _fetchUploadedPdfs();
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(S.of(context).deleteConfirmationError)),
    );
  }
}
}