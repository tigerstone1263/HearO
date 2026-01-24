import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';

import '../audio/note_audio.dart';

class PianoKeys extends PositionComponent {
  PianoKeys({
    required this.noteAudio,
  }) : super(
          anchor: Anchor.bottomRight,
          size: Vector2(280, 90),
        );

  final NoteAudio noteAudio;

  static const List<Note> _notes = [
    Note.c,
    Note.d,
    Note.e,
    Note.f,
    Note.g,
    Note.a,
    Note.b,
  ];

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    final keyWidth = size.x / _notes.length;
    for (var index = 0; index < _notes.length; index++) {
      final note = _notes[index];
      final key = _PianoKey(
        note: note,
        onPressed: () {
          noteAudio.play(note);
        },
      )
        ..size = Vector2(keyWidth, size.y)
        ..position = Vector2(keyWidth * index, 0);
      add(key);
    }
  }
}

class _PianoKey extends PositionComponent with TapCallbacks {
  _PianoKey({
    required this.note,
    required this.onPressed,
  }) : super(
          anchor: Anchor.topLeft,
        );

  final Note note;
  final VoidCallback onPressed;
  bool _pressed = false;

  @override
  bool get debugMode => false;

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    final baseColor = const Color(0xFFDFE6EE).withOpacity(0.18);
    final highlight = const Color(0xFFDFE6EE).withOpacity(0.5);
    final paint = Paint()..color = _pressed ? highlight : baseColor;
    final borderPaint = Paint()
      ..color = const Color(0xFFCED8E2).withOpacity(0.35)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    final rect = size.toRect();
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(6)),
      paint,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(6)),
      borderPaint,
    );
  }

  @override
  void onTapDown(TapDownEvent event) {
    _pressed = true;
    onPressed();
  }

  @override
  void onTapUp(TapUpEvent event) {
    _pressed = false;
  }

  @override
  void onTapCancel(TapCancelEvent event) {
    _pressed = false;
  }
}
