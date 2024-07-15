import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import '../model/video_model.dart';

class VideoPlayScreen extends StatefulWidget {
  final Lecture video;

  const VideoPlayScreen({super.key, required this.video});

  @override
  State<VideoPlayScreen> createState() => _VideoPlayScreenState();
}

class _VideoPlayScreenState extends State<VideoPlayScreen> {
  late VideoPlayerController _controller;
  bool _isPlaying = false;
  bool _isFullScreen = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.video.url)
      ..initialize().then((_) {
        setState(() {
          _isPlaying = _controller.value.isPlaying;
        });
      });

    _controller.addListener(() {
      setState(() {
        widget.video.progress = _controller.value.position.inSeconds /
            _controller.value.duration.inSeconds;
      });

      // Check if the video is completed
      if (_controller.value.position >= _controller.value.duration) {
        setState(() {
          widget.video.progress = 1.0; // Set progress to 100%
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _togglePlayPause() {
    setState(() {
      _isPlaying = !_isPlaying;
      _isPlaying ? _controller.play() : _controller.pause();
    });
  }

  void _toggleFullScreen() {
    setState(() {
      _isFullScreen = !_isFullScreen;
      if (_isFullScreen) {
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.landscapeRight,
          DeviceOrientation.landscapeLeft,
        ]);
      } else {
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
            overlays: SystemUiOverlay.values);
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
          DeviceOrientation.portraitDown,
        ]);
      }
    });
  }

  Widget _buildControls() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        VideoProgressIndicator(
          _controller,
          allowScrubbing: true,
          colors: const VideoProgressColors(
            playedColor: Colors.red,
            backgroundColor: Colors.white,
          ),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
                color: Colors.black,
                onPressed: _togglePlayPause,
              ),
              Text(
                "${_formatDuration(_controller.value.position)} / ${_formatDuration(_controller.value.duration)}",
                style: const TextStyle(color: Colors.black),
              ),
              IconButton(
                icon: Icon(
                    _isFullScreen ? Icons.fullscreen_exit : Icons.fullscreen),
                color: Colors.black,
                onPressed: _toggleFullScreen,
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return [if (duration.inHours > 0) hours, minutes, seconds].join(':');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _isFullScreen
          ? null
          : AppBar(
              backgroundColor: Colors.white,
              leading: IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: Color(0xFF34906c),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              title: Text(
                widget.video.title,
                style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
      body: Center(
        child: _controller.value.isInitialized
            ? GestureDetector(
                onTap: _togglePlayPause,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: VideoPlayer(_controller),
                    ),
                    Positioned(
                      top: 10,
                      left: 20,
                      child: IntrinsicWidth(
                        child: Container(
                          padding: const EdgeInsets.all(8.0),
                          color: Colors.black54,
                          child: Text(
                            widget.video.title,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: _buildControls(),
                    ),
                  ],
                ),
              )
            : const CircularProgressIndicator(),
      ),
    );
  }
}
