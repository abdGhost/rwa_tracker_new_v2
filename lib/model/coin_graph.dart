class GraphDataPoint {
  final int timestamp;
  final double open;
  final double high;
  final double low;
  final double close;

  GraphDataPoint({
    required this.timestamp,
    required this.open,
    required this.high,
    required this.low,
    required this.close,
  });

  factory GraphDataPoint.fromJson(List<dynamic> json) {
    return GraphDataPoint(
      timestamp: json[0],
      open: json[1],
      high: json[2],
      low: json[3],
      close: json[4],
    );
  }

  List<dynamic> toJson() {
    return [timestamp, open, high, low, close];
  }
}

class CoinGraph {
  final bool success;
  final List<GraphDataPoint> graphData;

  CoinGraph({
    required this.success,
    required this.graphData,
  });

  factory CoinGraph.fromJson(Map<String, dynamic> json) {
    var graphDataJson = json['graphData'] as List<dynamic>;
    List<GraphDataPoint> graphDataList =
        graphDataJson.map((e) => GraphDataPoint.fromJson(e)).toList();

    return CoinGraph(
      success: json['success'],
      graphData: graphDataList,
    );
  }
}
