import 'package:flutter/cupertino.dart';

import '../core/models.dart';

/// Заглушка обложки: градиент из цвета трека + нота.
/// Когда появится API — тут будет Image.network / CachedNetworkImage.
class Artwork extends StatelessWidget {
  const Artwork({
    super.key,
    required this.track,
    required this.size,
    this.radius = 12,
  });

  final Track track;
  final double size;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final hsl = HSLColor.fromColor(track.color);
    final second = hsl
        .withHue((hsl.hue + 50) % 360)
        .withLightness((hsl.lightness * 0.55).clamp(0.0, 1.0))
        .toColor();

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [track.color, second],
        ),
        boxShadow: [
          BoxShadow(
            color: track.color.withValues(alpha: 0.35),
            blurRadius: size * 0.2,
            offset: Offset(0, size * 0.06),
          ),
        ],
      ),
      child: Icon(
        CupertinoIcons.music_note_2,
        color: CupertinoColors.white.withValues(alpha: 0.75),
        size: size * 0.4,
      ),
    );
  }
}
