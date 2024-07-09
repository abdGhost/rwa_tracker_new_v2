class CoinDetail {
  bool status;
  Detail detail;

  CoinDetail({
    required this.status,
    required this.detail,
  });

  factory CoinDetail.fromJson(Map<String, dynamic> json) => CoinDetail(
        status: json["status"],
        detail: Detail.fromJson(json["detail"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "detail": detail.toJson(),
      };
}

class Detail {
  String id;
  String symbol;
  String name;

  Detail({
    required this.id,
    required this.symbol,
    required this.name,
  });

  factory Detail.fromJson(Map<String, dynamic> json) => Detail(
        id: json["id"],
        symbol: json["symbol"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "symbol": symbol,
        "name": name,
      };
}
