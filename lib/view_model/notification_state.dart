class NotificationState {
  final int unseenCount;
  final List<String> notifications;

  NotificationState({this.unseenCount = 0, this.notifications = const []});

  // copyWith method for immutable state
  NotificationState copyWith({int? unseenCount, List<String>? notifications}) {
    return NotificationState(
      unseenCount: unseenCount ?? this.unseenCount,
      notifications: notifications ?? this.notifications,
    );
  }
}
