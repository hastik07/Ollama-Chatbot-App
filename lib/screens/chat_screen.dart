import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/chat_provider.dart';
import '../widgets/chat_message_widget.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    if (_textController.text.isNotEmpty) {
      context.read<ChatProvider>().sendMessage(_textController.text);
      _textController.clear();
    }
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      Future.delayed(const Duration(milliseconds: 100), () {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Hastik\'s Chatbot'), centerTitle: true),
      body: Column(
        children: [
          Expanded(
            child: Consumer<ChatProvider>(
              builder: (context, chatProvider, child) {
                WidgetsBinding.instance.addPostFrameCallback(
                  (_) => _scrollToBottom(),
                );

                return ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(8.0),
                  itemCount: chatProvider.messages.length,
                  itemBuilder: (context, index) {
                    final message = chatProvider.messages[index];
                    return ChatMessageWidget(message: message);
                  },
                );
              },
            ),
          ),
          Consumer<ChatProvider>(
            builder: (context, chatProvider, child) {
              if (chatProvider.isLoading) {
                return const Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 8.0,
                    horizontal: 16.0,
                  ),
                  child: Row(
                    children: [
                      CircularProgressIndicator(strokeWidth: 2),
                      SizedBox(width: 16),
                      Text('The bot is thinking...'),
                    ],
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
          _buildChatInputField(),
        ],
      ),
    );
  }

  Widget _buildChatInputField() {
    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Theme.of(context).appBarTheme.backgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, -1),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _textController,
                onSubmitted: (_) => _sendMessage(),
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Type your message...',
                  hintStyle: TextStyle(color: Colors.grey[400]),
                  filled: true,
                  fillColor: const Color(0xFF40414F),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            IconButton(
              icon: const Icon(Icons.send, color: Colors.tealAccent),
              onPressed: _sendMessage,
              style: IconButton.styleFrom(
                backgroundColor: const Color(0xFF40414F),
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
