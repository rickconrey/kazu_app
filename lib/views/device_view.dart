import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kazu_app/events/device_event.dart';
import 'package:kazu_app/generated/control.pb.dart';
import 'package:kazu_app/models/ModelProvider.dart';

import '../blocs/ble_bloc.dart';
import '../blocs/device_bloc.dart';
import '../cubit/home_navigator_cubit.dart';
import '../repositories/data_repository.dart';
import '../session_cubit.dart';
import '../states/ble_state.dart';
import '../states/device_state.dart';

class DeviceView extends StatelessWidget {

  DeviceView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return BlocProvider(
      create: (context) => DeviceBloc(
        user: context.read<SessionCubit>().currentUser,
        dataRepository: context.read<DataRepository>(),
    ),
    child: BlocListener<DeviceBloc, DeviceState>(
        listener: (context, state) {

        },
        child: BlocBuilder<DeviceBloc, DeviceState>(builder: (context, state) {
          final bleConnected = context.select((BleBloc bloc) => bloc.state.isConnected);
          if (state.device == null || bleConnected == false) {
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
      )
    );
  }

  Widget _buildDeviceView() {
    return BlocBuilder<DeviceBloc, DeviceState>(builder: (context, state) {
      return Card(
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _buildNameTile(),
            _buildVersionTile(),
            _buildDoseTile(),
            _buildTemperatureTile(),
          ],
        ),
      );
    });
  }

  Widget _buildTemperatureTile() {
    return BlocBuilder<DeviceBloc, DeviceState>(builder: (context, state) {
      return ListTile(
        leading: const Text("Temperature"),
        title: Text(
          state.device?.temperature.toString() ?? "0",
        ),
        trailing: IconButton(
          icon: const Icon(Icons.send),
          onPressed: () =>
              BlocProvider.of<HomeNavigatorCubit>(context).showScan(),
        ),
      );
    });
  }

  Widget _buildDoseTile() {
    return BlocBuilder<DeviceBloc, DeviceState>(builder: (context, state) {
      return ListTile(
        leading: const Text("Dose"),
        title: Text(
          state.device?.dose.toString() ?? "0",
        ),
        trailing: IconButton(
          icon: const Icon(Icons.send),
          onPressed: () =>
              BlocProvider.of<HomeNavigatorCubit>(context).showScan(),
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

  Widget _buildNameTile() {
    return BlocBuilder<DeviceBloc, DeviceState>(builder: (context, state) {
      String _name = state.device?.bleName ?? "BT Name";
      String _deviceId = state.device?.deviceId ?? "Device ID";
      String _productId = "Kazu"; //_getProductString(state.device?.productId as ProductId);
      int _batteryLevel = state.device?.batteryLevel ?? 0;
      Icon _batteryIcon = const Icon(Icons.battery_full);
      if (_batteryLevel > 3900) {
        _batteryIcon = const Icon(
          Icons.battery_full,
          color: Colors.green,
        );
      }

        return ListTile(
          //leading: const Icon(Icons.lock_outline),
          leading: (state.device?.lockStatus == DeviceLockStatus.LOCKED) ? const Icon(Icons.lock, color: Colors.black) : const Icon(Icons.lock_open, color: Colors.grey),
          title: Center(
              child: Text(_name)
          ),
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
}