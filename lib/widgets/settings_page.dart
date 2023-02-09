import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:garage_app/models/settings.dart';

class GarageAppSettingsPage extends StatefulWidget {
  const GarageAppSettingsPage(
      {Key? key, required this.title, required this.appSettings})
      : super(key: key);

  final String title;
  final GarageAppSettings appSettings;

  @override
  State<GarageAppSettingsPage> createState() => _GarageAppSettingsPageState();
}

class _GarageAppSettingsPageState extends State<GarageAppSettingsPage> {
  bool _debugCheckboxValue = false;

  bool _passwordVisible = false;
  final _storage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _debugCheckboxValue = widget.appSettings.showDebug ?? false;
  }

  Future<String> readStorage(String key) async {
    return await _storage.read(key: key) ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          automaticallyImplyLeading: true,
        ),
        body: SingleChildScrollView(
          child: Form(
              onWillPop: () async {
                widget.appSettings.showDebug = _debugCheckboxValue;
                return true;
              },
              child: Column(children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 10.0),
                  child: Text('Authentication'),
                ),
                Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextFormField(
                      enableInteractiveSelection: true,
                      initialValue: widget.appSettings.username,
                      autofocus: true,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        filled: true,
                        hintText: '',
                        labelText: 'Username',
                      ),
                      onChanged: (value) {
                        widget.appSettings.username = value;
                      },
                    )),
                Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextFormField(
                      initialValue: widget.appSettings.password,
                      decoration: InputDecoration(
                        filled: true,
                        labelText: 'Password',
                        suffixIcon: IconButton(
                          icon: Icon(
                            // Based on passwordVisible state choose the icon
                            _passwordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Theme.of(context).primaryColorDark,
                          ),
                          onPressed: () {
                            // Update the state i.e. toogle the state of passwordVisible variable
                            setState(() {
                              _passwordVisible = !_passwordVisible;
                            });
                          },
                        ),
                      ),
                      obscureText: !_passwordVisible,
                      onChanged: (value) {
                        widget.appSettings.password = value;
                      },
                    )),
                const Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text('Configuration'),
                ),
                Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: DropdownButtonFormField<String>(
                      items: const [
                        DropdownMenuItem(
                          child: Text('System'),
                          value: 'system',
                        ),
                        DropdownMenuItem(
                          child: Text('Light'),
                          value: 'light',
                        ),
                        DropdownMenuItem(child: Text('Dark'), value: 'dark'),
                      ],
                      value: widget.appSettings.themeMode.name,
                      decoration: const InputDecoration(
                        filled: true,
                        hintText: '',
                        labelText: 'App Theme',
                      ),
                      onChanged: (value) {
                        widget.appSettings.themeMode = ThemeMode.values
                            .firstWhere((tm) => tm.name == value);
                      },
                    )),
                Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: DropdownButtonFormField<String>(
                      items: const [
                        DropdownMenuItem(
                          child: Text('<Select>'),
                          value: '',
                          enabled: false,
                        ),
                        DropdownMenuItem(
                          child: Text('Fahrenheit'),
                          value: 'F',
                        ),
                        DropdownMenuItem(child: Text('Celsius'), value: 'C'),
                      ],
                      value: widget.appSettings.tempUnits,
                      decoration: const InputDecoration(
                        filled: true,
                        hintText: '',
                        labelText: 'Temperature Units',
                      ),
                      onChanged: (value) {
                        widget.appSettings.tempUnits = value;
                      },
                    )),
                Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      textAlign: TextAlign.end,
                      initialValue: widget
                          .appSettings.doorInactiveRefreshSeconds
                          .toString(),
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        filled: true,
                        hintText: '',
                        labelText: 'Data Refresh Interval (Door INACTIVE)',
                        suffixText: 's',
                      ),
                      onChanged: (value) {
                        widget.appSettings.doorInactiveRefreshSeconds =
                            int.tryParse(value);
                      },
                    )),
                Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      textAlign: TextAlign.end,
                      initialValue: widget.appSettings.doorActiveRefreshSeconds
                          .toString(),
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        filled: true,
                        hintText: '',
                        labelText: 'Data Refresh Interval (Door ACTIVE)',
                        suffixText: 's',
                      ),
                      onChanged: (value) {
                        widget.appSettings.doorActiveRefreshSeconds =
                            int.tryParse(value);
                      },
                    )),
                Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: StatefulBuilder(
                        builder: (BuildContext context, StateSetter setState) {
                      return CheckboxListTile(
                          title: const Text('Show additional debug info'),
                          value: _debugCheckboxValue,
                          onChanged: (value) {
                            setState(() {
                              _debugCheckboxValue = value ?? false;
                            });
                          });
                    })),
              ])),
        ));
  }
}
