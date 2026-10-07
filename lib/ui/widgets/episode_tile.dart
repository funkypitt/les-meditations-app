// Copyright 2020 Ben Hills and the project contributors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:anytime/entities/episode.dart';
import 'package:anytime/l10n/L.dart';
import 'package:anytime/ui/podcast/transport_controls.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat;

/// One recording in a list: title, length, and on the right the offline switch
/// and the play button. No progress and no dimming: nothing is remembered
/// between sessions. Nothing unfolds — this is an app for listening, not a
/// podcast manager, so there is no queue, no "mark as played", no details sheet.
class EpisodeTile extends StatelessWidget {
  final Episode episode;
  final bool download;
  final bool play;
  final bool playing;
  final bool queued;

  const EpisodeTile({
    super.key,
    required this.episode,
    required this.download,
    required this.play,
    this.playing = false,
    this.queued = false,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      key: Key('PT${episode.guid}'),
      padding: const EdgeInsets.fromLTRB(20.0, 10.0, 12.0, 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  episode.title!,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: textTheme.bodyLarge,
                ),
                EpisodeSubtitle(episode),
              ],
            ),
          ),
          const SizedBox(width: 12.0),
          EpisodeTransportControls(
            episode: episode,
            download: download,
            play: play,
          ),
        ],
      ),
    );
  }
}

class EpisodeTransportControls extends StatelessWidget {
  final Episode episode;
  final bool download;
  final bool play;

  const EpisodeTransportControls({
    super.key,
    required this.episode,
    required this.download,
    required this.play,
  });

  @override
  Widget build(BuildContext context) {
    final buttons = <Widget>[];

    if (download) {
      buttons.add(Semantics(
        container: true,
        child: DownloadControl(
          episode: episode,
        ),
      ));
    }

    if (play) {
      buttons.add(Semantics(
        container: true,
        child: PlayControl(
          episode: episode,
        ),
      ));
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        for (var i = 0; i < buttons.length; i++) ...[
          if (i > 0) const SizedBox(width: 4.0),
          buttons[i],
        ],
      ],
    );
  }
}

/// The subtitle line of a recording: its length, and the date for the talks only.
class EpisodeSubtitle extends StatelessWidget {
  final Episode episode;
  final String date;
  final Duration length;

  EpisodeSubtitle(this.episode, {super.key})
      : date = episode.publicationDate == null
            ? ''
            : DateFormat(episode.publicationDate!.year == DateTime.now().year ? 'd MMM' : 'd MMM yyyy')
                .format(episode.publicationDate!),
        length = Duration(seconds: episode.duration);

  /// Only the talks are dated content; the meditations are timeless and their
  /// publication date is noise.
  bool get _showDate => (episode.pguid ?? '').contains('causeries');

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final parts = <String>[];
    final semanticParts = <String>[];

    if (_showDate && episode.publicationDate != null) {
      var dateLabel = date;
      var dateSemanticLabel = date;
      final now = DateTime.now();

      // If publication is within 7 days, give friendlier date format.
      if (now.difference(episode.publicationDate!).inDays < 7) {
        (dateLabel, dateSemanticLabel) = calculateTimeAgo(context, episode.publicationDate!, now);
      }

      parts.add(dateLabel);
      semanticParts.add(dateSemanticLabel);
    }

    if (length.inSeconds > 0) {
      if (length.inSeconds < 60) {
        parts.add(L.of(context)!.time_seconds(length.inSeconds));
        semanticParts.add(L.of(context)!.time_semantic_seconds(length.inSeconds));
      } else {
        parts.add(L.of(context)!.time_minutes(length.inMinutes));
        semanticParts.add(L.of(context)!.time_semantic_minutes(length.inMinutes));
      }
    }


    if (parts.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(top: 4.0),
      child: Text(
        parts.join(' · '),
        semanticsLabel: semanticParts.join(', '),
        overflow: TextOverflow.ellipsis,
        softWrap: false,
        style: textTheme.bodySmall,
      ),
    );
  }

  (String, String) calculateTimeAgo(BuildContext context, DateTime d, DateTime n) {
    final difference = n.difference(d);
    var label = '';
    var semanticLabel = '';

    if ((difference.inDays / 7).floor() >= 1) {
      label = L.of(context)!.episode_time_weeks_ago(1);
      semanticLabel = L.of(context)!.episode_semantic_time_weeks_ago(1);
    } else if (difference.inDays >= 1) {
      label = L.of(context)!.episode_time_days_ago(difference.inDays);
      semanticLabel = L.of(context)!.episode_semantic_time_days_ago(difference.inDays);
    } else if (difference.inHours >= 1) {
      label = L.of(context)!.episode_time_hours_ago(difference.inHours);
      semanticLabel = L.of(context)!.episode_semantic_time_hours_ago(difference.inHours);
    } else if (difference.inMinutes >= 1) {
      label = L.of(context)!.episode_time_minutes_ago(difference.inMinutes);
      semanticLabel = L.of(context)!.episode_semantic_time_minutes_ago(difference.inMinutes);
    } else {
      label = L.of(context)!.episode_time_now;
      semanticLabel = L.of(context)!.episode_time_now;
    }

    return (label, semanticLabel);
  }
}
