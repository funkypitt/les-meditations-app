// Copyright 2020 Ben Hills and the project contributors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:anytime/bloc/settings/settings_bloc.dart';
import 'package:anytime/core/utils.dart';
import 'package:anytime/entities/app_settings.dart';
import 'package:anytime/l10n/L.dart';
import 'package:anytime/ui/settings/episode_refresh.dart';
import 'package:anytime/ui/settings/settings_section_label.dart';
import 'package:anytime/ui/settings/theme_select.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

/// Settings page — simplified for the meditation app.
/// Removed: OPML import/export, search provider selection.
class Settings extends StatefulWidget {
  const Settings({
    super.key,
  });

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool sdcard = false;

  Widget _buildList(BuildContext context) {
    var settingsBloc = Provider.of<SettingsBloc>(context);

    return StreamBuilder<AppSettings>(
        stream: settingsBloc.settings,
        initialData: settingsBloc.currentSettings,
        builder: (context, snapshot) {
          return ListView(
            children: [
              SettingsDividerLabel(label: L.of(context)!.settings_personalisation_divider_label),
              const ThemeSelectWidget(),
              SettingsDividerLabel(label: L.of(context)!.settings_episodes_divider_label),
              MergeSemantics(
                child: ListTile(
                    shape: const RoundedRectangleBorder(side: BorderSide.none),
                    title: Text(L.of(context)!.settings_delete_played_label),
                    trailing: Switch.adaptive(
                      value: snapshot.data!.deleteDownloadedPlayedEpisodes,
                      onChanged: (value) => setState(() => settingsBloc.deleteDownloadedPlayedEpisodes(value)),
                    )),
              ),
              sdcard
                  ? MergeSemantics(
                      child: ListTile(
                        title: Text(L.of(context)!.settings_download_sd_card_label),
                        trailing: Switch.adaptive(
                          value: snapshot.data!.storeDownloadsSDCard,
                          onChanged: (value) => sdcard
                              ? setState(() {
                                  settingsBloc.storeDownloadonSDCard(value);
                                })
                              : null,
                        ),
                      ),
                    )
                  : const SizedBox(
                      height: 0,
                      width: 0,
                    ),
              SettingsDividerLabel(label: L.of(context)!.settings_playback_divider_label),
              MergeSemantics(
                child: ListTile(
                  title: Text(L.of(context)!.settings_auto_open_now_playing),
                  trailing: Switch.adaptive(
                    value: snapshot.data!.autoOpenNowPlaying,
                    onChanged: (value) => setState(() => settingsBloc.setAutoOpenNowPlaying(value)),
                  ),
                ),
              ),
              SettingsDividerLabel(label: L.of(context)!.settings_podcast_management_divider_label),
              const EpisodeRefreshWidget(),
              MergeSemantics(
                child: ListTile(
                  title: Text(L.of(context)!.settings_background_refresh_option),
                  subtitle: Text(L.of(context)!.settings_background_refresh_option_subtitle),
                  trailing: Switch.adaptive(
                    value: snapshot.data!.backgroundUpdate,
                    onChanged: (value) => setState(() => settingsBloc.backgroundUpdates(value)),
                  ),
                ),
              ),
              MergeSemantics(
                child: ListTile(
                  title: Text(L.of(context)!.settings_background_refresh_mobile_data_option),
                  subtitle: Text(L.of(context)!.settings_background_refresh_mobile_data_option_subtitle),
                  trailing: Switch.adaptive(
                    value: snapshot.data!.backgroundUpdateMobileData,
                    onChanged: (value) => setState(() => settingsBloc.backgroundUpdatesMobileData(value)),
                  ),
                ),
              ),
            ],
          );
        });
  }

  Widget _buildAndroid(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: Theme.of(context).appBarTheme.systemOverlayStyle!,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          title: Text(
            L.of(context)!.settings_label,
          ),
        ),
        body: _buildList(context),
      ),
    );
  }

  Widget _buildIos(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        padding: const EdgeInsetsDirectional.all(0.0),
        leading: CupertinoButton(
            child: Icon(
              Icons.arrow_back_ios,
              semanticLabel: L.of(context)?.go_back_button_label,
            ),
            onPressed: () {
              Navigator.pop(context);
            }),
        middle: Text(
          L.of(context)!.settings_label,
          style: TextStyle(color: Theme.of(context).colorScheme.primary),
        ),
        backgroundColor: Theme.of(context).colorScheme.surface,
      ),
      child: Material(child: _buildList(context)),
    );
  }

  @override
  Widget build(context) {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return _buildAndroid(context);
      case TargetPlatform.iOS:
        return _buildIos(context);
      default:
        assert(false, 'Unexpected platform $defaultTargetPlatform');
        return _buildAndroid(context);
    }
  }

  @override
  void initState() {
    super.initState();

    hasExternalStorage().then((value) {
      setState(() {
        sdcard = value;
      });
    });
  }
}
