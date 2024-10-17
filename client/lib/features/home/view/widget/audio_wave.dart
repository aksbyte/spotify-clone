import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:client/core/constant/app_export.dart';
import 'package:flutter/cupertino.dart';

class AudioWave extends StatefulWidget {
  final String path;

  const AudioWave({super.key, required this.path});

  @override
  State<AudioWave> createState() => _AudioWaveState();
}

class _AudioWaveState extends State<AudioWave> {
  final _playerController = PlayerController();

  @override
  void initState() {
    super.initState();
    _initAudioPlayer();
  }

  void _initAudioPlayer() async {
    await _playerController.preparePlayer(path: widget.path);
  }

  Future<void> _playAndPause() async {
    if (!_playerController.playerState.isPlaying) {
      await _playerController.startPlayer(finishMode: FinishMode.stop);
    } else if (!_playerController.playerState.isPaused) {
      await _playerController.pausePlayer();
    }
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    _playerController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: _playAndPause,
          icon: Icon(_playerController.playerState.isPlaying
              ? CupertinoIcons.pause_solid
              : CupertinoIcons.play_arrow_solid),
        ),
        Expanded(
          child: AudioFileWaveforms(
            size: const Size(double.infinity, 100),
            playerController: _playerController,
            playerWaveStyle: PlayerWaveStyle(
              fixedWaveColor: AppColor.borderColor,
              liveWaveColor: AppColor.gradient2,
              spacing: 5,
              showSeekLine: false,
            ),
            waveformType: WaveformType.fitWidth,
          ),
        ),
      ],
    );
  }
}
