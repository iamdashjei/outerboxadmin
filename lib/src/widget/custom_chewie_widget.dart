import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class CustomChewieVideoPlayerWidget extends StatefulWidget {
  final VideoPlayerController videoPlayerController;
  final bool looping;

  CustomChewieVideoPlayerWidget(this.videoPlayerController, this.looping);

  @override
  _CustomChewieVideoPlayerWidgetState createState() => _CustomChewieVideoPlayerWidgetState();
}

class _CustomChewieVideoPlayerWidgetState extends State<CustomChewieVideoPlayerWidget> {
  ChewieController _chewieController;
  Future<void> _future;

  @override
  void initState() {
    super.initState();
    _chewieController = ChewieController(
        videoPlayerController: widget.videoPlayerController,
        aspectRatio: 5/8,
        autoInitialize: true,
        looping: widget.looping,
        errorBuilder: (context, errorMessage) {
          return Center(
            child: Text(
              errorMessage,
              style: TextStyle(color: Colors.white),
            ),
          );
        }
    );
    //_future = initVideoPlayer();
  }

  Future<void> initVideoPlayer() async {
    await widget.videoPlayerController.initialize();
    setState(() {
      _chewieController = ChewieController(
          videoPlayerController: widget.videoPlayerController,
          aspectRatio: widget.videoPlayerController.value.aspectRatio,
          autoInitialize: true,
          looping: widget.looping,
          errorBuilder: (context, errorMessage) {
            return Center(
              child: Text(
                errorMessage,
                style: TextStyle(color: Colors.white),
              ),
            );
          }
      );
    });
  }

  buildPlaceholderImage(){
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  @override
  Widget build(BuildContext context) {
    // return Scaffold(
    //     body: FutureBuilder(
    //       future: _future,
    //       builder: (context, snapshot){
    //         if(snapshot.connectionState == ConnectionState.waiting) return buildPlaceholderImage();
    //
    //         return Center(
    //           child: Chewie(controller: _chewieController,),
    //         );
    //       },
    //     )
    // );
    return Container(
      //padding: const EdgeInsets.all(8.0),
      child: Chewie(
        controller: _chewieController,
      ),
    );
    // return Container(
    //   color: Color(0xFF737373),
    //   // This line set the transparent background
    //   child: Container(
    //       color: Colors.black,
    //       child: Column(
    //         mainAxisSize: MainAxisSize.min,
    //         children: <Widget>[
    //           Expanded(
    //             child: Center(
    //               child: _chewieController != null &&
    //                   _chewieController
    //                       .videoPlayerController.value.initialized
    //                   ? Chewie(
    //                 controller: _chewieController,
    //               )
    //                   : Column(
    //                 mainAxisAlignment: MainAxisAlignment.center,
    //                 children: const [
    //                   CircularProgressIndicator(),
    //                   SizedBox(height: 20),
    //                   Text('Loading'),
    //                 ],
    //               ),
    //             ),
    //           ),
    //
    //         ],
    //       )),
    // );
  }

  @override
  void dispose() {
    super.dispose();
    widget.videoPlayerController.dispose();
    _chewieController.dispose();
  }
}
