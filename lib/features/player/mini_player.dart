import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme.dart';
import '../../widgets/artwork.dart';
import '../../widgets/glass_surface.dart';
import '../../widgets/play_pause_icon.dart';
import '../../widgets/pressable.dart';
import 'full_player_page.dart';
import 'player_controller.dart';

class MiniPlayer extends ConsumerWidget {
  const MiniPlayer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final track = ref.watch(playerProvider.select((s) => s.current));
    if (track == null) return const SizedBox.shrink();
    final isPlaying = ref.watch(playerProvider.select((s) => s.isPlaying));
    final player = ref.read(playerProvider.notifier);

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 450),
      curve: Curves.easeOutCubic,
      builder: (context, v, child) => Opacity(
        opacity: v,
        child: Transform.translate(offset: Offset(0, 20 * (1 - v)), child: child),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
        child: Pressable(
          scale: 0.98,
          onTap: () => FullPlayerPage.open(context),
          child: GlassSurface(
            radius: 22,
            padding: const EdgeInsets.fromLTRB(10, 8, 6, 0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Hero(
                      tag: FullPlayerPage.heroTag,
                      child: Artwork(track: track, size: 44, radius: 10),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 250),
                        child: Column(
                          key: ValueKey(track.id),
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(track.title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AppText.title),
                            Text(track.artist,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AppText.subtitle),
                          ],
                        ),
                      ),
                    ),
                    Pressable(
                      scale: 0.85,
                      onTap: () {
                        HapticFeedback.lightImpact();
                        player.toggle();
                      },
                      child: SizedBox(
                        width: 44,
                        height: 44,
                        child: Center(
                          child: PlayPauseIcon(isPlaying: isPlaying, size: 24),
                        ),
                      ),
                    ),
                    Pressable(
                      scale: 0.85,
                      onTap: () {
                        HapticFeedback.lightImpact();
                        player.next();
                      },
                      child: const SizedBox(
                        width: 44,
                        height: 44,
                        child: Center(
                          child: Icon(CupertinoIcons.forward_fill,
                              size: 22, color: CupertinoColors.white),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                const _MiniProgress(),
                const SizedBox(height: 6),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MiniProgress extends ConsumerWidget {
  const _MiniProgress();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progress = ref.watch(playerProvider.select((s) => s.progress));
    return Padding(
      padding: const EdgeInsets.only(right: 4),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(1.5),
        child: SizedBox(
          height: 3,
          child: Stack(
            children: [
              Container(color: CupertinoColors.white.withValues(alpha: 0.18)),
              FractionallySizedBox(
                widthFactor: progress,
                child: Container(color: AppColors.accent),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
