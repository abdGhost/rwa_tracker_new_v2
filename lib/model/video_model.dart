class Video {
  final String thumbnail;
  final String title;
  final String description;
  final double rating;
  final String duration;
  final String instructor;
  final int ratingCount;
  final String url;
  double progress; // Add this field to hold the progress

  Video({
    required this.thumbnail,
    required this.title,
    required this.description,
    required this.rating,
    required this.duration,
    required this.instructor,
    required this.ratingCount,
    required this.url,
    this.progress = 0.0, // Initialize progress to 0.0
  });
}

List<Video> videos = [
  Video(
    thumbnail: 'assets/1.png',
    title: 'Real-world Assets',
    description:
        'Real-world assets (RWAs) are tangible or intangible assets from the physical world, such as real estate, commodities, stocks, and art, that are represented and traded as tokens on a blockchain.',
    rating: 4.5,
    duration: '00:00:44',
    instructor: 'Admin',
    ratingCount: 1500,
    url:
        'https://res.cloudinary.com/dbtsrjssc/video/upload/v1720787408/WhatsApp_Video_2024-07-12_at_5.59.12_PM_ybrpii.mp4',
  ),
  Video(
    thumbnail: 'assets/2.png',
    title: 'Benefits of Real-World Assets',
    description:
        'Benefits of tokenizing real-world assets (RWAs) include increased liquidity, easier transferability, fractional ownership, enhanced transparency, and improved accessibility to a broader range of investors.',
    rating: 4.7,
    duration: '00:01:01',
    instructor: 'Admin',
    ratingCount: 2000,
    url:
        'https://res.cloudinary.com/dbtsrjssc/video/upload/v1720787901/WhatsApp_Video_2024-07-12_at_5.59.13_PM_fcumzk.mp4',
  ),
  Video(
    thumbnail: 'assets/3.png',
    title: 'Diversify Your Portfolio',
    description:
        'Investing in tokenized real-world assets allows for diversification by spreading investments across different sectors, which reduces risk. These assets, like real estate and commodities, often appreciate over time, providing a hedge against inflation and preserving purchasing power. Additionally, tokenized assets backed by tangible items offer more stability compared to purely digital assets, reducing overall portfolio volatility.',
    rating: 4.7,
    duration: '00:00:33',
    instructor: 'Admin',
    ratingCount: 2000,
    url:
        'https://res.cloudinary.com/dbtsrjssc/video/upload/v1720788077/WhatsApp_Video_2024-07-12_at_5.59.13_PM_1_bwcfvx.mp4',
  ),
];
