// Host-side driver for the store screenshot run (see tools/store-screenshots.sh).
//
// Each `binding.takeScreenshot(name)` in the integration test lands here as PNG
// bytes and is written to $SHOT_DIR/<name>.png.

import 'dart:io';

import 'package:integration_test/integration_test_driver_extended.dart';

Future<void> main() async {
  final dir = Platform.environment['SHOT_DIR'] ?? 'store/screenshots/out';

  await integrationDriver(
    onScreenshot: (String name, List<int> bytes, [Map<String, Object?>? args]) async {
      final file = File('$dir/$name.png');
      await file.parent.create(recursive: true);
      await file.writeAsBytes(bytes);
      stdout.writeln('screenshot: ${file.path}');
      return true;
    },
  );
}
