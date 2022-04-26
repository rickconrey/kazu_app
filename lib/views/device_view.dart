import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kazu_app/events/device_event.dart';
import 'package:kazu_app/models/ModelProvider.dart';

import '../blocs/device_bloc.dart';
import '../cubit/home_navigator_cubit.dart';
import '../repositories/data_repository.dart';
import '../states/device_state.dart';

class DeviceView extends StatelessWidget {

  DeviceView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return BlocProvider(
      create: (context) => DeviceBloc(
        dataRepository: context.read<DataRepository>(),
    ),
    child: BlocListener<DeviceBloc, DeviceState>(
        listener: (context, state) {

        },
        child: BlocBuilder<DeviceBloc, DeviceState>(builder: (context, state) {
          if (state.device == null) {
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
                _buildCartridgeView(),
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
            //const ListTile(
            //  title: Center(
            //    child: Text("Dose 20"),
            //  ),
            //),
            //const ListTile(
            //  title: Center(
            //    child: Text("Temperature 250"),
            //  ),
            //),
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
          state.cartridge?.doseNumber.toString() ?? "0",
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
          state.cartridge?.doseNumber.toString() ?? "0",
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
      String _productId = _getProductString(state.device?.productId as ProductId);

      return ListTile(
        leading: const Icon(Icons.lock_outline),
        title: Center(
            child: Text(_name)
        ),
        trailing: const Icon(Icons.battery_full),
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
      String _firmwareVersion = state.device?.firmwareVersion?.toRadixString(16).replaceAllMapped(RegExp(r".{2}"), (match) => "${match.group(0)}.") ?? "22.03.00.00";
      String _imageLibraryVersion = state.device?.imageLibraryVersion?.toRadixString(16).replaceAllMapped(RegExp(r".{2}"), (match) => "${match.group(0)}.") ?? "22.00.00";
      return ListTile(
        leading: Text("Firmware: " + _firmwareVersion),
          //title: const Text("Versions"),
          trailing: Text("Image Library: " + _imageLibraryVersion),
          //subtitle: Row(
          //  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //  children: [
          //  ],
          //)
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