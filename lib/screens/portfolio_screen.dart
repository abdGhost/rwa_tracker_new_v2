import 'package:flutter/material.dart';
import 'package:rwatrackernew/screens/add_coin_new_v3.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../model/portfolio/crypto_asset.dart';
import 'coin_edit_screen.dart'; // Import the CoinEditScreen

class PortfolioScreen extends StatefulWidget {
  const PortfolioScreen({super.key});

  @override
  State<PortfolioScreen> createState() => _PortfolioScreenState();
}

class _PortfolioScreenState extends State<PortfolioScreen> {
  bool onBack = false;

  void _updateOnBack(bool value, [String? assetId]) {
    setState(() {
      onBack = value;
      _editedAssetId = assetId;
    });
    _fetchPortfolio();
  }

  String? _userName;
  List<PortfolioToken> _portfolioTokens = [];
  bool _isLoading = true;
  double _totalReturn = 0.0;
  double _totalPercentage = 0.0;
  double _totalAmount = 0.0;
  String? _editedAssetId; // Add this variable

  @override
  void initState() {
    super.initState();
    _loadUserName();
    _fetchPortfolio();
  }

  Future<void> _loadUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _userName = prefs.getString('user_name') ?? 'User';
    });
  }

  Future<void> _fetchPortfolio() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    print(token);

    final response = await http.get(
      // Uri.parse(
      //     'https://rwa-f1623a22e3ed.herokuapp.com/api/user/token/portfolio'),
      // Uri.parse('http://192.168.1.22:5001/api/user/token/portfolio'),
      Uri.parse(
          "https://rwa-f1623a22e3ed.herokuapp.com/api/user/token/portfolio"),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    print('*************************************************************');
    print(response.body);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['status'] == false) {
        setState(() {
          _isLoading = false;
        });
        return;
      }
      setState(() {
        _portfolioTokens = (data['portfolioToken'] as List)
            .map((item) => PortfolioToken.fromJson(item))
            .toList();
        _totalReturn = (data['totalReturn'] as num).toDouble();
        _totalPercentage = (data['totalPercentage'] as num).toDouble();
        _totalAmount = (data['totalAmount'] as num).toDouble();
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
      // Handle error
      ScaffoldMessenger.of(context)
          .hideCurrentSnackBar(); // Dismiss the current SnackBar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load portfolio')),
      );
    }
  }

  Future<void> _deleteAsset(String tokenId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    final response = await http.delete(
      // Uri.parse(
      //     'https://rwa-f1623a22e3ed.herokuapp.com/api/user/token/portfolio/$tokenId'),
      Uri.parse(
          'https://rwa-f1623a22e3ed.herokuapp.com/api/user/token/remove/portfolio/$tokenId'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    print('Delete response ----------------->');
    print(response.body);

    if (response.statusCode == 200) {
      setState(() {
        _portfolioTokens.removeWhere((token) => token.tokenId == tokenId);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Asset deleted successfully')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete asset')),
      );
    }
  }

  Future<bool?> _showDeleteConfirmationDialog(String tokenId) async {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false, // User must tap button to dismiss
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color(0xffFDFAF6),
          title: Center(
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Color(0xFF348f6c),
                borderRadius: BorderRadius.circular(50), // Rounded border
              ),
              child: Icon(
                Icons.delete,
                color: Colors.white,
                size: 30,
              ),
            ),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Are You Sure?',
                      style: TextStyle(
                        color: Color(0xFF707070),
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Do you really want to delete this coin? You will not be able to undo this action.',
                      textAlign: TextAlign.center, // Center align text
                      style: TextStyle(
                        color: Colors.black45,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: <Widget>[
            OutlinedButton(
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red[400], // Background color
              ),
              child: Text(
                'Delete',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
              onPressed: () {
                setState(() {
                  _deleteAsset(tokenId);
                  // _fetchPortfolio();
                  Navigator.of(context).pop(true);
                });
              },
            ),
          ],
        );
      },
    );
  }

  String capitalizeFirstLetter(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }

  double calculateTextWidth(String text, TextStyle style) {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout(minWidth: 0, maxWidth: double.infinity);
    return textPainter.size.width + 20; // Adding some padding
  }

  @override
  Widget build(BuildContext context) {
    print('************************************');
    print(_editedAssetId);

    String percentageText =
        '${_totalPercentage.toStringAsFixed(2).replaceAll('-', '')}%';
    TextStyle textStyle = TextStyle(
      color: _totalPercentage >= 0 ? Colors.green : Colors.red,
      fontWeight: FontWeight.bold,
    );
    double dynamicWidth = calculateTextWidth(percentageText, textStyle);

    return Scaffold(
      backgroundColor: Color(0xfffFDFAF6),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          'Portfolio',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
              color: Color(0xFF348f6c),
            ))
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      children: [
                        Image.asset(
                          'assets/rwa_logo.png',
                          width: 40,
                          height: 40,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Hello',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black54,
                                ),
                              ),
                              Text(
                                _userName ?? '',
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w700,
                                ),
                              )
                            ],
                          ),
                        ),
                        const Spacer(),
                        Padding(
                          padding: const EdgeInsets.only(right: 5),
                          child: Container(
                            width: 40,
                            height: 40,
                            child: FloatingActionButton(
                              onPressed: () async {
                                final result = await Navigator.of(context).push(
                                  MaterialPageRoute(builder: (context) {
                                    return AddCoinNew(
                                      onBackCallback: _updateOnBack,
                                    );
                                  }),
                                );
                                if (result == true) {
                                  _fetchPortfolio();
                                }
                              },
                              child: const Icon(
                                Icons.add,
                                color: Colors.white,
                              ),
                              backgroundColor: Color(0xFF348f6c),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(100.0),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    height: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Stack(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Total Portfolio',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                  color: Colors.black54,
                                ),
                              ),
                              Text(
                                '\$${_totalAmount.toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 24,
                                  color: Color(0xFF348f6c),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          top: 25,
                          right: 10,
                          child: Container(
                            width: dynamicWidth,
                            height: 30,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                color: _totalPercentage >= 0
                                    ? Colors.green
                                    : Colors.red,
                                width: 1.0,
                              ),
                              color: _totalPercentage >= 0
                                  ? Colors.green.withOpacity(0.2)
                                  : Colors.red.withOpacity(0.2),
                            ),
                            child: Center(
                              child: Text(
                                percentageText,
                                style: textStyle,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Text(
                      'Crypto Asset',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(10),
                      itemCount: _portfolioTokens.length,
                      itemBuilder: (context, index) {
                        final asset = _portfolioTokens[index];
                        return Dismissible(
                          key: Key(asset.tokenId),
                          direction: DismissDirection.endToStart,
                          confirmDismiss: (direction) async {
                            return await _showDeleteConfirmationDialog(
                                asset.tokenId);
                          },
                          background: Container(
                            color: Colors.red,
                            alignment: Alignment.centerRight,
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: Icon(
                              Icons.delete,
                              color: Colors.white,
                            ),
                          ),
                          child: GestureDetector(
                            onTap: () async {
                              final result = await Navigator.of(context).push(
                                MaterialPageRoute(builder: (context) {
                                  return CoinEditScreen(
                                      asset: asset,
                                      onBackCallback: _updateOnBack);
                                }),
                              );
                              if (result == true) {
                                setState(() {
                                  _editedAssetId =
                                      asset.tokenId; // Set the edited asset ID
                                });
                                _fetchPortfolio();
                              }
                            },
                            child: Card(
                              elevation: 0,
                              color: Colors.white,
                              shape: _editedAssetId == asset.tokenId
                                  ? new RoundedRectangleBorder(
                                      side: new BorderSide(
                                        color: Color(0xFF348f6c),
                                        width: 1.0,
                                      ),
                                      borderRadius: BorderRadius.circular(4.0))
                                  : new RoundedRectangleBorder(
                                      side: new BorderSide(
                                          color: Colors.white, width: 1.0),
                                      borderRadius: BorderRadius.circular(4.0),
                                    ),
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              child: Padding(
                                padding: const EdgeInsets.all(15),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Image.network(
                                      asset.image,
                                      width: 30,
                                      height: 30,
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              Icon(Icons.error),
                                    ),
                                    const SizedBox(width: 20),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            capitalizeFirstLetter(asset.name),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              fontSize: 16,
                                              color: Colors.black87,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            capitalizeFirstLetter(asset.symbol),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              fontSize: 14,
                                              color: Colors.black54,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Spacer(),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: <Widget>[
                                        Text(
                                          '\$${asset.portfolioTokenReturn.toStringAsFixed(2).replaceAll('-', '')}',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            color: Colors.black87,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        const SizedBox(height: 1),
                                        Row(
                                          children: [
                                            Icon(
                                              asset.returnPercentage >= 0
                                                  ? Icons.arrow_drop_up
                                                  : Icons.arrow_drop_down,
                                              color: asset.returnPercentage >= 0
                                                  ? Color(0xFF348f6c)
                                                  : Colors.red,
                                              size: 28,
                                            ),
                                            Text(
                                              '${asset.returnPercentage.toStringAsFixed(2).replaceAll('-', '')}%',
                                              style: TextStyle(
                                                color:
                                                    asset.returnPercentage >= 0
                                                        ? Color(0xFF348f6c)
                                                        : Colors.red,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
    );
  }
}
