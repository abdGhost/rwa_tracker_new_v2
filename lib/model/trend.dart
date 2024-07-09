import 'dart:convert';

class TrendResponse {
  final bool success;
  final List<TrendCoin> trend;

  TrendResponse({required this.success, required this.trend});

  factory TrendResponse.fromJson(String str) =>
      TrendResponse.fromMap(json.decode(str));

  factory TrendResponse.fromMap(Map<String, dynamic> json) => TrendResponse(
        success: json["success"] ?? false, // Default to false if null
        trend: List<TrendCoin>.from(
            json["trend"]?.map((x) => TrendCoin.fromMap(x)) ??
                []), // Handle null case for trend list
      );

  String toJson() => json.encode(toMap());

  Map<String, dynamic> toMap() => {
        "success": success,
        "trend": List<dynamic>.from(trend.map((x) => x.toMap())),
      };
}

class TrendCoin {
  final String id;
  final String symbol;
  final String name;
  final String image;
  final double currentPrice;
  final int marketCap;
  final int marketCapRank;
  final double fullyDilutedValuation;
  final double totalVolume;
  final double high24h;
  final double low24h;
  final double priceChange24h;
  final double priceChangePercentage24h;
  final double marketCapChange24h;
  final double marketCapChangePercentage24h;
  final double circulatingSupply;
  final double totalSupply;
  final double? maxSupply;
  final double ath;
  final double athChangePercentage;
  final DateTime athDate;
  final double atl;
  final double atlChangePercentage;
  final DateTime atlDate;
  final dynamic roi;
  final DateTime lastUpdated;

  TrendCoin({
    required this.id,
    required this.symbol,
    required this.name,
    required this.image,
    required this.currentPrice,
    required this.marketCap,
    required this.marketCapRank,
    required this.fullyDilutedValuation,
    required this.totalVolume,
    required this.high24h,
    required this.low24h,
    required this.priceChange24h,
    required this.priceChangePercentage24h,
    required this.marketCapChange24h,
    required this.marketCapChangePercentage24h,
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
  });

  factory TrendCoin.fromJson(String str) => TrendCoin.fromMap(json.decode(str));

  factory TrendCoin.fromMap(Map<String, dynamic> json) => TrendCoin(
        id: json["id"] ?? '',
        symbol: json["symbol"] ?? '',
        name: json["name"] ?? '',
        image: json["image"] ?? '',
        currentPrice: json["current_price"]?.toDouble() ?? 0.0,
        marketCap: json["market_cap"] ?? 0,
        marketCapRank: json["market_cap_rank"] ?? 0,
        fullyDilutedValuation:
            json["fully_diluted_valuation"]?.toDouble() ?? 0.0,
        totalVolume: json["total_volume"]?.toDouble() ?? 0.0,
        high24h: json["high_24h"]?.toDouble() ?? 0.0,
        low24h: json["low_24h"]?.toDouble() ?? 0.0,
        priceChange24h: json["price_change_24h"]?.toDouble() ?? 0.0,
        priceChangePercentage24h:
            json["price_change_percentage_24h"]?.toDouble() ?? 0.0,
        marketCapChange24h: json["market_cap_change_24h"]?.toDouble() ?? 0.0,
        marketCapChangePercentage24h:
            json["market_cap_change_percentage_24h"]?.toDouble() ?? 0.0,
        circulatingSupply: json["circulating_supply"]?.toDouble() ?? 0.0,
        totalSupply: json["total_supply"]?.toDouble() ?? 0.0,
        maxSupply: json["max_supply"]?.toDouble(),
        ath: json["ath"]?.toDouble() ?? 0.0,
        athChangePercentage: json["ath_change_percentage"]?.toDouble() ?? 0.0,
        athDate: DateTime.parse(json["ath_date"]),
        atl: json["atl"]?.toDouble() ?? 0.0,
        atlChangePercentage: json["atl_change_percentage"]?.toDouble() ?? 0.0,
        atlDate: DateTime.parse(json["atl_date"]),
        roi: json["roi"],
        lastUpdated: DateTime.parse(json["last_updated"]),
      );

  String toJson() => json.encode(toMap());

  Map<String, dynamic> toMap() => {
        "id": id,
        "symbol": symbol,
        "name": name,
        "image": image,
        "current_price": currentPrice,
        "market_cap": marketCap,
        "market_cap_rank": marketCapRank,
        "fully_diluted_valuation": fullyDilutedValuation,
        "total_volume": totalVolume,
        "high_24h": high24h,
        "low_24h": low24h,
        "price_change_24h": priceChange24h,
        "price_change_percentage_24h": priceChangePercentage24h,
        "market_cap_change_24h": marketCapChange24h,
        "market_cap_change_percentage_24h": marketCapChangePercentage24h,
        "circulating_supply": circulatingSupply,
        "total_supply": totalSupply,
        "max_supply": maxSupply,
        "ath": ath,
        "ath_change_percentage": athChangePercentage,
        "ath_date": athDate.toIso8601String(),
        "atl": atl,
        "atl_change_percentage": atlChangePercentage,
        "atl_date": atlDate.toIso8601String(),
        "roi": roi,
        "last_updated": lastUpdated.toIso8601String(),
      };
}
