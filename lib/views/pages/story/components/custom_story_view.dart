import 'dart:async';
import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:streax/config/size_config.dart';
import 'package:streax/views/pages/story/components/custom_story_item.dart';
import 'package:streax/views/pages/story/components/story_view/story_controller.dart';
import 'package:streax/views/pages/story/components/story_view/utils.dart';

/// Indicates where the progress indicators should be placed.
enum ProgressPosition { top, bottom, none }

/// This is used to specify the height of the progress indicator. Inline stories
/// should use [small]
enum IndicatorHeight { small, large }



/// Widget to display stories just like Whatsapp and Instagram. Can also be used
/// inline/inside [ListView] or [Column] just like Google News app. Comes with
/// gestures to pause, forward and go to previous page.
class CustomStoryView extends StatefulWidget {
  /// The pages to displayed.
  final List<CustomStoryItem?> storyItems;

  /// Callback for when a full cycle of story is shown. This will be called
  /// each time the full story completes when [repeat] is set to `true`.
  final VoidCallback? onComplete;

  final VoidCallback? onPlay;

  /// Callback for when a vertical swipe gesture is detected. If you do not
  /// want to listen to such event, do not provide it. For instance,
  /// for inline stories inside ListViews, it is preferrable to not to
  /// provide this callback so as to enable scroll events on the list view.
  final Function(Direction?)? onVerticalSwipeComplete;

  /// Callback for when a story is currently being shown.
  final ValueChanged<CustomStoryItem>? onStoryShow;

  /// Where the progress indicator should be placed.
  final ProgressPosition progressPosition;

  /// Should the story be repeated forever?
  final bool repeat;

  /// If you would like to display the story as full-page, then set this to
  /// `false`. But in case you would display this as part of a page (eg. in
  /// a [ListView] or [Column]) then set this to `true`.
  final bool inline;

  // Controls the playback of the stories
  final StoryController controller;

  // Indicator Color
  final Color? indicatorColor;
  // Indicator Foreground Color
  final Color? indicatorForegroundColor;

  CustomStoryView({super.key,
    required this.storyItems,
    required this.controller,
    this.onComplete,
    this.onPlay,
    this.onStoryShow,
    this.progressPosition = ProgressPosition.top,
    this.repeat = false,
    this.inline = false,
    this.onVerticalSwipeComplete,
    this.indicatorColor,
    this.indicatorForegroundColor,
  });

  @override
  State<StatefulWidget> createState() {
    return CustomStoryViewState();
  }
}

class CustomStoryViewState extends State<CustomStoryView> with TickerProviderStateMixin {
  AnimationController? _animationController;
  Animation<double>? _currentAnimation;
  Timer? _nextDebouncer;

  StreamSubscription<PlaybackState>? _playbackSubscription;

  VerticalDragInfo? verticalDragInfo;

  CustomStoryItem? get _currentStory {
    return widget.storyItems.firstWhereOrNull((it) => !it!.shown);
  }

  Widget get _currentView {
    var item = widget.storyItems.firstWhereOrNull((it) => !it!.shown);
    item ??= widget.storyItems.last;
    return item?.view ?? Container();
  }

  @override
  void initState() {
    super.initState();

    // All pages after the first unshown page should have their shown value as
    // false
    final firstPage = widget.storyItems.firstWhereOrNull((it) => !it!.shown);
    if (firstPage == null) {
      for (var it2 in widget.storyItems) {
        it2!.shown = false;
      }
    } else {
      final lastShownPos = widget.storyItems.indexOf(firstPage);
      widget.storyItems.sublist(lastShownPos).forEach((it) {
        it!.shown = false;
      });
    }

    _playbackSubscription =
        widget.controller.playbackNotifier.listen((playbackStatus) {
          switch (playbackStatus) {
            case PlaybackState.play:
              _removeNextHold();
              widget.onPlay!();
              _animationController?.forward();
              break;

            case PlaybackState.pause:
              _holdNext(); // then pause animation
              _animationController?.stop(canceled: false);
              break;

            case PlaybackState.next:
              _removeNextHold();
              _goForward();
              break;

            case PlaybackState.previous:
              _removeNextHold();
              _goBack();
              break;
          }
        });

    _play();
  }

  @override
  void dispose() {
    _clearDebouncer();

    _animationController?.dispose();
    _playbackSubscription?.cancel();

    super.dispose();
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  void _play() {
    _animationController?.dispose();
    // get the next playing page
    final storyItem = widget.storyItems.firstWhere((it) {
      return !it!.shown;
    })!;

    if (widget.onStoryShow != null) {
      widget.onStoryShow!(storyItem);
    }

    _animationController =
        AnimationController(duration: storyItem.duration, vsync: this);

    _animationController!.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        storyItem.shown = true;
        if (widget.storyItems.last != storyItem) {
          _beginPlay();
        } else {
          // done playing
          _onComplete();
        }
      }
    });

    _currentAnimation =
        Tween(begin: 0.0, end: 1.0).animate(_animationController!);

    widget.controller.play();
  }

  void _beginPlay() {
    setState(() {});
    _play();
  }

  void _onComplete() {
    if (widget.onComplete != null) {
      widget.controller.pause();
      widget.onComplete!();
    }

    if (widget.repeat) {
      for (var it in widget.storyItems) {
        it!.shown = false;
      }

      _beginPlay();
    }
  }

  void _goBack() {
    _animationController!.stop();

    if (_currentStory == null) {
      widget.storyItems.last!.shown = false;
    }

    if (_currentStory == widget.storyItems.first) {
      _beginPlay();
    } else {
      _currentStory!.shown = false;
      int lastPos = widget.storyItems.indexOf(_currentStory);
      final previous = widget.storyItems[lastPos - 1]!;

      previous.shown = false;

      _beginPlay();
    }
  }

  void _goForward() {
    if (_currentStory != widget.storyItems.last) {
      _animationController!.stop();

      // get last showing
      final _last = _currentStory;

      if (_last != null) {
        _last.shown = true;
        if (_last != widget.storyItems.last) {
          _beginPlay();
        }
      }
    } else {
      // this is the last page, progress animation should skip to end
      _animationController!
          .animateTo(1.0, duration: const Duration(milliseconds: 10));
    }
  }

  void _clearDebouncer() {
    _nextDebouncer?.cancel();
    _nextDebouncer = null;
  }

  void _removeNextHold() {
    _nextDebouncer?.cancel();
    _nextDebouncer = null;
  }

  void _holdNext() {
    _nextDebouncer?.cancel();
    _nextDebouncer = Timer(const Duration(milliseconds: 500), () {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: Stack(
              children: <Widget>[
                _currentView,
                Visibility(
                  visible: widget.progressPosition != ProgressPosition.none,
                  child: Align(
                    alignment: widget.progressPosition == ProgressPosition.top
                        ? Alignment.topCenter
                        : Alignment.bottomCenter,
                    child: SafeArea(
                      bottom: widget.inline ? false : true,
                      // we use SafeArea here for notched and bezeles phones
                      child: Container(
                        padding: const  EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        child: PageBar(
                          widget.storyItems
                              .map((it) => PageData(it!.duration, it.shown))
                              .toList(),
                          _currentAnimation,
                          key: UniqueKey(),
                          indicatorHeight: widget.inline
                              ? IndicatorHeight.small
                              : IndicatorHeight.large,
                          indicatorColor: widget.indicatorColor,
                          indicatorForegroundColor: widget.indicatorForegroundColor,
                        ),
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                   margin: EdgeInsets.only(top: SizeConfig.heightMultiplier *18,bottom:SizeConfig.heightMultiplier *10 ),
                    child: GestureDetector(
                        onTapDown: (details) {
                          widget.controller.pause();
                        },
                        onTapCancel: () {
                          widget.controller.play();
                        },
                        onTapUp: (details) {
                          // if debounce timed out (not active) then continue anim
                          if (_nextDebouncer?.isActive == false) {
                            widget.controller.play();
                          } else {
                            widget.controller.next();
                          }
                        },
                        onVerticalDragStart: widget.onVerticalSwipeComplete == null
                            ? null
                            : (details) {
                          widget.controller.pause();
                        },
                        onVerticalDragCancel: widget.onVerticalSwipeComplete == null
                            ? null
                            : () {
                          widget.controller.play();
                        },
                        onVerticalDragUpdate: widget.onVerticalSwipeComplete == null
                            ? null
                            : (details) {
                          verticalDragInfo ??= VerticalDragInfo();

                          verticalDragInfo!.update(details.primaryDelta!);

                          // TODO: provide callback interface for animation purposes
                        },
                        onVerticalDragEnd: widget.onVerticalSwipeComplete == null
                            ? null
                            : (details) {
                          widget.controller.play();
                          // finish up drag cycle
                          if (!verticalDragInfo!.cancel &&
                              widget.onVerticalSwipeComplete != null) {
                            widget.onVerticalSwipeComplete!(
                                verticalDragInfo!.direction);
                          }

                          verticalDragInfo = null;
                        },
                      ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  heightFactor: 1,
                  child: Container(
                      margin: EdgeInsets.only(top: SizeConfig.heightMultiplier *18,bottom:SizeConfig.heightMultiplier *10),
                      width: 70,
                      child: GestureDetector(onTap: () {
                        widget.controller.previous();
                      })),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Capsule holding the duration and shown property of each story. Passed down
/// to the pages bar to render the page indicators.
class PageData {
  Duration duration;
  bool shown;

  PageData(this.duration, this.shown);
}

/// Horizontal bar displaying a row of [StoryProgressIndicator] based on the
/// [pages] provided.
class PageBar extends StatefulWidget {
  final List<PageData> pages;
  final Animation<double>? animation;
  final IndicatorHeight indicatorHeight;
  final Color? indicatorColor;
  final Color? indicatorForegroundColor;

  PageBar(
      this.pages,
      this.animation, {
        this.indicatorHeight = IndicatorHeight.large,
        this.indicatorColor,
        this.indicatorForegroundColor,
        super.key,
      });

  @override
  State<StatefulWidget> createState() {
    return PageBarState();
  }
}

class PageBarState extends State<PageBar> {
  double spacing = 4;

  @override
  void initState() {
    super.initState();

    int count = widget.pages.length;
    spacing = (count > 15) ? 1 : ((count > 10) ? 2 : 4);

    widget.animation!.addListener(() {
      setState(() {});
    });
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  bool isPlaying(PageData page) {
    return widget.pages.firstWhereOrNull((it) => !it.shown) == page;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: widget.pages.map((it) {
        return Expanded(
          child: Container(
            margin: const  EdgeInsets.only(top: 16),
            padding: EdgeInsets.only(
                right: widget.pages.last == it ? 0 : spacing),
            child: StoryProgressIndicator(
              isPlaying(it) ? widget.animation!.value : (it.shown ? 1 : 0),
              indicatorHeight:
              widget.indicatorHeight == IndicatorHeight.large ? 5 : 3,
              indicatorColor: widget.indicatorColor,
              indicatorForegroundColor: widget.indicatorForegroundColor,
            ),
          ),
        );
      }).toList(),
    );
  }
}

/// Custom progress bar. Supposed to be lighter than the
/// original [ProgressIndicator], and rounded at the sides.
class StoryProgressIndicator extends StatelessWidget{
  /// From `0.0` to `1.0`, determines the progress of the indicator
  final double value;
  final double indicatorHeight;
  final Color? indicatorColor;
  final Color? indicatorForegroundColor;

  StoryProgressIndicator(
      this.value, {super.key,
        this.indicatorHeight = 5,
        this.indicatorColor,
        this.indicatorForegroundColor,
      });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.fromHeight(
        indicatorHeight,
      ),
      foregroundPainter: IndicatorOval(
        indicatorForegroundColor?? Colors.white.withOpacity(0.8),
        value,
      ),
      painter: IndicatorOval(
        indicatorColor?? Colors.white.withOpacity(0.4),
        1.0,
      ),
    );
  }
}

class IndicatorOval extends CustomPainter {
  final Color color;
  final double widthFactor;

  IndicatorOval(this.color, this.widthFactor);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    canvas.drawRRect(
        RRect.fromRectAndRadius(
            Rect.fromLTWH(0, 0, size.width * widthFactor, size.height),
            const Radius.circular(3)),
        paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

/// Concept source: https://stackoverflow.com/a/9733420
class ContrastHelper {
  static double luminance(int? r, int? g, int? b) {
    final a = [r, g, b].map((it) {
      double value = it!.toDouble() / 255.0;
      return value <= 0.03928
          ? value / 12.92
          : pow((value + 0.055) / 1.055, 2.4);
    }).toList();

    return a[0] * 0.2126 + a[1] * 0.7152 + a[2] * 0.0722;
  }

  static double contrast(rgb1, rgb2) {
    return luminance(rgb2[0], rgb2[1], rgb2[2]) /
        luminance(rgb1[0], rgb1[1], rgb1[2]);
  }
}
