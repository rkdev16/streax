import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:streax/config/app_colors.dart';
import 'package:streax/consts/app_consts.dart';
import 'package:streax/utils/extensions/extensions.dart';
import 'package:streax/video_trimmer/trim_viewer/trim_viewer.dart';
import 'package:streax/video_trimmer/trimmer.dart';
import 'package:streax/video_trimmer/video_viewer.dart';
import 'package:streax/views/dialogs/common/common_loader.dart';
import 'package:streax/views/widgets/common_app_bar.dart';
// import 'package:video_trimmer/video_trimmer.dart';

class TrimmerView extends StatefulWidget {
  final File file;

  TrimmerView(this.file);

  @override
  _TrimmerViewState createState() => _TrimmerViewState();
}

class _TrimmerViewState extends State<TrimmerView> {
  final Trimmer _trimmer = Trimmer();

  double _startValue = 0.0;
  double _endValue = 0.0;

  bool _isPlaying = false;
  bool _progressVisibility = false;

  Future<String?> _saveVideo() async {
    setState(() {
      _progressVisibility = true;
    });

    String? value;

    await _trimmer.saveTrimmedVideo(
        startValue: _startValue,
        endValue: _endValue,

        onSave: (String? outputPath) {
          setState(() {
            _progressVisibility = false;
            value = outputPath;
            debugPrint('OUTPUT PATH: $outputPath');
            Get.back(result: {
             AppConsts.keyVideoPath: outputPath,
             AppConsts.keyDuration: ((_endValue/1000) - (_startValue/1000)).ceil(),
           });
          });
        });

    return value;
  }

  void _loadVideo() {
    _trimmer.loadVideo(videoFile: widget.file);
  }

  @override
  void initState() {
    super.initState();
    _loadVideo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        title: 'video_trimmer'.tr,
        onBackTap: () {
          Get.back();
        },
        actions: [
          TextButton(
              onPressed: () async {
                _saveVideo().then((outputPath) {
                  debugPrint('OUTPUT PATH: $outputPath');
                });
              },
              child: Text(
                'save'.tr,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontSize: 14.fontMultiplier,
                    color: AppColors.kPrimaryColor,
                    fontWeight: FontWeight.w700),
              ))
        ],
      ),
      body: Builder(
        builder: (context) => Center(
          child: Container(
            padding: const EdgeInsets.only(bottom: 30.0),
            color: Colors.black,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Visibility(
                  visible: _progressVisibility,
                  child: const  LinearProgressIndicator(
                    backgroundColor: Colors.red,
                  ),
                ),
                Expanded(
                  child: VideoViewer(trimmer: _trimmer),
                ),
                Center(
                  child: TrimViewer(
                    trimmer: _trimmer,
                    viewerHeight: 50.0,
                    viewerWidth: MediaQuery.of(context).size.width,
                    maxVideoLength: const Duration(seconds: 15),
                    onChangeStart: (value) => _startValue = value,
                    onChangeEnd: (value) => _endValue = value,
                    onChangePlaybackState: (value) =>
                        setState(() => _isPlaying = value),
                  ),
                ),
                TextButton(
                  child: Icon(
                    _isPlaying? Icons.pause :  Icons.play_arrow,
                    size: 80.0,
                    color: Colors.white,
                  ),
                  onPressed: () async {
                    bool playbackState = await _trimmer.videoPlaybackControl(
                      startValue: _startValue,
                      endValue: _endValue,
                    );
                    setState(() {
                      _isPlaying = playbackState;
                    });
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
