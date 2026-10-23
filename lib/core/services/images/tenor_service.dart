import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import '../../../config/config.dart';
import '../../../features/personalization/models/gif_model.dart';

class TenorService {
  static Future<List<GifModel>> searchGifs(String query, {int limit = 100}) async {
    final uri = Uri.parse('${Config.tenorBaseUrl}?q=$query&key=${Config.tenorApiKey}&limit=$limit');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      try {
        final data = json.decode(response.body);

        final results = data['results'] as List;
        if (results.isNotEmpty) {
          return results.map<GifModel>((gif) {
            return GifModel.fromJson(gif);
          }).toList();
        } else {
          log('No results found');
          return [];
        }
      } catch (e) {
        log('Error decoding response: $e');
        throw Exception('Error decoding response');
      }
    } else {
      log('Failed to load GIFs: ${response.statusCode}');
      throw Exception('Failed to load GIFs');
    }
  }
}
