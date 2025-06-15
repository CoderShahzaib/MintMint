import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindmint/model/categories_model.dart';
import 'package:mindmint/resources/color.dart';
import 'package:percent_indicator/percent_indicator.dart';

class ProgressBarList extends ConsumerStatefulWidget {
  final CategoryRowData data;
  const ProgressBarList({super.key, required this.data});

  @override
  ConsumerState<ProgressBarList> createState() => _ProgressBarListState();
}

class _ProgressBarListState extends ConsumerState<ProgressBarList> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            backgroundImage: AssetImage(widget.data.image),
            radius: 28,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.data.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  "Question: ${widget.data.questions}",
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
          CircularPercentIndicator(
            radius: 28,
            lineWidth: 5,
            progressColor: AppColors.sky,
            percent: (widget.data.percentage / 100).clamp(0.0, 1.0),
            center: Text(
              "${widget.data.percentage.toStringAsFixed(1)}%",
              style: const TextStyle(fontSize: 13, color: AppColors.black),
            ),
          ),
        ],
      ),
    );
  }
}
