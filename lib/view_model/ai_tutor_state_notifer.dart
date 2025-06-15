import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mindmint/view_model/ai_tutor_state.dart';

class AiTutorNotifier extends StateNotifier<AiTutorData> {
  late final GenerativeModel _model;
  late final ChatSession _chat;

  final ChatUser currentUser = ChatUser(id: 'user', firstName: 'User');
  final ChatUser botUser = ChatUser(id: 'ai', firstName: 'QuizBot');

  AiTutorNotifier() : super(AiTutorData(messages: [], isLoading: false)) {
    _model = GenerativeModel(
      model: 'models/gemini-1.5-flash',
      apiKey: dotenv.env['AI_API_KEY']!,
    );
    _chat = _model.startChat();
  }

  Future<void> onSend(String text) async {
    final userMessage = ChatMessage(
      user: currentUser,
      createdAt: DateTime.now(),
      text: text,
    );

    state = state.copyWith(
      messages: [...state.messages, userMessage],
      isLoading: true,
    );

    try {
      final response = await _chat.sendMessage(Content.text(text));
      final botText = response.text ?? "I'm not sure how to respond to that.";

      final botMessage = ChatMessage(
        user: botUser,
        createdAt: DateTime.now().add(const Duration(seconds: 1)),
        text: botText,
      );

      final sorted = [...state.messages, userMessage, botMessage]
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

      state = state.copyWith(messages: sorted);
    } catch (e) {
      final errorMessage = ChatMessage(
        user: botUser,
        createdAt: DateTime.now(),
        text: "❌ Error: ${e.toString()}",
      );

      final sorted = [...state.messages, userMessage, errorMessage]
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

      state = state.copyWith(messages: sorted);
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }
}

final aiTutorProvider = StateNotifierProvider<AiTutorNotifier, AiTutorData>(
  (ref) => AiTutorNotifier(),
);
