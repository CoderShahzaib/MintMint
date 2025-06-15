import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindmint/model/allquiz_model.dart';
import 'package:mindmint/model/categories_model.dart';
import 'package:mindmint/view_model/home_services_notifier.dart';

final categoryRowsProvider = StreamProvider<List<CategoryRowData>>((ref) {
  final databaseRef = FirebaseDatabase.instance.ref('quizResults');
  final allQuizList = ref.watch(allQuizProvider); // Get the local images

  return databaseRef.onValue.map((event) {
    final data = event.snapshot.value as Map<dynamic, dynamic>?;

    if (data == null) return [];

    return data.entries.map((entry) {
      final value = entry.value as Map<dynamic, dynamic>;

      final categoryTitle = value['categoryName']?.toString() ?? 'N/A';

      // Try to find matching quiz data from allQuiz
      final match = allQuizList.firstWhere(
        (quiz) => quiz.title.toLowerCase() == categoryTitle.toLowerCase(),
        orElse:
            () => AllquizModel(
              title: categoryTitle,
              image: 'assets/default_category.png',
              questions: 0,
              quizUrl: '',
            ),
      );

      return CategoryRowData(
        title: categoryTitle,
        image: match.image, // Use matched image
        questions:
            int.tryParse(value['totalQuestions']?.toString() ?? '0') ?? 0,
        percentage:
            (value['scorePercent'] is double)
                ? value['scorePercent']
                : double.tryParse(value['scorePercent'].toString()) ?? 0.0,
      );
    }).toList();
  });
});
