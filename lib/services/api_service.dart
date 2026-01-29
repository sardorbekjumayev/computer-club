import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/club_model.dart';

class ApiService {
  static const String baseUrl = 'http://c869.coresuz.ru/club/api';

  static Future<List<ComputerClub>> fetchNearbyClubs(double lat, double lng) async {
    try {
      final url = '$baseUrl/nearby.php?lat=41.316425&lng=69.296026';
      debugPrint('--- API REQUEST (Nearby) ---');
      debugPrint('URL: $url');
      
      final response = await http.get(Uri.parse(url));
      debugPrint('STATUS CODE: ${response.statusCode}');
      debugPrint('RESPONSE BODY: ${response.body}');
      debugPrint('--- END API REQUEST ---');

      if (response.statusCode == 200) {
        final Map<String, dynamic> body = json.decode(response.body);
        final List clubsJson = body['data'] ?? [];
        final clubs = clubsJson.map((item) => ComputerClub.fromJson(item)).toList();
        debugPrint('ApiService Parsed ${clubs.length} clubs');
        return clubs;
      } else {
        debugPrint('ApiService Error: Non-200 status code');
        return [];
      }
    } catch (e) {
      debugPrint('ApiService Catch Error (nearby): $e');
      return [];
    }
  }

  static Future<ComputerClub?> fetchClubDetails(String id) async {
    try {
      final url = '$baseUrl/show.php?id=$id';
      debugPrint('--- API REQUEST (Details) ---');
      debugPrint('URL: $url');
      
      final response = await http.get(Uri.parse(url));
      debugPrint('STATUS CODE: ${response.statusCode}');
      debugPrint('RESPONSE BODY: ${response.body}');
      debugPrint('--- END API REQUEST ---');

      if (response.statusCode == 200) {
        final Map<String, dynamic> body = json.decode(response.body);
        return ComputerClub.fromJson(body);
      } else {
        return null;
      }
    } catch (e) {
      debugPrint('ApiService Catch Error (details): $e');
      return null;
    }
  }

  static Future<List<ClubTariff>> fetchTariffs(String id) async {
    try {
      final url = '$baseUrl/tariffs.php?id=$id';
      debugPrint('--- API REQUEST (Tariffs) ---');
      debugPrint('URL: $url');
      
      final response = await http.get(Uri.parse(url));
      debugPrint('STATUS CODE: ${response.statusCode}');
      debugPrint('RESPONSE BODY: ${response.body}');
      debugPrint('--- END API REQUEST ---');

      if (response.statusCode == 200) {
        final Map<String, dynamic> body = json.decode(response.body);
        final List tariffsJson = body['data'] ?? [];
        return tariffsJson.map((item) => ClubTariff.fromJson(item)).toList();
      } else {
        return [];
      }
    } catch (e) {
      debugPrint('ApiService Catch Error (tariffs): $e');
      return [];
    }
  }
}
