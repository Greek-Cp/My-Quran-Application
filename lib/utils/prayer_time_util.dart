import 'dart:convert';
import 'package:http/http.dart' as http;

class PrayerTimeUtil {
  static Future<Map<String, dynamic>> getPrayerTimes(
      String cityName, String countryName) async {
    final url =
        'https://api.aladhan.com/v1/timingsByCity?city=$cityName&country=$countryName&method=8';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['data']['timings'];
    } else {
      throw Exception('Failed to fetch prayer times');
    }
  }
}
