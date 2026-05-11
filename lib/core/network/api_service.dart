import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "http://192.168.0.213:8000";

  Future<String> summarize(String text) async {
    final response = await http.post(
      Uri.parse('$baseUrl/summarize'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"text": text, "summarize": true}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body)["result"];
    } else {
      throw Exception(response.body);
    }
  }

  //Translate text to a target language
  Future<String> translate(String text, String lang) async {
    final response = await http.post(
      Uri.parse('$baseUrl/translate'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"text": text, "target_language": lang}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body)["result"];
    } else {
      throw Exception(response.body);
    }
  }

  Future<Uint8List> tts(String text, String language, String speaker) async {
    final response = await http.post(
      Uri.parse('$baseUrl/tts'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "text": text,
        "language": language,
        "speaker_id": speaker,
        "stream": false,
        "format": "wav",
      }),
    );

    if (response.statusCode == 200) {
      return response.bodyBytes;
    } else {
      throw Exception(response.body);
    }
  }

  // 🔁 PIPELINE
  Future<Map<String, dynamic>> pipeline({
    required String text,
    bool summarize = false,
    bool translate = false,
    String targetLanguage = "tw",
    bool tts = false,
    String ttsLanguage = "twi",
    String speakerId = "male_low",
  }) async {
    final url = Uri.parse("$baseUrl/pipeline");

    final body = jsonEncode({
      "text": text,
      "summarize": summarize,
      "translate": translate,
      "target_language": targetLanguage,
      "tts": tts,
      "speaker_id": speakerId,
      "tts_language": ttsLanguage,
    });

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: body,
    );

    if (response.statusCode != 200) {
      throw Exception("Pipeline failed: ${response.body}");
    }

    final data = jsonDecode(response.body);

    // Handle audio if present
    if (data["audio"] != null) {
      data["audio"] = base64Decode(data["audio"]);
    }

    return data;
  }
}
