import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/portfolio/crypto_asset.dart';
import 'package:http/http.dart' as http;

class CoinEditScreen extends StatefulWidget {
  final Function(bool, String?) onBackCallback;
  final PortfolioToken asset;

  CoinEditScreen({required this.asset, required this.onBackCallback});

  @override
  State<CoinEditScreen> createState() => _CoinEditScreenState();
}

class _CoinEditScreenState extends State<CoinEditScreen> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _purchasePriceController =
      TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  bool _isCalculating = false;
  Map<String, dynamic>? _apiResult;

  @override
  void initState() {
    super.initState();
    _amountController.text = widget.asset.amount.toString();
    _quantityController.text = widget.asset.quantity.toString();
    _purchasePriceController.text =
        (widget.asset.amount / widget.asset.quantity).toStringAsFixed(2);

    _amountController.addListener(_updatePurchasePrice);
    _quantityController.addListener(_updatePurchasePrice);
  }

  @override
  void dispose() {
    _amountController.removeListener(_updatePurchasePrice);
    _quantityController.removeListener(_updatePurchasePrice);
    _amountController.dispose();
    _quantityController.dispose();
    _purchasePriceController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  void _updatePurchasePrice() {
    final double amount = double.tryParse(_amountController.text) ?? 0;
    final double quantity = double.tryParse(_quantityController.text) ?? 0;
    if (quantity != 0) {
      _purchasePriceController.text = (amount / quantity).toStringAsFixed(2);
    } else {
      _purchasePriceController.text = '0.00';
    }
  }

  @override
  Widget build(BuildContext context) {
    print(widget.asset.toJson());
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white, // Ensure AppBar is also white
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Color(0xFF34906c),
          ),
          onPressed: () {
            widget.onBackCallback(true, widget.asset.tokenId);
            Navigator.pop(context, true);
          },
        ),
        title: const Text(
          'Edit Coin',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Card(
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
                      widget.asset.image,
                      height: 30,
                      width: 30,
                    ),
                    const SizedBox(width: 16.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 200,
                          child: Text(
                            widget.asset.name,
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
                            widget.asset.symbol,
                            style: const TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w500,
                              color: Colors.black54,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 10.0),
                Row(
                  children: [
                    Text(
                      'Token ID:',
                      style: const TextStyle(
                        fontSize: 16.0,
                        color: Colors.black87,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      ' ${widget.asset.tokenId}',
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
                      'Amount:',
                      style: const TextStyle(
                        fontSize: 16.0,
                        color: Colors.black87,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      ' ${widget.asset.amount}',
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
                      'Quantity:',
                      style: const TextStyle(
                        fontSize: 16.0,
                        color: Colors.black87,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      ' ${widget.asset.quantity}',
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
                      widget.asset.returnPercentage > 0
                          ? 'Profit Percentage:'
                          : 'Loss Percentage:',
                      style: const TextStyle(
                        fontSize: 16.0,
                        color: Colors.black87,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      ' ${widget.asset.returnPercentage.abs()}%',
                      style: TextStyle(
                        fontSize: 14.0,
                        color: widget.asset.returnPercentage > 0
                            ? Colors.green
                            : Colors.red,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8.0),
                Row(
                  children: [
                    Text(
                      widget.asset.portfolioTokenReturn > 0
                          ? 'Profit:'
                          : 'Loss:',
                      style: const TextStyle(
                        fontSize: 16.0,
                        color: Colors.black87,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      ' ${widget.asset.portfolioTokenReturn.abs()}',
                      style: TextStyle(
                        fontSize: 14.0,
                        color: widget.asset.portfolioTokenReturn > 0
                            ? Colors.green
                            : Colors.red,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30.0),
                Container(
                  height: 300,
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
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 10.0),
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
                                hintText: 'Enter quantity',
                                hintStyle: const TextStyle(
                                    color: Color.fromRGBO(55, 204, 155, 1.0)),
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 10.0),
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
                                labelText: 'Enter purchase price per unit',
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
                                hintText: 'Enter purchase price per unit',
                                hintStyle: const TextStyle(
                                    color: Color.fromRGBO(55, 204, 155, 1.0)),
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 10.0),
                              ),
                              style: const TextStyle(
                                color: Colors.black54,
                                fontSize: 14,
                              ),
                              keyboardType: TextInputType.number,
                              enabled: false, // Make it read-only
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
                                        color:
                                            Color.fromRGBO(55, 204, 155, 1.0)),
                                    border: const OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Color.fromRGBO(
                                              55, 204, 155, 1.0)),
                                    ),
                                    focusedBorder: const OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Color.fromRGBO(
                                              55, 204, 155, 1.0)),
                                    ),
                                    enabledBorder: const OutlineInputBorder(
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
                                        color:
                                            Color.fromRGBO(55, 204, 155, 1.0)),
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 10.0, horizontal: 10.0),
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
                            onPressed: _isCalculating
                                ? null
                                : () {
                                    // Submit the coin data
                                    _submitCoinData();
                                  },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: const Color(0xFF348f6c),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    25.0), // Set your desired border radius here
                              ),
                            ),
                            child: _isCalculating
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2.0,
                                    ),
                                  )
                                : const Text(
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

                      // Display API result
                      if (_apiResult != null) ...[
                        const SizedBox(height: 25.0),
                        Text(
                          _apiResult!['tokenPortfolio']['return'] < 0
                              ? 'Loss: ${_apiResult!['tokenPortfolio']['returnPercentage'].abs()}%'
                              : 'Profit: ${_apiResult!['tokenPortfolio']['returnPercentage'].abs()}%',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w700,
                            color: _apiResult!['tokenPortfolio']['return'] < 0
                                ? Colors.red
                                : Colors.green,
                          ),
                        ),
                        Text(
                          _apiResult!['tokenPortfolio']['return'] < 0
                              ? 'Loss: ${_apiResult!['tokenPortfolio']['return'].abs()}'
                              : 'Profit: ${_apiResult!['tokenPortfolio']['return'].abs()}',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w700,
                            color: _apiResult!['tokenPortfolio']['return'] < 0
                                ? Colors.red
                                : Colors.green,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        _dateController.text = "${picked.toLocal()}".split(' ')[0];
      });
    }
  }

  Future<void> _submitCoinData() async {
    // Ensure all required fields are filled
    if (_amountController.text.isEmpty ||
        _purchasePriceController.text.isEmpty ||
        _quantityController.text.isEmpty ||
        _dateController.text.isEmpty) {
      // Show an error message or handle the validation as needed
      return;
    }

    setState(() {
      _isCalculating = true;
    });

    // Gather the values from the text fields
    final double amount = double.parse(_amountController.text);
    final double quantity = double.parse(_quantityController.text);
    final String date = _dateController.text;

    // You may need to replace this with the actual coin ID or details from the asset
    final String coinId = widget.asset.tokenId; // Ensure this is correctly set

    // Retrieve JWT token from local storage
    final prefs = await SharedPreferences.getInstance();
    final jwtToken = prefs.getString('token');

    if (jwtToken == null) {
      print('JWT token not found in local storage');
      setState(() {
        _isCalculating = false;
      });
      return;
    }

    try {
      // Create the request payload for the API call
      final Map<String, dynamic> payload = {
        'amount': amount,
        'quantity': quantity,
        'date': date, // Include the date if required by the API
      };

      // API call with the JWT token
      final response = await http.post(
        Uri.parse(
            'https://rwa-f1623a22e3ed.herokuapp.com/api/user/token/portfolio/$coinId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $jwtToken',
        },
        body: json.encode(payload),
      );

      if (response.statusCode == 200) {
        // Handle success of the API call
        print('API call successful');
        print(response.body);

        setState(() {
          _apiResult = json.decode(response.body);
        });
      } else {
        // Handle error of the API call
        print('Error in API call: ${response.statusCode}');
        print(response.body); // Print the response body for more details
      }
    } catch (e) {
      print('Exception: $e');
    }

    setState(() {
      _isCalculating = false;
    });
  }
}
