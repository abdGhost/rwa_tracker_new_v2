import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/blog.dart';
import '../model/coin.dart';
import '../model/coin_detail.dart';
import '../model/coin_graph.dart';
import '../model/hightlight.dart';
import '../model/signin/signin_request.dart';
import '../model/signin/signin_response.dart';
import '../model/signup/signup_request.dart';
import '../model/signup/signup_response.dart';
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

  final String blogApiUrl =
      "https://rwa-f1623a22e3ed.herokuapp.com/api/currencies/rwa/blog";

  Future<BlogModel> fetchBlogs() async {
    final response = await http.get(Uri.parse(blogApiUrl));

    if (response.statusCode == 200) {
      // If the server returns a 200 OK response, parse the JSON.
      return BlogModel.fromJson(json.decode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // throw an exception.
      throw Exception('Failed to load blogs');
    }
  }

  // Function to call the signup API
  Future<SignupResponse> signup(SignupRequest request) async {
    final url =
        Uri.parse('https://rwa-f1623a22e3ed.herokuapp.com/api/users/signup');

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
    final url =
        Uri.parse('https://rwa-f1623a22e3ed.herokuapp.com/api/users/signin');

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
      // Assuming error response is a JSON object
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
        // Handle the case where the response is not a JSON object
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
