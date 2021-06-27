import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerWidgetLatest extends StatefulWidget {
  final String videoUrl;

  VideoPlayerWidgetLatest(this.videoUrl);

  @override
  _VideoPlayerWidgetLatestState createState() => _VideoPlayerWidgetLatestState(videoUrl);
}

class _VideoPlayerWidgetLatestState extends State<VideoPlayerWidgetLatest> {
  final VideoPlayerController videoPlayerController;
  final String videoUrl;
  double videoDuration = 0;
  double currentDuration = 0;
  _VideoPlayerWidgetLatestState(this.videoUrl)
      : videoPlayerController = VideoPlayerController.network(videoUrl);
  ChewieController _chewieController;

  @override
  void initState() {
    super.initState();
    videoPlayerController.initialize().then((_) {
      setState(() {
        videoDuration =
            videoPlayerController.value.duration.inMilliseconds.toDouble();
      });





    });

    videoPlayerController.addListener(() {
      setState(() {
        currentDuration = videoPlayerController.value.position.inMilliseconds.toDouble();
      });
    });

    _chewieController = ChewieController(
        videoPlayerController: videoPlayerController,
        aspectRatio: videoPlayerController.value.aspectRatio,
        autoInitialize: true,
        looping: true,
        errorBuilder: (context, errorMessage) {
          return Center(
            child: Text(
              errorMessage,
              style: TextStyle(color: Colors.white),
            ),
          );
        }
    );
    // print(videoUrl);
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

              Container(
                //color: Theme.of(context).primaryColor,
                  width: 400,
                  constraints: BoxConstraints(maxHeight: 400),
                  child: AspectRatio(
                    aspectRatio: videoPlayerController.value.aspectRatio,
                    //child: VideoPlayer(videoPlayerController),
                    child: Chewie(
                      controller: _chewieController,
                    ),
                  )
              ),
            ],
          )),
    );
  }

  @override
  void dispose() {
    videoPlayerController.dispose();
    super.dispose();
  }
}
