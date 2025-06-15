import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindmint/view_model/notification_state.dart';

class NotificationStateNotifier extends StateNotifier<NotificationState> {
  NotificationStateNotifier() : super(NotificationState());

  // Method to update unseen notification count
  void updateUnseenCount(int count) {
    state = state.copyWith(
      unseenCount: count,
    ); // Using copyWith to update state
  }

  // Method to reset unseen notification count
  void resetUnseenCount() {
    state = state.copyWith(unseenCount: 0); // Reset unseen count
  }
}

final notificationStateProvider =
    StateNotifierProvider<NotificationStateNotifier, NotificationState>(
      (ref) => NotificationStateNotifier(),
    );
