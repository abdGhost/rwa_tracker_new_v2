import 'package:flutter/material.dart';
import 'package:rwatrackernew/screens/add_coin_new_v3.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../model/portfolio/crypto_asset.dart';

class PortfolioScreen extends StatefulWidget {
  const PortfolioScreen({super.key});

  @override
  State<PortfolioScreen> createState() => _PortfolioScreenState();
}

class _PortfolioScreenState extends State<PortfolioScreen> {
  String? _userName;

  @override
  void initState() {
    super.initState();
    _loadUserName();
  }

  Future<void> _loadUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _userName = prefs.getString('user_name1') ?? 'Ghost';
    });
  }

  final List<CryptoAsset> _cryptoAssets = [
    CryptoAsset(
      symbol: 'ONDO',
      name: 'Ondo Finance',
      imageUrl: 'assets/ondo.png',
      price: 1.02,
      change: 5.2,
    ),
    CryptoAsset(
      symbol: 'OM',
      name: 'MANTRA DAO',
      imageUrl: 'assets/mantra.png',
      price: 0.750963,
      change: 5.34,
    ),
    CryptoAsset(
      symbol: 'PENDLE',
      name: 'Pendle',
      imageUrl: 'assets/pendle.png',
      price: 0.729,
      change: 1.2,
    ),
    CryptoAsset(
      symbol: 'XDC',
      name: 'XDC Network',
      imageUrl: 'assets/xdc.png',
      price: 0.0275,
      change: 2.5,
    ),
    CryptoAsset(
      symbol: 'GFI',
      name: 'Goldfinch',
      imageUrl: 'assets/goldfinch.png',
      price: 2.11,
      change: -3.00,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
      body: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10),
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
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) {
                              // return const AddCoinNew();
                              return AddCoinNew();
                            }),
                          );
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
                // image: const DecorationImage(
                //   image: AssetImage('assets/graph_background.png'),
                //   fit: BoxFit.cover,
                // ),
              ),
              child: Stack(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 10, right: 10),
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
                          '\$127.98',
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
                      width: 60,
                      height: 30,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: Color(0xFF348f6c),
                          width: 1.0,
                        ),
                      ),
                      child: const Center(
                        child: Text(
                          '15.3%',
                          style: TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
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
                itemCount: _cryptoAssets.length,
                itemBuilder: (context, index) {
                  final asset = _cryptoAssets[index];
                  return Card(
                    elevation: 0.3,
                    color: Colors.white, // Ensure the card color is white
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          ClipRRect(
                            borderRadius: BorderRadius.circular(25),
                            // child: Image.network(
                            //   asset.imageUrl,
                            //   height: 50,
                            //   width: 50,
                            //   fit: BoxFit.cover,
                            //   errorBuilder: (context, error, stackTrace) {
                            //     return const Icon(
                            //       Icons.image,
                            //       size: 50,
                            //       color: Colors.grey,
                            //     );
                            //   },
                            // ),
                            child: Image.asset(
                              asset.imageUrl,
                              height: 40,
                              width: 40,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(
                                  Icons.image,
                                  size: 50,
                                  color: Colors.grey,
                                );
                              },
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  asset.symbol,
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
                                  asset.name,
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
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              Text(
                                '\$${asset.price.toStringAsFixed(2)}',
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
                                    asset.change >= 0
                                        ? Icons.arrow_drop_up
                                        : Icons.arrow_drop_down,
                                    color: asset.change >= 0
                                        ? Color(0xFF348f6c)
                                        : Colors.red,
                                    size: 28,
                                  ),
                                  Text(
                                    '${asset.change}%',
                                    style: TextStyle(
                                      color: asset.change >= 0
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
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
