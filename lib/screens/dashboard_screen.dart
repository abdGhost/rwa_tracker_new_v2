import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:rwatrackernew/screens/coin_details_screen.dart';
import '../api/api_service.dart';
import '../constant/app_color.dart';
import '../model/coin.dart';
import '../model/hightlight.dart';
import '../model/trend.dart';

import 'package:logger/logger.dart';
import 'package:fl_chart/fl_chart.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String formatNumber(double number) {
    if (number >= 1e9) {
      return '${(number / 1e9).toStringAsFixed(2)}B';
    } else if (number >= 1e6) {
      return '${(number / 1e6).toStringAsFixed(2)}M';
    } else if (number >= 1e3) {
      return '${(number / 1e3).toStringAsFixed(2)}K';
    }
    return number.toStringAsFixed(2);
  }

  late Future<Coin> futureCoin;
  late Future<HighlightModel> futureHighlight;
  late Future<TrendResponse> futureTrend;
  final Logger logger = Logger();

  @override
  void initState() {
    super.initState();
    futureCoin = ApiService().fetchCoins();
    futureHighlight = ApiService().fetchHighlightData();
    futureTrend = ApiService().fetchTrends();
    logger.d('Fetching highlight: $futureHighlight');
    logger.d('Fetching trend: $futureTrend');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        title: const Text(
          'Dashboard',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: FutureBuilder<Coin>(
        future: futureCoin,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            print(snapshot);
            logger.e('Error fetching coins: ${snapshot.error}');
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.currency.isEmpty) {
            return const Center(child: Text('No data available'));
          }

          List<Currency> currencies = snapshot.data!.currency;
          logger.d('Fetched currencies: $currencies');

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: FutureBuilder<Map<String, dynamic>>(
                    future: Future.wait([futureHighlight, futureTrend]).then(
                      (results) => {
                        'highlight': results[0],
                        'trend': results[1],
                      },
                    ),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final highlightData =
                            snapshot.data!['highlight'] as HighlightModel;
                        final trendData =
                            snapshot.data!['trend'] as TrendResponse;
                        return _buildHeader(highlightData, trendData);
                      } else if (snapshot.hasError) {
                        return Text('${snapshot.error}');
                      }
                      return const CircularProgressIndicator();
                    },
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 15, right: 15),
                  child: Text(
                    'Market',
                    style: TextStyle(
                        fontWeight: FontWeight.w600, color: Colors.white),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    children: currencies
                        .map((currency) => _buildCurrencyItem(currency))
                        .toList(),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(HighlightModel highlight, TrendResponse trend) {
    List<Map<String, dynamic>> items = [
      {
        'marketCap':
            '\$${highlight.highlightData.marketCap.toStringAsFixed(2)}',
        'marketCapChange24h': highlight.highlightData.marketCapChange24h,
        'volume_24h':
            '\$${highlight.highlightData.volume24h.toStringAsFixed(2)}',
        'color': cardColor.value.toString(),
      },
      {
        'title': 'Top 3 Tokens',
        'tokens': trend.trend
            .take(3)
            .map((coin) => {
                  'name': coin.name,
                  'low_24': coin.low24h.toString(),
                  'priceChange': coin.priceChange24h
                })
            .toList(),
        'color': cardColor.value.toString(),
      },
      {
        'title': 'Newly Added Tokens',
        'tokens': trend.trend.reversed
            .take(3)
            .map((coin) => {
                  'name': coin.name,
                  'low_24': coin.low24h.toString(),
                  'priceChange': coin.priceChange24h
                })
            .toList(),
        'color': cardColor.value.toString(),
      },
    ];

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: CarouselSlider(
        options: CarouselOptions(
          height: 160,
          enlargeCenterPage: true,
          autoPlay: false,
          aspectRatio: 16 / 9,
          autoPlayCurve: Curves.fastOutSlowIn,
          enableInfiniteScroll: true,
          autoPlayAnimationDuration: const Duration(milliseconds: 800),
          viewportFraction: 0.8,
        ),
        items: items.map((item) {
          return Builder(
            builder: (BuildContext context) {
              return Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Color(int.parse(item['color']!)),
                  borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (item.containsKey('marketCap'))
                        Expanded(
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item['marketCap']!,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Row(
                                  children: [
                                    const Text(
                                      'Market Cap',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Icon(
                                          highlight.highlightData
                                                      .marketCapChange24h >=
                                                  0
                                              ? Icons.arrow_drop_up
                                              : Icons.arrow_drop_down,
                                          color: highlight.highlightData
                                                      .marketCapChange24h >=
                                                  0
                                              ? successColor
                                              : dangerColor,
                                        ),
                                        Text(
                                          '${highlight.highlightData.marketCapChange24h.toStringAsFixed(2)}%',
                                          style: TextStyle(
                                            color: highlight.highlightData
                                                        .marketCapChange24h >=
                                                    0
                                                ? successColor
                                                : dangerColor,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                Text(
                                  item['volume_24h']!,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                  ),
                                ),
                                const Text(
                                  '24h trading volume',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ),
                      if (item.containsKey('title'))
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: Text(
                            item['title']!,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      if (item.containsKey('tokens'))
                        Expanded(
                          child: ListView.builder(
                            itemCount: (item['tokens'] as List).length,
                            itemBuilder: (context, index) {
                              final token = (item['tokens'] as List)[index];
                              return Padding(
                                padding: const EdgeInsets.only(top: 5.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      token['name'],
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Icon(
                                          token['priceChange'] >= 0
                                              ? Icons.arrow_drop_up
                                              : Icons.arrow_drop_down,
                                          color: token['priceChange'] >= 0
                                              ? successColor
                                              : dangerColor,
                                        ),
                                        Text(
                                          token['low_24']!,
                                          style: TextStyle(
                                            color: token['priceChange'] >= 0
                                                ? successColor
                                                : dangerColor,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          );
        }).toList(),
      ),
    );
  }

  Widget _buildCurrencyItem(Currency currency) {
    Color priceColor = (currency.priceChangePercentage24H ?? 0) >= 0
        ? successColor
        : dangerColor;

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: ((context) {
          return CoinDetailsScreen(
            currencyId: currency.id!,
          );
        })));
      },
      child: Container(
        height: 100,
        margin: const EdgeInsets.only(bottom: 10.0),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(4.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.network(
                currency.image ?? '',
                width: 40,
                height: 40,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.error),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    currency.name ?? '',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    currency.symbol?.toUpperCase() ?? '',
                    style: const TextStyle(
                      color: captionColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                width: 0,
              ),
              if (currency.sparklineIn7D?.price != null)
                _buildSparkline(currency.sparklineIn7D!.price, priceColor),
              const SizedBox(
                width: 0,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '\$${formatNumber(currency.marketCap ?? 0.0)}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    '${currency.priceChangePercentage24H?.toStringAsFixed(2) ?? '0.00'}%',
                    style: TextStyle(
                      color: priceColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSparkline(List<double> prices, Color lineColor) {
    return SizedBox(
      height: 50,
      width: 100, // Specify a width for the sparkline graph
      child: LineChart(
        LineChartData(
          lineBarsData: [
            LineChartBarData(
              spots: prices
                  .asMap()
                  .entries
                  .map((e) => FlSpot(e.key.toDouble(), e.value))
                  .toList(),
              isCurved: true,
              colors: [lineColor],
              barWidth: 2,
              isStrokeCapRound: true,
              belowBarData: BarAreaData(show: false),
              dotData: FlDotData(show: false),
            ),
          ],
          titlesData: FlTitlesData(show: false),
          gridData: FlGridData(show: false),
          borderData: FlBorderData(show: false),
        ),
      ),
    );
  }
}
