import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_application_1/services/shared_preferences_service.dart';
import '../../components/models/take_quiz_model.dart';
import '../../generated/l10n.dart';
import '../../services/api_services.dart';
import 'quiz_attempts_screen.dart';
import '../common_screens/shared_variables.dart';

class TakeQuizScreen extends StatefulWidget {
  final Quiz quiz;
  final Function(Locale) updateLocale;
  final int? customTimeLimitMinutes;

  const TakeQuizScreen({
    super.key, 
    required this.quiz, 
    required this.updateLocale,
    this.customTimeLimitMinutes,
  });

  @override
  _TakeQuizScreenState createState() => _TakeQuizScreenState();
}

class _TakeQuizScreenState extends State<TakeQuizScreen> {
  late Map<String, String?> _selectedAnswers;
  late DateTime _startTime;
  late Timer? _timer;
  int _remainingTime = 0;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _selectedAnswers = {};
    _startTime = DateTime.now();
    _remainingTime = SharedVariables.quizTimeMinutes * 60;
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingTime > 0) {
          _remainingTime--;
        } else {
          _timer?.cancel();
          _submitQuiz();
        }
      });
    });
  }

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  void _submitQuiz() async {
    if (_isSubmitting) return;

    _timer?.cancel();
    setState(() => _isSubmitting = true);

    try {
      final prefs = SharedPreferencesService.instance;
      final token = prefs.getString('auth_token');

      if (token == null) {
        throw Exception("Authentication token not found");
      }

      final List<Map<String, dynamic>> responses = widget.quiz.questions.map((q) {
        final selected = _selectedAnswers[q.question] ?? "";
        final correct = q.options.firstWhere((opt) => opt.isCorrect).text;
        final isCorrect = selected == correct;

        return {
          "question": q.question,
          "selected_answer": selected,
          "is_correct": isCorrect,
          "correct_answer": correct,
        };
      }).toList();

      final correctAnswers = responses.where((r) => r['is_correct'] == true).length;

      final Map<String, dynamic> body = {
        "quiz_name": widget.quiz.title,
        "total_questions": widget.quiz.questions.length,
        "correct_answers": correctAnswers,
        "score_percentage": (correctAnswers / widget.quiz.questions.length) * 100,
        "time_taken_seconds": DateTime.now().difference(_startTime).inSeconds,
        "responses": responses,
      };

      final response = await http.post(
        Uri.parse("${ApiService.baseUrl}/quiz-attempts"),
        headers: {
          'Content-Type': 'application/json',
          'authorization': token,
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);

        // Show the result in a dialog, then pop to home or results list
        await showDialog(
          context: context,
          builder: (context) => Dialog(
            insetPadding: EdgeInsets.all(16),
            child: QuizAttemptDetailScreen(
              attempt: result,
              updateLocale: widget.updateLocale,
            ),
          ),
        );
        // After closing the dialog, pop this screen
        if (mounted) Navigator.of(context).pop();
      } else {
        throw Exception('Failed to submit quiz: ${response.body}');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(S.of(context).quizSubmitError(e.toString()))),
      );
    } finally {
      setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.quiz.title),
        actions: [
          Container(
            margin: const EdgeInsets.all(8),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 255, 242, 220),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.orange),
            ),
            child: Text(
              _formatTime(_remainingTime),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.orange,
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.separated(
                itemCount: widget.quiz.questions.length,
                separatorBuilder: (context, index) => const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  final question = widget.quiz.questions[index];
                  return _buildQuestionCard(question);
                },
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isSubmitting ? null : _submitQuiz,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                backgroundColor: Colors.orange,
              ),
              child: _isSubmitting
                  ? const CircularProgressIndicator(color: Colors.white)
                  : Text(
                      S.of(context).submitQuiz, 
                      style: const TextStyle(color: Colors.white),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestionCard(MCQQuestion question) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              S.of(context).quizQuestion(question.question),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Column(
              children: question.options.map((option) {
                return RadioListTile<String>(
                  fillColor: const WidgetStatePropertyAll(Colors.orange),
                  title: Text(S.of(context).quizOption(option.text)),
                  value: option.text,
                  groupValue: _selectedAnswers[question.question],
                  onChanged: _isSubmitting ? null : (String? value) {
                    setState(() {
                      _selectedAnswers[question.question] = value;
                    });
                  },
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}