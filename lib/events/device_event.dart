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
