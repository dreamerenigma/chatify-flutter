import 'package:just_audio/just_audio.dart';

class VoicePlaybackService {
  final AudioPlayer _player = AudioPlayer();

  Stream<Duration> get positionStream => _player.positionStream;

  Stream<Duration?> get durationStream => _player.durationStream;

  Stream<PlayerState> get playerStateStream => _player.playerStateStream;

  Future<void> load(String path) async {
    await _player.setFilePath(path);
  }

  Future<void> play() => _player.play();

  Future<void> pause() => _player.pause();

  Future<void> seek(Duration position) => _player.seek(position);

  Future<void> dispose() => _player.dispose();
}
