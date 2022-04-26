import 'package:flutter_bloc/flutter_bloc.dart';

import '../events/device_event.dart';
import '../models/Cartridge.dart';
import '../repositories/data_repository.dart';
import '../states/device_state.dart';

class DeviceBloc extends Bloc<DeviceEvent, DeviceState> {
  final DataRepository dataRepository;

  DeviceBloc({
    required this.dataRepository,
    }) : super (DeviceState()){
    if (state.device == null) {
      //add(DeviceNoDevice());
      add(DeviceUpdate(deviceId:"testdevice"));
    }
  }

  @override
  Stream<DeviceState> mapEventToState(DeviceEvent event) async* {
    if (event is DeviceCurrent) {

    } else if (event is DeviceNoDevice) {

    } else if (event is DeviceUpdate) {
      var device = await dataRepository.getDeviceByDeviceId(deviceId: event.deviceId);
      Cartridge? cartridge;
      if (device?.lastCartridge != null) {
        String cartridgeId = device?.lastCartridge ?? "";
        cartridge = await dataRepository.getCartridgeByCartridgeId(cartridgeId: cartridgeId);
      }
      yield state.copyWith(device: device, cartridge: cartridge);
    }
  }
}