// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:task_03_category_route/category.dart';

final _backgroundColor = Colors.grey;

/// Category Route (screen).
///
/// This is the 'home' screen of the Unit Converter. It shows a header and
/// a list of [Categories].
///
/// While it is named CategoryRoute, a more apt name would be CategoryScreen,
/// because it is responsible for the UI at the route's destination.
class CategoryRoute extends StatelessWidget {
  const CategoryRoute();

  static const _categoryNames = <String>[
    'Length',
    'Area',
    'Volume',
    'Mass',
    'Time',
    'Digital Storage',
    'Energy',
    'Currency',
  ];

  static const _baseColors = <Color>[
    Colors.teal,
    Colors.orange,
    Colors.pinkAccent,
    Colors.blueAccent,
    Colors.yellow,
    Colors.greenAccent,
    Colors.purpleAccent,
    Colors.red,
  ];

  @override
  Widget build(BuildContext context) {
    // from above. Use a placeholder icon, such as `Icons.cake` for each
    // Category. We'll add custom icons later.
    final categories = <Widget>[];
    for (var i = 0; i < _categoryNames.length; i++) {
      categories
          .add(new Category(_categoryNames[i], _baseColors[i], Icons.cake));
    }

    final listView = _buildList(categories);
    final appBar = AppBar(
        backgroundColor: _backgroundColor,
        centerTitle: true,
        title: Text(
          'Unit Converter',
          style: TextStyle(
            color: Colors.black,
            fontSize: 30.0,
          ),
        ));

    return Scaffold(
      appBar: appBar,
      body: listView,
    );
  }

  Widget _buildList(List<Widget> categories) {
    return Container(
      color: _backgroundColor,
      child: ListView.separated(
          padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
          separatorBuilder: (context, index) => Divider(
                color: _backgroundColor,
              ),
          itemCount: categories.length,
          itemBuilder: (BuildContext context, int index) => categories[index]),
    );
  }
}
