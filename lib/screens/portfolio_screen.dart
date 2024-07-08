import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PortfolioScreen extends StatefulWidget {
  const PortfolioScreen({super.key});

  @override
  State<PortfolioScreen> createState() => _PortfolioScreenState();
}

class _PortfolioScreenState extends State<PortfolioScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(20, 20, 22, 1.0),
      appBar: AppBar(
        elevation: 0,
        title: Text(
          'Portfolio',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Center(
        child: ListView(
          padding: const EdgeInsets.all(10),
          children: [
            Row(
              children: [
                Image.asset(
                  'assets/rwa_logo.png',
                  width: 50,
                  height: 50,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hello',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        'James Durant',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      )
                    ],
                  ),
                ),
                Spacer(),
                Container(
                  width: 40,
                  height: 40,
                  child: FloatingActionButton(
                    onPressed: () {},
                    child: Icon(
                      Icons.add,
                      color: Colors.black,
                    ),
                    backgroundColor: Color.fromRGBO(55, 204, 155, 1.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100.0),
                    ),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              width: double.infinity,
              height: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  image: AssetImage(
                      'assets/graph_background.png'), // Replace with your graph background image
                  fit: BoxFit.cover,
                ),
              ),
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Total Portfolio',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          '\$127.98',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 24,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 10, // 10% of the container height
                    right: 10, // 10% of the container width
                    child: Container(
                      width: 60,
                      height: 30,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Center(
                        child: Text(
                          '15.3%', // Replace with your profile icon or image
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
            SizedBox(
              height: 20,
            ),
            Text(
              'Crypto Asset',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Card(
              color: const Color(0xFF222224), // Dark background for card
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              clipBehavior: Clip.antiAliasWithSaveLayer,
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Row(
                  crossAxisAlignment:
                      CrossAxisAlignment.center, // Center vertically
                  children: <Widget>[
                    Image.network(
                      'https://via.placeholder.com/100',
                      height: 50,
                      width: 50,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.image,
                            size: 100, color: Colors.grey);
                      },
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'BTC',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Color.fromRGBO(215, 221, 236, 1),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Bitcoin',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color.fromRGBO(215, 221, 236, 1),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Spacer(),
                    Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.end, // Align to right
                      children: <Widget>[
                        Text(
                          '\$54,382.64',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Color.fromRGBO(215, 221, 236, 1),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Container(
                          width: 60,
                          height: 20,
                          decoration: BoxDecoration(
                            color: Color.fromRGBO(55, 204, 155, 1.0),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Center(
                            child: Text(
                              '15.3%', // Replace with your profile icon or image
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
