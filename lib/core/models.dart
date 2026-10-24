import 'package:flutter/cupertino.dart';

@immutable
class Track {
  const Track({
    required this.id,
    required this.title,
    required this.artist,
    required this.album,
    required this.duration,
    required this.color,
  });

  final String id;
  final String title;
  final String artist;
  final String album;
  final Duration duration;

  /// Пока обложек нет, цвет задаёт градиент-заглушку.
  /// Когда подключим API — заменим на URL обложки.
  final Color color;
}

const demoTracks = <Track>[
  Track(id: '1', title: 'Midnight Drive', artist: 'Neon Harbor', album: 'Afterglow', duration: Duration(minutes: 3, seconds: 42), color: Color(0xFF6C4CFF)),
  Track(id: '2', title: 'Golden Hour', artist: 'Lumen', album: 'Daybreak', duration: Duration(minutes: 4, seconds: 5), color: Color(0xFFFF8A3D)),
  Track(id: '3', title: 'Paper Planes', artist: 'Marlow', album: 'Small Hours', duration: Duration(minutes: 2, seconds: 58), color: Color(0xFF1FB89A)),
  Track(id: '4', title: 'Static Bloom', artist: 'Velvet Circuit', album: 'Signal', duration: Duration(minutes: 3, seconds: 27), color: Color(0xFFE63E6D)),
  Track(id: '5', title: 'Northern Lights', artist: 'Aurora Vale', album: 'Frost', duration: Duration(minutes: 5, seconds: 12), color: Color(0xFF2E7BFF)),
  Track(id: '6', title: 'Slow Motion', artist: 'Kite & Co.', album: 'Sundays', duration: Duration(minutes: 3, seconds: 15), color: Color(0xFFB04CE6)),
  Track(id: '7', title: 'Afterparty', artist: 'Neon Harbor', album: 'Afterglow', duration: Duration(minutes: 3, seconds: 51), color: Color(0xFF3DB5FF)),
  Track(id: '8', title: 'Wildfire', artist: 'Lumen', album: 'Daybreak', duration: Duration(minutes: 4, seconds: 20), color: Color(0xFFFF5A3D)),
];

String formatDuration(Duration d) {
  final m = d.inMinutes;
  final s = (d.inSeconds % 60).toString().padLeft(2, '0');
  return '$m:$s';
}
