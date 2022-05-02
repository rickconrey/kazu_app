import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:kazu_app/models/User.dart';

abstract class BleEvent {}

class BleUnknown extends BleEvent {}
class BleScanResult extends BleEvent {
  //final ScanResult? result;
  final DiscoveredDevice? result;

  BleScanResult({this.result});
}
class BleScanRequest extends BleEvent {}

class BleConnectRequest extends BleEvent {
  final DiscoveredDevice device;
  //final ScanResult device;
  final User user;

  BleConnectRequest({required this.device, required this.user});
}

class BleConnectionEvent extends BleEvent {
  final ConnectionStateUpdate update;

  BleConnectionEvent({required this.update});
}

class BleConnected extends BleEvent {}
class BleDisconnected extends BleEvent {}
class BleSubscribe extends BleEvent {}

class BleTx extends BleEvent {
  final List<int>? message;

  BleTx({this.message});
}

class BleRx extends BleEvent {}