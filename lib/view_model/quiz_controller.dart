import 'package:flutter_riverpod/flutter_riverpod.dart';

class QuizController extends StateNotifier<int> {
  QuizController() : super(0);
  void nextQuestion() => state++;
  void reset() => state = 0;
}

final quizIndexProvider = StateNotifierProvider<QuizController, int>(
  (ref) => QuizController(),
);
