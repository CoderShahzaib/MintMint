import 'package:flutter/material.dart';
import 'package:mindmint/resources/color.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindmint/resources/components/progress_bar_list.dart';
import 'package:mindmint/view_model/categories_rows_provider.dart';

class ProgressbarScreen extends ConsumerStatefulWidget {
  const ProgressbarScreen({super.key});

  @override
  ConsumerState<ProgressbarScreen> createState() => _ProgressbarScreenState();
}

class _ProgressbarScreenState extends ConsumerState<ProgressbarScreen> {
  @override
  Widget build(BuildContext context) {
    final categoryAsync = ref.watch(categoryRowsProvider);
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: const Text("Progress Bar"),
        centerTitle: true,
        backgroundColor: AppColors.white,
      ),
      body: Hero(
        tag: 'progressbarList',
        child: categoryAsync.when(
          data: (rows) {
            return ListView.builder(
              itemCount: rows.length,
              itemBuilder: (context, index) {
                return ProgressBarList(data: rows[index]);
              },
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(child: Text('Error: $error')),
        ),
      ),
    );
  }
}
