import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../features/home/home_page.dart';
import '../features/library/library_page.dart';
import '../features/player/mini_player.dart';
import '../features/player/player_controller.dart';
import '../features/search/search_page.dart';
import '../widgets/app_tab_bar.dart';

class RootShell extends ConsumerStatefulWidget {
  const RootShell({super.key});

  @override
  ConsumerState<RootShell> createState() => _RootShellState();
}

class _RootShellState extends ConsumerState<RootShell> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final hasTrack = ref.watch(playerProvider.select((s) => s.current != null));

    return CupertinoPageScaffold(
      resizeToAvoidBottomInset: false,
      child: Column(
        children: [
          Expanded(
            // IndexedStack сохраняет скролл и состояние вкладок.
            child: IndexedStack(
              index: _index,
              children: const [HomePage(), SearchPage(), LibraryPage()],
            ),
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 350),
            curve: Curves.easeOutCubic,
            alignment: Alignment.bottomCenter,
            child: hasTrack
                ? const MiniPlayer()
                : const SizedBox(width: double.infinity),
          ),
          AppTabBar(
            currentIndex: _index,
            onTap: (i) {
              if (i == _index) return;
              HapticFeedback.selectionClick();
              setState(() => _index = i);
            },
          ),
        ],
      ),
    );
  }
}
