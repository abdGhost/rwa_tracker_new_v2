import 'package:flutter/material.dart';
import 'package:rwatrackernew/screens/video_play_screen.dart';
import '../model/video_model.dart';

class VideoItem extends StatefulWidget {
  final Video video;

  const VideoItem({super.key, required this.video});

  @override
  _VideoItemState createState() => _VideoItemState();
}

class _VideoItemState extends State<VideoItem> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final result = await Navigator.of(context).push(
          MaterialPageRoute(builder: (context) {
            return VideoPlayScreen(
                video: widget.video); // Pass the video object
          }),
        );
        // Force a rebuild to update the progress
        setState(() {});
      },
      child: Card(
        color: const Color(0xFF222224),
        margin: const EdgeInsets.all(8.0),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                width: 120.0,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(4.0),
                    bottomLeft: Radius.circular(4.0),
                  ),
                  image: DecorationImage(
                    image: NetworkImage(widget.video.thumbnail),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.video.title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5.0),
                      Row(
                        children: [
                          Text(
                            'By ${widget.video.instructor}',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(width: 20),
                          Text(
                            'Duration - ${widget.video.duration}',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10.0),
                      Text(
                        widget.video.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[800],
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      LinearProgressIndicator(
                        value: widget.video.progress,
                        backgroundColor: Colors.grey[700],
                        color: Colors.blue,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
