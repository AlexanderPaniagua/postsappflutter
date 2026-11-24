import 'dart:convert';
import 'dart:io';

class ApiService {
  final String baseUrl = 'https://jsonplaceholder.typicode.com';
  final HttpClient _client = HttpClient();

  Future<List<dynamic>> get(String path) async {
    final request = await _client.getUrl(Uri.parse(baseUrl + path));
    final response = await request.close();
    final body = await response.transform(utf8.decoder).join();

    if (response.statusCode != 200) {
      throw Exception('Request to $path failed: ${response.statusCode}');
    }
    return jsonDecode(body) as List<dynamic>;
  }
}
