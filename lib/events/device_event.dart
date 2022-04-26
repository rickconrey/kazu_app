import '../models/Device.dart';

abstract class DeviceEvent {}

class DeviceUnknown extends DeviceEvent {}
class DeviceNoDevice extends DeviceEvent {}
class DeviceCurrent extends DeviceEvent {}
class DeviceLast extends DeviceEvent {}

class DeviceUpdate extends DeviceEvent {
  final String deviceId;

  DeviceUpdate({required this.deviceId});
}
