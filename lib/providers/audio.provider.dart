import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final audioProvider = Provider<AudioCache>(
  (ref) {
    return AudioCache(
      prefix: 'assets/audio/',
      respectSilence: true,
    );
  },
  name: 'audioProvider',
);
