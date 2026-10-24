import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/models.dart';

@immutable
class PlayerSnapshot {
  const PlayerSnapshot({
    this.queue = const [],
    this.index = -1,
    this.isPlaying = false,
    this.position = Duration.zero,
  });

  final List<Track> queue;
  final int index;
  final bool isPlaying;
  final Duration position;

  Track? get current =>
      index >= 0 && index < queue.length ? queue[index] : null;

  double get progress {
    final c = current;
    if (c == null || c.duration.inMilliseconds == 0) return 0;
    return (position.inMilliseconds / c.duration.inMilliseconds)
        .clamp(0.0, 1.0);
  }

  PlayerSnapshot copyWith({
    List<Track>? queue,
    int? index,
    bool? isPlaying,
    Duration? position,
  }) =>
      PlayerSnapshot(
        queue: queue ?? this.queue,
        index: index ?? this.index,
        isPlaying: isPlaying ?? this.isPlaying,
        position: position ?? this.position,
      );
}

/// Заглушка плеера: логика очереди и прогресса уже рабочая, звука пока нет.
/// Позже внутренности заменим на just_audio + audio_service,
/// а публичный интерфейс (playTrack/toggle/seek/next/previous) останется.
class PlayerController extends Notifier<PlayerSnapshot> {
  static const _tick = Duration(milliseconds: 250);
  Timer? _timer;

  @override
  PlayerSnapshot build() {
    ref.onDispose(() => _timer?.cancel());
    return const PlayerSnapshot();
  }

  void playTrack(Track track, List<Track> queue) {
    final i = queue.indexWhere((t) => t.id == track.id);
    if (i < 0) return;
    state = PlayerSnapshot(
      queue: queue,
      index: i,
      isPlaying: true,
      position: Duration.zero,
    );
    _startTimer();
  }

  void toggle() {
    if (state.current == null) return;
    if (state.isPlaying) {
      _timer?.cancel();
    } else {
      _startTimer();
    }
    state = state.copyWith(isPlaying: !state.isPlaying);
  }

  /// [fraction] — от 0.0 до 1.0.
  void seek(double fraction) {
    final c = state.current;
    if (c == null) return;
    state = state.copyWith(
      position: Duration(
        milliseconds: (c.duration.inMilliseconds * fraction).round(),
      ),
    );
  }

  void next() {
    if (state.queue.isEmpty) return;
    _jump((state.index + 1) % state.queue.length);
  }

  void previous() {
    if (state.queue.isEmpty) return;
    if (state.position > const Duration(seconds: 3)) {
      state = state.copyWith(position: Duration.zero);
      return;
    }
    _jump((state.index - 1 + state.queue.length) % state.queue.length);
  }

  void _jump(int i) {
    state = state.copyWith(index: i, position: Duration.zero, isPlaying: true);
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(_tick, (_) {
      final c = state.current;
      if (c == null) return;
      final p = state.position + _tick;
      if (p >= c.duration) {
        next();
      } else {
        state = state.copyWith(position: p);
      }
    });
  }
}

final playerProvider =
    NotifierProvider<PlayerController, PlayerSnapshot>(PlayerController.new);
