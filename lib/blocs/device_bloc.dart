import 'package:flutter_bloc/flutter_bloc.dart';

import '../events/device_event.dart';
import '../states/device_state.dart';

class DeviceBloc extends Bloc<DeviceEvent, DeviceState> {
  DeviceBloc() : super (DeviceState());

  @override
  Stream<DeviceState> mapEventToState(DeviceEvent event) async* {

  }
}