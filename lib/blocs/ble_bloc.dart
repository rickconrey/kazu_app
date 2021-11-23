import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:kazu_app/events/ble_event.dart';
import 'package:kazu_app/repositories/ble_repository.dart';
import 'package:kazu_app/states/ble_state.dart';

class BleBloc extends Bloc<BleEvent, BleState> {
  final BleRepository bleRepository;

  BleBloc({required this.bleRepository}) : super (BleState());

  @override
  Stream<BleState> mapEventToState(BleEvent event) async* {
    if (event is BleScanRequest) {
      List<ScanResult> scanResults = [];
      yield state.copyWith(scanResults: scanResults);
      //bleRepository.scanForDevices(const Duration(seconds: 4));
      var scanListener = bleRepository.ble.scan(withServices: [Guid("8D53DC1D-1DB7-4CD3-868B-8A527460AA84")], timeout: const Duration(seconds: 4)).listen((result) {
        add(BleScanResult(result: result));
      });

    } else if (event is BleScanResult) {
      List<ScanResult> results = state.scanResults ?? [];
      results.add(event.result!);
      yield state.copyWith(scanResults: results);
    } else if (event is BleConnectRequest) {
      yield state.copyWith(device: event.device.device);
      await state.device?.connect();
      List<BluetoothService>? services = await state.device?.discoverServices();
      yield state.copyWith(services: services);
      add(BleConnected());
    } else if (event is BleConnected) {

    } else if (event is BleTx) {
      try {

      } catch (e) {
        rethrow;
      }
    }

  }
}