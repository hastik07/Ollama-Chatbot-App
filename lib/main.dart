import 'package:ai_chatbot/provider/chat_provider.dart';
import 'package:ai_chatbot/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ChatProvider(),
      child: const OllamaChatApp(),
    ),
  );
}

class OllamaChatApp extends StatelessWidget {
  const OllamaChatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ollama Chatbot',
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.blueGrey[900],
        scaffoldBackgroundColor: const Color(0xFF343541),
        appBarTheme: AppBarTheme(
          backgroundColor: const Color(0xFF444654),
          elevation: 0,
          titleTextStyle: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        colorScheme: ColorScheme.fromSwatch(
          brightness: Brightness.dark,
        ).copyWith(secondary: Colors.tealAccent),
      ),
      home: const ChatScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
