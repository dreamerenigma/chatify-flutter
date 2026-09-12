import 'package:path_provider/path_provider.dart';
import '../../../stubs/sound_real.dart';

class VoiceRecorderService {
  final AudioRecorder _recorder = AudioRecorder();
  String? _recordedFilePath;
  String? get recordedFilePath => _recordedFilePath;

  Future<String> start() async {
    final directory = await getTemporaryDirectory();
    final path = '${directory.path}/chatify_voice_${DateTime.now().millisecondsSinceEpoch}.m4a';

    await _recorder.start(const RecordConfig(encoder: AudioEncoder.aacLc), path: path);

    _recordedFilePath = path;

    return path;
  }

  Future<void> pause() async {
    await _recorder.pause();
  }

  Future<void> resume() async {
    await _recorder.resume();
  }

  Future<String?> stop() async {
    final path = await _recorder.stop();

    if (path != null) {
      _recordedFilePath = path;
    }

    return path;
  }

  Future<bool> isRecording() {
    return _recorder.isRecording();
  }

  Future<void> dispose() async {
    await _recorder.dispose();
  }
}
