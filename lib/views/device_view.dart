import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:kazu_app/events/ble_event.dart';
import 'package:kazu_app/events/device_event.dart';
import 'package:kazu_app/models/ModelProvider.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../blocs/ble_bloc.dart';
import '../blocs/device_bloc.dart';
import '../cubit/home_navigator_cubit.dart';
import '../repositories/data_repository.dart';
import '../session_cubit.dart';
import '../states/ble_state.dart';
import '../states/device_state.dart';

class DeviceView extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  DeviceView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => DeviceBloc(
              user: context.read<SessionCubit>().currentUser,
              dataRepository: context.read<DataRepository>(),
              bleBloc: context.read<BleBloc>(),
            ),
        child: BlocListener<BleBloc, BleState>(
          bloc: BlocProvider.of<BleBloc>(context),
          listener: (context, state) {
            //if (state.state == DeviceConnectionState.connected) {
            //  bleConnected = true;
            //} else {
            //  bleConnected = false;
            //}
          },
          child:
              BlocBuilder<DeviceBloc, DeviceState>(builder: (context, state) {
            //child: BlocBuilder<DeviceBloc, DeviceState>(builder: (context, state) {
            if (state.device == null) {
              //if (state.device == null || bleConnected == false) {
              return Scaffold(
                appBar: AppBar(
                  title: const Text('Kazu'),
                ),
                body: _buildAddDeviceView(context),
              );
            }
            return Scaffold(
              appBar: AppBar(
                title: const Text('Kazu'),
              ),
              body: Column(
                children: [
                  _buildDeviceView(),
                  //_buildCartridgeView(),
                ],
              ),
            );
          }),
        ));
  }

  Widget _buildDeviceView() {
    return BlocBuilder<DeviceBloc, DeviceState>(builder: (context, state) {
      bool connected = context.read<BleBloc>().state.state == DeviceConnectionState.connected;
      return Card(
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _buildNameTile(connected),
            if (connected == false) _buildDisconnectedTile(),
            _buildVersionTile(),
            _buildDoseTile(),
            _buildTemperatureTile(),
            _buildLastSyncedTile(),
            if (connected == true) _buildDisconnectedButtonTile(),
            _buildDeleteButtonTile(),
          ],
        ),
      );
    });
  }

  Widget _buildLastSyncedTile() {
    return BlocBuilder<DeviceBloc, DeviceState>(builder: (context, state) {
      return ListTile(
        title: Text(DateTime.fromMillisecondsSinceEpoch(state.device!.lastSynced!.toSeconds() * 1000).toString()),
      );
    });
  }

  Widget _buildDisconnectedTile() {
    return BlocBuilder<DeviceBloc, DeviceState>(builder: (context, state)
    {
      return ListTile(
        tileColor: Colors.grey,
        title: const Center(
          child: Text(
            "Disconnected",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        trailing: IconButton(
          icon: const Icon(
            Icons.refresh,
            color: Colors.white,
          ),
          onPressed: () =>
              context.read<BleBloc>().add(
                  BleAttemptAutoConnect(user: context.read<DeviceBloc>().user)),
        ),
      );
    });
  }

  Widget _buildDisconnectedButtonTile() {
    return BlocBuilder<DeviceBloc, DeviceState>(builder: (context, state)
    {
      return ListTile(
        trailing: IconButton(
          alignment: Alignment.bottomLeft,
          icon: const Icon(
            MdiIcons.bluetoothOff,
            //color: Colors.red,
          ),
          onPressed: () => BlocProvider.of<BleBloc>(context).add(BleDisconnected()),
        ),
      );
    });
  }

  Widget _buildDeleteButtonTile() {
    return BlocBuilder<DeviceBloc, DeviceState>(builder: (context, state)
    {
      return ListTile(
        trailing: IconButton(
          alignment: Alignment.bottomLeft,
          icon: const Icon(
            Icons.delete,
            //color: Colors.red,
          ),
          onPressed: () => BlocProvider.of<BleBloc>(context).add(BleDelete()),
        ),
      );
    });
  }

  //Widget _buildTemperatureTile() {
  //  return BlocListener<DeviceBloc, DeviceState>(
  //    listener: (context, state) {
  //      final temperatureFormStatus = state.temperatureFormStatus;
  //      if (temperatureFormStatus is SubmissionFailed) {
  //        _showSnackBar(context, temperatureFormStatus.exception.toString());
  //      }
  //    },
  //    child: Form(
  //        key: _formKey,
  //        child: Padding(
  //          padding: const EdgeInsets.symmetric(horizontal: 40),
  //          child: BlocBuilder<DeviceBloc, DeviceState>(builder: (context, state) {
  //            return TextFormField(
  //              decoration: const InputDecoration(
  //                hintText: 'Temperature',
  //              ),
  //              validator: (value) => state.isValidTemperature ? null : 'Temperature invalid',
  //              onChanged: (value) => context.read<DeviceBloc>().add(
  //                DeviceTemperatureChanged(temperature: int.tryParse(value)),
  //              ),
  //              t
  //            );
  //          }),
  //      ),
  //    ),
  //  );


  Widget _buildTemperatureTile() {
    return BlocBuilder<DeviceBloc, DeviceState>(builder: (context, state) {
      return ListTile(
        leading: const Text("Temperature"),
        title: TextFormField(
          initialValue: state.device?.temperature.toString() ?? "0",
          onChanged: (value) => context.read<DeviceBloc>().add(
            DeviceTemperatureChanged(temperature: int.tryParse(value)),
          ),

          //state.device?.temperature.toString() ?? "0",
        ),
        trailing: IconButton(
          icon: const Icon(Icons.send),
          onPressed: () =>
              context.read<DeviceBloc>().add(
                DeviceTemperatureSubmitted(),
              ),
        ),
      );
    });
  }

  Widget _buildDoseTile() {
    return BlocBuilder<DeviceBloc, DeviceState>(builder: (context, state) {
      return ListTile(
        leading: const Text("Dose"),
        //title: Text(
        //  state.device?.dose.toString() ?? "0",
        //),
        title: TextFormField(
          initialValue: state.device?.dose.toString() ?? "0",
          onChanged: (value) => context.read<DeviceBloc>().add(
                DeviceDoseChanged(dose: int.tryParse(value)),
              ),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.send),
          onPressed: () => context.read<DeviceBloc>().add(
                DeviceDoseSubmitted(),
              ),
        ),
      );
    });
  }

  Widget _buildCartridgeView() {
    return BlocBuilder<DeviceBloc, DeviceState>(builder: (context, state) {
      return Card(
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _buildCartridgeNameTile(),
            _buildDoseNumberTile(),
            _buildPositionTile(),
          ],
        )
      );
    });
  }

  Widget _buildDoseNumberTile() {
    return BlocBuilder<DeviceBloc, DeviceState>(builder: (context, state) {
      return ListTile(
        leading: const Text("Dose Number:"),
        title: Text(state.cartridge?.doseNumber.toString() ?? "0"),
      );
    });
  }

  Widget _buildPositionTile() {
    return BlocBuilder<DeviceBloc, DeviceState>(builder: (context, state) {
      return ListTile(
        leading: const Text("Position:"),
        title: Text(state.cartridge?.position.toString() ?? "0"),
      );
    });
  }

  Widget _buildCartridgeNameTile() {
    return BlocBuilder<DeviceBloc, DeviceState>(builder: (context, state) {
      String _productId = _getProductString(state.cartridge?.productId as ProductId);
      String _cartridgeType = _getCartridgeTypeString(state.cartridge?.type as CartridgeType);

      return ListTile(
        title: Center(
          child: Text(state.cartridge?.cartridgeId ?? "Cartridge"),
        ),
        subtitle: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(_productId),
            Text(_cartridgeType),
          ],
        ),

      );
    });
  }

  String _getCartridgeTypeString(CartridgeType cartridgeType) {
    String _cartridgeTypeString = "";
    switch (cartridgeType) {
      case CartridgeType.VAPOR:
        _cartridgeTypeString = "Vapor";
        break;
      case CartridgeType.ORAL:
        _cartridgeTypeString = "Oral";
        break;
      default:
        _cartridgeTypeString = "Unknown";
        break;
    }
    return _cartridgeTypeString;
  }

  String _getProductString(ProductId productId) {
    String _productString = "";
    switch (productId) {
      case ProductId.KAZU:
        _productString = "Kazu";
        break;
      case ProductId.PERRIGO:
        _productString = "Perrigo";
        break;
      default:
        _productString = "Unknown";
        break;
    }

    return _productString;
  }

  Widget _buildNameTile(bool connected) {
    return BlocBuilder<DeviceBloc, DeviceState>(builder: (context, state) {
      String _name = state.device?.bleName ?? "BT Name";
      String _deviceId = state.device?.deviceId ?? "Device ID";
      String _productId = "Kazu"; //_getProductString(state.device?.productId as ProductId);
      int _batteryLevel = state.device?.batteryLevel ?? 0;
      Icon _batteryIcon = const Icon(Icons.battery_full);
      if (_batteryLevel >= 3900) {
        _batteryIcon = const Icon(
          MdiIcons.battery,
          color: Colors.green,
        );
      } else if (_batteryLevel < 3900 && _batteryLevel > 3300) {
        _batteryIcon = const Icon(
          MdiIcons.battery50,
          color: Colors.amber,
        );
      } else {
        _batteryIcon = const Icon(
          MdiIcons.battery10,
          color: Colors.red,
        );
      }
      if (connected == false) {
        _batteryIcon = const Icon(
          MdiIcons.batteryUnknown,
          color: Colors.grey,
        );
      }

      return ListTile(
        //leading: const Icon(Icons.lock_outline),
        leading: IconButton(
          icon: (state.device?.lockStatus == DeviceLockStatus.LOCKED)
              ? const Icon(Icons.lock, color: Colors.black)
              : const Icon(Icons.lock_open, color: Colors.grey),
          onPressed: () => context.read<DeviceBloc>().add(
                DeviceLockSubmitted(lock: !state.lock),
              ),
        ),
        title: Center(child: Text(_name)),
        trailing: _batteryIcon,
        subtitle: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(_deviceId),
            Text(_productId),
          ],
        ),
      );
    });
  }

  Widget _buildVersionTile() {
    return BlocBuilder<DeviceBloc, DeviceState>(builder: (context, state) {
      int? _firmwareInt = state.device?.firmwareVersion?.toInt();
      String _firmwareVersion = "";
      if (_firmwareInt != null) {
        int year = (_firmwareInt >> 24) & 0xFF;
        int month = (_firmwareInt >> 20) & 0x0F;
        int product = (_firmwareInt >> 12) & 0xFF;
        int rev = _firmwareInt & 0xFF;
        _firmwareVersion = year.toString() + "." + month.toString() + "." + product.toString() + "." + rev.toString();
      }
      String _imageLibraryVersion = state.device?.imageLibraryVersion?.toRadixString(16).replaceAllMapped(RegExp(r".{2}"), (match) => "${match.group(0)}.") ?? "22.00.00";
      return ListTile(
        leading: Text("Firmware: " + _firmwareVersion),
          trailing: Text("Image Library: " + _imageLibraryVersion),
      );
    });
  }

  Widget _buildAddDeviceView(BuildContext context) {
    return ListTile(
      title: Column(
        children: [
          IconButton(
            icon: const Icon(Icons.add_circle),
            onPressed: () =>
                BlocProvider.of<HomeNavigatorCubit>(context).showScan(),
          ),
          const Text("Add Device"),
        ],
      ),
    );
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}