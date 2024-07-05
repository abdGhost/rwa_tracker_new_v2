import 'package:flutter/material.dart';
import 'package:rwatrackernew/screens/coin_details_screen.dart';
import '../api/api_service.dart';
import '../model/coin.dart';
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
  final Logger logger = Logger();

  @override
  void initState() {
    super.initState();
    futureCoin = ApiService().fetchCoins();
    logger.d('Fetching coins: $futureCoin');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(20, 20, 22, 1.0),
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
                _buildHeader(),
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

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Container(
        width: double.infinity,
        height: 140,
        decoration: const BoxDecoration(
          color: Color(0xFF222224),
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
        child: const Center(
          child: Text('Rounded Border', style: TextStyle(color: Colors.white)),
        ),
      ),
    );
  }

  Widget _buildCurrencyItem(Currency currency) {
    Color priceColor = (currency.priceChangePercentage24H ?? 0) >= 0
        ? Colors.green
        : Colors.red;

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
          color: const Color(0xFF222224),
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
                      color: Color.fromRGBO(98, 108, 139, 1),
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
