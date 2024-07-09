import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/coin.dart';
import '../model/coin_detail.dart';
import '../model/coin_graph.dart';
import '../model/hightlight.dart';
import '../model/signin/signin_request.dart';
import '../model/signin/signin_response.dart';
import '../model/signup/signup_request.dart';
import '../model/signup/signup_response.dart';
import '../model/trend.dart';
import '../model/blog.dart';

class ApiService {
  static const String baseUrl =
      'https://rwa-f1623a22e3ed.herokuapp.com/api/currencies';
  static const String trendApiUrl = 'https://rwa-f1623a22e3ed.herokuapp.com';

  Future<Coin> fetchCoins() async {
    final response =
        await http.get(Uri.parse('$baseUrl?page=1&size=10&category='));
    print(response);

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body) as Map<String, dynamic>;
      print('Response from API: $jsonResponse');

      if (jsonResponse.containsKey('currency')) {
        return Coin.fromJson(jsonResponse);
      } else {
        throw Exception('Unexpected response format');
      }
    } else {
      throw Exception('Failed to load coins');
    }
  }

  // Future<CoinDetail> coinDetails(String currencyId) async {
  //   final response = await http.get(Uri.parse('$baseUrl/rwa/coin/$currencyId'));
  //   print('************');
  //   print(response);

  //   if (response.statusCode == 200) {
  //     final jsonResponse = jsonDecode(response.body);
  //     return CoinDetail.fromJson(jsonResponse);
  //   } else {
  //     throw Exception('Failed to load coin details');
  //   }
  // }

  Future<CoinDetail> coinDetails(String currencyId) async {
    final response = await http.get(Uri.parse('$baseUrl/rwa/coin/$currencyId'));

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      return CoinDetail.fromJson(jsonResponse);
    } else {
      throw Exception('Failed to load coin details');
    }
  }

  Future<CoinGraph> fetchCoinGraphData(String name) async {
    final response =
        await http.get(Uri.parse('$baseUrl/rwa/graph/coinOHLC/$name'));

    if (response.statusCode == 200) {
      // Print CoinGraph response
      print('CoinGraph Response: ${response.body}');
      return CoinGraph.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load coin graph data');
    }
  }

  Future<HighlightModel> fetchHighlightData() async {
    final response = await http.get(Uri.parse('$baseUrl/rwa/highlight'));

    if (response.statusCode == 200) {
      return HighlightModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load highlight data');
    }
  }

  Future<TrendResponse> fetchTrends() async {
    final response =
        await http.get(Uri.parse('$trendApiUrl/api/currencies/rwa/trend'));

    if (response.statusCode == 200) {
      return TrendResponse.fromMap(json.decode(response.body));
    } else {
      throw Exception('Failed to load trends');
    }
  }

  Future<BlogModel> fetchBlogs() async {
    final response = await http.get(Uri.parse(
        'https://rwa-f1623a22e3ed.herokuapp.com/api/currencies/rwa/blog'));
    print(response.body);

    if (response.statusCode == 200) {
      return BlogModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load blogs');
    }
  }

  Future<SignupResponse> signup(SignupRequest request) async {
    final url = Uri.parse('$trendApiUrl/api/users/signup');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode == 200) {
      return SignupResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to sign up');
    }
  }

  Future<LoginResponse> login(LoginRequest request) async {
    final url = Uri.parse('$trendApiUrl/api/users/signin');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode == 200) {
      return LoginResponse.fromJson(jsonDecode(response.body));
    } else {
      try {
        final jsonResponse = jsonDecode(response.body);
        return LoginResponse(
          status: jsonResponse['success'] ?? false,
          message: jsonResponse['message'] ?? 'Unknown error',
          id: '',
          name: '',
          token: '',
          email: '',
        );
      } catch (e) {
        return LoginResponse(
          status: false,
          message: response.body,
          id: '',
          name: '',
          token: '',
          email: '',
        );
      }
    }
  }
}
