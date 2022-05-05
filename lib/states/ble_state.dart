import 'dart:async';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
//import 'package:flutter_blue/flutter_blue.dart';
import 'package:kazu_app/models/User.dart';
import 'package:synchronized/synchronized.dart';

class BleState {
  final User? user;
  final Map<String, dynamic>? result;
  //final BluetoothDevice? device;
  //final DiscoveredDevice? device;
  final String? device;
  final StreamSubscription<DiscoveredDevice>? scanner;
  final StreamSubscription<ConnectionStateUpdate>? connection;
  final DeviceConnectionState? state;
  final List<DiscoveredService>? services;
  final DiscoveredCharacteristic? tx;
  final DiscoveredCharacteristic? txNotify;
  final DiscoveredCharacteristic? rx;
  final QualifiedCharacteristic? qcTx;
  final QualifiedCharacteristic? qcTxNotify;
  final QualifiedCharacteristic? qcRx;
  var lock = Lock();

  Lock get bleLock => lock;

  //List<ScanResult>? scanResults = [];
  List<DiscoveredDevice>? scanResults = [];
  BleState({
    this.user,
    this.result,
    this.scanResults,
    this.device,
    this.scanner,
    this.connection,
    this.state = DeviceConnectionState.disconnected,
    this.services,
    this.tx,
    this.txNotify,
    this.rx,
    this.qcTx,
    this.qcTxNotify,
    this.qcRx,
  });

  BleState copyWith({
    User? user,
    //ScanResult? result,
    Map<String, dynamic>? result,
    //List<ScanResult>? scanResults,
    List<DiscoveredDevice>? scanResults,
    StreamSubscription<DiscoveredDevice>? scanner,
    StreamSubscription<ConnectionStateUpdate>? connection,
    //BluetoothDevice? device,
    //DiscoveredDevice? device,
    String? device,
    DeviceConnectionState? state,
    List<DiscoveredService>? services,
    DiscoveredCharacteristic? tx,
    DiscoveredCharacteristic? txNotify,
    DiscoveredCharacteristic? rx,
    QualifiedCharacteristic? qcTx,
    QualifiedCharacteristic? qcTxNotify,
    QualifiedCharacteristic? qcRx,
  }) {
    return BleState(
      user: user ?? this.user,
      result: result ?? this.result,
      scanResults: scanResults ?? this.scanResults,
      device: device ?? this.device,
      scanner: scanner ?? this.scanner,
      connection: connection ?? this.connection,
      state: state ?? this.state,
      services: services ?? this.services,
      tx: tx ?? this.tx,
      txNotify: txNotify ?? this.txNotify,
      rx: rx ?? this.rx,
      qcTx: qcTx ?? this.qcTx,
      qcTxNotify: qcTxNotify ?? this.qcTxNotify,
      qcRx: qcRx ?? this.qcRx,
    );
  }
}