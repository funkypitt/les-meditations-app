// Copyright 2020 Ben Hills and the project contributors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:anytime/bloc/podcast/podcast_bloc.dart';
import 'package:anytime/core/meditation_catalog.dart';
import 'package:anytime/entities/podcast.dart';
import 'package:anytime/ui/podcast/podcast_details.dart';
import 'package:anytime/ui/themes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sliver_tools/sliver_tools.dart';

/// Displays the fixed meditation catalog as a list of categories.
/// Each category corresponds to a podcast feed from enpleineconscience.ch.
class Discovery extends StatelessWidget {
  const Discovery({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiSliver(
      children: [
        SliverPadding(
          padding: const EdgeInsets.only(top: 4.0, bottom: 24.0),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                final feed = MeditationCatalog.feeds[index];
                return _CatalogTile(feed: feed);
              },
              childCount: MeditationCatalog.feeds.length,
            ),
          ),
        ),
      ],
    );
  }
}

class _CatalogTile extends StatelessWidget {
  final MeditationFeed feed;

  const _CatalogTile({required this.feed});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = Palette.of(context);

    return InkWell(
      onTap: () => _open(context),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Container(
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: palette.line)),
          ),
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          child: Text(
            feed.displayName,
            style: theme.textTheme.titleMedium,
          ),
        ),
      ),
    );
  }

  Future<void> _open(BuildContext context) async {
    final podcastBloc = Provider.of<PodcastBloc>(context, listen: false);

    // Look up the local subscription first (works offline).
    // The guid stored in Sembast is the feed URL.
    var podcast = await podcastBloc.podcastService.repository.findPodcastByGuid(feed.feedUrl);

    // Fall back to a network fetch if not yet subscribed.
    podcast ??= Podcast.fromUrl(url: feed.feedUrl);

    if (context.mounted) {
      Navigator.push(
        context,
        MaterialPageRoute<void>(
          settings: const RouteSettings(name: 'podcastdetails'),
          builder: (context) => PodcastDetails(podcast!, podcastBloc),
        ),
      );
    }
  }


}
