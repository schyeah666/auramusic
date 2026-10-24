import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/models.dart';
import '../../core/theme.dart';
import '../../widgets/artwork.dart';
import '../../widgets/fade_slide_in.dart';
import '../../widgets/pressable.dart';
import '../../widgets/track_tile.dart';
import '../player/player_controller.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(
        parent: AlwaysScrollableScrollPhysics(),
      ),
      slivers: [
        const CupertinoSliverNavigationBar(
          largeTitle: Text('Главная'),
          automaticallyImplyLeading: false,
          // Несколько nav-баров в одном маршруте ломают Hero-переходы.
          transitionBetweenRoutes: false,
        ),
        const SliverToBoxAdapter(child: _SectionTitle('Недавно слушали')),
        SliverToBoxAdapter(
          child: SizedBox(
            height: 212,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: demoTracks.length,
              separatorBuilder: (_, _) => const SizedBox(width: 14),
              itemBuilder: (context, i) => FadeSlideIn(
                index: i,
                child: _AlbumCard(track: demoTracks[i]),
              ),
            ),
          ),
        ),
        const SliverToBoxAdapter(child: _SectionTitle('Популярное')),
        SliverList.builder(
          itemCount: demoTracks.length,
          itemBuilder: (context, i) => FadeSlideIn(
            index: i,
            child: TrackTile(track: demoTracks[i], queue: demoTracks),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 24)),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
        child: Text(text, style: AppText.section),
      );
}

class _AlbumCard extends ConsumerWidget {
  const _AlbumCard({required this.track});

  final Track track;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Pressable(
      onTap: () {
        HapticFeedback.selectionClick();
        ref.read(playerProvider.notifier).playTrack(track, demoTracks);
      },
      child: SizedBox(
        width: 150,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Artwork(track: track, size: 150, radius: 16),
            const SizedBox(height: 10),
            Text(track.album,
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
    );
  }
}
