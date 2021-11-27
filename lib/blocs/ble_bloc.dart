import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:kazu_app/events/ble_event.dart';
import 'package:kazu_app/generated/telemetry.pb.dart';
import 'package:kazu_app/models/User.dart';
import 'package:kazu_app/repositories/ble_repository.dart';
import 'package:kazu_app/repositories/data_repository.dart';
import 'package:kazu_app/states/ble_state.dart';
import 'package:kazu_app/utils/cobs.dart';

class BleBloc extends Bloc<BleEvent, BleState> {
  final BleRepository bleRepository;
  final DataRepository dataRepository;
  final Guid kazuServiceUuid = Guid("c6f9b530-b0b1-b2f4-5769-7469f5b2b1b0");
  final Guid kazuTxUuid = Guid("c6f9b531-b0b1-b2f4-5769-7469f5b2b1b0");
  final Guid kazuTxNotifyUuid = Guid("c6f9b532-b0b1-b2f4-5769-7469f5b2b1b0");
  final Guid kazuRxUuid = Guid("c6f9b533-b0b1-b2f4-5769-7469f5b2b1b0");

  BleBloc({
    required this.bleRepository,
    required this.dataRepository,
  }) : super (BleState());

  @override
  Stream<BleState> mapEventToState(BleEvent event) async* {
    if (event is BleScanRequest) {
      List<ScanResult> scanResults = [];
      yield state.copyWith(scanResults: scanResults);
      var scanListener = bleRepository.ble.scan(withServices: [Guid("8D53DC1D-1DB7-4CD3-868B-8A527460AA84")], timeout: const Duration(seconds: 4)).listen((result) {
        add(BleScanResult(result: result));
      });

    } else if (event is BleScanResult) {
      List<ScanResult> results = state.scanResults ?? [];
      results.add(event.result!);
      yield state.copyWith(scanResults: results);

    } else if (event is BleConnectRequest) {
      yield state.copyWith(device: event.device.device, user: event.user);
      await state.device?.connect();
      List<BluetoothService>? services = await state.device?.discoverServices();
      for (BluetoothService service in services!) {
        if (service.uuid == kazuServiceUuid) {
          print("Found kazu service: $kazuServiceUuid");
          for (BluetoothCharacteristic characteristic in service.characteristics) {
            if (characteristic.uuid == kazuRxUuid) {
              print("Found kazu Rx");
              yield state.copyWith(rx: characteristic);
            } else if (characteristic.uuid == kazuTxNotifyUuid) {
              print("Found kazu RxNotify");
              yield state.copyWith(txNotify: characteristic);
            } else if (characteristic.uuid == kazuTxUuid) {
              print("Found kazu Tx");
              yield state.copyWith(tx: characteristic);
            }
          }
        }
      }
      yield state.copyWith(services: services);

      add(BleConnected());

    } else if (event is BleConnected) {
      yield state.copyWith(isConnected: true);

      //state.device?.requestMtu(42);
      //var mtu = await state.device?.mtu.first;
      //print("MTU: $mtu");
      //state.device?.requestMtu(512);
      //mtu = await state.device?.mtu.first;
      //print("MTU: $mtu");

      await state.txNotify?.setNotifyValue(true);
      state.txNotify?.value.listen((value) async {
        if (value.isNotEmpty) {
          if (state.tx != null) {
            List<int>? data = await bleRepository.readFromDevice(state.tx!, state.bleLock);
            if (data != null) {
              Cobs cobs = Cobs();
              List<int> results = cobs.decode(data);
              Telemetry telemetry = Telemetry.fromBuffer(results);
              print(telemetry);
              if (telemetry.whichPayload() == Telemetry_Payload.puffEvent) {
                dataRepository.createPuffEvent(
                    userId: state.user?.id ?? "0",
                    telemetry: telemetry,
                );
              }
            }
          }
        }
      });
    } else if (event is BleTx) {
      try {
        if (event.message != null) {
          state.rx?.write(event.message!);
        }
      } catch (e) {
        rethrow;
      }
    } else if (event is BleDisconnected) {
      state.txNotify?.setNotifyValue(false);
      if (state.device != null) {
        bleRepository.disconnectFromDevice(state.device!);
        yield state.copyWith(isConnected: false);
      }
    }
  }
}