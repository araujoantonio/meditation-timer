import 'package:just_audio/just_audio.dart';
import 'package:audio_session/audio_session.dart';

class BellService {
  final AudioPlayer _player = AudioPlayer();

  Future<void> init() async {
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration(
      avAudioSessionCategory: AVAudioSessionCategory.playback,
      avAudioSessionMode: AVAudioSessionMode.defaultMode,
      avAudioSessionCategoryOptions:
          AVAudioSessionCategoryOptions.mixWithOthers,
    ));
    await _player.setAsset('assets/sounds/bell.wav');
  }

  Future<void> playBell() async {
    await _player.seek(Duration.zero);
    await _player.play();
  }

  void dispose() {
    _player.dispose();
  }
}
