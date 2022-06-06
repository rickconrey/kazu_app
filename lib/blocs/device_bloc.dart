import 'package:amplify_datastore/amplify_datastore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kazu_app/repositories/ble_repository.dart';

import '../events/ble_event.dart';
import '../events/device_event.dart';
import '../models/Cartridge.dart';
import '../models/Device.dart';
import '../models/User.dart';
import '../repositories/data_repository.dart';
import '../states/device_state.dart';
import 'ble_bloc.dart';

class DeviceBloc extends Bloc<DeviceEvent, DeviceState> {
  final DataRepository dataRepository;
  final BleBloc bleBloc;
  final User user;

  DeviceBloc({
    required this.dataRepository,
    //required this.bleRepository,
    required this.bleBloc,
    required this.user,
    }) : super (DeviceState()){
    if (state.device == null) {
      add(DeviceNoDevice());
      //add(DeviceUpdate(deviceId:"testdevice"));
    }
  }

  @override
  Stream<DeviceState> mapEventToState(DeviceEvent event) async* {
    if (event is DeviceCurrent) {

    } else if (event is DeviceNoDevice) {
      Stream<QuerySnapshot> _deviceStream = dataRepository.getDeviceStreamByUserId(user.id);
      _deviceStream.listen((e) {
        add(DeviceUpdate(snapshot: e));
      });
    } else if (event is DeviceUpdate) {

      if (event.snapshot != null) {
        if (event.snapshot!.items.isNotEmpty) {
          Model device = event.snapshot!.items.first;
          yield state.copyWith(device: device as Device, dose: device.dose, temperature: device.temperature);
        }
      }

      //var device = await dataRepository.getDeviceByDeviceId(deviceId: event.deviceId);
      //Cartridge? cartridge;
      //if (device?.lastCartridge != null) {
      //  String cartridgeId = device?.lastCartridge ?? "";
      //  cartridge = await dataRepository.getCartridgeByCartridgeId(cartridgeId: cartridgeId);
      //}
    } else if (event is DeviceTemperatureSubmitted) {
      bleBloc.add(BleSubmitTemperature(temperature: state.temperature));
    } else if (event is DeviceDoseSubmitted) {
      bleBloc.add(BleSubmitDose(dose: state.dose));
    } else if (event is DeviceLockSubmitted) {
      yield state.copyWith(lock: event.lock);
      bleBloc.add(BleSubmitLock(lock: state.lock));
    } else if (event is DeviceTemperatureChanged) {
      yield state.copyWith(temperature: event.temperature);
    } else if (event is DeviceDoseChanged) {
      yield state.copyWith(dose: event.dose);
    }
  }
}