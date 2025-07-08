import 'package:flutter/material.dart';
import '../../generated/l10n.dart';
import '../../components/widgets/custom_app_bar.dart';
import '../../services/api_services.dart';
import 'package:url_launcher/url_launcher.dart';

class QuizResultsScreen extends StatefulWidget {
  final Function(Locale) updateLocale;
  const QuizResultsScreen({Key? key, required this.updateLocale}) : super(key: key);

  @override
  State<QuizResultsScreen> createState() => _QuizResultsScreenState();
}

class _QuizResultsScreenState extends State<QuizResultsScreen> {
  List<Map<String, dynamic>> _attempts = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchAttempts();
  }

  Future<void> _fetchAttempts() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final attempts = await ApiService.getQuizAttempts();
      setState(() {
        _attempts = attempts;
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
    final languageCode = Localizations.localeOf(context).languageCode;
    return Scaffold(
      appBar: CustomAppBar(
        title: S.of(context).quizResultsTitle,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.orange))
          : _error != null
              ? Center(child: Text(_error!))
              : _attempts.isEmpty
                  ? Center(child: Text(S.of(context).noQuizzesText))
                  : ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: _attempts.length,
                      separatorBuilder: (context, index) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final attempt = _attempts[index];
                        return ListTile(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          tileColor: Colors.grey[100],
                          title: Text(attempt['quiz_name'] ?? 'Quiz', style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text('${S.of(context).yourScore}: ${attempt['score_percentage']?.toStringAsFixed(1) ?? '--'}%'),
                          trailing: const Icon(Icons.arrow_forward_ios, size: 18),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => QuizAttemptDetailScreen(
                                  attempt: attempt,
                                  updateLocale: widget.updateLocale,
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
    );
  }
}

class QuizAttemptDetailScreen extends StatelessWidget {
  final Map<String, dynamic> attempt;
  final Function(Locale) updateLocale;
  const QuizAttemptDetailScreen({Key? key, required this.attempt, required this.updateLocale}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final correctAnswers = attempt['correct_answers'] ?? 0;
    final totalQuestions = attempt['total_questions'] ?? 0;
    final responses = List<Map<String, dynamic>>.from(attempt['responses'] ?? []);
    final youtubeResources = attempt['youtube_resources'] as Map<String, dynamic>?;
    final languageCode = Localizations.localeOf(context).languageCode;
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: CustomAppBar(
        title: attempt['quiz_name'] ?? S.of(context).quizResultsTitle,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  Text(
                    S.of(context).yourScore,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text(
                    S.of(context).scoreText(correctAnswers, totalQuestions),
                    style: TextStyle(fontSize: 32, color: Colors.orange),
                  ),
                  SizedBox(height: 20),
                  LinearProgressIndicator(
                    borderRadius: BorderRadius.circular(4),
                    value: totalQuestions > 0 ? correctAnswers / totalQuestions : 0,
                    minHeight: size.height * 0.015,
                    backgroundColor: Colors.grey[200],
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),
            Text(
              S.of(context).questionReview,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: responses.length,
              itemBuilder: (context, index) {
                final r = responses[index];
                final isCorrect = r['is_correct'] ?? false;
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  color: isCorrect ? Colors.green[50] : Colors.red[50],
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(r['question'], style: const TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 10),
                        Text(
                          S.of(context).yourAnswer(r['selected_answer'] ?? S.of(context).notAnswered),
                          style: TextStyle(color: isCorrect ? Colors.green : Colors.red),
                        ),
                        Text(
                          S.of(context).correctAnswer(r['correct_answer']),
                          style: const TextStyle(color: Colors.green),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: 28),
            if (youtubeResources != null && youtubeResources.isNotEmpty) ...[
              Divider(),
              Text(
                S.of(context).recommendedYoutubeResources,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.orange),
              ),
              SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: Column(
                  children: [
                    ...youtubeResources.entries.expand((entry) {
                      final topic = entry.key;
                      final List resources = entry.value;
                      return [
                        // Topic header
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            color: Colors.orange[50],
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(12),
                              topRight: Radius.circular(12),
                            ),
                          ),
                          child: Text(
                            topic,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.orange[800],
                            ),
                          ),
                        ),
                        // URLs as ListTiles
                        ...resources.map<Widget>((res) {
                          final url = res['url'] ?? '';
                          return ListTile(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                            leading: Icon(Icons.play_circle_outline, color: Colors.red[600], size: 24),
                            title: Text(
                              url,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.blue[700],
                                decoration: TextDecoration.underline,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            trailing: IconButton(
                              icon: Icon(Icons.open_in_new, color: Colors.grey[600], size: 18),
                              onPressed: () async {
                                if (await canLaunchUrl(Uri.parse(url))) {
                                  await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
                                }
                              },
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                            ),
                            onTap: () async {
                              if (await canLaunchUrl(Uri.parse(url))) {
                                await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
                              }
                            },
                          );
                        }).toList(),
                      ];
                    }).toList(),
                  ],
                ),
              ),
            ],
            SizedBox(height: 15),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  S.of(context).backToQuizzes,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: languageCode == "en" ? 14 : 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}