import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music_player/controller.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Music Player"),
        centerTitle: true,
      ),
      body: GetBuilder<AudioController>(builder: (audioController) {
        return audioController.isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : audioController.selectedAudio == ""
                ? SizedBox(
                  width: double.maxFinite,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text("Please select MP3 file from your device"),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: ()=>audioController.getAudio(),
                          child: const Text("Choose File"),
                        ),
                      ],
                    ),
                )
                : Column(
                    children: [
                      const SizedBox(height: 20),
                      SizedBox(
                        height: 200,
                        width: 200,
                        child: audioController.audioImage != null
                            ? Image.memory(
                                audioController.audioImage!,
                                fit: BoxFit.contain,
                              )
                            : Image.asset(
                                "assets/music_placeholder.png",
                                fit: BoxFit.contain,
                              ),
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: StreamBuilder(
                            stream: audioController.player.positionStream,
                            builder: (context, snapshot1) {
                              final Duration duration =
                                  snapshot1.data ?? Duration.zero;
                              return StreamBuilder(
                                  stream: audioController
                                      .player.bufferedPositionStream,
                                  builder: (context, snapshot2) {
                                    final Duration bufferedDuration =
                                        (snapshot2.data ?? Duration.zero);
                                    return SizedBox(
                                      height: 30,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16),
                                        child: ProgressBar(
                                            progress: duration,
                                            total: audioController
                                                    .player.duration ??
                                                const Duration(seconds: 0),
                                            buffered: bufferedDuration,
                                            timeLabelPadding: -1,
                                            timeLabelTextStyle: const TextStyle(
                                                fontSize: 14,
                                                color: Colors.black),
                                            progressBarColor: Colors.red,
                                            baseBarColor: Colors.grey[200],
                                            bufferedBarColor: Colors.grey[350],
                                            thumbColor: Colors.red,
                                            onSeek: (duration) async {
                                              await audioController.player
                                                  .seek(duration);
                                            }),
                                      ),
                                    );
                                  });
                            }),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          IconButton(
                            onPressed: () => audioController.seekBackward(),
                            icon: const Icon(Icons.replay_10),
                          ),
                          IconButton(
                            onPressed: () => audioController.togglePlay(),
                            icon: Icon(audioController.isPlaying ? Icons.pause : Icons.play_arrow),
                          ),
                          IconButton(
                            onPressed: () => audioController.seekForward(),
                            icon: const Icon(Icons.forward_10),
                          ),
                        ],
                      ),
                                  const SizedBox(height: 20),
const Text("Select different MP3 file"),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: ()=>audioController.getAudio(),
                          child: const Text("Choose File"),
                        ),
                    ],
                  );
      }),
    );
  }
}
