import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AddCoinScreen extends StatefulWidget {
  const AddCoinScreen({super.key});

  @override
  State<AddCoinScreen> createState() => _AddCoinScreenState();
}

class _AddCoinScreenState extends State<AddCoinScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<dynamic> _searchResults = [];
  bool _isLoading = false;
  bool _showSearchResults = true;
  dynamic _selectedCoin;
  Map<String, dynamic>? _coinDetails;

  Future<void> _searchCoins(String query) async {
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
        _showSearchResults = false;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _selectedCoin =
          null; // Reset selected coin when a new search is performed
      _showSearchResults =
          true; // Show search results when a new search is performed
    });

    final url =
        Uri.parse('https://api.coingecko.com/api/v3/search?query=$query');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        _searchResults = data['coins'];
      });
    } else {
      // Handle the error
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _getCoinDetails(String id) async {
    final url = Uri.parse('https://api.coingecko.com/api/v3/coins/$id');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        _coinDetails = data;
      });
    } else {
      // Handle the error
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Color(0xFF34906c),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text(
          'Add Coin',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search for a coin',
                labelStyle: TextStyle(color: Color.fromRGBO(55, 204, 155, 1.0)),
                border: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: Color.fromRGBO(55, 204, 155, 1.0)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: Color.fromRGBO(55, 204, 155, 1.0)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: Color.fromRGBO(55, 204, 155, 1.0)),
                ),
                suffixIcon: Icon(
                  Icons.search,
                  color: Colors.white,
                ),
                hintText: 'Search for a coin',
                hintStyle: TextStyle(color: Color.fromRGBO(55, 204, 155, 1.0)),
              ),
              style: TextStyle(color: Colors.white),
              onChanged: (value) {
                _searchCoins(value);
              },
            ),
            const SizedBox(height: 16.0),
            _isLoading
                ? const CircularProgressIndicator()
                : _showSearchResults
                    ? Expanded(
                        child: ListView.builder(
                          itemCount: _searchResults.length,
                          itemBuilder: (context, index) {
                            final coin = _searchResults[index];
                            return ListTile(
                              leading: Image.network(coin['thumb']),
                              title: Text(coin['name'],
                                  style: TextStyle(color: Colors.white)),
                              subtitle: Text(coin['symbol'],
                                  style: TextStyle(color: Colors.white70)),
                              onTap: () async {
                                await _getCoinDetails(coin['id']);
                                setState(() {
                                  _selectedCoin = coin;
                                  _showSearchResults = false;
                                  _searchController
                                      .clear(); // Clear the search field
                                });
                              },
                            );
                          },
                        ),
                      )
                    : Container(),
            _selectedCoin != null && _coinDetails != null
                ? Card(
                    color: Color(0xFF222224),
                    margin: const EdgeInsets.only(top: 16.0),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Image.network(
                                _selectedCoin['thumb'],
                                height: 50,
                                width: 50,
                              ),
                              const SizedBox(width: 16.0),
                              Text(
                                _selectedCoin['name'],
                                style: const TextStyle(
                                  fontSize: 24.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16.0),
                          Text(
                            'Symbol: ${_selectedCoin['symbol']}',
                            style: const TextStyle(
                                fontSize: 18.0, color: Colors.white),
                          ),
                          const SizedBox(height: 8.0),
                          Text(
                            'Market Cap Rank: ${_selectedCoin['market_cap_rank'] ?? 'N/A'}',
                            style: const TextStyle(
                                fontSize: 18.0, color: Colors.white),
                          ),
                          const SizedBox(height: 8.0),
                          Text(
                            'Current Price: \$${_coinDetails?['market_data']['current_price']['usd'] ?? 'N/A'}',
                            style: const TextStyle(
                                fontSize: 18.0, color: Colors.white),
                          ),
                          const SizedBox(height: 8.0),
                          Text(
                            'Total Market Cap: \$${_coinDetails?['market_data']['market_cap']['usd'] ?? 'N/A'}',
                            style: const TextStyle(
                                fontSize: 18.0, color: Colors.white),
                          ),
                          // Add more details as needed
                        ],
                      ),
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
