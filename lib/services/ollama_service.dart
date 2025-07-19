import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class OllamaService {
  final String _ollamaApiBaseUrl = 'http://10.0.2.2:11434';
  final String _model = 'llama3';

  Future<String> generateResponse(String prompt) async {
    final url = Uri.parse('$_ollamaApiBaseUrl/api/generate');
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({
      'model': _model,
      'prompt': prompt,
      'stream': false,
    });

    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        return responseBody['response']?.trim() ??
            'Sorry, I could not get a response.';
      } else {
        final errorBody = jsonDecode(response.body);
        return "Error: ${errorBody['error']}";
      }
    } catch (e) {
      debugPrint('Error connecting to Ollama: $e');
      return 'Error: Could not connect to Ollama. Please ensure it is running and the IP address is correct.';
    }
  }
}
