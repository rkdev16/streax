

import 'package:cached_video_player_fork/cached_video_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:streax/views/pages/home/components/profile_widget.dart';

class VideoWidget extends StatelessWidget {
  const VideoWidget({
    super.key,
    required this.controller,
  });


 final  CachedVideoPlayerController controller;


  @override
  Widget build(BuildContext context) {
    return Stack(
      // fit: StackFit.expand,
      alignment: Alignment.bottomCenter,
      children: [
        CachedVideoPlayer(
            controller
        ),
        // to show  overlay over media
        const OverlayWidget(),
      ],
    );
  }
}
