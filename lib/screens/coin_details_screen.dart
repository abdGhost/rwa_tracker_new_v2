import 'package:flutter/material.dart';

class CoinDetailsScreen extends StatefulWidget {
  const CoinDetailsScreen({super.key});

  @override
  State<CoinDetailsScreen> createState() => _CoinDetailsScreenState();
}

class _CoinDetailsScreenState extends State<CoinDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 238, 238, 238),
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
        elevation: 0,
        title: const Text(
          'CoinName',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Container(
              width: double.infinity,
              height: 140,
              decoration: BoxDecoration(
                color: Color(0xFF222224),
                border: Border.all(
                  color:
                      const Color.fromARGB(255, 238, 238, 238), // border color
                  width: 1.0, // border width
                ),
                borderRadius: const BorderRadius.all(
                  Radius.circular(10.0), // radius value for rounded corners
                ),
              ),
              child: const Center(
                child: Text('Rounded Border'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
