// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:native_camera_sound/native_camera_sound.dart';
import 'package:streax/config/app_colors.dart';
import 'package:streax/consts/app_consts.dart';
import 'package:streax/consts/app_icons.dart';
import 'package:streax/consts/enums.dart';
import 'package:streax/route/app_routes.dart';
import 'package:streax/utils/extensions/extensions.dart';
import 'package:streax/views/bottomsheets/skip_intro_bottom_sheet.dart';
import 'package:streax/views/widgets/common_button.dart';
import 'package:video_player/video_player.dart';

/// Camera example home widget.
///
const int timerDuration = 15;  //seconds
class RecordIntroScreen extends StatefulWidget {
  /// Default Constructor
  const RecordIntroScreen({super.key});

  @override
  State<RecordIntroScreen> createState() {
    return _RecordIntroScreenState();
  }
}

/// Returns a suitable camera icon for [direction].
IconData getCameraLensIcon(CameraLensDirection direction) {
  switch (direction) {
    case CameraLensDirection.back:
      return Icons.camera_rear;
    case CameraLensDirection.front:
      return Icons.camera_front;
    case CameraLensDirection.external:
      return Icons.camera;
  }
  // This enum is from a different package, so a new value could be added at
  // any time. The example should keep working if that happens.
  // ignore: dead_code
  return Icons.camera;
}

void _logError(String code, String? message) {
  // ignore: avoid_print
  print('Error: $code${message == null ? '' : '\nError Message: $message'}');
}

class _RecordIntroScreenState extends State<RecordIntroScreen>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  CameraController? camController;

  XFile? videoFile;
  VideoPlayerController? videoController;


  bool enableAudio = true;
  late AnimationController _cameraFlipAnimationController;
  late AnimationController _playPauseAnimationController;
  double _minAvailableExposureOffset = 0.0;
  double _maxAvailableExposureOffset = 0.0;
  double _currentExposureOffset = 0.0;
  double _minAvailableZoom = 1.0;
  double _maxAvailableZoom = 1.0;
  double _currentScale = 1.0;
  double _baseScale = 1.0;

  bool isFlashOn = false;
  bool isRecording = false;

  // Counting pointers (number of user fingers on screen)
  int _pointers = 0;

  double deviceRatio = 0.0;

  Timer? _timer;
  int start = timerDuration;

  RecordVideoFor? recordVideoFor;




  @override
  void initState() {
    super.initState();
    getArguments();
    initCamera();
    WidgetsBinding.instance.addObserver(this);

    _cameraFlipAnimationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 400));

    _playPauseAnimationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 400));
  }


  @override
  void dispose() {

    WidgetsBinding.instance.removeObserver(this);
    _cameraFlipAnimationController.dispose();
    camController?.dispose();

    super.dispose();
  }

  // #docregion AppLifecycle
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final CameraController? cameraController = camController;

    // App state changed before we got the chance to initialize.
    if (cameraController == null || !cameraController.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      cameraController.dispose();
    } else if (state == AppLifecycleState.resumed) {


      //  initCamera();
      _initializeCameraController(cameraController.description);
    }
  }

  // #enddocregion AppLifecycle

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
      ),
      child: Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            _cameraPreviewWidget(),
            Align(
              alignment: Alignment.topCenter,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 50),
                    child: Text(
                      'one_last_thing'.tr,
                      style: Theme
                          .of(context)
                          .textTheme
                          .headlineLarge
                          ?.copyWith(
                          fontWeight: FontWeight.w700,
                          fontSize: 20,
                          color: AppColors.colorF3),
                    ),
                  ),
                  CommonButton(
                      width: 80,
                      height: 30,
                      borderRadius: 100,
                      text: 'skip'.tr,
                      onPressed: () {
                        SkipIntroBottomSheet.show(context: context,onSkipTap: (){
                          Get.back();
                          switch(recordVideoFor){
                            case RecordVideoFor.editProfile :
                              Get.back();
                              break;
                            case RecordVideoFor.profileSetup:
                              Get.offAllNamed(AppRoutes.routeDashBoardScreen);
                              break;

                            default :
                              Get.back();
                          }


                        });
                      })
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                height: 172,
                decoration: BoxDecoration(color: Colors.black.withOpacity(0.8)),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                            onPressed: () async {
                              toggleFlashMode();
                            },
                            icon: SvgPicture.asset(
                              AppIcons.icFlashOn,
                              color: isFlashOn
                                  ? AppColors.kPrimaryColor
                                  : AppColors.colorC2,
                            )),
                        IconButton(
                            onPressed:(){
                              toggleVideoRecording();
                            },
                            icon: Container(
                                decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.fromBorderSide(BorderSide(
                                        color: Colors.white, width: 2))),
                                child: AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 400),
                                  transitionBuilder: (child, anim) =>
                                      FadeTransition(
                                        opacity: anim,
                                        child: child,
                                      ),
                                  child: isRecording
                                      ? const Icon(
                                    Icons.stop,
                                    color: AppColors.kPrimaryColor,
                                    size: 70,
                                  )
                                      : const Icon(
                                    Icons.circle,
                                    color: AppColors.kPrimaryColor,
                                    size: 70,
                                  ),
                                )

                              // Icon(
                              //
                              //   size: 70,
                              //   color: AppColors.kPrimaryColor,
                              // ),
                            )),
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.4),
                              shape: BoxShape.circle),
                          child: RotationTransition(
                            turns: Tween(begin: 0.0, end: 0.5)
                                .animate(_cameraFlipAnimationController),
                            child: IconButton(
                              onPressed: () {
                                _cameraFlipAnimationController.reset();
                                _cameraFlipAnimationController.forward();

                                toggleCamera();
                              },
                              icon: SvgPicture.asset(AppIcons.icRotation),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: Text(
                       isRecording ?  getCaptureDuration()  :  'description_record_intro'.tr,
                        style: Theme
                            .of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(
                            fontSize: 14.fontMultiplier,
                            color: Colors.white),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }




  getArguments(){
    Map<String,dynamic>? data = Get.arguments;
    if(data !=null){
      recordVideoFor = data[AppConsts.keyRecordVideoFor];
    }

  }


  initTimer(){
    cancelTimer();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        start = start -1;
        if(start ==0){
          stopRecording();
        }
      });

    });

  }

  cancelTimer(){
    if(_timer !=null){
      _timer?.cancel();
      _timer = null;
      start = timerDuration;
    }

  }


  String getCaptureDuration(){
    if(start >= 10){
      return '00:$start';
    }else{
      return '00:0$start';
    }
  }


  initCamera() async {
    try {
      WidgetsFlutterBinding.ensureInitialized();
      _cameras = await availableCameras();
      final frontCamera = _cameras.firstWhere(
              (element) => element.lensDirection == CameraLensDirection.front);
      _initializeCameraController(frontCamera);
    } on CameraException catch (e) {
      _logError(e.code, e.description);
    }
  }

  /// Display the preview from the camera (or a message if the preview is not available).
  Widget _cameraPreviewWidget() {
    final CameraController? cameraController = camController;

    if (cameraController == null || !cameraController.value.isInitialized) {
      return Container(
        color: Colors.black,
      );
    } else {
      return Listener(
        onPointerDown: (_) => _pointers++,
        onPointerUp: (_) => _pointers--,
        child: Transform.scale(
          scale: 1 /
              (camController!.value.aspectRatio *
                  MediaQuery
                      .of(context)
                      .size
                      .aspectRatio),
          child: AspectRatio(
            aspectRatio: camController!.value.aspectRatio,
            child: CameraPreview(
              camController!,
              child: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    return GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onScaleStart: _handleScaleStart,
                      onScaleUpdate: _handleScaleUpdate,
                      onTapDown: (TapDownDetails details) =>
                          onViewFinderTap(details, constraints),
                    );
                  }),
            ),
          ),
        ),
      );
    }
  }

  toggleFlashMode() async {
    if (camController != null) {
      if (camController?.value.flashMode == FlashMode.off) {
        await camController?.setFlashMode(FlashMode.torch);
        setState(() {
          isFlashOn = true;
        });
      } else {
        await camController?.setFlashMode(FlashMode.off);
        setState(() {
          isFlashOn = false;
        });
      }
    }
  }

  toggleCamera() async {
    if (camController != null && camController!.value.isInitialized) {
      CameraLensDirection currentCameraDirection =
          camController?.description.lensDirection ?? CameraLensDirection.front;
      final cameras = await availableCameras();

      CameraDescription cameraDescription;
      if (currentCameraDirection == CameraLensDirection.front) {
        cameraDescription = cameras.firstWhere(
                (camera) => camera.lensDirection == CameraLensDirection.back);
        currentCameraDirection = CameraLensDirection.back;
      } else {
        cameraDescription = cameras.firstWhere(
                (camera) => camera.lensDirection == CameraLensDirection.front);
        currentCameraDirection = CameraLensDirection.front;
      }
      camController!.setDescription(cameraDescription);
      if (mounted) {
        setState(() {});
      }
    }

    // cmController = CameraController(cameraDescription, ResolutionPreset.medium);
    // await cmController.initialize();
  }

  void _handleScaleStart(ScaleStartDetails details) {
    _baseScale = _currentScale;
  }

  Future<void> _handleScaleUpdate(ScaleUpdateDetails details) async {
    // When there are not exactly two fingers on screen don't scale
    if (camController == null || _pointers != 2) {
      return;
    }

    _currentScale = (_baseScale * details.scale)
        .clamp(_minAvailableZoom, _maxAvailableZoom);

    await camController!.setZoomLevel(_currentScale);
  }




  String timestamp() =>
      DateTime
          .now()
          .millisecondsSinceEpoch
          .toString();

  void showInSnackBar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  void onViewFinderTap(TapDownDetails details, BoxConstraints constraints) {
    if (camController == null) {
      return;
    }

    final CameraController cameraController = camController!;

    final Offset offset = Offset(
      details.localPosition.dx / constraints.maxWidth,
      details.localPosition.dy / constraints.maxHeight,
    );
    cameraController.setExposurePoint(offset);
    cameraController.setFocusPoint(offset);
  }

  Future<void> onNewCameraSelected(CameraDescription cameraDescription) async {
    if (camController != null) {
      return camController!.setDescription(cameraDescription);
    } else {
      return _initializeCameraController(cameraDescription);
    }
  }

  Future<void> _initializeCameraController(
      CameraDescription cameraDescription) async {
    final CameraController cameraController = CameraController(
      cameraDescription,
      kIsWeb ? ResolutionPreset.max : ResolutionPreset.medium,
      enableAudio: enableAudio,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );

    camController = cameraController;

    // If the controller is updated then update the UI.
    cameraController.addListener(() {
      if (mounted) {
        setState(() {});
      }
      if (cameraController.value.hasError) {
        showInSnackBar(
            'Camera error ${cameraController.value.errorDescription}');
      }
    });

    try {
      await cameraController.initialize();
      await Future.wait(<Future<Object?>>[
        // The exposure mode is currently not supported on the web.
        ...!kIsWeb
            ? <Future<Object?>>[
          cameraController.getMinExposureOffset().then(
                  (double value) => _minAvailableExposureOffset = value),
          cameraController
              .getMaxExposureOffset()
              .then((double value) => _maxAvailableExposureOffset = value)
        ]
            : <Future<Object?>>[],
        cameraController
            .getMaxZoomLevel()
            .then((double value) => _maxAvailableZoom = value),
        cameraController
            .getMinZoomLevel()
            .then((double value) => _minAvailableZoom = value),
      ]);
    } on CameraException catch (e) {
      switch (e.code) {
        case 'CameraAccessDenied':
          showInSnackBar('You have denied camera access.');
          break;
        case 'CameraAccessDeniedWithoutPrompt':
        // iOS only
          showInSnackBar('Please go to Settings app to enable camera access.');
          break;
        case 'CameraAccessRestricted':
        // iOS only
          showInSnackBar('Camera access is restricted.');
          break;
        case 'AudioAccessDenied':
          showInSnackBar('You have denied audio access.');
          break;
        case 'AudioAccessDeniedWithoutPrompt':
        // iOS only
          showInSnackBar('Please go to Settings app to enable audio access.');
          break;
        case 'AudioAccessRestricted':
        // iOS only
          showInSnackBar('Audio access is restricted.');
          break;
        default:
          _showCameraException(e);
          break;
      }
    }

    if (mounted) {
      setState(() {});
    }
  }

  void onAudioModeButtonPressed() {
    enableAudio = !enableAudio;
    if (camController != null) {
      onNewCameraSelected(camController!.description);
    }
  }


  toggleVideoRecording() {
    if (camController != null &&
        camController!.value.isInitialized &&
        !camController!.value.isRecordingVideo
    ) {
      startRecording();
    } else if (camController != null &&
        camController!.value.isInitialized &&
        camController!.value.isRecordingVideo
    ) {
      stopRecording();
    }
  }


  void startRecording() {
    NativeCameraSound.playStartRecord();
    startVideoRecording().then((_) {

      if (mounted) {
        setState(() {
          isRecording = true;
          initTimer();
        });
      }
    });
  }

  void stopRecording() {
    stopVideoRecording().then((XFile? file) {
      NativeCameraSound.playStopRecord();
      if (mounted) {
        setState(() {
          isRecording = false;
          cancelTimer();
        });
      }

      if (file != null) {
        videoFile = file;


        debugPrint('recordedd ================>>>>>>>>>>>>');


        Get.offNamed(AppRoutes.routeVideoPlaybackScreen,
            arguments: {
          AppConsts.keyVideoPath : videoFile?.path,
          AppConsts.keyRecordVideoFor : recordVideoFor
            });
      }
    });
  }

  Future<void> onPausePreviewButtonPressed() async {
    final CameraController? cameraController = camController;

    if (cameraController == null || !cameraController.value.isInitialized) {
      showInSnackBar('Error: select a camera first.');
      return;
    }

    if (cameraController.value.isPreviewPaused) {
      await cameraController.resumePreview();
    } else {
      await cameraController.pausePreview();
    }

    if (mounted) {
      setState(() {});
    }
  }

  void onPauseButtonPressed() {
    pauseVideoRecording().then((_) {
      if (mounted) {
        setState(() {});
      }
      showInSnackBar('Video recording paused');
    });
  }

  void onResumeButtonPressed() {
    resumeVideoRecording().then((_) {
      if (mounted) {
        setState(() {});
      }
      showInSnackBar('Video recording resumed');
    });
  }

  Future<void> startVideoRecording() async {
    final CameraController? cameraController = camController;

    if (cameraController == null || !cameraController.value.isInitialized) {
      showInSnackBar('Error: select a camera first.');
      return;
    }

    if (cameraController.value.isRecordingVideo) {
      // A recording is already started, do nothing.
      return;
    }

    try {
      await cameraController.startVideoRecording();
    } on CameraException catch (e) {
      _showCameraException(e);
      return;
    }
  }

  Future<XFile?> stopVideoRecording() async {
    final CameraController? cameraController = camController;

    if (cameraController == null || !cameraController.value.isRecordingVideo) {
      return null;
    }

    try {
      return await  cameraController.stopVideoRecording();
    } on CameraException catch (e) {
      _showCameraException(e);
      return null;
    }
  }

  Future<void> pauseVideoRecording() async {
    final CameraController? cameraController = camController;

    if (cameraController == null || !cameraController.value.isRecordingVideo) {
      return;
    }

    try {
      await cameraController.pauseVideoRecording();
    } on CameraException catch (e) {
      _showCameraException(e);
      rethrow;
    }
  }

  Future<void> resumeVideoRecording() async {
    final CameraController? cameraController = camController;

    if (cameraController == null || !cameraController.value.isRecordingVideo) {
      return;
    }

    try {
      await cameraController.resumeVideoRecording();
    } on CameraException catch (e) {
      _showCameraException(e);
      rethrow;
    }
  }

  Future<void> setFlashMode(FlashMode mode) async {
    if (camController == null) {
      return;
    }

    try {
      await camController!.setFlashMode(mode);
    } on CameraException catch (e) {
      _showCameraException(e);
      rethrow;
    }
  }

  Future<void> setExposureMode(ExposureMode mode) async {
    if (camController == null) {
      return;
    }

    try {
      await camController!.setExposureMode(mode);
    } on CameraException catch (e) {
      _showCameraException(e);
      rethrow;
    }
  }

  Future<void> setExposureOffset(double offset) async {
    if (camController == null) {
      return;
    }

    setState(() {
      _currentExposureOffset = offset;
    });
    try {
      offset = await camController!.setExposureOffset(offset);
    } on CameraException catch (e) {
      _showCameraException(e);
      rethrow;
    }
  }

  Future<void> setFocusMode(FocusMode mode) async {
    if (camController == null) {
      return;
    }

    try {
      await camController!.setFocusMode(mode);
    } on CameraException catch (e) {
      _showCameraException(e);
      rethrow;
    }
  }


  Future<XFile?> takePicture() async {
    final CameraController? cameraController = camController;
    if (cameraController == null || !cameraController.value.isInitialized) {
      showInSnackBar('Error: select a camera first.');
      return null;
    }

    if (cameraController.value.isTakingPicture) {
      // A capture is already pending, do nothing.
      return null;
    }

    try {
      final XFile file = await cameraController.takePicture();
      return file;
    } on CameraException catch (e) {
      _showCameraException(e);
      return null;
    }
  }

  void _showCameraException(CameraException e) {
    _logError(e.code, e.description);
    showInSnackBar('Error: ${e.code}\n${e.description}');
  }
}

/// CameraApp is the Main Application.
class CameraApp extends StatelessWidget {
  /// Default Constructor
  const CameraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: RecordIntroScreen(),
    );
  }
}

List<CameraDescription> _cameras = <CameraDescription>[];
