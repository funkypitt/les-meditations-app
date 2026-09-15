// Copyright 2020 Ben Hills and the project contributors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:anytime/ui/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

/// The play control shown on each episode row: a soft disc that turns burgundy
/// while the episode is the one playing.
class PlayPauseButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final String title;

  const PlayPauseButton({
    super.key,
    required this.icon,
    required this.label,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final palette = Palette.of(context);
    final active = icon == Icons.pause;

    return Semantics(
      label: '$label $title',
      child: Container(
        width: 44.0,
        height: 44.0,
        decoration: BoxDecoration(
          color: active ? palette.accent : palette.tint,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          size: 24.0,
          color: active ? palette.onAccent : palette.ink,
        ),
      ),
    );
  }
}

class PlayPauseBusyButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final String title;

  const PlayPauseBusyButton({
    super.key,
    required this.icon,
    required this.label,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final palette = Palette.of(context);

    return Semantics(
      label: '$label $title',
      child: SizedBox(
        width: 44.0,
        height: 44.0,
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(color: palette.tint, shape: BoxShape.circle),
            ),
            Icon(icon, size: 24.0, color: palette.ink),
            SpinKitRing(
              lineWidth: 2.0,
              color: palette.accent,
              size: 44.0,
            ),
          ],
        ),
      ),
    );
  }
}
