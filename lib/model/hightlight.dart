import 'dart:convert';

class HighlightData {
  final String id;
  final String name;
  final double marketCap;
  final double marketCapChange24h;
  final String content;
  final List<String> top3Coins;
  final double volume24h;
  final DateTime updatedAt;

  HighlightData({
    required this.id,
    required this.name,
    required this.marketCap,
    required this.marketCapChange24h,
    required this.content,
    required this.top3Coins,
    required this.volume24h,
    required this.updatedAt,
  });

  factory HighlightData.fromJson(Map<String, dynamic> json) {
    return HighlightData(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      marketCap: json['market_cap']?.toDouble() ?? 0.0,
      marketCapChange24h: json['market_cap_change_24h']?.toDouble() ?? 0.0,
      content: json['content'] ?? '',
      top3Coins: List<String>.from(json['top_3_coins'] ?? []),
      volume24h: json['volume_24h']?.toDouble() ?? 0.0,
      updatedAt: DateTime.parse(
          json['updated_at'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'market_cap': marketCap,
      'market_cap_change_24h': marketCapChange24h,
      'content': content,
      'top_3_coins': top3Coins,
      'volume_24h': volume24h,
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

class HighlightModel {
  final bool success;
  final HighlightData highlightData;

  HighlightModel({
    required this.success,
    required this.highlightData,
  });

  factory HighlightModel.fromJson(Map<String, dynamic> json) {
    return HighlightModel(
      success: json['success'] ?? false, // Default to false if null
      highlightData: HighlightData.fromJson(json['highlightData'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'highlightData': highlightData.toJson(),
    };
  }
}
