class BlogModel {
  final bool success;
  final List<Blog> blog;

  BlogModel({required this.success, required this.blog});

  factory BlogModel.fromJson(Map<String, dynamic> json) {
    return BlogModel(
      success: json['success'],
      blog: List<Blog>.from(json['blog'].map((x) => Blog.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'blog': blog.map((x) => x.toJson()).toList(),
    };
  }
}

class Blog {
  final String image;
  final String category;
  final String by;
  final String date;
  final String blogTitle;
  final String intro;
  final BlockQuote blockQuote;
  final List<Section> sections;
  final String conclusion;

  Blog({
    required this.image,
    required this.category,
    required this.by,
    required this.date,
    required this.blogTitle,
    required this.intro,
    required this.blockQuote,
    required this.sections,
    required this.conclusion,
  });

  factory Blog.fromJson(Map<String, dynamic> json) {
    return Blog(
      image: json['image'],
      category: json['category'],
      by: json['by'],
      date: json['date'],
      blogTitle: json['blogTitle'],
      intro: json['intro'],
      blockQuote: BlockQuote.fromJson(json['blockQuote']),
      sections:
          List<Section>.from(json['sections'].map((x) => Section.fromJson(x))),
      conclusion: json['conclusion'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'image': image,
      'category': category,
      'by': by,
      'date': date,
      'blogTitle': blogTitle,
      'intro': intro,
      'blockQuote': blockQuote.toJson(),
      'sections': sections.map((x) => x.toJson()).toList(),
      'conclusion': conclusion,
    };
  }
}

class BlockQuote {
  final String text;
  final String cite;

  BlockQuote({required this.text, required this.cite});

  factory BlockQuote.fromJson(Map<String, dynamic> json) {
    return BlockQuote(
      text: json['text'],
      cite: json['cite'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'cite': cite,
    };
  }
}

class Section {
  final String title;
  final List<Content> content;

  Section({required this.title, required this.content});

  factory Section.fromJson(Map<String, dynamic> json) {
    return Section(
      title: json['title'],
      content:
          List<Content>.from(json['content'].map((x) => Content.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'content': content.map((x) => x.toJson()).toList(),
    };
  }
}

class Content {
  final String subtitle;
  final String details;

  Content({required this.subtitle, required this.details});

  factory Content.fromJson(Map<String, dynamic> json) {
    return Content(
      subtitle: json['subtitle'],
      details: json['details'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'subtitle': subtitle,
      'details': details,
    };
  }
}
