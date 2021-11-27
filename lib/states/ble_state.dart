import 'dart:async';

import 'package:flutter_blue/flutter_blue.dart';
import 'package:kazu_app/models/User.dart';
import 'package:synchronized/synchronized.dart';

class BleState {
  final User? user;
  final ScanResult? result;
  final BluetoothDevice? device;
  final List<BluetoothService>? services;
  final BluetoothCharacteristic? tx;
  final BluetoothCharacteristic? txNotify;
  final BluetoothCharacteristic? rx;
  final bool? isConnected;
  var lock = Lock();

  Lock get bleLock => lock;

  List<ScanResult>? scanResults = [];
  BleState({
    this.user,
    this.result,
    this.scanResults,
    this.device,
    this.services,
    this.tx,
    this.txNotify,
    this.rx,
    this.isConnected = false,
  });

  BleState copyWith({
    User? user,
    ScanResult? result,
    List<ScanResult>? scanResults,
    BluetoothDevice? device,
    List<BluetoothService>? services,
    BluetoothCharacteristic? tx,
    BluetoothCharacteristic? txNotify,
    BluetoothCharacteristic? rx,
    bool? isConnected,
  }) {
    return BleState(
      user: user ?? this.user,
      result: result ?? this.result,
      scanResults: scanResults ?? this.scanResults,
      device: device ?? this.device,
      services: services ?? this.services,
      tx: tx ?? this.tx,
      txNotify: txNotify ?? this.txNotify,
      rx: rx ?? this.rx,
      isConnected: isConnected ?? this.isConnected,
    );
  }
}