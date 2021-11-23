import 'dart:async';

import 'package:flutter_blue/flutter_blue.dart';

class BleState {
  final ScanResult? result;
  final BluetoothDevice? device;
  final List<BluetoothService>? services;
  List<ScanResult>? scanResults = [];
  BleState({
    this.result,
    this.scanResults,
    this.device,
    this.services,
  });

  BleState copyWith({
    ScanResult? result,
    List<ScanResult>? scanResults,
    BluetoothDevice? device,
    List<BluetoothService>? services,
  }) {
    return BleState(
      result: result ?? this.result,
      scanResults: scanResults ?? this.scanResults,
      device: device ?? this.device,
      services: services ?? this.services,
    );
  }
}