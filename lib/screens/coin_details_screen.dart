import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../api/api_service.dart';
import '../model/coin_detail.dart';
import '../model/coin_graph.dart';

class CoinDetailsScreen extends StatefulWidget {
  final String currencyId;

  const CoinDetailsScreen({
    Key? key,
    required this.currencyId,
  }) : super(key: key);

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
        elevation: 0.4,
        title: FutureBuilder<CoinDetail>(
          future: futureCoin,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Text(
                'Loading...',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              );
            } else if (snapshot.hasError) {
              return const Text(
                'Error',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              );
            } else if (snapshot.hasData) {
              return Text(
                snapshot.data?.detail.name ?? 'Coin Name',
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              );
            } else {
              return const Text(
                'Coin Name',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              );
            }
          },
        ),
      ),
      body: SingleChildScrollView(
        child: FutureBuilder<CoinGraph>(
          future: futureCoinGraph,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return const Center(child: Text('Error loading graph data'));
            } else if (snapshot.hasData) {
              final coinGraph = snapshot.data!;
              return Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FutureBuilder<CoinDetail>(
                      future: futureCoin,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(
                              child: Text(
                                  'Error loading data: ${snapshot.error}'));
                        } else if (snapshot.hasData) {
                          final coinDetail = snapshot.data!;
                          final imageUrl = coinDetail.detail.image;
                          final coinName = coinDetail.detail.name;
                          final coinSymbol =
                              coinDetail.detail.symbol.toUpperCase();
                          final currentPrice = coinDetail
                                  .detail.marketData.currentPrice['usd'] ??
                              0.0;
                          final high24h =
                              coinDetail.detail.marketData.high24h['usd'] ??
                                  0.0;
                          final low24h =
                              coinDetail.detail.marketData.low24h['usd'] ?? 0.0;
                          final priceChange24h = coinDetail
                                  .detail.marketData.priceChangePercentage24h ??
                              0.0;

                          return Padding(
                            padding: const EdgeInsets.only(left: 0, right: 20),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Image.network(
                                      imageUrl,
                                      width: 30,
                                      height: 30,
                                    ),
                                    const SizedBox(width: 10),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          coinName,
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black87,
                                          ),
                                        ),
                                        Text(
                                          coinSymbol,
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Colors.black54,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Container(
                                  width: 120,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.2),
                                        spreadRadius: 2,
                                        blurRadius: 5,
                                        offset: const Offset(0, 3),
                                      ),
                                    ],
                                    border: Border.all(
                                        color: Colors.grey.withOpacity(0.2)),
                                  ),
                                  padding: const EdgeInsets.all(6),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '\$$currentPrice',
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.black87,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      const SizedBox(height: 2),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            priceChange24h >= 0
                                                ? Icons.arrow_drop_up
                                                : Icons.arrow_drop_down,
                                            color: priceChange24h >= 0
                                                ? Colors.green
                                                : Colors.red,
                                          ),
                                          Text(
                                            '${priceChange24h.toStringAsFixed(2)}%',
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                              color: priceChange24h >= 0
                                                  ? Colors.green
                                                  : Colors.red,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        } else {
                          return const Center(child: Text('No data available'));
                        }
                      },
                    ),
                    const SizedBox(height: 25),
                    const SizedBox(height: 20),
                    SizedBox(
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
                                      color: Colors.black, fontSize: 12),
                              getTitles: (value) {
                                DateTime date =
                                    DateTime.fromMillisecondsSinceEpoch(
                                        value.toInt());
                                return DateFormat('ha').format(date);
                              },
                              reservedSize: 40,
                              margin: 8,
                            ),
                            rightTitles: SideTitles(
                              showTitles: true,
                              getTextStyles: (context, value) =>
                                  const TextStyle(
                                      color: Colors.black, fontSize: 12),
                              getTitles: (value) {
                                double closest =
                                    coinGraph.graphData.first.close;
                                for (var dataPoint in coinGraph.graphData) {
                                  if ((dataPoint.close - value).abs() <
                                      (closest - value).abs()) {
                                    closest = dataPoint.close;
                                  }
                                }
                                return '\$${closest.toStringAsFixed(2)}';
                              },
                              reservedSize: 40,
                              margin: 8,
                            ),
                            topTitles: SideTitles(showTitles: false),
                          ),
                          gridData: FlGridData(show: false),
                          borderData: FlBorderData(show: false),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Coin Details Section
                    FutureBuilder<CoinDetail>(
                      future: futureCoin,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(
                              child: Text(
                                  'Error loading data: ${snapshot.error}'));
                        } else if (snapshot.hasData) {
                          final coinDetail = snapshot.data!;
                          final marketData = coinDetail.detail.marketData;
                          return Container(
                            color: Colors.white,
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    _buildCustomCard(
                                      'Current Price',
                                      '\$${marketData.currentPrice['usd']}',
                                    ),
                                    const SizedBox(width: 10),
                                    _buildCustomCard(
                                      'Market Cap',
                                      '\$${_formatLargeValue(marketData.marketCap['usd']!)}',
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    _buildCustomCard(
                                      'Total Volume',
                                      '\$${_formatLargeValue(marketData.totalVolume['usd']!)}',
                                    ),
                                    const SizedBox(width: 10),
                                    _buildCustomCard(
                                      'Market Cap Rank',
                                      '${marketData.marketCapRank}',
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    _buildCustomCard(
                                      '24h High',
                                      '\$${marketData.high24h['usd']}',
                                    ),
                                    const SizedBox(width: 10),
                                    _buildCustomCard(
                                      '24h Low',
                                      '\$${marketData.low24h['usd']}',
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    _buildCustomCard(
                                      'Circulating Supply',
                                      '${_formatLargeValue(marketData.circulatingSupply)}',
                                    ),
                                    const SizedBox(width: 10),
                                    _buildCustomCard(
                                      'Total Supply',
                                      '${_formatLargeValue(marketData.totalSupply)}',
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    _buildCustomCard(
                                      'All-time High',
                                      '\$${marketData.ath['usd']}',
                                    ),
                                    const SizedBox(width: 10),
                                    _buildCustomCard(
                                      'Since All-time High',
                                      '${marketData.athChangePercentage['usd']}%',
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                // Row(
                                //   children: [
                                //     _buildCustomCard('All-time High Date',
                                //         '${marketData.athDate['usd']}'),
                                //     const SizedBox(width: 10),
                                //     _buildCustomCard('All-time Low',
                                //         '\$${marketData.atl['usd']}'),
                                //   ],
                                // ),
                                const SizedBox(height: 10),
                                // Row(
                                //   children: [
                                //     _buildCustomCard('Since All-time Low',
                                //         '${marketData.atlChangePercentage['usd']}%'),
                                //     const SizedBox(width: 10),
                                //     _buildCustomCard('All-time Low Date',
                                //         '${marketData.atlDate['usd']}'),
                                //   ],
                                // ),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    _buildCustomCard(
                                      'Website',
                                      '${coinDetail.detail.links.homepage[0]}',
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        } else {
                          return const Center(child: Text('No data available'));
                        }
                      },
                    ),
                  ],
                ),
              );
            } else {
              return const Center(child: Text('No graph data available'));
            }
          },
        ),
      ),
    );
  }

  Widget _buildCustomCard(String title, String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
          border: Border.all(color: Colors.grey.withOpacity(0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.black87,
                overflow: TextOverflow.ellipsis,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  String _formatLargeValue(double value) {
    if (value >= 1e9) {
      return '${(value / 1e9).toStringAsFixed(1)}B';
    } else if (value >= 1e6) {
      return '${(value / 1e6).toStringAsFixed(1)}M';
    } else if (value >= 1e3) {
      return '${(value / 1e3).toStringAsFixed(1)}K';
    } else {
      return value.toStringAsFixed(2);
    }
  }
}
