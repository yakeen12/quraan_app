import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:quraan/models/multi_q_model.dart';

class MultiQuestionService {
  static const baseUrl = 'http://192.168.0.18:3000/api/questions/';

  static Future<List<MultiQuestion>> fetchQuestionsByLevel(int level) async {
    final response = await http.get(Uri.parse('$baseUrl$level'));
    if (response.statusCode == 200) {
      Iterable jsonResponse = json.decode(response.body);
      return jsonResponse
          .map((question) => MultiQuestion.fromJson(question))
          .toList();
    } else {
      throw Exception('Failed to load questions');
    }
  }
}
