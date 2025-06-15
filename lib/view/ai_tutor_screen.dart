import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:mindmint/resources/color.dart';
import 'package:mindmint/view_model/ai_tutor_state_notifer.dart';

class AiTutorScreen extends ConsumerWidget {
  const AiTutorScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(aiTutorProvider);
    final notifier = ref.read(aiTutorProvider.notifier);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Quiz Assistant",
          style: TextStyle(
            color: AppColors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF9F9F9), Color(0xFFEDEDED)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: DashChat(
                currentUser: notifier.currentUser,
                onSend: (msg) => notifier.onSend(msg.text),
                messages: state.messages,
                messageOptions: MessageOptions(
                  currentUserContainerColor: AppColors.sky,
                  containerColor: const Color(0xFFF1F3F4),
                  textColor: Colors.black87,
                  currentUserTextColor: Colors.white,
                  borderRadius: 16,
                  messagePadding: const EdgeInsets.all(12),
                  showOtherUsersAvatar: true,
                  showCurrentUserAvatar: true,
                  avatarBuilder: (user, onPressAvatar, onLongPressAvatar) {
                    return CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 16,
                      child: Icon(
                        user.id == 'user' ? Icons.person : Icons.smart_toy,
                        color:
                            user.id == 'user'
                                ? Colors.grey[800]
                                : Colors.indigo,
                        size: 20,
                      ),
                    );
                  },
                ),
                inputOptions: InputOptions(
                  sendOnEnter: true,
                  inputDecoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: "Ask me anything...",
                    hintStyle: const TextStyle(color: Colors.grey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 14,
                    ),
                  ),
                ),
              ),
            ),
            if (state.isLoading)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Row(
                  children: [
                    CircularProgressIndicator(strokeWidth: 2),
                    SizedBox(width: 12),
                    Text(
                      "QuizBot is typing...",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
