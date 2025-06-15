class GeneralKnowledge {
  GeneralKnowledge({required this.responseCode, required this.results});

  final int? responseCode;
  final List<Result> results;

  factory GeneralKnowledge.fromJson(Map<String, dynamic> json) {
    return GeneralKnowledge(
      responseCode: json["response_code"],
      results:
          json["results"] == null
              ? []
              : List<Result>.from(
                json["results"]!.map((x) => Result.fromJson(x)),
              ),
    );
  }
}

class Result {
  Result({
    required this.type,
    required this.difficulty,
    required this.category,
    required this.question,
    required this.correctAnswer,
    required this.incorrectAnswers,
  });

  final String? type;
  final String? difficulty;
  final String? category;
  final String? question;
  final String? correctAnswer;
  final List<String> incorrectAnswers;

  factory Result.fromJson(Map<String, dynamic> json) {
    return Result(
      type: json["type"],
      difficulty: json["difficulty"],
      category: json["category"],
      question: json["question"],
      correctAnswer: json["correct_answer"],
      incorrectAnswers:
          json["incorrect_answers"] == null
              ? []
              : List<String>.from(json["incorrect_answers"]!.map((x) => x)),
    );
  }
}
