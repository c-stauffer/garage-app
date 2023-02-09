import 'package:flutter/material.dart';
import 'package:garage_app/global_config.dart';
import 'widgets/home_page.dart';

void main() {
  runApp(const GarageApp());
}

// TODO LIST:
// X add the debug widgets (door sensor states, last known state, whatever else)
// X toggle debug widgets based on setting value
// - add the code to actuate the door
//   - start timer based on setting val, re-query on tick.
//   - stop timer when door state is OPEN or CLOSED.
// X refactor widgets (if possible) into separate chunks to reduce complexity/duplication
// - create models for the data on each page
// - use Provider package for state management (instead of setState() calls)

class GarageApp extends StatefulWidget {
  const GarageApp({Key? key}) : super(key: key);

  @override
  State<GarageApp> createState() => _GarageAppState();
}

class _GarageAppState extends State<GarageApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Garage Door Utility',
      theme: ThemeData(
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
      ),
      themeMode: currentTheme.currentTheme(),
      home: const GarageAppRoot(title: 'Garage Door Control and Status'),
    );
  }

  @override
  void initState() {
    super.initState();
    currentTheme.addListener(() {
      setState(() {});
    });
  }
}

class GarageAppRoot extends StatefulWidget {
  const GarageAppRoot({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<GarageAppRoot> createState() => _GarageAppRootState();
}

class _GarageAppRootState extends State<GarageAppRoot> {
  @override
  Widget build(BuildContext context) {
    return GarageAppHomePage(title: widget.title);
  }
}
