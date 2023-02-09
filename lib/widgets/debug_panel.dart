import 'package:flutter/material.dart';

import '../models/microdata.dart';

class DebugPanel extends StatelessWidget {
  const DebugPanel({
    Key? key,
    required MicrocontrollerData? microData,
  })  : _microData = microData,
        super(key: key);

  final MicrocontrollerData? _microData;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Table(children: [
        const TableRow(children: [
          Text(
            'Debug info:',
            textAlign: TextAlign.left,
          ),
          Text(
            '',
          ),
          Text(
            '',
          ),
        ]),
        const TableRow(children: [
          Text(
            'Closed switch:',
            textAlign: TextAlign.center,
          ),
          Text(
            'Open switch:',
            textAlign: TextAlign.center,
          ),
          Text(
            'Last Known State:',
            textAlign: TextAlign.center,
          ),
        ]),
        TableRow(children: [
          Text(
            _microData?.closedSwitchStatus ?? '...',
            textAlign: TextAlign.center,
            //style: Theme.of(context).textTheme.headlineSmall,
            //style: Theme.of(context).textTheme.headline4,
          ),
          Text(
            _microData?.openSwitchStatus ?? '...',
            textAlign: TextAlign.center,
            //style: Theme.of(context).textTheme.headlineSmall,
          ),
          Text(
            _microData?.lastKnownDoorState ?? '...',
            textAlign: TextAlign.center,
            //style: Theme.of(context).textTheme.headlineSmall,
          ),
        ]),
      ]),
    ]);
  }
}
