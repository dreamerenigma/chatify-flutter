import 'package:path/path.dart' as path;
import '../../../stubs/sound_real.dart';
import '../../../utils/constants/app_directories.dart';

class VoiceRecorderService {
  final AudioRecorder _recorder = AudioRecorder();
  String? _recordedFilePath;
  String? get recordedFilePath => _recordedFilePath;

  Future<String> start() async {
    final voiceDirectory = await AppDirectories.getVoiceDirectory();

    if (voiceDirectory == null) {
      throw Exception('Voice directory is unavailable');
    }

    final filePath = path.join(voiceDirectory, 'voice_${DateTime.now().millisecondsSinceEpoch}.m4a');

    await _recorder.start(const RecordConfig(encoder: AudioEncoder.aacLc), path: filePath);

    _recordedFilePath = filePath;

    return filePath;
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
