import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rwatrackernew/model/coin_detail.dart';

import '../api/api_service.dart';
import '../model/coin_graph.dart';

class CoinDetailsScreen extends StatefulWidget {
  final String currencyId;

  const CoinDetailsScreen({
    super.key,
    required this.currencyId,
  });

  @override
  State<CoinDetailsScreen> createState() => _CoinDetailsScreenState();
}

class _CoinDetailsScreenState extends State<CoinDetailsScreen> {
  late Future<CoinDetail> futureCoin;
  late Future<CoinGraph> futureCoinGraph;

  @override
  void initState() {
    super.initState();
    futureCoin = ApiService().coinDetails(widget.currencyId);
    futureCoinGraph = ApiService().fetchCoinGraphData(widget.currencyId);
  }

  @override
  Widget build(BuildContext context) {
    print(futureCoinGraph);
    return Scaffold(
      backgroundColor: const Color.fromRGBO(20, 20, 22, 1.0),
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
        title: FutureBuilder<CoinDetail>(
          future: futureCoin,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Text(
                'Loading...',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              );
            } else if (snapshot.hasError) {
              return const Text(
                'Error',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              );
            } else if (snapshot.hasData) {
              return Text(
                snapshot.data?.detail?.name ?? 'Coin Name',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              );
            } else {
              return const Text(
                'Coin Name',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              );
            }
          },
        ),
      ),
      body: FutureBuilder<CoinDetail>(
        future: futureCoin,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error loading coin details'));
          } else if (snapshot.hasData) {
            final coinDetail = snapshot.data!;
            return Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Price'.toUpperCase(),
                              style: const TextStyle(
                                color: Color.fromRGBO(98, 108, 139, 1),
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              '\$${coinDetail.detail!.marketData!.currentPrice['usd']}'
                                  .toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Market Cap'.toUpperCase(),
                              style: const TextStyle(
                                color: Color.fromRGBO(98, 108, 139, 1),
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              '\$${coinDetail.detail!.marketData!.currentPrice['usd']}'
                                  .toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Volume (24h)'.toUpperCase(),
                              style: const TextStyle(
                                color: Color.fromRGBO(98, 108, 139, 1),
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              '\$${coinDetail.detail!.marketData!.currentPrice['usd']}'
                                  .toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    FutureBuilder<CoinGraph>(
                      future: futureCoinGraph,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return const Center(
                              child: Text('Error loading graph data'));
                        } else if (snapshot.hasData) {
                          final coinGraph = snapshot.data!;
                          print('-----------------------');
                          coinGraph.graphData.forEach((dataPoint) {
                            print(
                                'Timestamp: ${dataPoint.timestamp}, Close: ${dataPoint.close}');
                          });

                          return Container(
                            width: double.infinity,
                            height: 300,
                            child: LineChart(
                              LineChartData(
                                lineBarsData: [
                                  LineChartBarData(
                                    spots: coinGraph.graphData
                                        .map((dataPoint) => FlSpot(
                                            dataPoint.timestamp.toDouble(),
                                            dataPoint.close))
                                        .toList(),
                                    isCurved: true,
                                    colors: [Colors.green],
                                    barWidth: 2,
                                    belowBarData: BarAreaData(
                                      show: true,
                                      colors: [Colors.green.withOpacity(0.3)],
                                    ),
                                    dotData: FlDotData(show: false),
                                  ),
                                ],
                                titlesData: FlTitlesData(
                                  leftTitles: SideTitles(showTitles: false),
                                  bottomTitles: SideTitles(
                                    showTitles: true,
                                    getTextStyles: (context, value) =>
                                        const TextStyle(
                                            color: Colors.white, fontSize: 12),
                                    getTitles: (value) {
                                      DateTime date =
                                          DateTime.fromMillisecondsSinceEpoch(
                                              value.toInt());
                                      String formattedDate =
                                          DateFormat('ha').format(date);
                                      return formattedDate;
                                    },
                                    reservedSize: 40,
                                    margin: 8,
                                  ),
                                  rightTitles: SideTitles(
                                    showTitles: true,
                                    getTextStyles: (context, value) =>
                                        const TextStyle(
                                            color: Colors.white, fontSize: 12),
                                    getTitles: (value) =>
                                        '\$${value.toString()}',
                                    reservedSize: 40,
                                    margin: 8,
                                  ),
                                  topTitles: SideTitles(showTitles: false),
                                ),
                                gridData: FlGridData(show: false),
                              ),
                            ),
                          );
                        } else {
                          return const Center(
                              child: Text('No graph data available'));
                        }
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Market Cap Rank',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            Text(
                              '#${coinDetail.detail!.marketCapRank.toString()}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                        Divider()
                      ],
                    )
                  ],
                ));
          } else {
            return const Center(child: Text('No coin details available'));
          }
        },
      ),
    );
  }
}
