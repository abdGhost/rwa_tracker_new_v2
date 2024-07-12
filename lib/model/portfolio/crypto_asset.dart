class CryptoAsset {
  bool status;
  List<PortfolioToken> portfolioToken;
  double totalAmount;
  double totalReturn;
  double totalPercentage;

  CryptoAsset({
    required this.status,
    required this.portfolioToken,
    required this.totalAmount,
    required this.totalReturn,
    required this.totalPercentage,
  });

  factory CryptoAsset.fromJson(Map<String, dynamic> json) {
    return CryptoAsset(
      status: json['status'],
      portfolioToken: (json['portfolioToken'] as List)
          .map((item) => PortfolioToken.fromJson(item))
          .toList(),
      totalAmount: (json['totalAmount'] as num).toDouble(),
      totalReturn: (json['totalReturn'] as num).toDouble(),
      totalPercentage: (json['totalPercentage'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'portfolioToken': portfolioToken.map((item) => item.toJson()).toList(),
      'totalAmount': totalAmount,
      'totalReturn': totalReturn,
      'totalPercentage': totalPercentage,
    };
  }
}

class PortfolioToken {
  String tokenId;
  int amount;
  int quantity;
  double returnPercentage;
  double portfolioTokenReturn;
  String symbol;
  String name;
  String image; // Added image field

  PortfolioToken({
    required this.tokenId,
    required this.amount,
    required this.quantity,
    required this.returnPercentage,
    required this.portfolioTokenReturn,
    required this.symbol,
    required this.name,
    required this.image, // Initialize image in the constructor
  });

  factory PortfolioToken.fromJson(Map<String, dynamic> json) {
    return PortfolioToken(
      tokenId: json['tokenId'],
      amount: json['amount'],
      quantity: json['quantity'],
      returnPercentage: (json['returnPercentage'] as num).toDouble(),
      portfolioTokenReturn: (json['return'] as num).toDouble(),
      symbol: json['symbol'],
      name: json['name'],
      image: json['image'], // Parse image from JSON
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tokenId': tokenId,
      'amount': amount,
      'quantity': quantity,
      'returnPercentage': returnPercentage,
      'portfolioTokenReturn': portfolioTokenReturn,
      'symbol': symbol,
      'name': name,
      'image': image, // Include image in JSON
    };
  }
}
