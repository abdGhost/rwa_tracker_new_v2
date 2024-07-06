import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rwatrackernew/api/api_service.dart';
import '../model/blog.dart';
import 'blog_detail_screen.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  late Future<BlogModel> futureBlog;

  @override
  void initState() {
    super.initState();
    futureBlog = ApiService().fetchBlogs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(20, 20, 22, 1.0),
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          'Blog',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Center(
        child: FutureBuilder<BlogModel>(
          future: futureBlog,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data?.blog.length,
                itemBuilder: (context, index) {
                  var blog = snapshot.data!.blog[index];
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BlogDetailScreen(blog: blog),
                        ),
                      );
                    },
                    child: Card(
                      color:
                          const Color(0xFF222224), // Dark background for card
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: Row(
                          crossAxisAlignment:
                              CrossAxisAlignment.center, // Center vertically
                          children: <Widget>[
                            Image.network(
                              blog.image.startsWith('http')
                                  ? blog.image
                                  : 'https://via.placeholder.com/100',
                              height: 100,
                              width: 100,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(Icons.image,
                                    size: 100, color: Colors.grey);
                              },
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    blog.blogTitle,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Color.fromRGBO(215, 221, 236, 1),
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Row(
                                    children: [
                                      const Icon(
                                        FontAwesomeIcons.user,
                                        size: 14,
                                        color: Color.fromRGBO(0, 128, 0, 1.0),
                                      ),
                                      const SizedBox(width: 5),
                                      Text(
                                        blog.by,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color:
                                              Color.fromRGBO(98, 108, 139, 1),
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 20,
                                      ),
                                      const Icon(
                                        FontAwesomeIcons.calendar,
                                        size: 14,
                                        color: Color.fromRGBO(0, 128, 0, 1.0),
                                      ),
                                      const SizedBox(width: 5),
                                      Text(
                                        blog.date,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color:
                                              Color.fromRGBO(98, 108, 139, 1),
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    blog.intro,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Color.fromRGBO(194, 196, 201, 1),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            } else {
              return const Text('No data');
            }
          },
        ),
      ),
    );
  }
}
