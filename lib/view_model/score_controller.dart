import 'package:flutter_riverpod/flutter_riverpod.dart';

class ScoreController extends StateNotifier<int> {
  ScoreController() : super(0);
  void increment() => state++;
  void reset() => state = 0;
}

final scoreProvider = StateNotifierProvider<ScoreController, int>(
  (ref) => ScoreController(),
);
