import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_application_1/screens/common_screens/shared_variables.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import '../../components/models/generated_quiz_model.dart';
import '../../components/widgets/custom_text_form_field.dart';
import '../../generated/l10n.dart';
import '../../services/api_services.dart';
import '../../components/widgets/custom_app_bar.dart';

class GenerateQuizScreen extends StatefulWidget {
  final String? existingPdfPath;

  const GenerateQuizScreen({super.key, this.existingPdfPath});

  @override
  _GenerateQuizScreenState createState() => _GenerateQuizScreenState();
}

class _GenerateQuizScreenState extends State<GenerateQuizScreen> {
  
  PlatformFile? _selectedFile;
  bool _isGenerating = false;
  List<MCQQuestion> _generatedQuestions = [];
  int _numberOfQuestions = 5;
  final _subject = TextEditingController();
  final _topicController = TextEditingController();
  List<Map<String, dynamic>> _uploadedPdfs = [];
  bool _isLoadingPdfs = false;

  @override
  void initState() {
    super.initState();
    if (widget.existingPdfPath != null) {
      _selectedFile = PlatformFile(
        name: widget.existingPdfPath!.split('/').last,
        path: widget.existingPdfPath,
        size: 0,
      );
    }
    _fetchUploadedPdfs();
  }

  Future<void> _fetchUploadedPdfs() async {
    setState(() {
      _isLoadingPdfs = true;
    });

    try {
      final pdfs = await ApiService.getUploadedPdfs();
      setState(() {
        _uploadedPdfs = pdfs;
        _isLoadingPdfs = false;
      });
    } catch (e) {
      setState(() {
        _isLoadingPdfs = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(S.of(context).failedToLoadPDFs(e.toString()))),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    Locale currentLocale = Localizations.localeOf(context);
    String languageCode = currentLocale.languageCode;

    return Scaffold(
      appBar: CustomAppBar(
        title: S.of(context).generateQuizTitle,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(screenWidth * 0.04),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildFilePicker(screenWidth, screenHeight, languageCode),
            SizedBox(height: screenHeight * 0.02),
            _buildConfigurationOptions(screenWidth, screenHeight, languageCode),
            SizedBox(height: screenHeight * 0.02),
            _buildGenerateButton(screenWidth, screenHeight, languageCode),
            SizedBox(height: screenHeight * 0.03),
            _buildResultsSection(screenWidth, screenHeight, languageCode),
          ],
        ),
      ),
    );
  }

Widget _buildFilePicker(double screenWidth, double screenHeight, String languageCode) {
    return Container(
      width: double.infinity,
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(screenWidth * 0.04),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                S.of(context).uploadPdfTitle,
                style: TextStyle(
                  fontSize: screenWidth * 0.05,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: screenHeight * 0.01),
              Text(
                _selectedFile?.name ?? S.of(context).noFileSelected,
                style: const TextStyle(
                  color: Colors.grey,
                ),
              ),
              SizedBox(height: screenHeight * 0.015),
              Column(
                children: [
                  ElevatedButton.icon(
                    onPressed: _pickFile,
                    icon: const Icon(
                      Icons.upload_file,
                      color: Colors.orange,
                    ),
                    label: Text(
                      S.of(context).selectPdfButton,
                      style: TextStyle(
                        color: Colors.orange,
                        fontSize: languageCode == 'ar' ? screenWidth * 0.045 : screenWidth * 0.04,
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  ElevatedButton.icon(
                    onPressed: _selectFromUploadedPdfs,
                    icon: const Icon(
                      Icons.folder_open,
                      color: Colors.orange,
                    ),
                    label: Text(
                      S.of(context).selectFromUploaded,
                      style: TextStyle(
                        color: Colors.orange,
                        fontSize: languageCode == 'ar' ? screenWidth * 0.045 : screenWidth * 0.04,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

Widget _buildConfigurationOptions(double screenWidth, double screenHeight, String languageCode) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(screenWidth * 0.04),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              S.of(context).quizConfigTitle,
              style: TextStyle(
                fontSize: screenWidth * 0.05,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: screenHeight * 0.015),
            CustomTextField(
              controller: _subject,
              labelText: S.of(context).subjectLabel,
              isRequired: true,
            ),
            SizedBox(height: screenHeight * 0.015),
            CustomTextField(
              controller: _topicController,
              labelText: S.of(context).topicLabel,
              isRequired: true,
            ),
            SizedBox(height: screenHeight * 0.015),
            Text(
              '${S.of(context).quizTimeLabel.replaceFirst(':', '')} (${SharedVariables.quizTimeMinutes})',
              style: TextStyle(
                fontSize: screenWidth * 0.04,
              ),
            ),
            Slider(
              value: SharedVariables.quizTimeMinutes.toDouble(),
              min: 1,
              max: 120,
              divisions: 120,
              label: SharedVariables.quizTimeMinutes.toString(),
              onChanged: (value) {
                setState(() {
                  SharedVariables.quizTimeMinutes = value.toInt();
                });
              },
              thumbColor: Colors.orange,
              activeColor: Colors.orange,
            ),
            SizedBox(height: screenHeight * 0.015),
            Text(
              S.of(context).numberOfQuestions(_numberOfQuestions),
              style: TextStyle(
                fontSize: screenWidth * 0.04,
              ),
            ),
            Slider(
              value: _numberOfQuestions.toDouble(),
              min: 3,
              max: 20,
              divisions: 17,
              label: _numberOfQuestions.toString(),
              onChanged: (value) {
                setState(() {
                  _numberOfQuestions = value.toInt();
                });
              },
              thumbColor: Colors.orange,
              activeColor: Colors.orange,
            ),
            SizedBox(height: screenHeight * 0.015),
          ],
        ),
      ),
    );
  }

Widget _buildGenerateButton(double screenWidth, double screenHeight, String languageCode) {
    return Center(
      child: ElevatedButton.icon(
        onPressed: _selectedFile == null || _isGenerating ? null : _generateQuiz,
        icon: _isGenerating 
            ? const CircularProgressIndicator(color: Colors.white)
            : const Icon(
                Icons.auto_awesome,
                color: Colors.orange,
              ),
        label: Text(
          _isGenerating ? S.of(context).generatingButton : S.of(context).generateButton,
          style: TextStyle(
            color: Colors.orange,
            fontSize: languageCode == 'ar' ? screenWidth * 0.045 : screenWidth * 0.04,
          ),
        ),
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.06,
            vertical: screenHeight * 0.015,
          ),
        ),
      ),
    );
  }

Widget _buildResultsSection(double screenWidth, double screenHeight, String languageCode) {
    if (_generatedQuestions.isEmpty) return const SizedBox();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          S.of(context).generatedQuestionsTitle,
          style: TextStyle(
            fontSize: screenWidth * 0.05,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: screenHeight * 0.01),
        ..._generatedQuestions.map((question) => _buildQuestionCard(question, screenWidth, screenHeight)).toList(),
        SizedBox(height: screenHeight * 0.02),
        Center(
          child: ElevatedButton(
            onPressed: _saveQuestions,
            child: Text(
              S.of(context).saveQuizButton,
              style: TextStyle(
                color: Colors.orange,
                fontSize: languageCode == 'ar' ? screenWidth * 0.045 : screenWidth * 0.04,
              ),
            ),
          ),
        ),
      ],
    );
  }

Widget _buildQuestionCard(MCQQuestion question, double screenWidth, double screenHeight) {
    return Card(
      margin: EdgeInsets.only(bottom: screenHeight * 0.012),
      child: Padding(
        padding: EdgeInsets.all(screenWidth * 0.04),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              question.question,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: screenWidth * 0.04,
              ),
            ),
            SizedBox(height: screenHeight * 0.008),
            ...question.options.map((option) => Padding(
              padding: EdgeInsets.symmetric(vertical: screenHeight * 0.004),
              child: Row(
                children: [
                  Icon(
                    option.isCorrect ? Icons.check_circle : Icons.radio_button_unchecked,
                    color: option.isCorrect ? Colors.green : null,
                    size: screenWidth * 0.06,
                  ),
                  SizedBox(width: screenWidth * 0.02),
                  Expanded(
                    child: Text(
                      option.text,
                      style: TextStyle(
                        fontSize: screenWidth * 0.04,
                      ),
                    ),
                  ),
                ],
              ),
            )).toList(),
          ],
        ),
      ),
    );
  }

Future<void> _pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles();

      if (result != null) {
        setState(() {
          _selectedFile = result.files.first;
          _generatedQuestions = []; // Clear previous results
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(S.of(context).fileError(e.toString()))),
      );
    }
  }

Future<void> _selectFromUploadedPdfs() async {
    if (_isLoadingPdfs) return;

    if (_uploadedPdfs.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(S.of(context).noMaterialsText)),
      );
      return;
    }

    final selectedPdf = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          S.of(context).selectPdfTitle,
          style: TextStyle(
            fontSize: MediaQuery.of(context).size.width * 0.05,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Container(
          width: double.maxFinite,
          height: MediaQuery.of(context).size.height * 0.4,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: _uploadedPdfs.length,
            itemBuilder: (context, index) {
              final pdf = _uploadedPdfs[index];
              return ListTile(
                leading: Icon(
                  Icons.picture_as_pdf,
                  color: Colors.red,
                  size: MediaQuery.of(context).size.width * 0.06,
                ),
                title: Text(
                  pdf['filename'] ?? S.of(context).untitledPdf,
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.04,
                  ),
                ),
                onTap: () => Navigator.of(context).pop(pdf),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              S.of(context).cancelButton,
              style: TextStyle(
                color: Colors.orange,
                fontSize: MediaQuery.of(context).size.width * 0.04,
              ),
            ),
          ),
        ],
      ),
    );

    if (selectedPdf != null) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator(color: Colors.orange,)),
      );
      try {
        final pdfUrl =
            '${ApiService.baseUrl}/pdfs/${selectedPdf['filename']}';
        final downloadedFile =
            await _downloadPdf(pdfUrl, selectedPdf['filename']);
        Navigator.of(context).pop(); // Close loading dialog
        setState(() {
          _selectedFile = PlatformFile(
            name: downloadedFile.path.split('/').last,
            path: downloadedFile.path,
            size: downloadedFile.lengthSync(),
          );
          _generatedQuestions = [];
        });
      } catch (e) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to download PDF: ${e.toString()}')),
        );
      }
    }
  }

Future<File> _downloadPdf(String url, String filename) async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final bytes = response.bodyBytes;
      final tempDir = await getTemporaryDirectory();
      final file = File('${tempDir.path}/$filename');
      await file.writeAsBytes(bytes);
      return file;
    } else {
      throw Exception(
          'Failed to download PDF. Status code: ${response.statusCode}');
    }
  }

Future<void> _generateQuiz() async {
    if (_selectedFile == null) return;

    setState(() {
      _isGenerating = true;
      _generatedQuestions = [];
    });

    try {
      final pdfBytes = await File(_selectedFile!.path!).readAsBytes();
      final questions = await _callAIModel(
        pdfBytes: pdfBytes,
        numQuestions: _numberOfQuestions,
        subject: _subject,
        topic: _topicController,
      );

      setState(() {
        _generatedQuestions = questions;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(S.of(context).generationError(e.toString()))),
      );
    } finally {
      setState(() {
        _isGenerating = false;
      });
    }
  }

Future<List<MCQQuestion>> _callAIModel({
  required Uint8List pdfBytes,
  required int numQuestions,
  required TextEditingController subject,
  required TextEditingController topic,
}) async {
  try {
    if (pdfBytes.isEmpty) throw Exception('PDF is empty');
    if (numQuestions <= 0) throw Exception('Invalid question count');
    if (subject.text.isEmpty) throw Exception('Subject is empty');
    if (topic.text.isEmpty) throw Exception('Topic is empty');

    final tempDir = await getTemporaryDirectory();
    final file = File('${tempDir.path}/temp_${DateTime.now().millisecondsSinceEpoch}.pdf');
    await file.writeAsBytes(pdfBytes);

    final response = await ApiService.generateQuiz(
      pdfFile: file,
      quizName: subject.text.trim(),
      numQuestions: numQuestions,
      topic: topic.text.trim(),
    );

    return Quiz.fromApiResponse(response).questions;
  } catch (e) {
    throw Exception('Failed to generate quiz: '+e.toString());
  }
}

Future<void> _saveQuestions() async {
  try {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    // Since generateQuiz already saves, we just need to return
    Navigator.of(context).pop(); // Close loading dialog
    Navigator.of(context).pop(true); // Return true to indicate success
  } catch (e) {
    Navigator.of(context).pop(); // Close loading dialog
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(S.of(context).saveQuizError(e.toString()))),
    );
  }
}
}