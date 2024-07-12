import 'package:flutter/material.dart';

import '../model/video_model.dart';
import 'video_item_screen.dart';

class VideoScreen extends StatefulWidget {
  const VideoScreen({super.key});

  @override
  State<VideoScreen> createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.white,
      backgroundColor: Color(0xfffFDFAF6),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0.4,
        backgroundColor: Colors.white, // Ensure AppBar is also white
        title: const Text(
          'Video',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: videos.length,
        itemBuilder: (context, index) {
          return VideoItem(video: videos[index]);
        },
      ),
    );
  }
}
