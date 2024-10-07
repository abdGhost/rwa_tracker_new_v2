import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/video_model.dart';
import 'video_item_screen.dart';

class VideoScreen extends StatefulWidget {
  const VideoScreen({super.key});

  @override
  State<VideoScreen> createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  late Future<Video> futureVideo;

  @override
  void initState() {
    super.initState();
    futureVideo = _initialize();
  }

  Future<Video> _initialize() async {
    String? token = await _getToken();
    if (token != null) {
      return fetchVideoData(token);
    } else {
      // Return a Future with an error
      return Future.error('Token not found');
    }
  }

  Future<String?> _getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token'); // Replace 'token' with your actual key
  }

  Future<Video> fetchVideoData(String token) async {
    final response = await http.get(
      Uri.parse('https://rwa-f1623a22e3ed.herokuapp.com/api/lecture'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    print('Video response------------------');
    print(response.body);

    if (response.statusCode == 200) {
      return Video.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load video data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfffFDFAF6),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0.4,
        backgroundColor: Colors.white, // Ensure AppBar is also white
        title: const Text(
          'Learn',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: FutureBuilder<Video>(
        future: futureVideo,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child: CircularProgressIndicator(
              color: Color(0xFF348f6c),
            ));
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.lecture.isEmpty) {
            return Center(child: Text('No videos found'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.lecture.length,
              itemBuilder: (context, index) {
                return VideoItem(video: snapshot.data!.lecture[index]);
              },
            );
          }
        },
      ),
    );
  }
}
