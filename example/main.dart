import 'package:flutter/material.dart';
import 'package:flutter_guitar_tabs/flutter_guitar_tabs.dart';

main() {
  runApp(MaterialApp(
    home: Scaffold(
      body: Center(
        child: TabWidget(
          name: 'Dm',
          tabs: ["x 0 0 2 3 1", "x 5 7 7 6 5", "10 12 12 10 10 10"],
          size: 2,
        ),
      ),
    ),
  ));
}
