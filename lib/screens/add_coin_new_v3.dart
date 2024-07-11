import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AddCoinNew extends StatefulWidget {
  const AddCoinNew({super.key});

  @override
  State<AddCoinNew> createState() => _AddCoinNewState();
}

class _AddCoinNewState extends State<AddCoinNew> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  List<dynamic> _searchResults = [];
  bool _isLoading = false;
  bool _showSearchResults = true;
  dynamic _selectedCoin;
  Map<String, dynamic>? _coinDetails;
  DateTime? _selectedDate;

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
      _selectedCoin = null;
      _showSearchResults = true;
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

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  String _calculateProfitOrLoss() {
    if (_amountController.text.isEmpty || _coinDetails == null) {
      return '';
    }

    double amount = double.parse(_amountController.text);
    double currentPrice =
        _coinDetails?['market_data']['current_price']['usd'] ?? 0;
    double profitOrLoss = amount * currentPrice;

    return 'Current Value: \$${profitOrLoss.toStringAsFixed(2)}';
  }

  @override
  void dispose() {
    _searchController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
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
            color: Colors.black87,
            fontWeight: FontWeight.w600,
          ),
        ),
        elevation: 0.3,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search for a coin',
                labelStyle: const TextStyle(color: Color(0xFF348f6c)),
                border: const OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF348f6c)),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF348f6c)),
                ),
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF348f6c)),
                ),
                suffixIcon: const Icon(
                  Icons.search,
                  color: Color(0xFF348f6c),
                ),
                hintText: 'Search for a coin',
                hintStyle: const TextStyle(
                  color: Color(0xFF348f6c),
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                ),
              ),
              style: const TextStyle(
                color: Colors.black54,
              ),
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
                              title: Text(
                                coin['name'],
                                style: const TextStyle(
                                  color: Colors.black87,
                                ),
                              ),
                              subtitle: Text(
                                coin['symbol'],
                                style: const TextStyle(
                                  color: Colors.black54,
                                ),
                              ),
                              onTap: () async {
                                await _getCoinDetails(coin['id']);
                                setState(() {
                                  _selectedCoin = coin;
                                  _showSearchResults = false;
                                  _searchController.clear();
                                });
                              },
                            );
                          },
                        ),
                      )
                    : Container(),
            _selectedCoin != null && _coinDetails != null
                ? Expanded(
                    child: Card(
                      color: const Color(0xFF222224),
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
                            const SizedBox(height: 16.0),
                            TextField(
                              controller: _amountController,
                              decoration: InputDecoration(
                                labelText: 'Enter amount',
                                labelStyle: const TextStyle(
                                    color: Color.fromRGBO(55, 204, 155, 1.0)),
                                border: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Color.fromRGBO(55, 204, 155, 1.0)),
                                ),
                                focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Color.fromRGBO(55, 204, 155, 1.0)),
                                ),
                                enabledBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Color.fromRGBO(55, 204, 155, 1.0)),
                                ),
                                hintText: 'Enter amount',
                                hintStyle: const TextStyle(
                                    color: Color.fromRGBO(55, 204, 155, 1.0)),
                              ),
                              style: const TextStyle(color: Colors.white),
                              keyboardType: TextInputType.number,
                            ),
                            const SizedBox(height: 16.0),
                            Row(
                              children: [
                                ElevatedButton(
                                  onPressed: () => _selectDate(context),
                                  child: const Text('Select Purchase Date'),
                                ),
                                const SizedBox(width: 16.0),
                                Text(
                                  _selectedDate == null
                                      ? 'No date chosen'
                                      : '${_selectedDate!.toLocal()}'
                                          .split(' ')[0],
                                  style: const TextStyle(
                                      fontSize: 16.0, color: Colors.white),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16.0),
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  // Trigger the calculation and UI update
                                });
                              },
                              child: const Text('Calculate Profit or Loss'),
                            ),
                            const SizedBox(height: 16.0),
                            Text(
                              _calculateProfitOrLoss(),
                              style: const TextStyle(
                                  fontSize: 18.0, color: Colors.white),
                            ),
                          ],
                        ),
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
