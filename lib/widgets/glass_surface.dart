import 'dart:ui';

import 'package:flutter/cupertino.dart';

/// Стеклянная поверхность, нарисованная средствами Flutter (blur + блик по краю).
///
/// ВАЖНО: это имитация, а не настоящий Liquid Glass. Настоящий Liquid Glass
/// (UIGlassEffect / SwiftUI .glassEffect) рендерит только нативный UIKit/SwiftUI,
/// поэтому в этом шаблоне он используется для таб-бара (см. app_tab_bar.dart).
/// Если нужен настоящий Liquid Glass под мини-плеером, его делают через
/// platform view — это следующий шаг (см. README).
class GlassSurface extends StatelessWidget {
  const GlassSurface({
    super.key,
    required this.child,
    this.radius = 24,
    this.padding = EdgeInsets.zero,
  });

  final Widget child;
  final double radius;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(radius);
    return ClipRRect(
      borderRadius: borderRadius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: borderRadius,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                CupertinoColors.white.withValues(alpha: 0.16),
                CupertinoColors.white.withValues(alpha: 0.06),
              ],
            ),
            border: Border.all(
              color: CupertinoColors.white.withValues(alpha: 0.18),
              width: 0.5,
            ),
          ),
          child: Padding(padding: padding, child: child),
        ),
      ),
    );
  }
}
