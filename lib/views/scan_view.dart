import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:kazu_app/blocs/ble_bloc.dart';
import 'package:kazu_app/events/ble_event.dart';
import 'package:kazu_app/states/ble_state.dart';

import '../session_cubit.dart';

class ScanView extends StatelessWidget {
  ScanView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final sessionCubit = context.read<SessionCubit>();
    return BlocBuilder<BleBloc, BleState>(builder: (context, state) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Find devices"),
        ),
        body: SingleChildScrollView(
          child: Column(
              children: state.scanResults != null
                  ? [
                ...state.scanResults!.map((item) {
                  return ScanResultTile(
                    result: item,
                    onTap: () =>
                      state.state == DeviceConnectionState.disconnected
                        ? context.read<BleBloc>().add(
                          BleConnectRequest(
                            device: item,
                            user: sessionCubit.currentUser,
                          )
                        )
                        : context.read<BleBloc>().add(BleDisconnected()),
                  );
                }),
              ]
                  : []
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.search),
          onPressed: () => context.read<BleBloc>().add(BleScanRequest()),
        ),
      );
    });
  }
}

class ScanResultTile extends StatelessWidget {
  const ScanResultTile({Key? key, required this.result, this.onTap})
      : super(key: key);

  final DiscoveredDevice result;
  final VoidCallback? onTap;

  Widget _buildTitle(BuildContext context) {
    if (result.name.isNotEmpty) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            result.name,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            result.id.toString(),
            style: Theme.of(context).textTheme.caption,
          )
        ],
      );
    } else {
      return Text(result.id.toString());
    }
  }

  Widget _buildAdvRow(BuildContext context, String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(title, style: Theme.of(context).textTheme.caption),
          const SizedBox(
            width: 12.0,
          ),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context)
                  .textTheme
                  .caption
                  ?.apply(color: Colors.black),
              softWrap: true,
            ),
          ),
        ],
      ),
    );
  }

  String getNiceHexArray(List<int> bytes) {
    return '[${bytes.map((i) => i.toRadixString(16).padLeft(2, '0')).join(', ')}]'
        .toUpperCase();
  }

  String getNiceManufacturerData(Map<int, List<int>> data) {
    if (data.isEmpty) {
      return 'N/A';
    }
    List<String> res = [];
    data.forEach((id, bytes) {
      res.add(
          '${id.toRadixString(16).toUpperCase()}: ${getNiceHexArray(bytes)}');
    });
    return res.join(', ');
  }

  String getNiceServiceData(Map<String, List<int>> data) {
    if (data.isEmpty) {
      return 'N/A';
    }
    List<String> res = [];
    data.forEach((id, bytes) {
      res.add('${id.toUpperCase()}: ${getNiceHexArray(bytes)}');
    });
    return res.join(', ');
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BleBloc, BleState>(builder: (context, state) {
      return ExpansionTile(
        title: _buildTitle(context),
        leading: Text(result.rssi.toString()),
        trailing: ElevatedButton(
          child: (result.id == state.device?.id) && (state.state == DeviceConnectionState.connected)
          //child: context.read<BleBloc>().state.isConnected!
              ? const Text('DISCONNECT')
              : const Text('CONNECT'),
          onPressed: onTap,
        ),
        children: <Widget>[
          _buildAdvRow(
              context, 'Complete Local Name',
              result.name),
          _buildAdvRow(context, 'Tx Power Level',
              '${result.rssi}'),
          //_buildAdvRow(context, 'Manufacturer Data',
          //    getNiceManufacturerData(
          //        result.manufacturerData)),
          _buildAdvRow(
              context,
              'Service UUIDs',
              (result.serviceUuids.isNotEmpty)
                  ? result.serviceUuids.join(', ')
                  .toUpperCase()
                  : 'N/A'),
          //_buildAdvRow(context, 'Service Data',
          //    getNiceServiceData(result.serviceData)),
        ],
      );
    });
  }
}