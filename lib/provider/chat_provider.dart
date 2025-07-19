import 'package:flutter/material.dart';

import '../models/chat_message.dart';
import '../services/ollama_service.dart';

class ChatProvider with ChangeNotifier {
  final List<ChatMessage> _messages = [];
  final OllamaService _ollamaService = OllamaService();
  bool _isLoading = false;

  List<ChatMessage> get messages => _messages;
  bool get isLoading => _isLoading;

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    _messages.add(ChatMessage(text: text, isUser: true));
    _isLoading = true;
    notifyListeners();

    try {
      final botResponse = await _ollamaService.generateResponse(text);

      _messages.add(ChatMessage(text: botResponse, isUser: false));
    } catch (e) {
      _messages.add(ChatMessage(text: 'Error: ${e.toString()}', isUser: false));
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
