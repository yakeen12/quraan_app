import 'package:http/http.dart' as http;
import 'package:quraan/models/match_q_model.dart';
import 'dart:convert';

import 'package:quraan/models/multi_q_model.dart';

class MatchQuestionService {
  static const baseUrl = 'http://192.168.0.165:3000/api/matchquestion/';

  static Future<List<MatchQuestion>> fetchQuestionsByLevel(int level) async {
    final response = await http.get(Uri.parse('$baseUrl$level'));
    if (response.statusCode == 200) {
      Iterable jsonResponse = json.decode(response.body);
      return jsonResponse
          .map((question) => MatchQuestion.fromJson(question))
          .toList();
    } else {
      throw Exception('Failed to load questions');
    }
  }
}
