import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';

class AddCoinScreen extends StatefulWidget {
  const AddCoinScreen({super.key});

  @override
  State<AddCoinScreen> createState() => _AddCoinScreenState();
}

class _AddCoinScreenState extends State<AddCoinScreen> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _investmentController = TextEditingController();
  List<dynamic> _searchResults = [];
  bool _isLoading = false;
  bool _showSearchResults = true;
  dynamic _selectedCoin;
  Map<String, dynamic>? _coinDetails;
  String _selectedDuration = '1 year';
  double _annualGrowthRate = 0.0; // Store the calculated annual growth rate
  double _dailyVolatility = 0.0; // Store the daily volatility

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
      await _fetchHistoricalData(
          id); // Fetch historical data after getting coin details
    } else {
      // Handle the error
    }
  }

  Future<void> _fetchHistoricalData(String id) async {
    final url = Uri.parse(
        'https://api.coingecko.com/api/v3/coins/$id/market_chart?vs_currency=usd&days=365');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<dynamic> prices = data['prices'];
      if (prices.isNotEmpty) {
        double initialPrice = prices.first[1].toDouble();
        double finalPrice = prices.last[1].toDouble();
        _annualGrowthRate = (finalPrice - initialPrice) / initialPrice;

        // Calculate daily returns and volatility
        List<double> dailyReturns = [];
        for (int i = 1; i < prices.length; i++) {
          double dailyReturn =
              (prices[i][1].toDouble() - prices[i - 1][1].toDouble()) /
                  prices[i - 1][1].toDouble();
          dailyReturns.add(dailyReturn);
        }
        double mean =
            dailyReturns.reduce((a, b) => a + b) / dailyReturns.length;
        double variance = dailyReturns
                .map((r) => pow(r - mean, 2).toDouble())
                .reduce((a, b) => a + b) /
            dailyReturns.length;
        _dailyVolatility = sqrt(variance);
      } else {
        _annualGrowthRate = 0.0;
        _dailyVolatility = 0.0;
      }
    } else {
      _annualGrowthRate = 0.0;
      _dailyVolatility = 0.0;
      // Handle the error
    }
  }

  double _calculatePrediction(double amount, String duration) {
    int years = int.parse(duration.split(' ')[0]);
    return amount * pow((1 + _annualGrowthRate), years);
  }

  double _nextGaussian() {
    final Random rand = Random();
    double u1 = rand.nextDouble();
    double u2 = rand.nextDouble();
    return sqrt(-2.0 * log(u1)) * cos(2.0 * pi * u2);
  }

  List<double> _runMonteCarloSimulation(double initialPrice, int days) {
    List<double> pricePath = [initialPrice];
    Random rand = Random();

    for (int i = 1; i <= days; i++) {
      double dailyReturn =
          _annualGrowthRate / 365 + _dailyVolatility * _nextGaussian();
      double newPrice = pricePath.last * (1 + dailyReturn);
      pricePath.add(newPrice);
    }
    return pricePath;
  }

  @override
  void dispose() {
    _searchController.dispose();
    _investmentController.dispose();
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
                    child: ListView(
                      children: [
                        Card(
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
                                const SizedBox(height: 16.0),
                                TextField(
                                  controller: _investmentController,
                                  decoration: InputDecoration(
                                    labelText: 'Amount to invest',
                                    labelStyle: TextStyle(
                                        color:
                                            Color.fromRGBO(55, 204, 155, 1.0)),
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Color.fromRGBO(
                                              55, 204, 155, 1.0)),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Color.fromRGBO(
                                              55, 204, 155, 1.0)),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Color.fromRGBO(
                                              55, 204, 155, 1.0)),
                                    ),
                                    hintText: 'Enter amount',
                                    hintStyle: TextStyle(
                                        color:
                                            Color.fromRGBO(55, 204, 155, 1.0)),
                                  ),
                                  style: TextStyle(color: Colors.white),
                                  keyboardType: TextInputType.number,
                                ),
                                const SizedBox(height: 16.0),
                                DropdownButtonFormField<String>(
                                  value: _selectedDuration,
                                  items: ['1 year', '2 years', '5 years']
                                      .map((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                  onChanged: (newValue) {
                                    setState(() {
                                      _selectedDuration = newValue!;
                                    });
                                  },
                                  decoration: InputDecoration(
                                    labelText: 'Select duration',
                                    labelStyle: TextStyle(
                                        color:
                                            Color.fromRGBO(55, 204, 155, 1.0)),
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Color.fromRGBO(
                                              55, 204, 155, 1.0)),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Color.fromRGBO(
                                              55, 204, 155, 1.0)),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Color.fromRGBO(
                                              55, 204, 155, 1.0)),
                                    ),
                                  ),
                                  dropdownColor: Color(0xFF222224),
                                  style: TextStyle(color: Colors.white),
                                ),
                                const SizedBox(height: 16.0),
                                ElevatedButton(
                                  onPressed: () {
                                    double amount = double.parse(
                                        _investmentController.text);
                                    double prediction = _calculatePrediction(
                                        amount, _selectedDuration);

                                    // Run Monte Carlo simulation
                                    List<double> simulationResults =
                                        _runMonteCarloSimulation(
                                            (_coinDetails?['market_data']
                                                    ['current_price']['usd'])
                                                .toDouble(),
                                            int.parse(_selectedDuration
                                                    .split(' ')[0]) *
                                                365);

                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text('Investment Prediction'),
                                          content: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                  'Your investment of \$${amount.toStringAsFixed(2)} could grow to \$${prediction.toStringAsFixed(2)} in $_selectedDuration.'),
                                              SizedBox(height: 16.0),
                                              Text(
                                                  'Monte Carlo Simulation Result: \$${simulationResults.last.toStringAsFixed(2)}')
                                            ],
                                          ),
                                          actions: <Widget>[
                                            TextButton(
                                              child: Text('Close'),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  child: Text('Show Prediction'),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
