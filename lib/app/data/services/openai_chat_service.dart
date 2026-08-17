import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class OpenAIChatService {
  static const String _apiKeyKey = 'openai_api_key';

  Future<String> getApiKey() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_apiKeyKey) ?? '';
  }

  Future<String> askChef(String query, List<Map<String, String>> history) async {
    final apiKey = await getApiKey();
    if (apiKey.isEmpty) {
      return _fallbackResponse(query, isKeyMissing: true);
    }

    try {
      // Map history to OpenAI message format
      final messages = [
        {
          'role': 'system',
          'content': 'You are a professional and helpful Cambodian Culinary Chef named "AI Culinary Assistant". '
              'You have deep expertise in traditional Khmer ingredients (such as Kroeung, Prahok, Kampot Pepper), cooking techniques, and regional recipes. '
              'Provide rich, accurate, and structured culinary guidance. '
              'Keep answers relatively concise and highly helpful. You can chat in both Khmer and English.',
        }
      ];

      // Add recent history (up to last 10 messages)
      final recentHistory = history.length > 10 ? history.sublist(history.length - 10) : history;
      for (final msg in recentHistory) {
        messages.add({
          'role': msg['sender'] == 'user' ? 'user' : 'assistant',
          'content': msg['text'] ?? '',
        });
      }

      // Add the current query if not already in history
      if (history.isEmpty || history.last['text'] != query) {
        messages.add({
          'role': 'user',
          'content': query,
        });
      }

      final response = await http.post(
        Uri.parse('https://api.openai.com/v1/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        body: jsonEncode({
          'model': 'gpt-4o-mini',
          'messages': messages,
          'temperature': 0.7,
        }),
      ).timeout(const Duration(seconds: 12));

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        final reply = data['choices'][0]['message']['content'].toString().trim();
        if (reply.isNotEmpty) {
          return reply;
        }
      }

      return _fallbackResponse(query, errorPrefix: '[API Error Fallback]');
    } catch (e) {
      return _fallbackResponse(query, errorPrefix: '[Network Error Fallback]');
    }
  }

  String _fallbackResponse(String query, {bool isKeyMissing = false, String errorPrefix = ''}) {
    final q = query.toLowerCase();
    String mockReply = '';

    if (q.contains('amok') || q.contains('អាម៉ុក')) {
      mockReply = 'For authentic Fish Amok, steam for exactly 20 minutes in banana leaf cups lined with noni leaves (Sleok Nhor) so the coconut mousse achieves a velvet custard texture without curdling!';
    } else if (q.contains('kroeung') || q.contains('គ្រឿង')) {
      mockReply = 'Khmer Yellow Kroeung requires lemongrass stalks, fresh galangal, turmeric, kaffir lime zest, garlic, and shallots pounded in a stone mortar until bright golden!';
    } else if (q.contains('lok lak') || q.contains('ឡុកឡាក់')) {
      mockReply = 'Sear Lok Lak beef cubes in a blazing hot wok for only 3-4 minutes to trap the juices! Always serve with lime, salt, and crushed Kampot peppercorns.';
    } else {
      mockReply = 'Khmer cuisine balances 5 main elements: sweetness from coconut & palm sugar, herbal aromas from Kroeung, umami from Prahok, citrus freshness, and gentle heat. Ask me about any dish or technique!';
    }

    if (isKeyMissing) {
      return '$mockReply\n\n*(Note: Configure your OpenAI API key in the Admin Dashboard to enable live AI Culinary Chat responses.)*';
    } else {
      return '$errorPrefix $mockReply';
    }
  }
}
