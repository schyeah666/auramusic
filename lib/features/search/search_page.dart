import 'package:flutter/cupertino.dart';

import '../../core/models.dart';
import '../../core/theme.dart';
import '../../widgets/fade_slide_in.dart';
import '../../widgets/track_tile.dart';

const _genres = <(String, Color)>[
  ('Поп', Color(0xFFE63E6D)),
  ('Рок', Color(0xFF8E3DFF)),
  ('Хип-хоп', Color(0xFFFF8A3D)),
  ('Электроника', Color(0xFF2E7BFF)),
  ('Джаз', Color(0xFF1FB89A)),
  ('Классика', Color(0xFF7A6A55)),
  ('Инди', Color(0xFFB04CE6)),
  ('Релакс', Color(0xFF3DB5FF)),
];

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String _query = '';

  // TODO: заменить локальный фильтр на запрос к API (с debounce).
  List<Track> get _results {
    final q = _query.trim().toLowerCase();
    if (q.isEmpty) return const [];
    return demoTracks
        .where((t) =>
            t.title.toLowerCase().contains(q) ||
            t.artist.toLowerCase().contains(q) ||
            t.album.toLowerCase().contains(q))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final searching = _query.trim().isNotEmpty;
    final results = _results;

    return CustomScrollView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      physics: const BouncingScrollPhysics(
        parent: AlwaysScrollableScrollPhysics(),
      ),
      slivers: [
        const CupertinoSliverNavigationBar(
          largeTitle: Text('Поиск'),
          automaticallyImplyLeading: false,
          transitionBetweenRoutes: false,
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            child: CupertinoSearchTextField(
              placeholder: 'Исполнители, треки, альбомы',
              onChanged: (v) => setState(() => _query = v),
            ),
          ),
        ),
        if (!searching) ...[
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(20, 8, 20, 12),
              child: Text('Жанры', style: AppText.section),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1.7,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, i) => FadeSlideIn(
                  index: i,
                  child: _GenreTile(name: _genres[i].$1, color: _genres[i].$2),
                ),
                childCount: _genres.length,
              ),
            ),
          ),
        ] else if (results.isEmpty)
          const SliverFillRemaining(
            hasScrollBody: false,
            child: Center(
              child: Text('Ничего не найдено', style: AppText.subtitle),
            ),
          )
        else
          SliverList.builder(
            itemCount: results.length,
            itemBuilder: (context, i) =>
                TrackTile(track: results[i], queue: results),
          ),
        const SliverToBoxAdapter(child: SizedBox(height: 24)),
      ],
    );
  }
}

class _GenreTile extends StatelessWidget {
  const _GenreTile({required this.name, required this.color});

  final String name;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      alignment: Alignment.topLeft,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [color, color.withValues(alpha: 0.55)],
        ),
      ),
      child: Text(
        name,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: CupertinoColors.white,
        ),
      ),
    );
  }
}
