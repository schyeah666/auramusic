import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/models.dart';
import '../../core/theme.dart';
import '../../widgets/artwork.dart';
import '../../widgets/play_pause_icon.dart';
import '../../widgets/pressable.dart';
import 'player_controller.dart';

class FullPlayerPage extends ConsumerWidget {
  const FullPlayerPage({super.key});

  static const heroTag = 'player-artwork';

  static Future<void> open(BuildContext context) {
    HapticFeedback.selectionClick();
    return Navigator.of(context, rootNavigator: true).push(
      CupertinoPageRoute<void>(
        fullscreenDialog: true,
        builder: (_) => const FullPlayerPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final track = ref.watch(playerProvider.select((s) => s.current));
    if (track == null) return const CupertinoPageScaffold(child: SizedBox());

    final isPlaying = ref.watch(playerProvider.select((s) => s.isPlaying));
    final player = ref.read(playerProvider.notifier);
    final size = MediaQuery.sizeOf(context);
    final artSize = math.min(size.width - 64, size.height * 0.42);

    return CupertinoPageScaffold(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 700),
        curve: Curves.easeOut,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              track.color.withValues(alpha: 0.85),
              AppColors.background,
            ],
            stops: const [0.0, 0.85],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Column(
              children: [
                const SizedBox(height: 4),
                Pressable(
                  scale: 0.9,
                  onTap: () => Navigator.of(context).pop(),
                  child: const SizedBox(
                    width: 64,
                    height: 36,
                    child: Center(
                      child: Icon(CupertinoIcons.chevron_compact_down,
                          size: 34, color: CupertinoColors.white),
                    ),
                  ),
                ),
                const Spacer(),
                AnimatedScale(
                  scale: isPlaying ? 1 : 0.86,
                  duration: const Duration(milliseconds: 450),
                  curve: Curves.easeOutCubic,
                  child: Hero(
                    tag: heroTag,
                    child: Artwork(track: track, size: artSize, radius: 24),
                  ),
                ),
                const Spacer(),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: Align(
                    key: ValueKey(track.id),
                    alignment: Alignment.centerLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          track.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: CupertinoColors.white,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          track.artist,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 18,
                            color: AppColors.secondaryText,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                _SeekBar(duration: track.duration),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Pressable(
                      scale: 0.85,
                      onTap: () {
                        HapticFeedback.lightImpact();
                        player.previous();
                      },
                      child: const SizedBox(
                        width: 72,
                        height: 72,
                        child: Center(
                          child: Icon(CupertinoIcons.backward_fill,
                              size: 34, color: CupertinoColors.white),
                        ),
                      ),
                    ),
                    Pressable(
                      scale: 0.9,
                      onTap: () {
                        HapticFeedback.mediumImpact();
                        player.toggle();
                      },
                      child: Container(
                        width: 76,
                        height: 76,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: CupertinoColors.white,
                        ),
                        child: Center(
                          child: PlayPauseIcon(
                            isPlaying: isPlaying,
                            size: 34,
                            color: CupertinoColors.black,
                          ),
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
                        width: 72,
                        height: 72,
                        child: Center(
                          child: Icon(CupertinoIcons.forward_fill,
                              size: 34, color: CupertinoColors.white),
                        ),
                      ),
                    ),
                  ],
                ),
                // TODO: shuffle / repeat / AirPlay / очередь / текст песни.
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SeekBar extends ConsumerWidget {
  const _SeekBar({required this.duration});

  final Duration duration;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progress = ref.watch(playerProvider.select((s) => s.progress));
    final position = ref.watch(playerProvider.select((s) => s.position));
    final remaining = duration - position;

    return Column(
      children: [
        // TODO: когда подключим реальный звук, на время перетаскивания
        // нужно ставить позицию из слайдера, а не из потока плеера.
        CupertinoSlider(
          value: progress,
          activeColor: CupertinoColors.white,
          thumbColor: CupertinoColors.white,
          onChanged: ref.read(playerProvider.notifier).seek,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(formatDuration(position), style: AppText.subtitle),
            Text('-${formatDuration(remaining)}', style: AppText.subtitle),
          ],
        ),
      ],
    );
  }
}
