import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class OpenAITranslationService {
  static const String _apiKeyKey = 'openai_api_key';

  Future<void> saveApiKey(String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_apiKeyKey, key.trim());
  }

  Future<String> getApiKey() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_apiKeyKey) ?? '';
  }

  Future<String> translate(String text, {required bool toKhmer}) async {
    final apiKey = await getApiKey();
    if (apiKey.isEmpty) {
      return _fallbackTranslate(text, toKhmer: toKhmer);
    }

    try {
      final response = await http.post(
        Uri.parse('https://api.openai.com/v1/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        body: jsonEncode({
          'model': 'gpt-4o-mini',
          'messages': [
            {
              'role': 'system',
              'content': 'You are a professional culinary translator between English and Khmer. '
                  'Translate the user\'s recipe names or descriptions accurately. '
                  'Maintain high linguistic quality and cultural context. '
                  'Output ONLY the raw translated text. Do NOT add quotes, markdown, explanations, or formatting.',
            },
            {
              'role': 'user',
              'content': 'Translate to ${toKhmer ? "Khmer" : "English"}: $text',
            }
          ],
          'temperature': 0.3,
        }),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        final translatedText = data['choices'][0]['message']['content'].toString().trim();
        if (translatedText.isNotEmpty) {
          return translatedText;
        }
      }
      
      // If server returned error code, fallback
      return _fallbackTranslate(text, toKhmer: toKhmer, prefix: '[API Error Fallback]');
    } catch (e) {
      return _fallbackTranslate(text, toKhmer: toKhmer, prefix: '[Network Error Fallback]');
    }
  }

  String _fallbackTranslate(String text, {required bool toKhmer, String prefix = ''}) {
    // Simple local translation for common terms
    final normalized = text.trim().toLowerCase();
    
    // English to Khmer lookup
    final Map<String, String> enToKm = {
      'stir-fried ginger beef': 'ឆាសាច់គោខ្ញី',
      'ginger beef': 'សាច់គោឆាខ្ញី',
      'chicken amok': 'អាម៉ុកសាច់មាន់',
      'pork and rice': 'បាយសាច់ជ្រូក',
      'cambodian donuts': 'នំកង',
      'rice noodles': 'នំបញ្ចុក',
      'sour soup': 'សម្លម្ជូរ',
      'fried rice': 'បាយឆា',
      'fried noodles': 'មីឆា',
      'beef lok lak': 'ឡុកឡាក់សាច់គោ',
      'fish amok': 'អាម៉ុកត្រី',
    };

    // Khmer to English lookup
    final Map<String, String> kmToEn = {
      'ឆាសាច់គោខ្ញី': 'Stir-fried ginger beef',
      'សាច់គោឆាខ្ញី': 'Stir-fried ginger beef',
      'អាម៉ុកសាច់មាន់': 'Chicken Amok',
      'បាយសាច់ជ្រូក': 'Bai Sach Chrouk',
      'នំកង': 'Cambodian Donuts (Num Kong)',
      'នំបញ្ចុក': 'Rice Noodles (Nom Banh Chok)',
      'សម្លម្ជូរ': 'Sour Soup',
      'បាយឆា': 'Fried Rice',
      'មីឆា': 'Fried Noodles (Mee Cha)',
      'ឡុកឡាក់សាច់គោ': 'Beef Lok Lak',
      'អាម៉ុកត្រី': 'Fish Amok',
    };

    if (toKhmer) {
      if (enToKm.containsKey(normalized)) {
        return enToKm[normalized]!;
      }
      return prefix.isNotEmpty ? '$prefix ខ្មែរ: $text' : '$text (ប្រែជាភាសាខ្មែរ)';
    } else {
      if (kmToEn.containsKey(normalized)) {
        return kmToEn[normalized]!;
      }
      return prefix.isNotEmpty ? '$prefix EN: $text' : '$text (Translated to English)';
    }
  }
}
