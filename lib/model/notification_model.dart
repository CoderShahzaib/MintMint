import 'package:hive/hive.dart';

@HiveType(typeId: 0)
class NotificationModel extends HiveObject {
  @HiveField(0)
  final String title;

  @HiveField(1)
  final String body;

  @HiveField(2)
  final DateTime time;

  NotificationModel({
    required this.title,
    required this.body,
    required this.time,
  });
}

// ✅ Manual adapter: no need to generate .g.dart
class NotificationModelAdapter extends TypeAdapter<NotificationModel> {
  @override
  final int typeId = 0;

  @override
  NotificationModel read(BinaryReader reader) {
    return NotificationModel(
      title: reader.readString(),
      body: reader.readString(),
      time: DateTime.fromMillisecondsSinceEpoch(reader.readInt()),
    );
  }

  @override
  void write(BinaryWriter writer, NotificationModel obj) {
    writer.writeString(obj.title);
    writer.writeString(obj.body);
    writer.writeInt(obj.time.millisecondsSinceEpoch);
  }
}
