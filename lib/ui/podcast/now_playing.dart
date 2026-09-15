// Copyright 2020 Ben Hills and the project contributors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:anytime/bloc/podcast/audio_bloc.dart';
import 'package:anytime/entities/episode.dart';
import 'package:anytime/l10n/L.dart';
import 'package:anytime/services/audio/audio_player_service.dart';
import 'package:anytime/ui/podcast/playback_error_listener.dart';
import 'package:anytime/ui/podcast/player_position_controls.dart';
import 'package:anytime/ui/podcast/player_transport_controls.dart';
import 'package:anytime/ui/widgets/delayed_progress_indicator.dart';
import 'package:anytime/ui/widgets/placeholder_builder.dart';
import 'package:anytime/ui/widgets/podcast_image.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

/// This is the full-screen player Widget which is invoked by touching the mini player.
///
/// This is the parent widget of the now playing screen(s). If we are running on a mobile in
/// portrait mode, we display the episode details, controls and additional options
/// as a draggable view. For tablets in portrait or on desktop, we display a split
/// screen. The main details and controls appear in one pane with the additional
/// controls in another.
///
/// TODO: The fade in/out transition applied when scrolling the queue is the first implementation.
/// Using [Opacity] is a very inefficient way of achieving this effect, but will do as a place
/// holder until a better animation can be achieved.
class NowPlaying extends StatefulWidget {
  const NowPlaying({
    super.key,
  });

  @override
  State<NowPlaying> createState() => _NowPlayingState();
}

class _NowPlayingState extends State<NowPlaying> with WidgetsBindingObserver {
  late StreamSubscription<AudioState> playingStateSubscription;
  var textGroup = AutoSizeGroup();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    final audioBloc = Provider.of<AudioBloc>(context, listen: false);
    var popped = false;

    // If the episode finishes we can close.
    playingStateSubscription =
        audioBloc.playingState!.where((state) => state == AudioState.stopped).listen((playingState) async {
      // Prevent responding to multiple stop events after we've popped and lost context.
      if (!popped) {
        popped = true;
        if (mounted) {
          Navigator.of(context).pop();
        }
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    playingStateSubscription.cancel();

    super.dispose();
  }

  /// The player is one screen: the recording, its title, and the transport.
  /// No tabs, no queue, no notes — this app plays one recording at a time.
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final audioBloc = Provider.of<AudioBloc>(context, listen: false);
    final playerBuilder = PlayerControlsBuilder.of(context);

    return Semantics(
      header: false,
      label: L.of(context)!.semantics_main_player_header,
      explicitChildNodes: true,
      child: StreamBuilder<Episode?>(
          stream: audioBloc.nowPlaying,
          builder: (context, snapshot) {
            if (!snapshot.hasData || snapshot.data == null) {
              return Container();
            }

            final episode = snapshot.data!;
            final WidgetBuilder? transportBuilder = playerBuilder?.builder(episode.duration);

            return AnnotatedRegion<SystemUiOverlayStyle>(
              value: theme.appBarTheme.systemOverlayStyle!,
              child: Scaffold(
                appBar: AppBar(
                  backgroundColor: theme.scaffoldBackgroundColor,
                  elevation: 0.0,
                  leading: IconButton(
                    tooltip: L.of(context)!.minimise_player_window_button_label,
                    icon: Icon(
                      Icons.keyboard_arrow_down,
                      semanticLabel: L.of(context)!.minimise_player_window_button_label,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                  flexibleSpace: const PlaybackErrorListener(child: SizedBox.shrink()),
                ),
                body: SafeArea(
                  top: false,
                  child: Column(
                    children: [
                      Expanded(
                        child: NowPlayingEpisode(
                          imageUrl: episode.positionalImageUrl,
                          episode: episode,
                          textGroup: textGroup,
                        ),
                      ),
                      transportBuilder != null
                          ? transportBuilder(context)
                          : const Padding(
                              padding: EdgeInsets.only(bottom: 24.0),
                              child: SizedBox(
                                height: 148.0,
                                child: NowPlayingTransport(),
                              ),
                            ),
                    ],
                  ),
                ),
              ),
            );
          }),
    );
  }
}

/// This widget displays the episode logo, episode title and current
/// chapter if available.
///
/// If running in portrait this will be in a vertical format; if in
/// landscape this will be in a horizontal format. The actual displaying
/// of the episode text is handed off to [NowPlayingEpisodeDetails].
class NowPlayingEpisode extends StatelessWidget {
  final String? imageUrl;
  final Episode episode;
  final AutoSizeGroup? textGroup;

  const NowPlayingEpisode({
    super.key,
    required this.imageUrl,
    required this.episode,
    required this.textGroup,
  });

  @override
  Widget build(BuildContext context) {
    final placeholderBuilder = PlaceholderBuilder.of(context);
    final orientation = MediaQuery.of(context).orientation;
    final size = MediaQuery.of(context).size;

    return OrientationBuilder(
      builder: (context, _) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(24.0, 8.0, 24.0, 8.0),
          child: orientation == Orientation.portrait || size.width >= 1000
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 7,
                      child: Semantics(
                        label: L.of(context)!.semantic_podcast_artwork_label,
                        child: PodcastImage(
                          key: Key('nowplaying$imageUrl'),
                          url: imageUrl!,
                          width: size.width * .75,
                          height: size.height * .75,
                          fit: BoxFit.contain,
                          borderRadius: 24.0,
                          placeholder: placeholderBuilder != null
                              ? placeholderBuilder.builder()(context)
                              : DelayedCircularProgressIndicator(),
                          errorPlaceholder: placeholderBuilder != null
                              ? placeholderBuilder.errorBuilder()(context)
                              : const Image(image: AssetImage('assets/images/meditation-placeholder-logo.png')),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: NowPlayingEpisodeDetails(
                        episode: episode,
                        textGroup: textGroup,
                      ),
                    ),
                  ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Padding(
                        padding: const EdgeInsets.only(
                          left: 8.0,
                          bottom: 8.0,
                        ),
                        child: PodcastImage(
                          key: Key('nowplaying$imageUrl'),
                          url: imageUrl!,
                          height: 280,
                          width: 280,
                          fit: BoxFit.contain,
                          borderRadius: 20.0,
                          placeholder: placeholderBuilder != null
                              ? placeholderBuilder.builder()(context)
                              : DelayedCircularProgressIndicator(),
                          errorPlaceholder: placeholderBuilder != null
                              ? placeholderBuilder.errorBuilder()(context)
                              : const Image(image: AssetImage('assets/images/meditation-placeholder-logo.png')),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 5,
                      child: NowPlayingEpisodeDetails(
                        episode: episode,
                        textGroup: textGroup,
                      ),
                    ),
                  ],
                ),
        );
      },
    );
  }
}

/// This widget is responsible for displaying the main episode details.
///
/// This displays the current episode title and, if available, the
/// current chapter title and optional link.
class NowPlayingEpisodeDetails extends StatelessWidget {
  final Episode? episode;
  final AutoSizeGroup? textGroup;
  static const minFontSize = 14.0;

  const NowPlayingEpisodeDetails({
    super.key,
    this.episode,
    this.textGroup,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final chapterTitle = episode?.currentChapter?.title ?? '';
    final chapterUrl = episode?.currentChapter?.url ?? '';

    return Column(
      children: [
        Expanded(
          flex: 5,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 16.0, 8.0, 0.0),
            child: Semantics(
              container: true,
              child: AutoSizeText(
                episode?.title ?? '',
                group: textGroup,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                minFontSize: minFontSize,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24.0,
                ),
                maxLines: episode!.hasChapters ? 3 : 4,
              ),
            ),
          ),
        ),
        if (episode!.hasChapters)
          Expanded(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 0.0, 0.0, 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(
                    child: Semantics(
                      label: L.of(context)!.semantic_current_chapter_label,
                      container: true,
                      child: AutoSizeText(
                        chapterTitle,
                        group: textGroup,
                        minFontSize: minFontSize,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.grey[300],
                          fontWeight: FontWeight.normal,
                          fontSize: 16.0,
                        ),
                        maxLines: 2,
                      ),
                    ),
                  ),
                  chapterUrl.isEmpty
                      ? const SizedBox(
                          height: 0,
                          width: 0,
                        )
                      : Semantics(
                          label: L.of(context)!.semantic_chapter_link_label,
                          container: true,
                          child: IconButton(
                              padding: EdgeInsets.zero,
                              icon: const Icon(
                                Icons.link,
                              ),
                              color: theme.primaryIconTheme.color,
                              onPressed: () {
                                _chapterLink(chapterUrl);
                              }),
                        ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  void _chapterLink(String url) async {
    final uri = Uri.parse(url);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch chapter link: $url';
    }
  }
}

/// This is the parent widget for the episode position and transport
/// controls.
class NowPlayingTransport extends StatelessWidget {
  const NowPlayingTransport({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: <Widget>[
        Divider(
          height: 0.0,
        ),
        PlayerPositionControls(),
        PlayerTransportControls(),
      ],
    );
  }
}

/// This widget allows users to inject their own transport controls
/// into the app.
///
/// When rendering the controls, Anytime will check if a PlayerControlsBuilder
/// is in the tree. If so, it will use the builder rather than its own
/// transport controls.
class PlayerControlsBuilder extends InheritedWidget {
  final WidgetBuilder Function(int duration) builder;

  const PlayerControlsBuilder({
    super.key,
    required this.builder,
    required super.child,
  });

  static PlayerControlsBuilder? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<PlayerControlsBuilder>();
  }

  @override
  bool updateShouldNotify(PlayerControlsBuilder oldWidget) {
    return builder != oldWidget.builder;
  }
}
