import 'package:flutter/cupertino.dart';
import 'package:liquid_glass_native/liquid_glass_native.dart';

/// Нативный таб-бар. На iOS 26+ (сборка в Xcode с iOS 26 SDK) — настоящий
/// Liquid Glass через SwiftUI glassEffect. На старых iOS — обычные системные
/// контролы.
///
/// Вся зависимость от liquid_glass_native изолирована в этом файле: если
/// пакет перестанет устраивать, меняем только его.
class AppTabBar extends StatelessWidget {
  const AppTabBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return LiquidGlassTabBar(
      items: const [
        TabItem(label: 'Главная', sfSymbol: 'house.fill'),
        TabItem(label: 'Поиск', sfSymbol: 'magnifyingglass'),
        TabItem(label: 'Медиатека', sfSymbol: 'music.note.list'),
      ],
      currentIndex: currentIndex,
      onTap: onTap,
    );
  }
}
