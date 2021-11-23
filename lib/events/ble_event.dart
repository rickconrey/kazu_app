import 'package:flutter_blue/flutter_blue.dart';

abstract class BleEvent {}

class BleUnknown extends BleEvent {}
class BleScanResult extends BleEvent {
  final ScanResult? result;

  BleScanResult({this.result});
}
class BleScanRequest extends BleEvent {}

class BleConnectRequest extends BleEvent {
  final ScanResult device;

  BleConnectRequest({required this.device});
}

class BleConnected extends BleEvent {}
class BleDisconnected extends BleEvent {}
class BleSubscribe extends BleEvent {}

class BleTx extends BleEvent {
  final List<int>? message;

  BleTx({this.message});
}

class BleRx extends BleEvent {}