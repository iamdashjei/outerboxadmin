import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
class ChewieVideoPlayerWidget extends StatefulWidget {
  final File videoUrl;

  ChewieVideoPlayerWidget(this.videoUrl);

  @override
  _ChewieVideoPlayerWidgetState createState() => _ChewieVideoPlayerWidgetState(videoUrl);
}

class _ChewieVideoPlayerWidgetState extends State<ChewieVideoPlayerWidget> {
  VideoPlayerController videoPlayerController;
  final File videoUrl;
  ChewieController _chewieController;
  double videoDuration = 0;
  double currentDuration = 0;
  _ChewieVideoPlayerWidgetState(this.videoUrl);

  @override
  void initState() {
    super.initState();

    initializePlayer();

    //print(videoUrl);
  }

  Future<void> initializePlayer() async {
    videoPlayerController = VideoPlayerController.file(videoUrl);
    await Future.wait([
      videoPlayerController.initialize(),
    ]);

    _chewieController = ChewieController(
      videoPlayerController: videoPlayerController,
      aspectRatio: 3 / 2,
      autoPlay: true,
      looping: true,
      // Try playing around with some of these other options:

      // showControls: false,
      // materialProgressColors: ChewieProgressColors(
      //   playedColor: Colors.red,
      //   handleColor: Colors.blue,
      //   backgroundColor: Colors.grey,
      //   bufferedColor: Colors.lightGreen,
      // ),
      // placeholder: Container(
      //   color: Colors.grey,
      // ),
      // autoInitialize: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFF737373),
      // This line set the transparent background
      child: Container(
          color: Colors.black,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Expanded(
                child: Center(
                  child: _chewieController != null &&
                      _chewieController
                          .videoPlayerController.value.initialized
                      ? Chewie(
                    controller: _chewieController,
                  )
                      : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      CircularProgressIndicator(),
                      SizedBox(height: 20),
                      Text('Loading'),
                    ],
                  ),
                ),
              ),
              // TextButton(
              //   onPressed: () {
              //     _chewieController.enterFullScreen();
              //   },
              //   child: const Text('View Video'),
              // ),
              // Row(
              //   children: <Widget>[
              //     Expanded(
              //       child: TextButton(
              //         onPressed: () {
              //           setState(() {
              //             _chewieController.dispose();
              //             videoPlayerController.pause();
              //             videoPlayerController.seekTo(const Duration());
              //             _chewieController = ChewieController(
              //               videoPlayerController: videoPlayerController,
              //               autoPlay: true,
              //               looping: true,
              //             );
              //           });
              //         },
              //         child: const Padding(
              //           padding: EdgeInsets.symmetric(vertical: 16.0),
              //           child: Text("Landscape Video"),
              //         ),
              //       ),
              //     ),
              //   ],
              // ),
            ],
          )),
    );
  }

  @override
  void dispose() {
    videoPlayerController.dispose();
    _chewieController.dispose();
    super.dispose();
  }
}
