// Copyright 2026 Pierre Gallaz. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:io';
import 'dart:typed_data';

import 'package:logging/logging.dart';

/// Works out the length of a remote MP3 from its first kilobytes.
///
/// The enpleineconscience.ch feeds carry no `itunes:duration`, so until an
/// episode has been played or downloaded its length is unknown. Fetching the
/// whole file just for that would defeat the point; instead we read the start
/// of the file with a `Range` request and use the Xing/Info header written by
/// LAME (exact frame count) or, failing that, the bitrate of the first frame
/// and the file size (right for constant-bitrate files, a fair estimate
/// otherwise).
class Mp3Duration {
  static final _log = Logger('Mp3Duration');
  static const _firstChunk = 256 * 1024;
  static const _afterTagChunk = 4096;

  /// Returns the duration in seconds, or null when it cannot be determined.
  /// [lengthBytes] is the enclosure length from the feed; when 0 the size
  /// from the `Content-Range` header is used.
  static Future<int?> probe(String url, {int lengthBytes = 0, HttpClient? client}) async {
    final http = client ?? HttpClient();
    http.connectionTimeout = const Duration(seconds: 15);

    try {
      var (bytes, total) = await _range(http, url, 0, _firstChunk - 1);

      if (bytes == null) {
        return null;
      }

      var offset = id3v2Size(bytes);

      // A cover image can push the audio past the first chunk: fetch a second,
      // small range right after the tag.
      if (offset >= bytes.length) {
        final (more, _) = await _range(http, url, offset, offset + _afterTagChunk - 1);

        if (more == null) {
          return null;
        }

        bytes = more;
        offset = 0;
      }

      final size = lengthBytes > 0 ? lengthBytes : total;

      return durationFromBytes(bytes, offset, size);
    } catch (e) {
      _log.fine('Could not probe $url: $e');
      return null;
    } finally {
      if (client == null) {
        http.close(force: true);
      }
    }
  }

  static Future<(Uint8List?, int)> _range(HttpClient http, String url, int from, int to) async {
    final request = await http.getUrl(Uri.parse(url));
    request.headers.set(HttpHeaders.rangeHeader, 'bytes=$from-$to');
    request.followRedirects = true;

    final response = await request.close();

    if (response.statusCode != HttpStatus.partialContent && response.statusCode != HttpStatus.ok) {
      _log.fine('Range request for $url answered ${response.statusCode}');
      await response.drain<void>();
      return (null, 0);
    }

    var total = 0;
    final contentRange = response.headers.value('content-range');

    if (contentRange != null) {
      total = int.tryParse(contentRange.split('/').last) ?? 0;
    } else {
      total = response.contentLength > 0 ? response.contentLength : 0;
    }

    final builder = BytesBuilder(copy: false);
    final limit = to - from + 1;

    await for (final chunk in response) {
      builder.add(chunk);

      // A server that ignores Range sends the whole file: stop early.
      if (builder.length >= limit) {
        break;
      }
    }

    return (builder.takeBytes(), total);
  }

  /// Size of a leading ID3v2 tag (header included), 0 when there is none.
  static int id3v2Size(Uint8List bytes) {
    if (bytes.length < 10 || bytes[0] != 0x49 || bytes[1] != 0x44 || bytes[2] != 0x33) {
      return 0;
    }

    final size = (bytes[6] << 21) | (bytes[7] << 14) | (bytes[8] << 7) | bytes[9];
    final footer = (bytes[5] & 0x10) != 0 ? 10 : 0;

    return 10 + size + footer;
  }

  /// Duration in seconds from a buffer holding the first audio frames, which
  /// start at or after [offset]. [fileSize] is the whole file, used for the
  /// constant-bitrate fallback.
  static int? durationFromBytes(Uint8List bytes, int offset, int fileSize) {
    final frame = _findFrame(bytes, offset);

    if (frame == null) {
      return null;
    }

    final i = frame.offset;

    // Xing/Info (LAME) or VBRI (Fraunhofer) headers give the frame count.
    final xing = i + 4 + frame.sideInfoSize;

    if (xing + 12 <= bytes.length && (_tagAt(bytes, xing, 'Xing') || _tagAt(bytes, xing, 'Info'))) {
      final flags = bytes[xing + 7];

      if ((flags & 0x01) != 0) {
        final frames = _uint32(bytes, xing + 8);
        return (frames * frame.samplesPerFrame / frame.sampleRate).round();
      }
    }

    final vbri = i + 4 + 32;

    if (vbri + 18 <= bytes.length && _tagAt(bytes, vbri, 'VBRI')) {
      final frames = _uint32(bytes, vbri + 14);
      return (frames * frame.samplesPerFrame / frame.sampleRate).round();
    }

    if (fileSize <= offset || frame.bitrate == 0) {
      return null;
    }

    return ((fileSize - i) * 8 / frame.bitrate).round();
  }

  static bool _tagAt(Uint8List b, int at, String tag) {
    if (at + 4 > b.length) return false;
    return b[at] == tag.codeUnitAt(0) &&
        b[at + 1] == tag.codeUnitAt(1) &&
        b[at + 2] == tag.codeUnitAt(2) &&
        b[at + 3] == tag.codeUnitAt(3);
  }

  static int _uint32(Uint8List b, int at) => (b[at] << 24) | (b[at + 1] << 16) | (b[at + 2] << 8) | b[at + 3];

  static const _bitrates = <int, List<int>>{
    // MPEG-1 layer III
    1: [0, 32, 40, 48, 56, 64, 80, 96, 112, 128, 160, 192, 224, 256, 320, 0],
    // MPEG-2 / 2.5 layer III
    2: [0, 8, 16, 24, 32, 40, 48, 56, 64, 80, 96, 112, 128, 144, 160, 0],
  };
  static const _sampleRates = <int, List<int>>{
    1: [44100, 48000, 32000, 0],
    2: [22050, 24000, 16000, 0],
    25: [11025, 12000, 8000, 0],
  };

  /// Finds the first layer III frame header at or after [from] and requires a
  /// second header where the first one says it should be, so an ID3 or junk
  /// byte pattern is not mistaken for audio. The buffer is read in 256 KB chunks,
  /// so a real file always has that second frame in reach.
  static _Frame? _findFrame(Uint8List b, int from) {
    for (var i = from; i + 4 <= b.length; i++) {
      final f = _parseHeader(b, i);

      if (f == null) continue;

      final next = i + f.frameLength;

      if (next + 4 <= b.length && _parseHeader(b, next) != null) {
        return f;
      }
    }

    return null;
  }

  static _Frame? _parseHeader(Uint8List b, int i) {
    if (b[i] != 0xFF || (b[i + 1] & 0xE0) != 0xE0) return null;

    final versionBits = (b[i + 1] >> 3) & 0x03; // 0: 2.5, 2: 2, 3: 1
    final layerBits = (b[i + 1] >> 1) & 0x03; // 1: layer III
    final bitrateIndex = (b[i + 2] >> 4) & 0x0F;
    final sampleIndex = (b[i + 2] >> 2) & 0x03;
    final padding = (b[i + 2] >> 1) & 0x01;
    final channelMode = (b[i + 3] >> 6) & 0x03; // 3: mono

    if (versionBits == 1 || layerBits != 1 || bitrateIndex == 0 || bitrateIndex == 15 || sampleIndex == 3) {
      return null;
    }

    final mpeg1 = versionBits == 3;
    final bitrate = _bitrates[mpeg1 ? 1 : 2]![bitrateIndex] * 1000;
    final sampleRate = _sampleRates[mpeg1 ? 1 : (versionBits == 2 ? 2 : 25)]![sampleIndex];
    final samplesPerFrame = mpeg1 ? 1152 : 576;
    final frameLength = (samplesPerFrame ~/ 8) * bitrate ~/ sampleRate + padding;
    final sideInfoSize = mpeg1 ? (channelMode == 3 ? 17 : 32) : (channelMode == 3 ? 9 : 17);

    return _Frame(i, bitrate, sampleRate, samplesPerFrame, frameLength, sideInfoSize);
  }
}

class _Frame {
  final int offset;
  final int bitrate;
  final int sampleRate;
  final int samplesPerFrame;
  final int frameLength;
  final int sideInfoSize;

  const _Frame(this.offset, this.bitrate, this.sampleRate, this.samplesPerFrame, this.frameLength, this.sideInfoSize);
}
