import 'dart:async';
import 'dart:convert' as convert;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:garage_app/models/microdata.dart';
import 'package:garage_app/models/settings.dart';
import 'package:http/http.dart' as http;

import 'debug_panel.dart';
import 'settings_page.dart';

class GarageAppHomePage extends StatefulWidget {
  const GarageAppHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  //final GarageAppSettings appSettings;

  @override
  State<GarageAppHomePage> createState() => _GarageAppHomePageState();
}

class _GarageAppHomePageState extends State<GarageAppHomePage> {
  final GarageAppSettings _appSettings = GarageAppSettings();
  MicrocontrollerData? _microData;
  DateTime lastRefresh = DateTime.now();
  String _activateButtonText = 'Activate Door';
  String? _doorStateAtActuation;
  Timer? _doorActivateTimer;

  @override
  void initState() {
    super.initState();
    loadSettings();
  }

  Future<void> loadSettings() async {
    await _appSettings.init();
    getMicroData();
  }

  Future<http.Response> sendRequest(String uri) {
    var url = Uri.https('garage.crogge.rs', uri);
    var basicAuth = 'Basic ' +
        convert.base64.encode(convert.utf8
            .encode('${_appSettings.username}:${_appSettings.password}'));
    return http.get(url, headers: <String, String>{'authorization': basicAuth});
  }

  void handleTimerTick() {
    if (kDebugMode) {
      print('Tick...');
    }
    getMicroData().then((rsp) {
      if (_microData?.doorState != _doorStateAtActuation &&
          (_microData?.doorState == 'OPEN' ||
              _microData?.doorState == 'CLOSED')) {
        _doorActivateTimer?.cancel();
        _activateButtonText = 'Activate Door';
        _doorStateAtActuation = _microData?.doorState;
      }
    });
  }

  void activateDoor() {
    setState(() {
      _doorStateAtActuation = _microData?.doorState;
      _activateButtonText = 'Door Active...';
    });
    // send the activate request
    if (kDebugMode) {
      print('Activating Door!');
    }
    sendRequest('/actuate');
    // start timer to get state updates
    _doorActivateTimer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        setState(() {
          handleTimerTick();
        });
      },
    );
  }

  String? roundNumericString(String? val, int decimalPlaces) {
    if (val == null) return null;
    var numericVal = double.tryParse(val);
    if (numericVal == null) return null;
    return numericVal.toStringAsFixed(decimalPlaces);
  }

  Future<void> getMicroData() async {
    if ((_appSettings.username?.isEmpty ?? true) ||
        (_appSettings.password?.isEmpty ?? true)) {
      return;
    } else {
      sendRequest('/all').then((rsp) {
        if (rsp.statusCode == 200) {
          setState(() {
            _microData = MicrocontrollerData(
                convert.jsonDecode(rsp.body) as Map<String, dynamic>);
            lastRefresh = DateTime.now();
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.settings,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => GarageAppSettingsPage(
                        title: 'Settings', appSettings: _appSettings)),
              ).then((val) {
                getMicroData();
              });
            },
          )
        ],
      ),
      body: RefreshIndicator(
          onRefresh: getMicroData,
          child: Stack(children: <Widget>[
            ListView(),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.all(10),
                    child: Table(children: [
                      const TableRow(children: [
                        Text(
                          'Temperature:',
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          'Humidity:',
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          'Heat Index:',
                          textAlign: TextAlign.center,
                        ),
                      ]),
                      TableRow(children: [
                        Text(
                          '${roundNumericString(_microData?.unitsTemperatures[_appSettings.tempUnits], 0) ?? '...'}°',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        Text(
                          '${roundNumericString(_microData?.humidity, 0) ?? '...'}%',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        Text(
                          '${roundNumericString(_microData?.unitsHeatindexes[_appSettings.tempUnits], 0) ?? '...'}°',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                      ]),
                    ]),
                  ),
                  Container(
                    margin: const EdgeInsets.all(40),
                    child: Column(children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            minimumSize: const Size.fromHeight(80)),
                        onPressed: () {
                          activateDoor();
                        },
                        child: Text(
                          _activateButtonText,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),
                    ]),
                  ),
                  const Text('Door status: '),
                  Text(
                    _microData?.doorState ?? '...',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  // ===== DEBUG STUFF =====
                  Container(
                    margin: const EdgeInsets.fromLTRB(10, 50, 10, 10),
                    child: _appSettings.showDebug ?? false
                        ? DebugPanel(microData: _microData)
                        : null,
                  ),
                  // ===== END DEBUG STUFF =====
                  Expanded(
                      child: Align(
                          alignment: FractionalOffset.bottomLeft,
                          child: Container(
                              margin: const EdgeInsets.all(10.0),
                              child: Text(
                                  ' Last Refreshed: ${lastRefresh.toString().substring(0, 19)}',
                                  style:
                                      Theme.of(context).textTheme.bodySmall)))),
                ],
              ),
            ),
          ])),
    );
  }
}
