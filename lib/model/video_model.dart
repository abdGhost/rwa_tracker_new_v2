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
    thumbnail: 'https://via.placeholder.com/100',
    title: 'Learn Flutter & Dart',
    description: 'A complete guide to the Flutter framework.',
    rating: 4.5,
    duration: '3h 20m',
    instructor: 'John Doe',
    ratingCount: 1500,
    url: 'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
  ),
  Video(
    thumbnail: 'https://via.placeholder.com/100',
    title: 'Advanced Flutter',
    description: 'Take your Flutter skills to the next level.',
    rating: 4.7,
    duration: '5h 15m',
    instructor: 'Jane Smith',
    ratingCount: 2000,
    url: 'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
  ),
  Video(
    thumbnail: 'https://via.placeholder.com/100',
    title: 'Advanced Flutter',
    description: 'Take your Flutter skills to the next level.',
    rating: 4.7,
    duration: '5h 15m',
    instructor: 'Jane Smith',
    ratingCount: 2000,
    url: 'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
  ),
  Video(
    thumbnail: 'https://via.placeholder.com/100',
    title: 'Advanced Flutter',
    description: 'Take your Flutter skills to the next level.',
    rating: 4.7,
    duration: '5h 15m',
    instructor: 'Jane Smith',
    ratingCount: 2000,
    url: 'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
  ),
  // Add more video instances here
];
