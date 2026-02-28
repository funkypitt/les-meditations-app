// Copyright 2020 Ben Hills and the project contributors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:anytime/api/podcast/mobile_podcast_api.dart';
import 'package:anytime/api/podcast/podcast_api.dart';
import 'package:anytime/bloc/discovery/discovery_bloc.dart';
import 'package:anytime/bloc/podcast/audio_bloc.dart';
import 'package:anytime/bloc/podcast/episode_bloc.dart';
import 'package:anytime/bloc/podcast/podcast_bloc.dart';
import 'package:anytime/bloc/podcast/queue_bloc.dart';
import 'package:anytime/bloc/search/search_bloc.dart';
import 'package:anytime/bloc/settings/settings_bloc.dart';
import 'package:anytime/bloc/ui/pager_bloc.dart';
import 'package:anytime/core/environment.dart';
import 'package:anytime/core/meditation_catalog.dart';
import 'package:anytime/entities/feed.dart';
import 'package:anytime/entities/podcast.dart';
import 'package:anytime/l10n/L.dart';
import 'package:anytime/navigation/navigation_route_observer.dart';
import 'package:anytime/repository/repository.dart';
import 'package:anytime/repository/sembast/sembast_repository.dart';
import 'package:anytime/services/audio/audio_player_service.dart';
import 'package:anytime/services/audio/default_audio_player_service.dart';
import 'package:anytime/services/download/download_service.dart';
import 'package:anytime/services/download/mobile_download_manager.dart';
import 'package:anytime/services/download/mobile_download_service.dart';
import 'package:anytime/services/notifications/mobile_notification_service.dart';
import 'package:anytime/services/notifications/notification_service.dart';
import 'package:anytime/services/podcast/mobile_podcast_service.dart';
import 'package:anytime/services/podcast/podcast_service.dart';
import 'package:anytime/services/settings/mobile_settings_service.dart';
import 'package:anytime/state/library_state.dart';
import 'package:anytime/ui/library/discovery.dart';
import 'package:anytime/ui/library/downloads.dart';
import 'package:anytime/ui/podcast/mini_player.dart';
import 'package:anytime/ui/podcast/podcast_details.dart';
import 'package:anytime/ui/podcast/up_next_view.dart';
import 'package:anytime/ui/settings/settings.dart';
import 'package:anytime/ui/themes.dart';
import 'package:anytime/ui/widgets/layout_selector.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart' show SchedulerBinding;
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';

import '../services/settings/settings_service.dart';

/// En Pleine Conscience — Meditation app built on Anytime Podcast Player.
// ignore: must_be_immutable
class AnytimePodcastApp extends StatefulWidget {
  final Repository repository;
  late PodcastApi podcastApi;
  late DownloadService downloadService;
  late NotificationService notificationService;
  late AudioPlayerService audioPlayerService;
  PodcastService? podcastService;
  SettingsBloc? settingsBloc;
  MobileSettingsService mobileSettingsService;
  List<int> certificateAuthorityBytes;

  AnytimePodcastApp({
    super.key,
    required this.mobileSettingsService,
    required this.certificateAuthorityBytes,
  }) : repository = SembastRepository() {
    podcastApi = MobilePodcastApi();
    notificationService = MobileNotificationService();

    podcastService = MobilePodcastService(
      api: podcastApi,
      repository: repository,
      notificationService: notificationService,
      settingsService: mobileSettingsService,
    );

    assert(podcastService != null);

    downloadService = MobileDownloadService(
      repository: repository,
      downloadManager: MobileDownloaderManager(),
      podcastService: podcastService!,
    );

    audioPlayerService = DefaultAudioPlayerService(
      repository: repository,
      settingsService: mobileSettingsService,
      podcastService: podcastService!,
    );

    settingsBloc = SettingsBloc(
      settingsService: mobileSettingsService,
      notificationService: notificationService,
    );

    podcastApi.addClientAuthorityBytes(certificateAuthorityBytes);
  }

  @override
  AnytimePodcastAppState createState() => AnytimePodcastAppState();
}

class AnytimePodcastAppState extends State<AnytimePodcastApp> {
  ThemeData? theme = Themes.lightTheme().themeData;

  @override
  void initState() {
    super.initState();

    widget.settingsBloc!.settings.listen((event) {
      setState(() {
        var newTheme = Themes.darkTheme().themeData;

        switch (event.theme) {
          case 'system':
            var brightness = SchedulerBinding.instance.platformDispatcher.platformBrightness;
            newTheme = brightness == Brightness.dark ? Themes.darkTheme().themeData : Themes.lightTheme().themeData;
            break;
          case 'light':
            newTheme = Themes.lightTheme().themeData;
            break;
          case 'dark':
            newTheme = Themes.darkTheme().themeData;
            break;
        }

        if (newTheme != theme) {
          theme = newTheme;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<SearchBloc>(
          create: (_) => SearchBloc(
            podcastService: widget.podcastService!,
          ),
          dispose: (_, value) => value.dispose(),
        ),
        Provider<DiscoveryBloc>(
          create: (_) => DiscoveryBloc(
            podcastService: widget.podcastService!,
          ),
          dispose: (_, value) => value.dispose(),
        ),
        Provider<EpisodeBloc>(
          create: (_) =>
              EpisodeBloc(podcastService: widget.podcastService!, audioPlayerService: widget.audioPlayerService),
          dispose: (_, value) => value.dispose(),
        ),
        Provider<PodcastBloc>(
          create: (_) => PodcastBloc(
              podcastService: widget.podcastService!,
              audioPlayerService: widget.audioPlayerService,
              downloadService: widget.downloadService,
              notificationService: widget.notificationService,
              settingsService: widget.mobileSettingsService),
          dispose: (_, value) => value.dispose(),
        ),
        Provider<PagerBloc>(
          create: (_) => PagerBloc(),
          dispose: (_, value) => value.dispose(),
        ),
        Provider<AudioBloc>(
          create: (_) => AudioBloc(audioPlayerService: widget.audioPlayerService),
          dispose: (_, value) => value.dispose(),
        ),
        Provider<SettingsBloc?>(
          create: (_) => widget.settingsBloc,
          dispose: (_, value) => value!.dispose(),
        ),
        Provider<QueueBloc>(
          create: (_) => QueueBloc(
            audioPlayerService: widget.audioPlayerService,
            podcastService: widget.podcastService!,
          ),
          dispose: (_, value) => value.dispose(),
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        showSemanticsDebugger: false,
        title: 'les méditations',
        navigatorObservers: [NavigationRouteObserver()],
        localizationsDelegates: const <LocalizationsDelegate<Object>>[
          AnytimeLocalisationsDelegate(),
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en', ''),
          Locale('fr', ''),
          Locale('es', ''),
          Locale('de', ''),
          Locale('gl', ''),
          Locale('it', ''),
          Locale('nl', ''),
          Locale('ru', ''),
          Locale('tr', ''),
          Locale('vi', ''),
          Locale('zh_Hans', ''),
        ],
        theme: theme,
        home: const AnytimeHomePage(title: 'enpleineconscience.ch'),
      ),
    );
  }
}

class AnytimeHomePage extends StatefulWidget {
  final String? title;
  final bool topBarVisible;

  const AnytimeHomePage({
    super.key,
    this.title,
    this.topBarVisible = true,
  });

  @override
  State<AnytimeHomePage> createState() => _AnytimeHomePageState();
}

class _AnytimeHomePageState extends State<AnytimeHomePage> with WidgetsBindingObserver {
  final log = Logger('_AnytimeHomePageState');
  bool libraryRefreshing = false;
  Widget? library;
  bool _autoSubscribeTriggered = false;

  @override
  void initState() {
    super.initState();

    final audioBloc = Provider.of<AudioBloc>(context, listen: false);
    final podcastBloc = Provider.of<PodcastBloc>(context, listen: false);

    WidgetsBinding.instance.addObserver(this);

    audioBloc.transitionLifecycleState(LifecycleState.resume);
    podcastBloc.transitionLifecycleState(LifecycleState.resume);

    Provider.of<PodcastBloc>(context, listen: false).libraryListener.listen((d) {
      setState(() {
        libraryRefreshing = (d is LibraryRefreshingState);
      });
    });

    // Auto-subscribe to all meditation catalog feeds on first launch
    _autoSubscribeToCatalog();
  }

  /// On first launch (no subscriptions), automatically subscribe to all
  /// meditation feeds from the catalog and set appropriate sort order.
  Future<void> _autoSubscribeToCatalog() async {
    if (_autoSubscribeTriggered) return;
    _autoSubscribeTriggered = true;

    final podcastService =
        Provider.of<PodcastBloc>(context, listen: false).podcastService;

    final subs = await podcastService.subscriptions();
    if (subs.isNotEmpty) return;

    log.info('First launch detected — subscribing to meditation catalog');

    for (final feed in MeditationCatalog.feeds) {
      try {
        final podcast = Podcast.fromUrl(url: feed.feedUrl);
        final loaded = await podcastService.loadPodcast(podcast: podcast);

        if (loaded != null) {
          // Set sort order: oldest first for all except les-causeries
          loaded.sort = feed.oldestFirst
              ? PodcastEpisodeSort.earliestFirst
              : PodcastEpisodeSort.latestFirst;
          await podcastService.subscribe(loaded);
          log.fine('Subscribed to: ${loaded.title}');
        }
      } catch (e) {
        log.warning('Failed to subscribe to ${feed.displayName}: $e');
      }
    }

    // Reload subscriptions in the UI
    final podcastBloc = Provider.of<PodcastBloc>(context, listen: false);
    podcastBloc.podcastEvent(PodcastEvent.reloadSubscriptions);
  }

  @override
  void dispose() {
    final audioBloc = Provider.of<AudioBloc>(context, listen: false);
    final podcastBloc = Provider.of<PodcastBloc>(context, listen: false);

    audioBloc.transitionLifecycleState(LifecycleState.detach);
    podcastBloc.transitionLifecycleState(LifecycleState.detach);

    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    final audioBloc = Provider.of<AudioBloc>(context, listen: false);
    final podcastBloc = Provider.of<PodcastBloc>(context, listen: false);
    var settingsBloc = Provider.of<SettingsBloc>(context, listen: false);

    switch (state) {
      case AppLifecycleState.resumed:
        audioBloc.transitionLifecycleState(LifecycleState.resume);
        podcastBloc.transitionLifecycleState(LifecycleState.resume);
        if (context.mounted) {
          SettingsService? settings = await MobileSettingsService.instance();
          settingsBloc.theme(settings!.theme);
        }
        break;
      case AppLifecycleState.paused:
        audioBloc.transitionLifecycleState(LifecycleState.pause);
        podcastBloc.transitionLifecycleState(LifecycleState.pause);
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    try {
    final theme = Theme.of(context);
    final pager = Provider.of<PagerBloc>(context);
    final searchBloc = Provider.of<EpisodeBloc>(context);
    final backgroundColour = Theme.of(context).scaffoldBackgroundColor;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: theme.appBarTheme.systemOverlayStyle ?? SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: backgroundColour,
        body: Column(
          children: <Widget>[
            Expanded(
              child: CustomScrollView(
                slivers: <Widget>[
                  SliverVisibility(
                    visible: widget.topBarVisible,
                    sliver: SliverAppBar(
                      title: ExcludeSemantics(
                        child: Image.asset(
                          'assets/images/meditation-logo.png',
                          height: 42,
                        ),
                      ),
                      centerTitle: true,
                      backgroundColor: backgroundColour,
                      floating: false,
                      pinned: true,
                      snap: false,
                      actions: <Widget>[
                        PopupMenuButton<String>(
                          onSelected: _menuSelect,
                          icon: const Icon(
                            Icons.more_vert,
                          ),
                          itemBuilder: (BuildContext context) {
                            return <PopupMenuEntry<String>>[
                              PopupMenuItem<String>(
                                textStyle: theme.textTheme.titleMedium,
                                value: 'settings',
                                child: Row(
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.only(right: 8.0),
                                      child: Icon(Icons.settings, size: 18.0),
                                    ),
                                    Text(L.of(context)!.settings_label),
                                  ],
                                ),
                              ),
                              PopupMenuItem<String>(
                                textStyle: theme.textTheme.titleMedium,
                                value: 'about',
                                child: Row(
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.only(right: 8.0),
                                      child: Icon(Icons.info_outline, size: 18.0),
                                    ),
                                    Text(L.of(context)!.about_label),
                                  ],
                                ),
                              ),
                            ];
                          },
                        ),
                      ],
                    ),
                  ),
                  StreamBuilder<int>(
                      stream: pager.currentPage,
                      builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
                        return _fragment(snapshot.data, searchBloc);
                      }),
                ],
              ),
            ),
            const MiniPlayer(),
          ],
        ),
        bottomNavigationBar: StreamBuilder<int>(
            stream: pager.currentPage,
            initialData: 0,
            builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
              int index = snapshot.data ?? 0;

              return BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                backgroundColor: theme.bottomAppBarTheme.color,
                selectedIconTheme: theme.iconTheme,
                selectedItemColor: theme.iconTheme.color,
                selectedFontSize: 11.0,
                unselectedFontSize: 11.0,
                unselectedItemColor:
                    HSLColor.fromColor(theme.bottomAppBarTheme.color ?? const Color(0xFFFFF8F5)).withLightness(0.8).toColor(),
                currentIndex: index,
                onTap: pager.changePage,
                items: <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                    icon: index == 0 ? const Icon(Icons.self_improvement) : const Icon(Icons.self_improvement_outlined),
                    label: 'Méditations',
                  ),
                  BottomNavigationBarItem(
                    icon: index == 1 ? const Icon(Icons.download) : const Icon(Icons.download_outlined),
                    label: L.of(context)?.downloads ?? 'Téléchargements',
                  ),
                ],
              );
            }),
      ),
    );
    } catch (e, stack) {
      return Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Text(
              'BUILD ERROR:\n\n$e\n\n$stack',
              style: const TextStyle(fontSize: 11, color: Colors.red),
            ),
          ),
        ),
      );
    }
  }

  Widget _fragment(int? index, EpisodeBloc searchBloc) {
    if (index == 0) {
      return const Discovery();
    } else {
      return const Downloads();
    }
  }

  void _menuSelect(String choice) async {
    var podcastBloc = Provider.of<PodcastBloc>(context, listen: false);
    final theme = Theme.of(context);

    switch (choice) {
      case 'about':
        showAboutDialog(
            context: context,
            applicationName: 'les méditations',
            applicationVersion: 'v${Environment.projectVersion}',
            applicationIcon: Image.asset(
              'assets/images/meditation-logo.png',
              width: 52.0,
              height: 52.0,
            ),
            children: <Widget>[
              const Text('enpleineconscience.ch — Méditations guidées'),
            ]);
        break;
      case 'settings':
        await Navigator.push(
          context,
          MaterialPageRoute<void>(
            fullscreenDialog: true,
            settings: const RouteSettings(name: 'settings'),
            builder: (context) => const Settings(),
          ),
        );
        break;
      case 'layout':
        await showModalBottomSheet<void>(
          context: context,
          backgroundColor: theme.secondaryHeaderColor,
          barrierLabel: L.of(context)!.scrim_layout_selector,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16.0),
              topRight: Radius.circular(16.0),
            ),
          ),
          builder: (context) => const LayoutSelectorWidget(),
        );
        break;
      case 'library':
        _updateLibrary();
        break;
    }
  }

  void _updateLibrary() async {
    var podcastBloc = Provider.of<PodcastBloc>(context, listen: false);
    podcastBloc.podcastEvent(PodcastEvent.refreshSubscriptions);
  }
}

class TitleWidget extends StatelessWidget {
  const TitleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    const baseStyle = TextStyle(
      fontWeight: FontWeight.bold,
      fontFamily: 'MontserratRegular',
      fontSize: 18,
    );

    return Padding(
      padding: const EdgeInsets.only(left: 2.0),
      child: Row(
        children: <Widget>[
          Text(
            'enpleineconscience',
            style: baseStyle.copyWith(color: const Color(0xFF7B5B5B)),
          ),
          Text(
            '.ch',
            style: baseStyle.copyWith(color: isDark ? Colors.white : Colors.black),
          ),
        ],
      ),
    );
  }
}
