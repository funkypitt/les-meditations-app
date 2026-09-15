// Walks the app and takes the store screenshots.
//
// Run through tools/store-screenshots.sh, which sizes the emulator for each
// store format and collects the PNGs. The screenshots come from the Flutter
// surface itself, so they carry no Android status bar or navigation buttons.
//
// The walk uses real feeds from enpleineconscience.ch: the emulator needs
// network access, and the category tapped below must exist in the catalog.

import 'package:anytime/services/settings/mobile_settings_service.dart';
import 'package:anytime/ui/anytime_podcast_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

const _category = String.fromEnvironment('SHOT_CATEGORY', defaultValue: 'Mini-méditations 10+');

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('store screenshots', (tester) async {
    // Same boot as main(), minus its FlutterError.onError override, which the
    // test binding does not allow.
    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    final settings = (await MobileSettingsService.instance())!;
    final app = AnytimePodcastApp(
      mobileSettingsService: settings,
      certificateAuthorityBytes: const [],
    );
    await tester.pumpWidget(app);
    await binding.convertFlutterSurfaceToImage();
    await _waitFor(tester, find.text('Bodyscan'), timeout: const Duration(seconds: 40), binding: binding);
    await _settle(tester);
    await binding.takeScreenshot('01-accueil');

    // The category page: header, description and the first recordings. On small
    // screens the category sits below the fold, so scroll it into view first.
    await tester.scrollUntilVisible(find.text(_category), 200, scrollable: find.byType(Scrollable).first);
    await _settle(tester, const Duration(milliseconds: 600));
    await tester.tap(find.text(_category));
    final play = find.bySemanticsLabel(RegExp(r'^(Écouter|Play) '));
    await _waitFor(tester, play, timeout: const Duration(seconds: 60));
    await _settle(tester);
    await binding.takeScreenshot('02-categorie');

    // Start the first recording: its row turns burgundy and the mini player appears.
    await tester.tap(play.first);
    final pause = find.bySemanticsLabel(RegExp(r'^Pause '));
    await _waitFor(tester, pause, timeout: const Duration(seconds: 60));
    await _settle(tester, const Duration(seconds: 3));
    await binding.takeScreenshot('03-lecture');

    // Back to the home page, then open the full player from the mini player.
    await tester.tap(find.byIcon(Icons.close).first);
    await _waitFor(tester, find.byKey(const Key('miniplayergesture')));
    await _settle(tester);
    await tester.tap(find.byKey(const Key('miniplayergesture')));
    await _waitFor(tester, find.byIcon(Icons.keyboard_arrow_down));
    await _settle(tester, const Duration(seconds: 2));
    await binding.takeScreenshot('04-lecteur');

    // The same player in dark mode, through the app's own theme setting.
    app.settingsBloc!.theme('dark');
    await _settle(tester, const Duration(seconds: 2));
    await binding.takeScreenshot('05-lecteur-sombre');
    app.settingsBloc!.theme('system');
    await _settle(tester, const Duration(seconds: 2));

    // Close the player and pause playback so the emulator is left quiet.
    await tester.tap(find.byIcon(Icons.keyboard_arrow_down));
    await _waitFor(tester, find.byKey(const Key('miniplayergesture')));
    await _settle(tester);
    await binding.takeScreenshot('06-accueil-lecture');
  }, timeout: const Timeout(Duration(minutes: 6)));
}

/// Pumps real time until [finder] matches, or fails after [timeout]. On failure
/// the screen is captured and the visible texts listed, to see what was there.
Future<void> _waitFor(WidgetTester tester, Finder finder,
    {Duration timeout = const Duration(seconds: 20), IntegrationTestWidgetsFlutterBinding? binding}) async {
  final end = DateTime.now().add(timeout);
  while (finder.evaluate().isEmpty) {
    if (DateTime.now().isAfter(end)) {
      final texts = find.byType(Text).evaluate().map((e) => (e.widget as Text).data ?? '').where((t) => t.isNotEmpty);
      // ignore: avoid_print
      print('TEXTS ON SCREEN: ${texts.join(' | ')}');
      if (binding != null) {
        await binding.takeScreenshot('debug-timeout');
      }
      fail('Timed out waiting for $finder');
    }
    await tester.pump(const Duration(milliseconds: 250));
  }
}

/// Lets animations and images finish without relying on pumpAndSettle, which never
/// settles while the position stream ticks.
Future<void> _settle(WidgetTester tester, [Duration duration = const Duration(milliseconds: 1200)]) async {
  final end = DateTime.now().add(duration);
  while (DateTime.now().isBefore(end)) {
    await tester.pump(const Duration(milliseconds: 100));
  }
}
