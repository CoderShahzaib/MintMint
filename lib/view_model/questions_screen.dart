import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindmint/view_model/score_controller.dart';

class QuestionsScreen {
  String? selectedAnswer;
  final List<String> options;

  QuestionsScreen({required this.options, this.selectedAnswer});
  QuestionsScreen copyWith({
    String? selectedAnswer,
    List<String>? options,
    int? correctCount,
  }) => QuestionsScreen(
    options: options ?? this.options,
    selectedAnswer: selectedAnswer ?? this.selectedAnswer,
  );
}

class QuestionNotifier extends StateNotifier<QuestionsScreen> {
  QuestionNotifier() : super(QuestionsScreen(options: []));
  void setSelectedAnswer(
    String? selectedAnswer,
    String correctAnswer,
    WidgetRef ref,
  ) {
    if (state.selectedAnswer != null) return;
    final isCorrect = selectedAnswer == correctAnswer;
    if (isCorrect) {
      ref.read(scoreProvider.notifier).increment();
    }
    state = state.copyWith(selectedAnswer: selectedAnswer);
    print('Selected: $selectedAnswer | Correct: $correctAnswer');
  }

  void setQuestion(List<String> options) {
    state = QuestionsScreen(options: options, selectedAnswer: null);
  }

  void reset() {
    state = QuestionsScreen(options: []);
  }
}

final QuestionProvider =
    StateNotifierProvider<QuestionNotifier, QuestionsScreen>(
      (ref) => QuestionNotifier(),
    );
