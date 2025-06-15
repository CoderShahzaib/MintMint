import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:mindmint/repository/home_repository.dart';
import 'package:mindmint/resources/color.dart';
import 'package:mindmint/resources/components/question_card.dart';
import 'package:mindmint/view/result_screen.dart';
import 'package:mindmint/view_model/questions_screen.dart';
import 'package:mindmint/view_model/quiz_controller.dart';
import 'package:mindmint/view_model/score_controller.dart';

class QuizScreen extends ConsumerStatefulWidget {
  final String categoryUrl;
  final String categoryName;
  const QuizScreen({
    super.key,
    required this.categoryUrl,
    required this.categoryName,
  });

  @override
  ConsumerState<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends ConsumerState<QuizScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(quizIndexProvider.notifier).reset();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(generalKnowledgeProvider(widget.categoryUrl));
    final currentIndex = ref.watch(quizIndexProvider);
    var unescape = HtmlUnescape();

    return Scaffold(
      backgroundColor: AppColors.quizScreenColor,
      appBar: AppBar(
        title: Text(
          "Question No. ${currentIndex + 1}",
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        centerTitle: true,
        backgroundColor: AppColors.quizScreenColor,
        elevation: 0,
      ),
      body: SafeArea(
        child: state.when(
          data: (questions) {
            if (currentIndex >= questions.results.length) {
              Future.microtask(() {
                final score = ref.read(scoreProvider);
                ref.read(quizIndexProvider.notifier).reset();
                ref.read(QuestionProvider.notifier).reset();
                ref.read(scoreProvider.notifier).reset();

                if (context.mounted) {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder:
                          (_) => ResultScreen(
                            totalQuestions: questions.results.length,
                            correctAnswer: score,
                            categoryUrl: widget.categoryUrl,
                            categoryName: widget.categoryName,
                            scorePercent: ((score / questions.results.length) *
                                    100)
                                .toStringAsFixed(1),
                          ),
                    ),
                  );
                }
              });
              return const SizedBox.shrink();
            }

            final q = questions.results[currentIndex];
            final options = [
              ...q.incorrectAnswers.map((e) => unescape.convert(e.toString())),
              unescape.convert(q.correctAnswer.toString()),
            ]..shuffle();
            Future.microtask(() {
              final questionState = ref.read(QuestionProvider);
              if (questionState.options.isEmpty ||
                  questionState.selectedAnswer != null) {
                ref.read(QuestionProvider.notifier).setQuestion(options);
              }
            });

            return QuestionCard(
              key: ValueKey(currentIndex),
              question: unescape.convert(q.question.toString()),
              options: options,
              correctAnswer: unescape.convert(q.correctAnswer.toString()),
              onNext: (selectedAnswer) {
                ref.read(quizIndexProvider.notifier).nextQuestion();
              },
            );
          },
          error: (error, _) {
            String message = "Something went wrong.";
            if (error.toString().contains("429")) {
              message = "Too many requests. Retrying in a moment...";
            }

            return Center(
              child: Text(
                "Error: $message",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  color: AppColors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          },
          loading:
              () => const Center(
                child: CircularProgressIndicator(color: AppColors.sky),
              ),
        ),
      ),
    );
  }
}
