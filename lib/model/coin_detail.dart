class CoinDetail {
  bool status;
  Detail detail;

  CoinDetail({
    required this.status,
    required this.detail,
  });

  factory CoinDetail.fromJson(Map<String, dynamic> json) {
    return CoinDetail(
      status: json['status'],
      detail: Detail.fromJson(json['detail']),
    );
  }
}

class Detail {
  String name;
  String symbol;
  String image;
  MarketData marketData;
  Links links;

  Detail({
    required this.name,
    required this.symbol,
    required this.image,
    required this.marketData,
    required this.links,
  });

  factory Detail.fromJson(Map<String, dynamic> json) {
    return Detail(
      name: json['name'],
      symbol: json['symbol'],
      image: json['image']['large'],
      marketData: MarketData.fromJson(json['market_data']),
      links: Links.fromJson(json['links']),
    );
  }
}

class MarketData {
  Map<String, double> currentPrice;
  Map<String, double> marketCap;
  Map<String, double> totalVolume;
  int marketCapRank;
  Map<String, double> fullyDilutedValuation;
  Map<String, double> high24h;
  Map<String, double> low24h;
  double circulatingSupply;
  double totalSupply;
  Map<String, double> ath;
  Map<String, double> athChangePercentage;
  Map<String, DateTime> athDate;
  Map<String, double> atl;
  Map<String, double> atlChangePercentage;
  Map<String, DateTime> atlDate;
  double priceChangePercentage24h; // Added priceChangePercentage24h property

  MarketData({
    required this.currentPrice,
    required this.marketCap,
    required this.totalVolume,
    required this.marketCapRank,
    required this.fullyDilutedValuation,
    required this.high24h,
    required this.low24h,
    required this.circulatingSupply,
    required this.totalSupply,
    required this.ath,
    required this.athChangePercentage,
    required this.athDate,
    required this.atl,
    required this.atlChangePercentage,
    required this.atlDate,
    required this.priceChangePercentage24h, // Initialize priceChangePercentage24h
  });

  factory MarketData.fromJson(Map<String, dynamic> json) {
    return MarketData(
      currentPrice: _parseToDoubleMap(json['current_price']),
      marketCap: _parseToDoubleMap(json['market_cap']),
      totalVolume: _parseToDoubleMap(json['total_volume']),
      marketCapRank: json['market_cap_rank'],
      fullyDilutedValuation: _parseToDoubleMap(json['fully_diluted_valuation']),
      high24h: _parseToDoubleMap(json['high_24h']),
      low24h: _parseToDoubleMap(json['low_24h']),
      circulatingSupply: json['circulating_supply'].toDouble(),
      totalSupply: json['total_supply'].toDouble(),
      ath: _parseToDoubleMap(json['ath']),
      athChangePercentage: _parseToDoubleMap(json['ath_change_percentage']),
      athDate: _parseToDateTimeMap(json['ath_date']),
      atl: _parseToDoubleMap(json['atl']),
      atlChangePercentage: _parseToDoubleMap(json['atl_change_percentage']),
      atlDate: _parseToDateTimeMap(json['atl_date']),
      priceChangePercentage24h: json['price_change_percentage_24h']
          .toDouble(), // Parse priceChangePercentage24h from JSON
    );
  }

  static Map<String, double> _parseToDoubleMap(Map<String, dynamic> json) {
    final Map<String, double> result = {};
    json.forEach((key, value) {
      result[key] = value is int ? value.toDouble() : value;
    });
    return result;
  }

  static Map<String, DateTime> _parseToDateTimeMap(Map<String, dynamic> json) {
    final Map<String, DateTime> result = {};
    json.forEach((key, value) {
      result[key] = DateTime.parse(value);
    });
    return result;
  }
}

class Links {
  List<String> homepage;

  Links({
    required this.homepage,
  });

  factory Links.fromJson(Map<String, dynamic> json) {
    return Links(
      homepage: List<String>.from(json['homepage']),
    );
  }
}
