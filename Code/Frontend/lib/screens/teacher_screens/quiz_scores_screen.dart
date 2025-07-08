import 'package:flutter/material.dart';
import 'package:flutter_application_1/generated/l10n.dart';
import '../../components/widgets/custom_app_bar.dart';
import '../../services/api_services.dart';

class QuizResultsScreen extends StatefulWidget {
  const QuizResultsScreen({super.key});

  @override
  State<QuizResultsScreen> createState() => _QuizResultsScreenState();
}

class _QuizResultsScreenState extends State<QuizResultsScreen> {
  List<Map<String, dynamic>> _quizzes = [];
  String? _selectedQuizName;
  Map<String, dynamic>? _quizStatistics;
  List<Map<String, dynamic>> _studentScores = [];
  bool _isLoading = true;
  bool _isQuizLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchQuizzes();
  }

  Future<void> _fetchQuizzes() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final quizzes = await ApiService.getUploadedQuizzes();
      setState(() {
        _quizzes = quizzes;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _error = e.toString();
      });
    }
  }

  Future<void> _fetchQuizResults(String quizName) async {
    setState(() {
      _isQuizLoading = true;
      _quizStatistics = null;
      _studentScores = [];
      _error = null;
    });
    try {
      final stats = await ApiService.getQuizStatistics(quizName);
      final scores = await ApiService.getQuizScores(quizName);
      setState(() {
        _quizStatistics = stats;
        _studentScores = scores;
        _isQuizLoading = false;
      });
    } catch (e) {
      setState(() {
        _isQuizLoading = false;
        _error = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: CustomAppBar(
        title: S.of(context).quizScoresTitle,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(screenWidth * 0.04),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                S.of(context).quizResultsSubtitle,
                style: TextStyle(
                  fontSize: screenWidth * 0.05,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: screenHeight * 0.02),
              _isLoading
                  ? const Center(child: CircularProgressIndicator(color: Colors.orange))
                  : _quizzes.isEmpty
                      ? Center(
                          child: Text(
                            S.of(context).noQuizzesText,
                            style: TextStyle(fontSize: screenWidth * 0.04),
                          ),
                        )
                      : DropdownButton<String>(
                          value: _selectedQuizName,
                          hint: Text(S.of(context).quizNameDropMenu),
                          isExpanded: true,
                          items: _quizzes.map((quiz) {
                            final name = quiz['quiz_name'] ?? 'Unknown Quiz';
                            return DropdownMenuItem<String>(
                              value: name,
                              child: Text(name),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedQuizName = value;
                            });
                            if (value != null) {
                              _fetchQuizResults(value);
                            }
                          },
                        ),
              SizedBox(height: screenHeight * 0.02),
              if (_isQuizLoading)
                const Center(child: CircularProgressIndicator(color: Colors.orange)),
              if (_error != null)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    _error!,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              if (_quizStatistics != null && _selectedQuizName != null)
                Expanded(
                  child: ListView(
                    children: [
                      Card(
                        margin: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
                        child: Padding(
                          padding: EdgeInsets.all(screenWidth * 0.04),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _selectedQuizName!,
                                style: TextStyle(
                                  fontSize: screenWidth * 0.04,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: screenHeight * 0.01),
                              _buildResultRow(S.of(context).averageScoreLabel, '${_quizStatistics!['average_score']?.toStringAsFixed(2) ?? '0'}%'),
                              SizedBox(height: screenHeight * 0.01),
                              _buildResultRow(S.of(context).highestScoreLabel, '${_quizStatistics!['highest_score']?.toStringAsFixed(2) ?? '0'}%'),
                              SizedBox(height: screenHeight * 0.01),
                              _buildResultRow(S.of(context).lowestScoreLabel, '${_quizStatistics!['lowest_score']?.toStringAsFixed(2) ?? '0'}%'),
                              SizedBox(height: screenHeight * 0.02),
                              Text(
                                S.of(context).studentScoresLabel,
                                style: TextStyle(
                                  fontSize: screenWidth * 0.04,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: screenHeight * 0.01),
                              if (_studentScores.isEmpty)
                                Text(S.of(context).noQuizResults),
                              ..._studentScores.map((score) {
                                return Padding(
                                  padding: EdgeInsets.symmetric(vertical: screenHeight * 0.005),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        score['student_name'] ?? 'Unknown Student',
                                        style: TextStyle(fontSize: screenWidth * 0.035),
                                      ),
                                      Text(
                                        '${score['best_score']?.toStringAsFixed(2) ?? '0'}%',
                                        style: TextStyle(
                                          fontSize: screenWidth * 0.035,
                                          fontWeight: FontWeight.bold,
                                          color: _getScoreColor(score['best_score']),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResultRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: MediaQuery.of(context).size.width * 0.035,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: MediaQuery.of(context).size.width * 0.035,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Color _getScoreColor(dynamic score) {
    if (score == null) return Colors.grey;
    final numericScore = double.tryParse(score.toString()) ?? 0;
    if (numericScore >= 80) return Colors.green;
    if (numericScore >= 60) return Colors.orange;
    return Colors.red;
  }
} 