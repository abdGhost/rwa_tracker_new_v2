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
  MarketData marketData;
  Links links;

  Detail({
    required this.name,
    required this.marketData,
    required this.links,
  });

  factory Detail.fromJson(Map<String, dynamic> json) {
    return Detail(
      name: json['name'],
      marketData: MarketData.fromJson(json['market_data']),
      links: Links.fromJson(json['links']),
    );
  }
}

class MarketData {
  Map<String, double> marketCap;
  Map<String, double> totalVolume;

  MarketData({
    required this.marketCap,
    required this.totalVolume,
  });

  factory MarketData.fromJson(Map<String, dynamic> json) {
    return MarketData(
      marketCap: _parseToDoubleMap(json['market_cap']),
      totalVolume: _parseToDoubleMap(json['total_volume']),
    );
  }

  static Map<String, double> _parseToDoubleMap(Map<String, dynamic> json) {
    final Map<String, double> result = {};
    json.forEach((key, value) {
      result[key] = value is int ? value.toDouble() : value;
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
