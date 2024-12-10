


import 'package:cached_video_player_fork/cached_video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:streax/consts/app_icons.dart';

class PlayerControllers extends StatelessWidget {
  const PlayerControllers({
    super.key,
    required this.isPlaying,
    required this.isMute,
    required this.controller,
    required this.onTogglePlaybackTap,
    required this.onToggleVolumeTap
  });


 final  bool isPlaying ;
 final  bool isMute ;
 final CachedVideoPlayerController controller;
 final VoidCallback onTogglePlaybackTap;
 final VoidCallback onToggleVolumeTap;


  @override
  Widget build(BuildContext context) {
    return  Row(
      children: [

           IconButton(

               onPressed: onTogglePlaybackTap,
            icon:  Icon(isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
              color: Colors.white,)),
        Expanded(
          child: VideoProgressIndicator(
            controller,
            allowScrubbing: true,
            padding: const  EdgeInsets.symmetric(vertical: 8),
            colors:  VideoProgressColors(
                backgroundColor: Colors.white.withOpacity(0.25),
                playedColor: Colors.white,
                bufferedColor: Colors.transparent

            ),
          ),
        ),

        IconButton(onPressed: onToggleVolumeTap,
            icon:  SvgPicture.asset( isMute ? AppIcons.icVolumeOff :  AppIcons.icVolumeUp ,
              colorFilter: const  ColorFilter.mode(Colors.white, BlendMode.srcIn),)),
      ],
    );
  }
}






