class Quiz {
  final String id;
  final String title;
  final List<MCQQuestion> questions;
  final int? timeLimitMinutes;

  const Quiz({
    required this.id,
    required this.title,
    required this.questions,
    this.timeLimitMinutes,
  });

  factory Quiz.fromJson(Map<String, dynamic> json) {
    return Quiz(
      id: json['_id'],
      title: json['quiz_name'],
      questions: (json['paragraphs_qa_pairs'] as List)
          .map((qa) => MCQQuestion.fromJson(qa))
          .toList(),
      timeLimitMinutes: json['time_limit_minutes'] != null ? int.tryParse(json['time_limit_minutes'].toString()) : null,
    );
  }
}

class MCQQuestion {
  final String question;
  final String answer;
  final List<MCQOption> options;

  const MCQQuestion({
    required this.question,
    required this.answer,
    required this.options,
  });

  factory MCQQuestion.fromJson(Map<String, dynamic> json) {
    return MCQQuestion(
      question: json['question'],
      answer: json['answer'],
      options: (json['options'] as List)
          .map((option) => MCQOption(
                text: option,
                isCorrect: option == json['answer'],
              ))
          .toList(),
    );
  }
}

class MCQOption {
  final String text;
  final bool isCorrect;

  const MCQOption({
    required this.text,
    required this.isCorrect,
  });
}


class QuizAttempt {
  final String quizId;
  final String studentId;
  final DateTime startedAt;
  final DateTime? completedAt;
  final Map<String, String?> answers;
  final int? score;

  const QuizAttempt({
    required this.quizId,
    required this.studentId,
    required this.startedAt,
    this.completedAt,
    required this.answers,
    this.score,
  });
}