import 'package:dash_chat_2/dash_chat_2.dart';

class AiTutorData {
  final List<ChatMessage> messages;
  final bool isLoading;

  AiTutorData({required this.messages, required this.isLoading});

  AiTutorData copyWith({List<ChatMessage>? messages, bool? isLoading}) {
    return AiTutorData(
      messages: messages ?? this.messages,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
