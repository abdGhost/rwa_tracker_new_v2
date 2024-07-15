class Video {
  bool status;
  List<Lecture> lecture;

  Video({
    required this.status,
    required this.lecture,
  });

  factory Video.fromJson(Map<String, dynamic> json) {
    return Video(
      status: json['status'],
      lecture:
          (json['lecture'] as List).map((i) => Lecture.fromJson(i)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'lecture': lecture.map((e) => e.toJson()).toList(),
    };
  }
}

class Lecture {
  String thumbnail;
  String title;
  String description;
  double rating;
  String duration;
  String instructor;
  dynamic ratingCount;
  String url;
  double progress;

  Lecture({
    required this.thumbnail,
    required this.title,
    required this.description,
    required this.rating,
    required this.duration,
    required this.instructor,
    required this.ratingCount,
    required this.url,
    required this.progress,
  });

  factory Lecture.fromJson(Map<String, dynamic> json) {
    return Lecture(
      thumbnail: json['thumbnail'],
      title: json['title'],
      description: json['description'],
      rating: json['rating'].toDouble(),
      duration: json['duration'],
      instructor: json['instructor'],
      ratingCount: json['ratingCount'] is int
          ? json['ratingCount']
          : int.parse(json['ratingCount']),
      url: json['url'].replaceAll(' ', ''), // Removing spaces in the URL
      progress: json['progress'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'thumbnail': thumbnail,
      'title': title,
      'description': description,
      'rating': rating,
      'duration': duration,
      'instructor': instructor,
      'ratingCount': ratingCount,
      'url': url,
      'progress': progress,
    };
  }
}
