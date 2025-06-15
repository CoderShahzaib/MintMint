import 'package:flutter/material.dart';
import 'package:mindmint/resources/color.dart';
import 'package:mindmint/resources/components/home_components.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindmint/view_model/home_services_notifier.dart';

class AllQuiz extends ConsumerStatefulWidget {
  const AllQuiz({super.key});

  @override
  ConsumerState<AllQuiz> createState() => _AllQuizState();
}

class _AllQuizState extends ConsumerState<AllQuiz> {
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    final state = ref.watch(homeServicesProvider);
    final notifier = ref.read(homeServicesProvider.notifier);
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: const Text("All Quizzes"),
        centerTitle: true,
        backgroundColor: AppColors.white,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: TextField(
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  borderSide: BorderSide(color: Colors.black),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  borderSide: BorderSide(color: Colors.black),
                ),
                labelText: 'Search',
              ),
              onChanged: (value) {
                ref.read(homeServicesProvider.notifier).filterItems(value);
              },
            ),
          ),
          SizedBox(height: screenHeight * 0.02),
          Expanded(child: AllQuizScreen()),
        ],
      ),
    );
  }
}
