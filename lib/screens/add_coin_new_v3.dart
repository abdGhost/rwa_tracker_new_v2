import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';
import '../api/api_service.dart';
import '../model/coin_detail.dart';
import 'dart:async';

class AddCoinNew extends StatefulWidget {
  const AddCoinNew({super.key});

  @override
  State<AddCoinNew> createState() => _AddCoinNewState();
}

class _AddCoinNewState extends State<AddCoinNew> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _purchasePriceController =
      TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  List<dynamic> _searchResults = [];
  bool _isLoading = false;
  bool _showSearchResults = true;
  dynamic _selectedCoin;
  CoinDetail? _coinDetails;
  DateTime? _selectedDate;
  final ApiService _apiService = ApiService();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    _amountController.addListener(_calculatePurchasePrice);
    _quantityController.addListener(_calculatePurchasePrice);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _amountController.removeListener(_calculatePurchasePrice);
    _quantityController.removeListener(_calculatePurchasePrice);
    _searchController.dispose();
    _amountController.dispose();
    _purchasePriceController.dispose();
    _quantityController.dispose();
    _dateController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (_searchController.text.isNotEmpty) {
        _searchCoins(_searchController.text);
      } else {
        setState(() {
          _searchResults = [];
          _showSearchResults = false;
        });
      }
    });
  }

  void _calculatePurchasePrice() {
    if (_amountController.text.isNotEmpty &&
        _quantityController.text.isNotEmpty) {
      double amount = double.parse(_amountController.text);
      double quantity = double.parse(_quantityController.text);
      double purchasePrice = amount / quantity;
      _purchasePriceController.text = purchasePrice.toStringAsFixed(6);
    }
  }

  Future<void> _searchCoins(String query) async {
    setState(() {
      _isLoading = true;
      _searchResults = [];
      _selectedCoin = null;
      _showSearchResults = true;
    });

    final url = Uri.parse(
        'https://rwa-f1623a22e3ed.herokuapp.com/api/currencies?page=1&size=30&category=$query');
    final response = await http.get(url);

    print('Response status: ${response.statusCode}');
    print('Response body for search: ${response.body}');

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print('Decoded data: $data'); // Log the decoded data for debugging

      if (data != null && data['currency'] is List) {
        setState(() {
          _searchResults = data['currency'];
        });
      } else {
        setState(() {
          _searchResults = [];
        });
      }
    } else {
      // Handle the error appropriately
      setState(() {
        _searchResults = [];
      });
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _getCoinDetails(String id) async {
    try {
      final coinDetails = await _apiService.coinDetails(id);
      setState(() {
        _coinDetails = coinDetails;
      });
    } catch (e) {
      print('Error fetching coin details: $e');
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
        _dateController.text = '${_selectedDate!.toLocal()}'.split(' ')[0];
        print('Date');
        print(_dateController.text);
      });
    }
  }

  String _calculateProfitOrLoss() {
    // Check for empty inputs or null coin details
    if (_amountController.text.isEmpty ||
        _purchasePriceController.text.isEmpty ||
        _quantityController.text.isEmpty ||
        _coinDetails == null) {
      return '';
    }

    // Parse input values
    double amount =
        double.parse(_amountController.text); // Total amount invested
    double purchasePrice = double.parse(
        _purchasePriceController.text); // Price per unit at purchase
    double quantity =
        double.parse(_quantityController.text); // Quantity purchased
    double currentPrice = _coinDetails?.detail.marketData.currentPrice['usd'] ??
        0; // Current price per unit

    // Calculate total purchase price and total current price
    double totalPurchasePrice =
        purchasePrice * quantity; // Total initial investment
    double totalCurrentPrice =
        currentPrice * quantity; // Current total value of investment

    // Calculate profit or loss
    double profitOrLoss =
        totalCurrentPrice - totalPurchasePrice; // Absolute profit or loss

    // Calculate percentage only if totalPurchasePrice is not zero
    double percentage =
        totalPurchasePrice != 0 ? (profitOrLoss / totalPurchasePrice) * 100 : 0;

    // Debug prints
    print('Amount: $amount');
    print('Purchase Price per Unit: $purchasePrice');
    print('Quantity: $quantity');
    print('Current Price per Unit: $currentPrice');
    print('Total Purchase Price: $totalPurchasePrice');
    print('Total Current Price: $totalCurrentPrice');
    print('Profit or Loss: $profitOrLoss');
    print('Percentage: $percentage');

    // Determine result message
    String result = profitOrLoss >= 0
        ? 'Profit: \$${profitOrLoss.toStringAsFixed(2)} (${percentage.toStringAsFixed(2)}%)'
        : 'Loss: \$${profitOrLoss.abs().toStringAsFixed(2)} (${percentage.abs().toStringAsFixed(2)}%)';

    return result;
  }

  // Future<void> _submitCoinData() async {
  //   print('calling api');
  //   // Ensure all required fields are filled
  //   if (_amountController.text.isEmpty ||
  //       _purchasePriceController.text.isEmpty ||
  //       _quantityController.text.isEmpty ||
  //       _dateController.text.isEmpty ||
  //       _coinDetails == null) {
  //     // Show an error message or handle the validation as needed
  //     return;
  //   }

  //   // Gather the values from the text fields
  //   final double amount = double.parse(_amountController.text);
  //   final double purchasePrice = double.parse(_purchasePriceController.text);
  //   final double quantity = double.parse(_quantityController.text);
  //   final String date = _dateController.text;
  //   final String coinId = _selectedCoin['id'];

  //   // Create the request payload
  //   final Map<String, dynamic> payload = {
  //     'amount': amount,
  //     'purchasePrice': purchasePrice,
  //     'quantity': quantity,
  //     'date': date,
  //     'coinId': coinId,
  //   };

  //   // Make the API call
  //   try {
  //     final response = await http.post(
  //       Uri.parse(
  //           'https://yourapiendpoint.com/submitCoinData'), // Replace with your API endpoint
  //       headers: {'Content-Type': 'application/json'},
  //       body: json.encode(payload),
  //     );

  //     if (response.statusCode == 200) {
  //       // Handle success
  //       print('Data submitted successfully');
  //     } else {
  //       // Handle error
  //       print('Error submitting data: ${response.statusCode}');
  //     }
  //   } catch (e) {
  //     print('Exception: $e');
  //   }
  // }

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
        actions: [
          IconButton(
            icon: const Icon(
              Icons.add,
              color: Color(0xFF34906c),
            ),
            onPressed: () {},
          ),
        ],
        title: const Text(
          'Add Coin',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w600,
          ),
        ),
        elevation: 0.3,
      ),
      body: SingleChildScrollView(
        child: Padding(
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
                  suffixIcon:
                      const Icon(Icons.search, color: Color(0xFF348f6c)),
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
              ),
              const SizedBox(height: 16.0),
              _isLoading
                  ? const CircularProgressIndicator(
                      color: Color(0xFF348f6c),
                    )
                  : _showSearchResults
                      ? _searchResults.isNotEmpty
                          ? ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: _searchResults.length,
                              itemBuilder: (context, index) {
                                final coin = _searchResults[index];
                                return ListTile(
                                  leading: Image.network(
                                    coin['image'],
                                    width: 40,
                                    height: 40,
                                  ),
                                  title: Text(
                                    coin['name'],
                                    style: const TextStyle(
                                      color: Colors.black87,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                    ),
                                  ),
                                  subtitle: Text(
                                    coin['symbol'],
                                    style: const TextStyle(
                                      color: Colors.black54,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                    ),
                                  ),
                                  onTap: () async {
                                    await _getCoinDetails(coin['id']);
                                    setState(() {
                                      _selectedCoin = coin;
                                      _showSearchResults = false;
                                      _searchController.clear();
                                    });
                                    FocusScope.of(context).unfocus();
                                  },
                                );
                              },
                            )
                          : const Center(
                              child: Text(
                                'No coin found',
                                style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 16,
                                ),
                              ),
                            )
                      : Container(),
              _selectedCoin != null && _coinDetails != null
                  ? Card(
                      elevation: 0,
                      color: Colors.white,
                      margin: const EdgeInsets.only(top: 16.0),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Image.network(
                                  _selectedCoin['image'],
                                  height: 30,
                                  width: 30,
                                ),
                                const SizedBox(width: 16.0),
                                Column(
                                  children: [
                                    Container(
                                      width: 200,
                                      child: Text(
                                        _selectedCoin['name'],
                                        style: const TextStyle(
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: 200,
                                      child: Text(
                                        _selectedCoin['symbol'],
                                        style: const TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black54,
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                            const SizedBox(height: 10.0),
                            Row(
                              children: [
                                Text(
                                  'Market Cap Rank:',
                                  style: const TextStyle(
                                    fontSize: 16.0,
                                    color: Colors.black87,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Text(
                                  ' ${_selectedCoin['market_cap_rank'] ?? 'N/A'}',
                                  style: const TextStyle(
                                    fontSize: 14.0,
                                    color: Colors.black54,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8.0),
                            Row(
                              children: [
                                Text(
                                  'Current Price:',
                                  style: const TextStyle(
                                    fontSize: 16.0,
                                    color: Colors.black87,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Text(
                                  ' ${_coinDetails?.detail.marketData.currentPrice['usd'] ?? 'N/A'}',
                                  style: const TextStyle(
                                    fontSize: 14.0,
                                    color: Colors.black54,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8.0),
                            Row(
                              children: [
                                Text(
                                  'Total Market Cap: ',
                                  style: const TextStyle(
                                    fontSize: 16.0,
                                    color: Colors.black87,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Text(
                                  ' \$${_coinDetails?.detail.marketData.marketCap['usd'] ?? 'N/A'}',
                                  style: const TextStyle(
                                    fontSize: 14.0,
                                    color: Colors.black54,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 30.0),
                            Container(
                              height: 260,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: TextField(
                                          controller: _amountController,
                                          decoration: InputDecoration(
                                            labelText: 'Enter amount',
                                            labelStyle: const TextStyle(
                                                color: Color.fromRGBO(
                                                    55, 204, 155, 1.0)),
                                            border: const OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Color.fromRGBO(
                                                      55, 204, 155, 1.0)),
                                            ),
                                            focusedBorder:
                                                const OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Color.fromRGBO(
                                                      55, 204, 155, 1.0)),
                                            ),
                                            enabledBorder:
                                                const OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Color.fromRGBO(
                                                      55, 204, 155, 1.0)),
                                            ),
                                            hintText: 'Enter amount',
                                            hintStyle: const TextStyle(
                                                color: Color.fromRGBO(
                                                    55, 204, 155, 1.0)),
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                                    vertical: 10.0,
                                                    horizontal: 10.0),
                                          ),
                                          style: const TextStyle(
                                            color: Colors.black54,
                                            fontSize: 14,
                                          ),
                                          keyboardType: TextInputType.number,
                                        ),
                                      ),
                                      const SizedBox(width: 16.0),
                                      Expanded(
                                        child: TextField(
                                          controller: _quantityController,
                                          decoration: InputDecoration(
                                            labelText: 'Enter quantity',
                                            labelStyle: const TextStyle(
                                                color: Color.fromRGBO(
                                                    55, 204, 155, 1.0)),
                                            border: const OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Color.fromRGBO(
                                                      55, 204, 155, 1.0)),
                                            ),
                                            focusedBorder:
                                                const OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Color.fromRGBO(
                                                      55, 204, 155, 1.0)),
                                            ),
                                            enabledBorder:
                                                const OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Color.fromRGBO(
                                                      55, 204, 155, 1.0)),
                                            ),
                                            hintText: 'Enter quantity',
                                            hintStyle: const TextStyle(
                                                color: Color.fromRGBO(
                                                    55, 204, 155, 1.0)),
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                                    vertical: 10.0,
                                                    horizontal: 10.0),
                                          ),
                                          style: const TextStyle(
                                            color: Colors.black54,
                                            fontSize: 14,
                                          ),
                                          keyboardType: TextInputType.number,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16.0),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: TextField(
                                          controller: _purchasePriceController,
                                          decoration: InputDecoration(
                                            labelText:
                                                'Enter purchase price per unit',
                                            labelStyle: const TextStyle(
                                                color: Color.fromRGBO(
                                                    55, 204, 155, 1.0)),
                                            border: const OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Color.fromRGBO(
                                                      55, 204, 155, 1.0)),
                                            ),
                                            focusedBorder:
                                                const OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Color.fromRGBO(
                                                      55, 204, 155, 1.0)),
                                            ),
                                            enabledBorder:
                                                const OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Color.fromRGBO(
                                                      55, 204, 155, 1.0)),
                                            ),
                                            hintText:
                                                'Enter purchase price per unit',
                                            hintStyle: const TextStyle(
                                                color: Color.fromRGBO(
                                                    55, 204, 155, 1.0)),
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                                    vertical: 10.0,
                                                    horizontal: 10.0),
                                          ),
                                          style: const TextStyle(
                                            color: Colors.black54,
                                            fontSize: 14,
                                          ),
                                          keyboardType: TextInputType.number,
                                          readOnly: true,
                                        ),
                                      ),
                                      const SizedBox(width: 16.0),
                                      Expanded(
                                        child: GestureDetector(
                                          onTap: () => _selectDate(context),
                                          child: AbsorbPointer(
                                            child: TextField(
                                              controller: _dateController,
                                              decoration: InputDecoration(
                                                labelText: 'Select date',
                                                labelStyle: const TextStyle(
                                                    color: Color.fromRGBO(
                                                        55, 204, 155, 1.0)),
                                                border:
                                                    const OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Color.fromRGBO(
                                                          55, 204, 155, 1.0)),
                                                ),
                                                focusedBorder:
                                                    const OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Color.fromRGBO(
                                                          55, 204, 155, 1.0)),
                                                ),
                                                enabledBorder:
                                                    const OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Color.fromRGBO(
                                                          55, 204, 155, 1.0)),
                                                ),
                                                prefixIcon: const Icon(
                                                  Icons.calendar_today,
                                                  color: Color(0xFF348f6c),
                                                ),
                                                hintText: 'Select date',
                                                hintStyle: const TextStyle(
                                                    color: Color.fromRGBO(
                                                        55, 204, 155, 1.0)),
                                                contentPadding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 10.0,
                                                        horizontal: 10.0),
                                              ),
                                              style: const TextStyle(
                                                color: Colors.black54,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 25.0),
                                  Center(
                                    child: SizedBox(
                                      width: 140, // Set the width you desire
                                      height: 40, // Set the height you desire
                                      child: ElevatedButton(
                                        onPressed: () {
                                          setState(() {
                                            // Trigger the calculation and UI update
                                            _calculateProfitOrLoss();
                                          });
                                          // Submit the coin data
                                          // _submitCoinData();
                                        },
                                        style: ElevatedButton.styleFrom(
                                          foregroundColor: Colors.white,
                                          backgroundColor:
                                              const Color(0xFF348f6c),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                25.0), // Set your desired border radius here
                                          ),
                                        ),
                                        child: const Text(
                                          'Calculate',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16.0),
                            Text(
                              _calculateProfitOrLoss(),
                              style: const TextStyle(
                                  fontSize: 18.0, color: Colors.black54),
                            ),
                          ],
                        ),
                      ),
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
