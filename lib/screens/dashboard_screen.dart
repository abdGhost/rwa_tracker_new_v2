import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:rwatrackernew/screens/coin_details_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../api/api_service.dart';
import '../constant/app_color.dart';
import '../model/coin.dart';
import '../model/hightlight.dart';
import '../model/trend.dart';
import 'package:logger/logger.dart';
import 'package:fl_chart/fl_chart.dart';
import 'login_screen.dart';

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

  void _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) {
      return const LoginScreen();
    }));
  }

  Future<bool?> _showLogoutConfirmationDialog() async {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color(0xffFDFAF6),
          title: Center(
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Color(0xFF348f6c),
                borderRadius: BorderRadius.circular(50),
              ),
              child: Icon(
                Icons.logout,
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
                      'Do you really want to logout?',
                      textAlign: TextAlign.center,
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
                backgroundColor: Colors.red[400],
              ),
              child: Text(
                'Logout',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfffFDFAF6),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          'Home',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.black),
            onPressed: () async {
              bool? result = await _showLogoutConfirmationDialog();
              if (result == true) {
                _logout();
              }
            },
          ),
        ],
      ),
      body: FutureBuilder<Coin>(
        future: futureCoin,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator(color: Color(0xFF348f6c)));
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
                      return const CircularProgressIndicator(
                          color: Color(0xFF348f6c));
                    },
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 20, right: 15),
                  child: Text(
                    'Market',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                      fontSize: 16,
                    ),
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
        'sparkline': [
          0.9080335769113298,
          0.9149032567797601,
          0.9225281031883805,
          0.9737763847683216,
          0.948945817156601,
          0.9433510524870485,
          0.9595671479022112,
          0.9604665150610893,
          0.9588219255591189,
          0.9360563328321745,
          0.9213276649200862,
          0.9148174037532386,
          0.9138798785063427,
          0.9229703167948554,
          0.9314694657043411,
          0.9174200027071306,
          0.9249639653725621,
          0.9319323396759529,
          0.9266867727947296,
          0.934324661779357,
          0.9252695163046516,
          0.9392670064742102,
          0.9370501825707549,
          0.9479797554041691,
          0.9502622256058644,
          0.9546999566150337,
          0.9489640554023823,
          0.9471624048319693,
          0.9478690572760538,
          0.9407694825286402,
          0.9389294894205098,
          0.9324498856764446,
          0.9221981567506166,
          0.9234835138043738,
          0.9312760051997052,
          0.9255940562443523,
          0.9144933422412119,
          0.926511593322447,
          0.9398585780168266,
          0.9486090587161762,
          0.9324111222748087,
          0.9417757803233251,
          0.9379738104506034,
          0.9299344654004336,
          0.9376813451660098,
          0.9399199029079196,
          0.9492140649440565,
          0.9666801758676241,
          0.9615537164942838,
          0.9783585001102625,
          0.9648769588749324,
          0.9600216766228883,
          0.9604587584650885,
          0.9730600238943932,
          0.9645816978872962,
          0.9595690445556049,
          0.9631701967920254,
          0.9902047641990964,
          0.9998532551130948,
          0.9894131290209216,
          0.9763231426104301,
          0.9749074416261493,
          0.9784652276965046,
          0.9742083081259297,
          0.9783737651084267,
          0.9857541138048371,
          0.9825264600878704,
          0.9887192386523512,
          1.0129843970144894,
          0.9954240813766171,
          0.9902804574699642,
          0.9894183140546441,
          0.9910783660450059,
          0.995119320718987,
          1.0000261798551549,
          1.0016414798016502,
          1.0090082325683436,
          1.014838823744156,
          1.0143782145885776,
          1.0273783394873517,
          1.017812961728472,
          0.9975003293122533,
          0.9687129395769758,
          0.9736699180811204,
          0.9685209223175264,
          0.968718991309083,
          0.9536468096521558,
          0.9614241330935025,
          0.9630395119701897,
          0.9711294970765022,
          0.9665547950578703,
          0.976627407755462,
          0.9637119662817403,
          0.9736756485356132,
          0.9589650219465328,
          0.9589042648398034,
          0.9536532315667037,
          0.9522102217793995,
          0.9497353689047863,
          0.947700756279637,
          0.9242301105723623,
          0.9266641140356845,
          0.9321917728570641,
          0.9458738864389781,
          0.962303917249588,
          0.9603220595290907,
          0.978826564143632,
          0.9810929918225919,
          0.9906534501484986,
          0.9982496487794393,
          0.9870352584999752,
          0.9842430907187597,
          0.9748361905506874,
          0.9768226132751138,
          0.984999239121796,
          0.9853353027084051,
          0.9926616642433077,
          0.9849645510824344,
          0.9822331407119278,
          0.9747873416400058,
          0.9803684302543441,
          0.9805387442406549,
          0.9773495478207035,
          0.9708189677922804,
          0.9851354616589191,
          0.979131307573509,
          0.9829072780090935,
          0.9892558158596886,
          0.9775499604582798,
          0.9853586613516973,
          0.9879594910459633,
          0.9800217822022175,
          0.9787705629533557,
          0.9768510900387077,
          0.9834367028909595,
          0.9783348616724342,
          0.9819897568806466,
          0.99091011405006,
          0.9845120860311027,
          1.0022205116402152,
          0.9950327579468903,
          0.9927710749318225,
          0.9961519421962414,
          1.0040141578915847,
          1.0101117647162687,
          0.9990017153968459,
          1.00268690900864,
          1.0078641779758262,
          1.008478898165246,
          0.9903892423647044,
          0.9841956561551825,
          0.9774758829469193,
          0.9790492886460102,
          0.9891744524480026,
          0.9859852202874761,
          0.9870410372277414,
          0.9834746781937967,
          0.9824959509869546,
          0.9801524702155703,
          0.9829877614185275,
          1.007405051014613,
          1.0071093941906144,
          1.0107827060780905,
          1.0291727745992094,
          1.0273892629645993,
          1.0449314543112607,
          1.0432225108415631,
          1.034945667553887
        ],
        'sparkline2': [
          0.851537785964559,
          0.8517808347619711,
          0.84859661798479,
          0.8914987530953518,
          0.8860582223889542,
          0.9125963748635932,
          0.9304162144068542,
          0.9460341543941052,
          0.9412630805810929,
          0.9185816990452217,
          0.906524491096742,
          0.8941984552379396,
          0.9057577144264293,
          0.9147927135318585,
          0.9156916293001186,
          0.9182331911323441,
          0.9274226099602942,
          0.9234651760363191,
          0.9174315800245165,
          0.9042996819661997,
          0.8860692730253964,
          0.890613386635241,
          0.8809185565093977,
          0.8895578185828852,
          0.8906360395220501,
          0.9228945481429172,
          0.9120116325696906,
          0.9331124538728877,
          0.9283318114028823,
          0.9314641322033821,
          0.9354090639568666,
          0.9377005376319466,
          0.9377371714700377,
          0.9250126351336264,
          0.9388766503802629,
          0.9399891322158603,
          0.9386765107419633,
          0.9414291554029331,
          0.959262521365845,
          0.9642538330747547,
          0.9563833157876046,
          0.9503916959800407,
          0.9614676705104361,
          0.9393286727755994,
          0.9363256522208374,
          0.9472246278550537,
          0.9473316200223167,
          0.9401850841085093,
          0.9499968305603713,
          0.9370707754675623,
          0.945137954888622,
          0.9573774374061167,
          0.960486989234535,
          0.9655665034597787,
          0.9697566571575558,
          0.9548575655186728,
          0.9578312696055055,
          0.9488308963057267,
          0.950272989544302,
          0.9687037237998416,
          0.9652110346883084,
          0.9532254682203178,
          0.9513715399893572,
          0.9525984246392027,
          0.9612335476434033,
          0.9679716969751914,
          0.9731529664408997,
          0.9788958347204012,
          0.9842585519793328,
          0.9803124732077935,
          0.9741660935026987,
          0.9718109497018994,
          0.9713979338300648,
          0.9649560649968693,
          0.9576022347130975,
          0.956073473727544,
          0.9535504454753218,
          0.9680476524719326,
          1.0054749491790993,
          1.0679534690138133,
          1.02148380909481,
          1.0591057360455125,
          1.0508614370926983,
          1.1223819026107296,
          1.1022862270810934,
          1.0861781535296373,
          1.066688707480707,
          1.0681919911246653,
          1.0714917386777276,
          1.0704597876698014,
          1.060606418000399,
          1.0561072905750233,
          1.0570718068404168,
          1.0676623509853131,
          1.0526176427811436,
          1.048449030805324,
          1.0260528391745873,
          1.0314671531401831,
          1.0151557588157267,
          1.013452219318406,
          0.9939087898629182,
          0.9924656566996971,
          1.040113570869816,
          1.0395995822177293,
          1.072033655305302,
          1.0308236925917351,
          1.039430303574895,
          1.0500228772878102,
          1.070062374445215,
          1.066609214016507,
          1.060338071112094,
          1.0564039558245824,
          1.067615285231793,
          1.066953011452663,
          1.0693224944517048,
          1.070293825115471,
          1.0587440340368888,
          1.0796311311207778,
          1.0826280237843084,
          1.0833160518931013,
          1.0609044508927183,
          1.0524296900272567,
          1.0568687144472098,
          1.063826441178556,
          1.0805033969357576,
          1.0806692159682272,
          1.047849954703051,
          1.0686670243506349,
          1.0740317785613311,
          1.0763680756600418,
          1.0745198073598603,
          1.0717720449111656,
          1.068944498793725,
          1.061564624774056,
          1.0591783337037723,
          1.0581622900416365,
          1.0568351206160629,
          1.0603774160646726,
          1.0677970243783543,
          1.0651868353095362,
          1.0711997235738153,
          1.0751592818483855,
          1.0985203075103978,
          1.0752686804811784,
          1.058965004500935,
          1.063565100549957,
          1.0523944270554986,
          1.047997066718833,
          1.0551092839543197,
          1.0630628091128373,
          1.0320569198056952,
          1.0554610212129882,
          1.0499496308444827,
          1.056304626604269,
          1.0587502803235638,
          1.0568498250464724,
          1.0706271613616978,
          1.0690098608848337,
          1.0695898892071634,
          1.074808811615492,
          1.0694322491271648,
          1.063993307383651,
          1.0765331525049124,
          1.0772562870400544,
          1.0891857700782706,
          1.0810233767634148,
          1.0883886998436838,
          1.0877016614134845
        ],
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
          height: 180,
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
                  color: Color(0xFFfbf2e6),
                  borderRadius: const BorderRadius.all(Radius.circular(8.0)),
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
                                Row(
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item['marketCap']!,
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 20,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            const Text(
                                              'Market Cap',
                                              style: TextStyle(
                                                color: Colors.black,
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
                                                    color: highlight
                                                                .highlightData
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
                                      ],
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    _buildMarketCapGraph(
                                      highlight
                                          .highlightData.marketCapChange24h,
                                      item['sparkline'] as List<double>,
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item['volume_24h']!,
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 20,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        const Text(
                                          '24h Trading Volume',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                      ],
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    _buildMarketCapGraph(
                                      highlight
                                          .highlightData.marketCapChange24h,
                                      item['sparkline2'] as List<double>,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      if (item.containsKey('title'))
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: Row(
                            children: [
                              Icon(
                                Icons.trending_up,
                                color: Colors.red,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                item['title']!,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 20,
                                ),
                              ),
                            ],
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
                                        color: Colors.black,
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

  Widget _buildMarketCapGraph(double marketCapChange24h, List<double> prices) {
    Color lineColor = marketCapChange24h >= 0 ? Colors.green : Colors.red;

    return SizedBox(
      height: 50,
      width: 80,
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
      child: Card(
        color: Colors.white,
        elevation: 0.0,
        margin: const EdgeInsets.only(bottom: 10.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
            border: Border.all(color: Colors.grey.withOpacity(0.1)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                Image.network(
                  currency.image ?? '',
                  width: 30,
                  height: 30,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.error),
                ),
                const SizedBox(width: 10),
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        currency.name ?? '',
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        currency.symbol?.toUpperCase() ?? '',
                        style: const TextStyle(
                          color: captionColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                if (currency.sparklineIn7D?.price != null)
                  SizedBox(
                    width: 80,
                    child: _buildSparkline(
                      currency.sparklineIn7D!.price,
                      priceColor,
                    ),
                  ),
                const SizedBox(width: 30),
                SizedBox(
                  width: 80,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '\$${formatNumber(currency.marketCap ?? 0.0)}',
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 16,
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSparkline(List<double> prices, Color lineColor) {
    return SizedBox(
      height: 50,
      width: 100,
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
