class MCQQuestion {
  final String question;
  final List<MCQOption> options;

  const MCQQuestion({required this.question, required this.options});

  factory MCQQuestion.fromJson(Map<String, dynamic> json) {
    final optionsList = json['options'] as List<dynamic>;
    final correctAnswer = json['correct_answer'] as String;
    
    final options = optionsList.map((option) {
      return MCQOption(
        text: option as String,
        isCorrect: option == correctAnswer,
      );
    }).toList();
    
    return MCQQuestion(
      question: json['question'],
      options: options,
    );
  }
}

class MCQOption {
  final String text;
  final bool isCorrect;

  const MCQOption({required this.text, required this.isCorrect});

  factory MCQOption.fromJson(Map<String, dynamic> json) {
    return MCQOption(
      text: json['text'],
      isCorrect: json['is_correct'],
    );
  }
}

class Quiz {
  final String title;
  final int totalQuestions;
  final List<MCQQuestion> questions;

  const Quiz({
    required this.title,
    required this.totalQuestions,
    required this.questions,
  });

  /// Custom factory to parse the nested API structure
  factory Quiz.fromApiResponse(Map<String, dynamic> json) {
    // Get the questions list directly from the response
    final questionsList = (json['questions']) as List;
    
    return Quiz(
      title: json['quiz_name'],  // Using top-level field
      totalQuestions: json['total_questions'],  // Using top-level field
      questions: questionsList
          .map((q) => MCQQuestion.fromJson(q as Map<String, dynamic>))
          .toList(),
    );
  }

  static fromJson(Map<String, dynamic> quiz) {
    return Quiz(
      title: quiz['quiz_name'],
      totalQuestions: quiz['total_questions'],
      questions: quiz['questions'].map((q) => MCQQuestion.fromJson(q)).toList(),
    );
  }

}
