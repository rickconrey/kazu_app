import 'package:equatable/equatable.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:kazu_app/models/User.dart';

abstract class BleEvent extends Equatable{}

class BleUnknown extends BleEvent {
  @override
  List<Object?> get props => [];
}

class BleScanResult extends BleEvent {
  //final ScanResult? result;
  final DiscoveredDevice? result;

  BleScanResult({this.result});

  @override
  List<Object?> get props => [result];
}
class BleScanRequest extends BleEvent {

  @override
  List<Object?> get props => [];
}

class BleConnectRequest extends BleEvent {
 // final DiscoveredDevice device;
  final String device;
  //final ScanResult device;
  final User user;

  BleConnectRequest({required this.device, required this.user});

  @override
  List<Object?> get props => [device, user];
}

class BleConnectionEvent extends BleEvent {
  final ConnectionStateUpdate update;

  BleConnectionEvent({required this.update});

  @override
  List<Object?> get props => [update];
}

class BleAttemptAutoConnect extends BleEvent {
  final User user;

  BleAttemptAutoConnect({required this.user});

  @override
  List<Object?> get props => [user];
}

class BleConnected extends BleEvent {

  @override
  List<Object?> get props => [];
}
class BleDisconnected extends BleEvent {

  @override
  List<Object?> get props => [];
}
class BleDelete extends BleEvent {

  @override
  List<Object?> get props => [];
}
class BleSubscribe extends BleEvent {
  @override
  List<Object?> get props => [];
}

class BleTx extends BleEvent {
  final List<int>? message;

  BleTx({this.message});

  @override
  List<Object?> get props => [message];
}

class BleRx extends BleEvent {
  @override
  List<Object?> get props => [];
}

class BleSubmitTemperature extends BleEvent {
  final int temperature;

  BleSubmitTemperature({required this.temperature});

  @override
  List<Object?> get props => [temperature];
}

class BleSubmitDose extends BleEvent {
  final int dose;

  BleSubmitDose({required this.dose});

  @override
  List<Object?> get props => [dose];
}

class BleSubmitLock extends BleEvent {
  final bool lock;

  BleSubmitLock({required this.lock});

  @override
  List<Object?> get props => [lock];
}
