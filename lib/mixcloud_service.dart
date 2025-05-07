import 'dart:convert';
import 'package:http/http.dart' as http;

class MixcloudService {
  final String baseUrl = 'https://api.mixcloud.com/search/';

  // Search only for cloudcasts (songs/mixes)
  Future<Map<String, dynamic>> searchForSongs(String query) async {
    final url = '$baseUrl?type=cloudcast&q=${Uri.encodeComponent(query)}';
    print('Searching with URL: $url');  // Debugging: Log the URL to ensure it's correct

    final response = await http.get(Uri.parse(url));

    // Check for response status
    print('Response status: ${response.statusCode}');
    if (response.statusCode == 200) {
      try {
        final data = json.decode(response.body);
        print('Response body: ${response.body}');  // Log the response body for inspection
        return data;
      } catch (e) {
        print('Error decoding JSON: $e');  // Handle JSON parsing errors
        throw Exception('Failed to parse JSON response');
      }
    } else {
      print('Failed request with status: ${response.statusCode}');
      throw Exception('Failed to load Mixcloud data');
    }
  }
}
