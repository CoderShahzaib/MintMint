import 'package:flutter/material.dart';
import 'package:mindmint/resources/color.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindmint/view_model/questions_screen.dart';

class QuestionCard extends ConsumerStatefulWidget {
  final String question;
  final List<String> options;
  final String correctAnswer;
  final Function(String selectedAnswer) onNext;
  const QuestionCard({
    super.key,
    required this.question,
    required this.options,
    required this.correctAnswer,
    required this.onNext,
  });

  @override
  ConsumerState<QuestionCard> createState() => _QuestionCardState();
}

class _QuestionCardState extends ConsumerState<QuestionCard> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final state = ref.watch(
      QuestionProvider.select((state) => state.selectedAnswer),
    );
    final notifier = ref.read(QuestionProvider.notifier);

    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Text(
                widget.question,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              SizedBox(height: screenHeight * 0.05),
              ...widget.options.map((option) {
                final isSelected = option == state;
                final isCorrect = option == widget.correctAnswer;

                return Padding(
                  padding: EdgeInsets.only(bottom: screenHeight * 0.02),
                  child: OptionTile(
                    text: option,
                    isSelected: isSelected,
                    isCorrect: isCorrect,
                    onTap:
                        state == null
                            ? () {
                              notifier.setSelectedAnswer(
                                option,
                                widget.correctAnswer,
                                ref,
                              );
                            }
                            : null,
                  ),
                );
              }),
              if (state != null)
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Text(
                    state == widget.correctAnswer
                        ? 'Correct!'
                        : 'Wrong! The correct answer is ${widget.correctAnswer}',
                    style: TextStyle(
                      color:
                          state == widget.correctAnswer
                              ? AppColors.green
                              : AppColors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              if (state != null)
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.deepPurple,
                      foregroundColor: AppColors.white,
                      elevation: 5,
                      padding: EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 20,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      textStyle: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                    onPressed: () {
                      widget.onNext(widget.correctAnswer);
                    },
                    child: Text("Next Question"),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class OptionTile extends StatelessWidget {
  final String text;
  final bool isSelected;
  final bool isCorrect;
  final VoidCallback? onTap;

  const OptionTile({
    super.key,
    required this.text,
    required this.onTap,
    this.isSelected = false,
    this.isCorrect = false,
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    Color backgroundColor = AppColors.white;
    Color borderColor = AppColors.grey;
    Color shadowColor = AppColors.grey;

    if (isSelected) {
      backgroundColor = isCorrect ? Colors.green.shade100 : Colors.red.shade100;
      borderColor = isCorrect ? Colors.green : Colors.red;
      shadowColor = isCorrect ? Colors.green.shade300 : Colors.red.shade300;
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: screenHeight * 0.09,
        width: screenWidth * 0.75,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          border: Border.all(color: borderColor, width: 2),
          boxShadow: [
            BoxShadow(
              color: shadowColor,
              blurRadius: isSelected ? 8 : 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: isSelected ? AppColors.black87 : AppColors.black,
            ),
          ),
        ),
      ),
    );
  }
}
