// Copyright 2020 Ben Hills and the project contributors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

class SettingsDividerLabel extends StatelessWidget {
  final String label;
  final EdgeInsetsGeometry padding;

  const SettingsDividerLabel({
    super.key,
    required this.label,
    this.padding = const EdgeInsets.fromLTRB(20.0, 28.0, 20.0, 4.0),
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Semantics(
        header: true,
        child: Text(
          // The section strings are shouted in every locale; the design uses sentence case.
          label.isEmpty ? label : label[0] + label.substring(1).toLowerCase(),
          style: Theme.of(context).textTheme.labelMedium!.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
        ),
      ),
    );
  }
}
