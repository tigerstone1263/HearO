import 'package:audioplayers/audioplayers.dart';

enum Note { c, d, e, f, g, a, b }

class NoteAudio {
  final Map<Note, AudioPlayer> _players = {};
  final Set<Note> _configured = {};
  double _volume = 1.0;

  double get volume => _volume;

  Future<void> setVolume(double value) async {
    final next = value.clamp(0.0, 1.0);
    if (next == _volume) {
      return;
    }
    _volume = next;
    for (final player in _players.values) {
      await player.setVolume(_volume);
    }
  }

  Future<void> play(Note note) async {
    final player = _players.putIfAbsent(note, AudioPlayer.new);
    if (!_configured.contains(note)) {
      await player.setPlayerMode(PlayerMode.lowLatency);
      await player.setReleaseMode(ReleaseMode.stop);
      await player.setVolume(_volume);
      _configured.add(note);
    }

    await player.play(AssetSource(_assetFor(note)));
  }

  Future<void> dispose() async {
    final players = _players.values.toList();
    _players.clear();
    _configured.clear();
    for (final player in players) {
      await player.dispose();
    }
  }

  String _assetFor(Note note) {
    switch (note) {
      case Note.c:
        return 'sounds/note_c4.wav';
      case Note.d:
        return 'sounds/note_d4.wav';
      case Note.e:
        return 'sounds/note_e4.wav';
      case Note.f:
        return 'sounds/note_f4.wav';
      case Note.g:
        return 'sounds/note_g4.wav';
      case Note.a:
        return 'sounds/note_a4.wav';
      case Note.b:
        return 'sounds/note_b4.wav';
    }
  }
}
