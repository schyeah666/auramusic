import 'package:flutter/cupertino.dart';

import '../../core/theme.dart';
import '../../widgets/fade_slide_in.dart';
import '../../widgets/pressable.dart';

const _items = <(String, String, IconData, Color)>[
  ('Любимые треки', '128 треков', CupertinoIcons.heart_fill, Color(0xFFFF375F)),
  ('Загрузки', 'Скоро', CupertinoIcons.arrow_down_circle_fill, Color(0xFF2E7BFF)),
  ('Недавно добавленные', '24 трека', CupertinoIcons.clock_fill, Color(0xFF1FB89A)),
  ('Мои плейлисты', '6 плейлистов', CupertinoIcons.music_note_list, Color(0xFFB04CE6)),
];

class LibraryPage extends StatelessWidget {
  const LibraryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(
        parent: AlwaysScrollableScrollPhysics(),
      ),
      slivers: [
        const CupertinoSliverNavigationBar(
          largeTitle: Text('Медиатека'),
          automaticallyImplyLeading: false,
          transitionBetweenRoutes: false,
        ),
        SliverList.builder(
          itemCount: _items.length,
          itemBuilder: (context, i) {
            final (title, subtitle, icon, color) = _items[i];
            return FadeSlideIn(
              index: i,
              child: Pressable(
                scale: 0.98,
                onTap: () {}, // TODO: открыть список
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: Row(
                    children: [
                      Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          color: color,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(icon, color: CupertinoColors.white),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(title, style: AppText.title),
                            const SizedBox(height: 2),
                            Text(subtitle, style: AppText.subtitle),
                          ],
                        ),
                      ),
                      const Icon(CupertinoIcons.chevron_right,
                          size: 16, color: AppColors.secondaryText),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 24)),
      ],
    );
  }
}
