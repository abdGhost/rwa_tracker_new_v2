import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/coin.dart';
import '../model/coin_detail.dart';
import '../model/coin_graph.dart';
import '../model/hightlight.dart';
import '../model/trend.dart';

class ApiService {
  final String baseUrl =
      'https://rwa-f1623a22e3ed.herokuapp.com/api/currencies?page=1&size=10&category=';

  Future<Coin> fetchCoins() async {
    final response = await http.get(Uri.parse(baseUrl));
    print(response);

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

  Future<CoinDetail> coinDetails(String? name) async {
    final response = await http.get(Uri.parse(
        'https://rwa-f1623a22e3ed.herokuapp.com/api/currencies/rwa/coin/$name'));
    print(baseUrl);

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body) as Map<String, dynamic>;

      // Debug print the response to check its structure
      print('Response from API: $jsonResponse');

      // Ensure that the response is a map with a 'detail' key holding the coin details
      if (jsonResponse.containsKey('success') &&
          jsonResponse.containsKey('detail')) {
        return CoinDetail.fromJson(jsonResponse);
      } else {
        throw Exception('Unexpected response format');
      }
    } else {
      throw Exception('Failed to load coin details');
    }
  }

  Future<CoinGraph> fetchCoinGraphData(String name) async {
    final response = await http.get(Uri.parse(
        'https://rwa-f1623a22e3ed.herokuapp.com/api/currencies/rwa/graph/coinOHLC/$name'));

    if (response.statusCode == 200) {
      return CoinGraph.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load coin graph data');
    }
  }

  final String highlightApiUrl =
      'https://rwa-f1623a22e3ed.herokuapp.com/api/currencies/rwa/highlight';

  Future<HighlightModel> fetchHighlightData() async {
    final response = await http.get(Uri.parse(highlightApiUrl));

    if (response.statusCode == 200) {
      return HighlightModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load highlight data');
    }
  }

  final String trendApiUrl = 'https://rwa-f1623a22e3ed.herokuapp.com';

  Future<TrendResponse> fetchTrends() async {
    final response =
        await http.get(Uri.parse('$trendApiUrl/api/currencies/rwa/trend'));

    if (response.statusCode == 200) {
      return TrendResponse.fromMap(json.decode(response.body));
    } else {
      throw Exception('Failed to load trends');
    }
  }
}
