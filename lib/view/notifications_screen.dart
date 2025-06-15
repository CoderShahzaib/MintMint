import 'package:flutter/material.dart';
import 'package:mindmint/model/notification_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  void _confirmClearAll(BuildContext context, Box<NotificationModel> box) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text("Clear All Notifications"),
            content: const Text(
              "Are you sure you want to delete all notifications?",
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("Cancel"),
              ),
              TextButton(
                onPressed: () {
                  box.clear();
                  Navigator.of(context).pop();
                },
                child: const Text(
                  "Delete All",
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notifications"),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep),
            onPressed: () {
              final box = Hive.box<NotificationModel>('notifications');
              if (box.isNotEmpty) {
                _confirmClearAll(context, box);
              }
            },
          ),
        ],
      ),
      body: ValueListenableBuilder<Box<NotificationModel>>(
        valueListenable:
            Hive.box<NotificationModel>('notifications').listenable(),
        builder: (context, box, _) {
          final notifications = box.values.toList().reversed.toList();
          final keys = box.keys.toList().reversed.toList();

          if (notifications.isEmpty) {
            return const Center(child: Text("No notifications yet"));
          }

          return ListView.separated(
            itemCount: notifications.length,
            padding: const EdgeInsets.all(12),
            separatorBuilder: (_, __) => const Divider(),
            itemBuilder: (context, index) {
              final notification = notifications[index];
              final key = keys[index];

              return ListTile(
                leading: const Icon(Icons.notifications),
                title: Text(notification.title),
                subtitle: Text(notification.body),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "${notification.time.hour.toString().padLeft(2, '0')}:${notification.time.minute.toString().padLeft(2, '0')}",
                      style: const TextStyle(fontSize: 12),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        box.delete(key);
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
