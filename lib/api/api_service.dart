import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/coin.dart';

class ApiService {
  final String baseUrl = 'http://192.168.1.7:5000/api/mobile/currencies';

  Future<Coin> fetchCoins() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body) as Map<String, dynamic>;

      // Debug print the response to check its structure
      print('Response from API: $jsonResponse');

      // Ensure that the response is a map with a 'currency' key holding the list of coins
      if (jsonResponse.containsKey('currency')) {
        return Coin.fromJson(jsonResponse);
      } else {
        throw Exception('Unexpected response format');
      }
    } else {
      throw Exception('Failed to load coins');
    }
  }
}
