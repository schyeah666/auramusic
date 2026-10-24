import 'package:flutter/cupertino.dart';

class PlayPauseIcon extends StatelessWidget {
  const PlayPauseIcon({
    super.key,
    required this.isPlaying,
    required this.size,
    this.color = CupertinoColors.white,
  });

  final bool isPlaying;
  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 200),
      transitionBuilder: (child, anim) => ScaleTransition(
        scale: anim,
        child: FadeTransition(opacity: anim, child: child),
      ),
      child: Icon(
        isPlaying ? CupertinoIcons.pause_fill : CupertinoIcons.play_fill,
        key: ValueKey(isPlaying),
        size: size,
        color: color,
      ),
    );
  }
}
