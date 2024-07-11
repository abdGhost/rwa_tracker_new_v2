class CryptoAsset {
  final String symbol;
  final String name;
  final String imageUrl;
  final double price;
  final double change;

  CryptoAsset({
    required this.symbol,
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.change,
  });
}

final List<CryptoAsset> _cryptoAssets = [
  CryptoAsset(
    symbol: 'BTC',
    name: 'Bitcoin',
    imageUrl: 'https://via.placeholder.com/100',
    price: 54382.64,
    change: 15.3,
  ),
  CryptoAsset(
    symbol: 'BTC',
    name: 'Bitcoin',
    imageUrl: 'https://via.placeholder.com/100',
    price: 54382.64,
    change: 15.3,
  ),

  CryptoAsset(
    symbol: 'BTC',
    name: 'Bitcoin',
    imageUrl: 'https://via.placeholder.com/100',
    price: 54382.64,
    change: 15.3,
  ),
  CryptoAsset(
    symbol: 'BTC',
    name: 'Bitcoin',
    imageUrl: 'https://via.placeholder.com/100',
    price: 54382.64,
    change: 15.3,
  ),
  CryptoAsset(
    symbol: 'BTC',
    name: 'Bitcoin',
    imageUrl: 'https://via.placeholder.com/100',
    price: 54382.64,
    change: 15.3,
  ),
  CryptoAsset(
    symbol: 'BTC',
    name: 'Bitcoin',
    imageUrl: 'https://via.placeholder.com/100',
    price: 54382.64,
    change: 15.3,
  ),
  // Add more CryptoAsset instances here
];
