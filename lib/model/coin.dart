class Coin {
  Coin({
    required this.success,
    required this.currency,
    required this.total,
  });

  final bool? success;
  final List<Currency> currency;
  final int? total;

  factory Coin.fromJson(Map<String, dynamic> json) {
    return Coin(
      success: json["success"],
      currency: json["currency"] == null
          ? []
          : List<Currency>.from(
              json["currency"].map((x) => Currency.fromJson(x))),
      total: json["total"],
    );
  }

  Map<String, dynamic> toJson() => {
        "success": success,
        "currency": currency.map((x) => x.toJson()).toList(),
        "total": total,
      };
}

class Currency {
  Currency({
    required this.id,
    required this.symbol,
    required this.name,
    required this.image,
    required this.currentPrice,
    required this.marketCap,
    required this.marketCapRank,
    required this.fullyDilutedValuation,
    required this.totalVolume,
    required this.high24H,
    required this.low24H,
    required this.priceChange24H,
    required this.priceChangePercentage24H,
    required this.marketCapChange24H,
    required this.marketCapChangePercentage24H,
    required this.circulatingSupply,
    required this.totalSupply,
    required this.maxSupply,
    required this.ath,
    required this.athChangePercentage,
    required this.athDate,
    required this.atl,
    required this.atlChangePercentage,
    required this.atlDate,
    required this.roi,
    required this.lastUpdated,
    required this.sparklineIn7D,
  });

  final String? id;
  final String? symbol;
  final String? name;
  final String? image;
  final double? currentPrice;
  final double? marketCap;
  final int? marketCapRank;
  final int? fullyDilutedValuation;
  final double? totalVolume;
  final double? high24H;
  final double? low24H;
  final double? priceChange24H;
  final double? priceChangePercentage24H;
  final double? marketCapChange24H;
  final double? marketCapChangePercentage24H;
  final double? circulatingSupply;
  final double? totalSupply;
  final double? maxSupply;
  final double? ath;
  final double? athChangePercentage;
  final DateTime? athDate;
  final double? atl;
  final double? atlChangePercentage;
  final DateTime? atlDate;
  final Roi? roi;
  final DateTime? lastUpdated;
  final SparklineIn7D? sparklineIn7D;

  factory Currency.fromJson(Map<String, dynamic> json) {
    return Currency(
      id: json["id"],
      symbol: json["symbol"],
      name: json["name"],
      image: json["image"],
      currentPrice: json["current_price"]?.toDouble(),
      marketCap: json["market_cap"]?.toDouble(),
      marketCapRank: json["market_cap_rank"],
      fullyDilutedValuation: json["fully_diluted_valuation"],
      totalVolume: json["total_volume"]?.toDouble(),
      high24H: json["high_24h"]?.toDouble(),
      low24H: json["low_24h"]?.toDouble(),
      priceChange24H: json["price_change_24h"]?.toDouble(),
      priceChangePercentage24H: json["price_change_percentage_24h"]?.toDouble(),
      marketCapChange24H: json["market_cap_change_24h"]?.toDouble(),
      marketCapChangePercentage24H:
          json["market_cap_change_percentage_24h"]?.toDouble(),
      circulatingSupply: json["circulating_supply"]?.toDouble(),
      totalSupply: json["total_supply"]?.toDouble(),
      maxSupply: json["max_supply"]?.toDouble(),
      ath: json["ath"]?.toDouble(),
      athChangePercentage: json["ath_change_percentage"]?.toDouble(),
      athDate: DateTime.tryParse(json["ath_date"] ?? ""),
      atl: json["atl"]?.toDouble(),
      atlChangePercentage: json["atl_change_percentage"]?.toDouble(),
      atlDate: DateTime.tryParse(json["atl_date"] ?? ""),
      roi: json["roi"] == null ? null : Roi.fromJson(json["roi"]),
      lastUpdated: DateTime.tryParse(json["last_updated"] ?? ""),
      sparklineIn7D: json["sparkline_in_7d"] == null
          ? null
          : SparklineIn7D.fromJson(json["sparkline_in_7d"]),
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "symbol": symbol,
        "name": name,
        "image": image,
        "current_price": currentPrice,
        "market_cap": marketCap,
        "market_cap_rank": marketCapRank,
        "fully_diluted_valuation": fullyDilutedValuation,
        "total_volume": totalVolume,
        "high_24h": high24H,
        "low_24h": low24H,
        "price_change_24h": priceChange24H,
        "price_change_percentage_24h": priceChangePercentage24H,
        "market_cap_change_24h": marketCapChange24H,
        "market_cap_change_percentage_24h": marketCapChangePercentage24H,
        "circulating_supply": circulatingSupply,
        "total_supply": totalSupply,
        "max_supply": maxSupply,
        "ath": ath,
        "ath_change_percentage": athChangePercentage,
        "ath_date": athDate?.toIso8601String(),
        "atl": atl,
        "atl_change_percentage": atlChangePercentage,
        "atl_date": atlDate?.toIso8601String(),
        "roi": roi?.toJson(),
        "last_updated": lastUpdated?.toIso8601String(),
        "sparkline_in_7d": sparklineIn7D?.toJson(),
      };
}

class Roi {
  Roi({
    required this.times,
    required this.currency,
    required this.percentage,
  });

  final double? times;
  final String? currency;
  final double? percentage;

  factory Roi.fromJson(Map<String, dynamic> json) {
    return Roi(
      times: json["times"]?.toDouble(),
      currency: json["currency"],
      percentage: json["percentage"]?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
        "times": times,
        "currency": currency,
        "percentage": percentage,
      };
}

class SparklineIn7D {
  SparklineIn7D({
    required this.price,
  });

  final List<double> price;

  factory SparklineIn7D.fromJson(Map<String, dynamic> json) {
    return SparklineIn7D(
      price: json["price"] == null
          ? []
          : List<double>.from(json["price"].map((x) => x?.toDouble() ?? 0.0)),
    );
  }

  Map<String, dynamic> toJson() => {
        "price": List<dynamic>.from(price.map((x) => x)),
      };
}
