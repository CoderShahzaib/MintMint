import 'package:flutter/material.dart';
import 'package:mindmint/resources/color.dart';
import 'package:mindmint/utils/routes/routes_name.dart';
import 'package:mindmint/view/quiz_screen.dart';
import 'package:firebase_database/firebase_database.dart';

class ResultScreen extends StatelessWidget {
  final int totalQuestions;
  final int correctAnswer;
  final String categoryUrl;
  final String categoryName;
  final String scorePercent;

  const ResultScreen({
    super.key,
    required this.totalQuestions,
    required this.correctAnswer,
    required this.categoryUrl,
    required this.categoryName,
    required this.scorePercent,
  });
  void _sendResultToFirebase() {
    final dbRef = FirebaseDatabase.instance.ref().child('quizResults');
    dbRef.push().set({
      'totalQuestions': totalQuestions,
      'correctAnswer': correctAnswer,
      'categoryUrl': categoryUrl,
      "incorrectAnswer": totalQuestions - correctAnswer,
      "timeStamp": DateTime.now().toIso8601String(),
      "categoryName": categoryName,
      "scorePercent": scorePercent,
    });
  }

  @override
  Widget build(BuildContext context) {
    _sendResultToFirebase();
    final incorrectAnswers = totalQuestions - correctAnswer;
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.quizScreenColor,
      appBar: AppBar(
        title: const Text("Quiz Result"),
        centerTitle: true,
        backgroundColor: AppColors.quizScreenColor,
        elevation: 0,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '🎉 Your Score 🎉',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: AppColors.black,
                ),
              ),
              SizedBox(height: screenHeight * 0.05),
              Container(
                width: screenWidth * 0.7,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.grey.withOpacity(0.5),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      'Score: $scorePercent%',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Correct: $correctAnswer',
                      style: TextStyle(
                        fontSize: 18,
                        color: AppColors.green,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Incorrect: $incorrectAnswers',
                      style: TextStyle(
                        fontSize: 18,
                        color: AppColors.red,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: screenHeight * 0.08),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder:
                          (_) => QuizScreen(
                            categoryUrl: categoryUrl,
                            categoryName: categoryName,
                          ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.sky,
                  minimumSize: Size(screenWidth * 0.7, 50),
                ),
                child: const Text(
                  "Play Again",
                  style: TextStyle(fontSize: 18, color: AppColors.white),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(
                    context,
                  ).pushNamedAndRemoveUntil(RoutesName.home, (route) => false);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.black,
                  minimumSize: Size(screenWidth * 0.7, 50),
                ),
                child: const Text(
                  "Home",
                  style: TextStyle(fontSize: 18, color: AppColors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
