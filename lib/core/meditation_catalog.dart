// Copyright 2024 En Pleine Conscience. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

/// A single entry in the meditation catalog.
class MeditationFeed {
  final String feedUrl;
  final String displayName;
  final bool oldestFirst;

  const MeditationFeed({
    required this.feedUrl,
    required this.displayName,
    this.oldestFirst = true,
  });
}

/// Pre-configured catalog of meditation podcast feeds from enpleineconscience.ch.
/// Order matters — this is the display order in the app.
/// Titles are the real RSS channel titles.
class MeditationCatalog {
  static const List<MeditationFeed> feeds = [
    MeditationFeed(
      feedUrl: 'https://www.enpleineconscience.ch/feed/podcast/les-causeries-denpleineconscience-ch',
      displayName: "Les causeries d'enpleineconscience.ch",
      oldestFirst: false,
    ),
    MeditationFeed(
      feedUrl: 'https://www.enpleineconscience.ch/feed/podcast/bodyscan',
      displayName: 'Bodyscan',
    ),
    MeditationFeed(
      feedUrl: 'https://www.enpleineconscience.ch/feed/podcast/assise-respiration',
      displayName: 'Assises centr\u00e9es sur la respiration',
    ),
    MeditationFeed(
      feedUrl: 'https://www.enpleineconscience.ch/feed/podcast/etirements',
      displayName: '\u00c9tirements et yoga',
    ),
    MeditationFeed(
      feedUrl: 'https://www.enpleineconscience.ch/feed/podcast/assise-plusieurs-objets',
      displayName: 'Assises centr\u00e9es sur plusieurs objets et attention ouverte',
    ),
    MeditationFeed(
      feedUrl: 'https://www.enpleineconscience.ch/feed/podcast/bienveillance',
      displayName: 'Bienveillance et autres beaux sentiments',
    ),
    MeditationFeed(
      feedUrl: 'https://www.enpleineconscience.ch/feed/podcast/silence',
      displayName: 'Silences avec sons de bols',
    ),
    MeditationFeed(
      feedUrl: 'https://www.enpleineconscience.ch/feed/podcast/mini-meditations-10',
      displayName: 'Mini-m\u00e9ditations 10+',
    ),
    MeditationFeed(
      feedUrl: 'https://www.enpleineconscience.ch/feed/podcast/suites',
      displayName: 'Suites m\u00e9ditatives',
    ),
    MeditationFeed(
      feedUrl: 'https://www.enpleineconscience.ch/feed/podcast/meditations-40-pour-le-chemin-meditatif',
      displayName: 'M\u00e9ditations 40+ pour le chemin m\u00e9ditatif',
    ),
    MeditationFeed(
      feedUrl: 'https://www.enpleineconscience.ch/feed/podcast/meditations-10-pour-le-chemin-meditatif',
      displayName: 'M\u00e9ditations 10+ pour le chemin m\u00e9ditatif',
    ),
    MeditationFeed(
      feedUrl: 'https://www.enpleineconscience.ch/feed/podcast/theme-de-la-semaine',
      displayName: 'Th\u00e8mes de la semaine pour "le chemin m\u00e9ditatif"',
    ),
  ];
}
