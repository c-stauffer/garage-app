class MicrocontrollerData {
  final String? closedSwitchStatus;
  final String? openSwitchStatus;
  final String? heatIndex;
  final String? humidity;
  final String? lastKnownDoorState;
  final String? doorState;
  final String? temperature;
  Map<String, String?> get unitsTemperatures => {
        'C': temperature,
        'F': _ctof(temperature),
      };
  Map<String, String?> get unitsHeatindexes => {
        'C': heatIndex,
        'F': _ctof(heatIndex),
      };

  MicrocontrollerData(Map<String, dynamic> json)
      : closedSwitchStatus = json['closed'],
        openSwitchStatus = json['open'],
        heatIndex = json['heatindex'],
        humidity = json['humidity'],
        lastKnownDoorState = json['last'],
        doorState = json['state'],
        temperature = json['temperature'];

  String? _ctof(String? value) {
    if (value == null) return null;
    return (double.parse(value.toString()) * 9 / 5 + 32).toString();
  }

  // Not currently used... HeatIndex was coming back in F
  // from microcontroller due to the DHT library having units parameter
  // backwards, but that's been fixed in the micro's API.
  // String? _ftoc(String? value) {
  //   if (value == null) return null;
  //   return ((double.parse(value.toString()) - 32) * 5 / 9).toString();
  // }
}
