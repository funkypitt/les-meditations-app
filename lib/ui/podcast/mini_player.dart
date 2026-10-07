// Copyright 2020 Ben Hills and the project contributors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:math' as math;

import 'package:anytime/bloc/podcast/audio_bloc.dart';
import 'package:anytime/entities/episode.dart';
import 'package:anytime/l10n/L.dart';
import 'package:anytime/services/audio/audio_player_service.dart';
import 'package:anytime/ui/themes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// The one and only player of the app: a bar at the very bottom of every
/// screen, shown as soon as a recording is loaded (playing, paused, or stopped
/// at 00:00). It offers play/pause and stop, nothing else: no seeking, no
/// skipping, no full-screen player to open.
///
/// [MiniPlayerHost] wraps the whole navigator so the bar sits under every
/// route, sheets and dialogs included, and takes the bottom system inset
/// (and the keyboard) on their behalf.
class MiniPlayerHost extends StatelessWidget {
  final Widget child;

  const MiniPlayerHost({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final audioBloc = Provider.of<AudioBloc>(context, listen: false);
    final mq = MediaQuery.of(context);

    return StreamBuilder<AudioState>(
        stream: audioBloc.playingState,
        initialData: AudioState.none,
        builder: (context, snapshot) {
          final visible = _MiniPlayer.isVisible(snapshot.data);
          final bottomInset = math.max(mq.padding.bottom, mq.viewInsets.bottom);

          // The tree above the navigator keeps the same shape whether the bar
          // is shown or not: only the MediaQuery data changes, so no route
          // state is ever lost when the bar appears.
          return Column(
            children: [
              Expanded(
                child: MediaQuery(
                  data: visible
                      ? mq.copyWith(
                          padding: mq.padding.copyWith(bottom: 0),
                          viewPadding: mq.viewPadding.copyWith(bottom: 0),
                          viewInsets: mq.viewInsets.copyWith(bottom: 0),
                        )
                      : mq,
                  child: child,
                ),
              ),
              if (visible) _MiniPlayer(bottomInset: bottomInset),
            ],
          );
        });
  }
}

class _MiniPlayer extends StatelessWidget {
  final double bottomInset;

  const _MiniPlayer({required this.bottomInset});

  static const double barHeight = 72.0;

  static bool isVisible(AudioState? state) =>
      state != null && state != AudioState.stopped && state != AudioState.none && state != AudioState.error;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = Palette.of(context);
    final audioBloc = Provider.of<AudioBloc>(context, listen: false);
    final l = L.of(context)!;

    return Semantics(
      container: true,
      label: l.semantics_mini_player_header,
      child: Material(
        color: palette.ground,
        child: Padding(
          padding: EdgeInsets.only(bottom: bottomInset),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Hairline, then the progress line: the only moving thing on screen.
              Container(height: 1.0, color: palette.line),
              StreamBuilder<PositionState>(
                  stream: audioBloc.playPosition,
                  initialData: audioBloc.playPosition?.valueOrNull,
                  builder: (context, snapshot) {
                    final position = snapshot.data?.position ?? Duration.zero;
                    final length = snapshot.data?.length ?? Duration.zero;
                    final fraction = length.inMilliseconds > 0
                        ? (position.inMilliseconds / length.inMilliseconds).clamp(0.0, 1.0)
                        : 0.0;

                    return Align(
                      alignment: Alignment.centerLeft,
                      child: FractionallySizedBox(
                        widthFactor: fraction,
                        child: Container(height: 3.0, color: palette.accent),
                      ),
                    );
                  }),
              SizedBox(
                height: barHeight,
                child: Padding(
                  padding: const EdgeInsets.only(left: 20.0, right: 12.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: StreamBuilder<Episode?>(
                            stream: audioBloc.nowPlaying,
                            initialData: audioBloc.nowPlaying?.valueOrNull,
                            builder: (context, episodeSnapshot) {
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    episodeSnapshot.data?.title ?? '',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: theme.textTheme.bodyLarge,
                                  ),
                                  const SizedBox(height: 2.0),
                                  StreamBuilder<PositionState>(
                                      stream: audioBloc.playPosition,
                                      initialData: audioBloc.playPosition?.valueOrNull,
                                      builder: (context, snapshot) {
                                        final position = snapshot.data?.position ?? Duration.zero;
                                        final length = snapshot.data?.length ?? Duration.zero;
                                        final text = length.inSeconds > 0
                                            ? '${_clock(position)} / ${_clock(length)}'
                                            : _clock(position);

                                        return Text(
                                          text,
                                          maxLines: 1,
                                          style: theme.textTheme.bodySmall!.copyWith(
                                            color: palette.inkSoft,
                                            fontFeatures: const [FontFeature.tabularFigures()],
                                          ),
                                        );
                                      }),
                                ],
                              );
                            }),
                      ),
                      const SizedBox(width: 12.0),
                      StreamBuilder<AudioState>(
                          stream: audioBloc.playingState,
                          builder: (context, snapshot) {
                            final playing =
                                snapshot.data == AudioState.playing || snapshot.data == AudioState.buffering;

                            return _RoundButton(
                              key: const Key('miniplayer_playpause'),
                              icon: playing ? Icons.pause : Icons.play_arrow,
                              label: playing ? l.pause_button_label : l.play_button_label,
                              background: palette.accent,
                              foreground: palette.onAccent,
                              onPressed: () => audioBloc
                                  .transitionState(playing ? TransitionState.pause : TransitionState.play),
                            );
                          }),
                      const SizedBox(width: 8.0),
                      _RoundButton(
                        key: const Key('miniplayer_stop'),
                        icon: Icons.stop,
                        label: l.stop_button_label,
                        background: Colors.transparent,
                        foreground: palette.ink,
                        onPressed: () => audioBloc.transitionState(TransitionState.reset),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 7:05, 12:30, 1:02:05 — the figures people read on a kitchen timer.
  static String _clock(Duration d) {
    final h = d.inHours;
    final m = d.inMinutes.remainder(60);
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');

    return h > 0 ? '$h:${m.toString().padLeft(2, '0')}:$s' : '$m:$s';
  }
}

/// A large round button: 52 px of target for every age, one icon, one colour.
class _RoundButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color background;
  final Color foreground;
  final VoidCallback onPressed;

  const _RoundButton({
    super.key,
    required this.icon,
    required this.label,
    required this.background,
    required this.foreground,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 52.0,
      height: 52.0,
      child: Material(
        color: background,
        shape: const CircleBorder(),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onPressed,
          child: Icon(icon, size: 32.0, color: foreground, semanticLabel: label),
        ),
      ),
    );
  }
}
