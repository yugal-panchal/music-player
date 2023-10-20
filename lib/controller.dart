import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter_media_metadata/flutter_media_metadata.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';

class AudioController extends GetxController {
  String _selectedAudio = "";
  Uint8List? _audioImage;
  bool _isPlaying = false;
  AudioPlayer _player = AudioPlayer();
  bool _isLoading = false;

  String get selectedAudio => _selectedAudio;
  Uint8List? get audioImage => _audioImage;
  bool get isPlaying => _isPlaying;
  AudioPlayer get player => _player;
  bool get isLoading => _isLoading;

  getAudio() async {
    _isLoading = true;
    update();
    FilePickerResult? pickedFile = await FilePicker.platform.pickFiles();
    if (pickedFile != null && pickedFile.files.single.path!.endsWith(".mp3")) {
      _selectedAudio = pickedFile.files.single.path!;
      final metaData = await MetadataRetriever.fromFile(File(_selectedAudio));
      _audioImage = metaData.albumArt;
      player.setAudioSource(AudioSource.file(_selectedAudio));
    } else {
      Get.showSnackbar(const GetSnackBar(
        message: "Please pick a MP3 file",
      ));
    }
    _isLoading = false;
    update();
  }

  togglePlay() {
    _isPlaying = !_isPlaying;
    if (_isPlaying) {
      player.play();
    } else {
      player.pause();
    }
    update();
  }

  seekForward() {
    player.seek(Duration(seconds: player.position.inSeconds + 10));
    update();
  }

  seekBackward() {
    if (player.position.inSeconds > 10) {
      player.seek(Duration(seconds: player.position.inSeconds - 10));
    }
    update();
  }
}
