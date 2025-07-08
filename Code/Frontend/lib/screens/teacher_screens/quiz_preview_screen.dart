import 'package:flutter/material.dart';
import 'package:flutter_application_1/generated/l10n.dart';
import '../../components/models/take_quiz_model.dart';
import '../../components/widgets/custom_app_bar.dart';
import '../../services/api_services.dart';

class TeacherQuizPreviewScreen extends StatefulWidget {
  final Map<String, dynamic> quiz;
  final Function(Locale) updateLocale;

  const TeacherQuizPreviewScreen({
    super.key,
    required this.quiz,
    required this.updateLocale,
  });

  @override
  State<TeacherQuizPreviewScreen> createState() => _TeacherQuizPreviewScreenState();
}

class _TeacherQuizPreviewScreenState extends State<TeacherQuizPreviewScreen> {

  List<Map<String, dynamic>> _uploadedQuizzes = [];
  bool _isLoading = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: widget.quiz['quiz_name'] ?? S.of(context).untitledQuiz,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.white),
            onPressed: () async {
              final confirmed = await _showDeleteConfirmationDialog(widget.quiz['quiz_name']);
              if (confirmed) {
                await _deleteQuiz(widget.quiz['quiz_name']);
                _fetchUploadedQuizzes();
                Navigator.pop(context, true);
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: (widget.quiz['paragraphs_qa_pairs'] as List).length,
          itemBuilder: (context, index) {
            final qaPair = widget.quiz['paragraphs_qa_pairs'][index];
            final question = MCQQuestion(
              question: qaPair['question'],
              answer: qaPair['answer'],
              options: (qaPair['options'] as List).map((option) => MCQOption(
                text: option,
                isCorrect: option == qaPair['answer'],
              )).toList(),
            );
            return _buildQuestionCard(question);
          },
        ),
      ),
    );

  }

  Widget _buildQuestionCard(MCQQuestion question) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              question.question,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ...question.options.map((option) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  Icon(
                    option.isCorrect 
                      ? Icons.check_circle 
                      : Icons.radio_button_unchecked,
                    color: option.isCorrect ? Colors.green : null,
                  ),
                  const SizedBox(width: 8),
                  Expanded(child: Text(option.text)),
                ],
              ),
            )).toList(),
          ],
        ),
      ),
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
        SnackBar(content: Text(S.of(context).deleteConfirmationSuccess(quizName))),
      );
      // Refresh the quiz list
      _fetchUploadedQuizzes();
    }
  } catch (e) { 
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(S.of(context).deleteConfirmationError)),
    );
  }
}

  Future<void> _fetchUploadedQuizzes() async {
    try {
      final quizzes = await ApiService.getUploadedQuizzes();
      if (mounted) {
        setState(() {
          _uploadedQuizzes = quizzes;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(S.of(context).failedToLoadQuizzes(e.toString()))),
        );
      }
    }
  }
}