import 'package:amplify_datastore/amplify_datastore.dart';

import '../models/Device.dart';

abstract class DeviceEvent {}

class DeviceUnknown extends DeviceEvent {}
class DeviceNoDevice extends DeviceEvent {}
class DeviceCurrent extends DeviceEvent {}
class DeviceLast extends DeviceEvent {}

class DeviceUpdate extends DeviceEvent {
  //final String deviceId;
  final QuerySnapshot? snapshot;

  DeviceUpdate({required this.snapshot});
}

class DeviceTemperatureChanged extends DeviceEvent {
  final int? temperature;

  DeviceTemperatureChanged({this.temperature});
}

class DeviceDoseChanged extends DeviceEvent {
  final int? dose;

  DeviceDoseChanged({this.dose});
}

class DeviceTemperatureSubmitted extends DeviceEvent {}
class DeviceDoseSubmitted extends DeviceEvent {}
class DeviceLockSubmitted extends DeviceEvent {
  final bool lock;
  DeviceLockSubmitted({required this.lock});
}

