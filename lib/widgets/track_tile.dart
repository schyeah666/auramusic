import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/models.dart';
import '../core/theme.dart';
import '../features/player/player_controller.dart';
import 'artwork.dart';
import 'equalizer_bars.dart';
import 'pressable.dart';

class TrackTile extends ConsumerWidget {
  const TrackTile({super.key, required this.track, required this.queue});

  final Track track;
  final List<Track> queue;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isCurrent =
        ref.watch(playerProvider.select((s) => s.current?.id == track.id));
    final isPlaying = ref.watch(playerProvider.select((s) => s.isPlaying));

    return Pressable(
      scale: 0.98,
      onTap: () {
        HapticFeedback.selectionClick();
        ref.read(playerProvider.notifier).playTrack(track, queue);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        child: Row(
          children: [
            Artwork(track: track, size: 52, radius: 10),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    track.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.title.copyWith(
                      color: isCurrent ? AppColors.accent : CupertinoColors.white,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    track.artist,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.subtitle,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            if (isCurrent)
              EqualizerBars(animating: isPlaying)
            else
              Text(formatDuration(track.duration), style: AppText.subtitle),
          ],
        ),
      ),
    );
  }
}
