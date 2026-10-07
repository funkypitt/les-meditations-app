// Copyright 2020 Ben Hills and the project contributors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:anytime/ui/themes.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

/// Displays a download button for an episode.
///
/// A bare icon at rest; while a download runs the icon is replaced by a
/// progress ring with the percentage inside.
class DownloadButton extends StatelessWidget {
  final String label;
  final String title;
  final IconData icon;
  final int percent;
  final VoidCallback onPressed;

  const DownloadButton({
    super.key,
    required this.label,
    required this.title,
    required this.icon,
    required this.percent,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final palette = Palette.of(context);
    final progress = percent.toDouble() / 100;
    final done = icon == Icons.download_done;

    return Semantics(
      label: '$label $title',
      child: InkWell(
        onTap: onPressed,
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: 44.0,
          height: 44.0,
          child: percent > 0
              ? CircularPercentIndicator(
                  radius: 20.0,
                  lineWidth: 2.0,
                  backgroundColor: palette.tintStrong,
                  progressColor: palette.accent,
                  animation: true,
                  animateFromLastPercent: true,
                  percent: progress,
                  center: Text(
                    '$percent',
                    style: Theme.of(context).textTheme.labelSmall!.copyWith(color: palette.ink),
                  ),
                )
              : Icon(
                  icon,
                  size: 24.0,
                  color: done ? palette.accent : palette.ink,
                ),
        ),
      ),
    );
  }
}
