// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import 'unit.dart';

const _padding = EdgeInsets.all(16.0);

/// [ConverterRoute] where users can input amounts to convert in one [Unit]
/// and retrieve the conversion in another [Unit] for a specific [Category].
///
/// While it is named ConverterRoute, a more apt name would be ConverterScreen,
/// because it is responsible for the UI at the route's destination.
class ConverterRoute extends StatefulWidget {
  /// Color for this [Category].
  final Color color;

  /// Units for this [Category].
  final List<Unit> units;

  /// This [ConverterRoute] requires the color and units to not be null.
  const ConverterRoute({
    @required this.color,
    @required this.units,
  })  : assert(color != null),
        assert(units != null);

  @override
  _ConverterRouteState createState() => _ConverterRouteState();
}

class _ConverterRouteState extends State<ConverterRoute> {
  double _input;
  Unit _fromItem;
  Unit _toItem;
  String _convertedValue = '';
  List<DropdownMenuItem<Unit>> _menuItems;

  // TODO: Determine whether you need to override anything, such as initState()

  // TODO: Add other helper functions. We've given you one, _format()

  /// Clean up conversion; trim trailing zeros, e.g. 5.500 -> 5.5, 10.0 -> 10
  String _format(double conversion) {
    var outputNum = conversion.toStringAsPrecision(7);
    if (outputNum.contains('.') && outputNum.endsWith('0')) {
      var i = outputNum.length - 1;
      while (outputNum[i] == '0') {
        i -= 1;
      }
      outputNum = outputNum.substring(0, i + 1);
    }
    if (outputNum.endsWith('.')) {
      return outputNum.substring(0, outputNum.length - 1);
    }
    return outputNum;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _setDefaults();
    _menuItems = _createDropdownMenuItems(widget.units);
  }

  void _setDefaults() {
    if (widget.units.length < 2) {
      return;
    }

    _fromItem = widget.units[0];
    _toItem = widget.units[1];
  }

  @override
  Widget build(BuildContext context) {
    // includes the input value, and 'from' unit [Dropdown].
    final input = Container(
        padding: _padding,
        child: Column(
          children: [
            _buildInputTextField('Input', _onInputChanged),
            _buildDropDown(_fromItem, widget.units, _onItemSelected)
          ],
        ));

    final arrows = RotatedBox(
      quarterTurns: 1,
      child: Icon(Icons.compare_arrows, size: 40),
    );

    final output = Container(
        padding: _padding,
        child: Column(
          children: [
            _buildOutputText('Output', _convertedValue),
            _buildDropDown(_toItem, widget.units, _onOutputItemChanged)
          ],
        ));

    // TODO: Create the 'output' group of widgets. This is a Column that
    // includes the output value, and 'to' unit [Dropdown].

    // TODO: Return the input, arrows, and output widgets, wrapped in a Column.

    // TODO: Delete the below placeholder code.
    final unitWidgets = widget.units.map((Unit unit) {
      return Container(
        color: widget.color,
        margin: EdgeInsets.all(8.0),
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Text(
              unit.name,
              style: Theme.of(context).textTheme.headline5,
            ),
            Text(
              'Conversion: ${unit.conversion}',
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ],
        ),
      );
    }).toList();

    final converter = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        input,
        arrows,
        output,
      ],
    );
    return Container(
      padding: _padding,
      child: converter,
    );

    return ListView(
      children: unitWidgets,
    );
  }

  TextField _buildInputTextField(String label, ValueChanged<String> onChanged) {
    return TextField(
      style: Theme.of(context).textTheme.headline4,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: Theme.of(context).textTheme.headline4,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
      ),
      keyboardType: TextInputType.number,
      onChanged: (text) {
        onChanged(text);
      },
    );
  }

  Widget _buildOutputText(String label, String text) {
    return Column(
      children: [
        InputDecorator(
          child: Text(
            text,
            style: Theme.of(context).textTheme.headline4,
          ),
          decoration: InputDecoration(
              labelText: label,
              labelStyle: Theme.of(context).textTheme.headline4,
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0))),
        ),
      ],
    );
  }

  void _onInputChanged(String text) {
    if (text == null || text.isEmpty) {
      return;
    }

    _input = double.tryParse(text);
    if (_input != null) {
      _updateConversion(_input);
    }
  }

  void _onItemSelected(Unit item) {
    setState(() {
      _fromItem = item;
      _updateConversion(_input);
    });
  }

  void _onOutputItemChanged(Unit unit) {
    setState(() {
      _toItem = unit;
      _updateConversion(_input);
    });
  }

  Widget _buildDropDown(
      Unit value, List<Unit> units, ValueChanged<Unit> onChanged) {
    return Container(
      margin: EdgeInsets.only(top: 16.0),
      padding: EdgeInsets.symmetric(vertical: 8.0),
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        border: Border.all(color: Colors.grey[500], width: 1.0),
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(canvasColor: Colors.grey[50]),
        child: DropdownButtonHideUnderline(
          child: ButtonTheme(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            alignedDropdown: true,
            child: _buildDropDownButton(value, units, onChanged),
          ),
        ),
      ),
    );
  }

  DropdownButton<Unit> _buildDropDownButton(
      Unit value, List<Unit> units, ValueChanged<Unit> onChanged) {
    return DropdownButton<Unit>(
      value: value,
      items: _menuItems,
      style: Theme.of(context).textTheme.headline6,
      onChanged: (item) {
        onChanged(item);
      },
    );
  }

  List<DropdownMenuItem<Unit>> _createDropdownMenuItems(List<Unit> units) {
    return units.map((Unit value) {
      return new DropdownMenuItem<Unit>(
        value: value,
        child: new Text(
          value.name,
          softWrap: true,
        ),
      );
    }).toList();
  }

  void _updateConversion(double value) {
    setState(() {
      _convertedValue =
          _format(value * (_fromItem.conversion / _toItem.conversion));
    });
  }
}
