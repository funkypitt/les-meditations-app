import 'dart:typed_data';

import 'package:anytime/services/podcast/mp3_duration.dart';
import 'package:flutter_test/flutter_test.dart';

/// Builds an MPEG-1 layer III, 44.1 kHz, 128 kbps, joint-stereo frame header.
List<int> _frameHeader({bool padding = false}) => [0xFF, 0xFB, 0x90 | (padding ? 0x02 : 0x00), 0x40];

/// A stream of [count] valid 417-byte CBR frames.
Uint8List _cbrStream(int count) {
  final out = <int>[];
  for (var i = 0; i < count; i++) {
    out.addAll(_frameHeader());
    out.addAll(List.filled(417 - 4, 0));
  }
  return Uint8List.fromList(out);
}

Uint8List _id3(int payload) => Uint8List.fromList([
      0x49, 0x44, 0x33, 0x03, 0x00, 0x00, // "ID3", v2.3, no footer
      (payload >> 21) & 0x7F, (payload >> 14) & 0x7F, (payload >> 7) & 0x7F, payload & 0x7F,
      ...List.filled(payload, 0),
    ]);

void main() {
  group('Mp3Duration', () {
    test('reads the ID3v2 tag size', () {
      expect(Mp3Duration.id3v2Size(_id3(1000)), 1010);
      expect(Mp3Duration.id3v2Size(_cbrStream(1)), 0);
    });

    test('uses the Xing/Info frame count when present', () {
      // Frame, 32 bytes of side info, then "Info" with the frames flag and 91701 frames.
      final frame = <int>[..._frameHeader(), ...List.filled(32, 0)];
      frame.addAll('Info'.codeUnits);
      frame.addAll([0, 0, 0, 0x01]);
      frame.addAll([0x00, 0x01, 0x66, 0x35]); // 91701
      frame.addAll(List.filled(417 - frame.length, 0));
      final bytes = Uint8List.fromList([..._id3(100), ...frame, ..._cbrStream(2)]);

      final seconds = Mp3Duration.durationFromBytes(bytes, Mp3Duration.id3v2Size(bytes), 57550305);

      expect(seconds, (91701 * 1152 / 44100).round()); // 2395 s
    });

    test('falls back to bitrate x size for plain CBR files', () {
      final bytes = Uint8List.fromList([..._id3(50), ..._cbrStream(3)]);
      // 10 minutes at 128 kbps, plus the tag.
      final fileSize = 60 + 600 * 128000 ~/ 8;

      final seconds = Mp3Duration.durationFromBytes(bytes, Mp3Duration.id3v2Size(bytes), fileSize);

      expect(seconds, 600);
    });

    test('does not mistake a lone sync pattern for audio', () {
      final junk = Uint8List.fromList([0x00, 0xFF, 0xFB, 0x90, 0x40, 0x00, 0x00, 0x00, 0x00, 0x00]);

      expect(Mp3Duration.durationFromBytes(junk, 0, 1000000), isNull);
    });
  });
}
