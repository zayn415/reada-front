import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiClient {
  final String baseUrl = 'http://10.0.0.2:8080';

  Future<Map<String, dynamic>> postRequest(
    String endpoint,
    Map<String, dynamic> body,
  ) async {
    final url = Uri.parse('$baseUrl$endpoint');
    try {
      final response = await http.post(
        url,
        body: json.encode(body),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('请求失败：${response.statusCode}');
      }
    } catch (e) {
      throw Exception('请求失败：$e');
    }
  }
}
