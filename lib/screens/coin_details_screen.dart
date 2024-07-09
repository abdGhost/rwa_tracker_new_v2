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
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              );
            } else if (snapshot.hasData) {
              return Text(
                snapshot.data?.detail.name ?? 'Coin Name',
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
                    const Text(
                      'Graph Data',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                      ),
                    ),
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
                                      color: Colors.white, fontSize: 12),
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
                                      color: Colors.white, fontSize: 12),
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
                    // Static Information Section
                    Column(
                      children: [
                        _buildRow('Static Info 1', 'Value 1'),
                        const Divider(),
                        _buildRow('Static Info 2', 'Value 2'),
                        const Divider(),
                      ],
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

  Widget _buildRow(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: Colors.white,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
