import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindmint/resources/color.dart';
import 'package:mindmint/utils/routes/routes_name.dart';
import 'package:mindmint/view_model/home_services_notifier.dart';

class SelectCategoryScreen extends ConsumerWidget {
  const SelectCategoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = ref.watch(allQuizProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Select Category",
          style: TextStyle(color: AppColors.black),
        ),
        centerTitle: true,
        backgroundColor: AppColors.white,
        iconTheme: const IconThemeData(color: AppColors.black),
      ),
      backgroundColor: AppColors.white,
      body: ListView.builder(
        itemCount: categories.length,
        padding: const EdgeInsets.all(16),
        itemBuilder: (context, index) {
          final category = categories[index];

          return GestureDetector(
            onTap: () {
              Navigator.pushNamed(
                context,
                RoutesName.questionScreen,
                arguments: {
                  'quizUrl': category.quizUrl,
                  'title': category.title,
                },
              );
            },
            child: Card(
              color: AppColors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 4,
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: ListTile(
                contentPadding: const EdgeInsets.all(12),
                leading: Image.asset(category.image, height: 40, width: 40),
                title: Text(
                  category.title,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                subtitle: Text("${category.questions} Questions"),
                trailing: const Icon(Icons.arrow_forward_ios),
              ),
            ),
          );
        },
      ),
    );
  }
}
