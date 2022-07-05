import 'dart:async';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:kazu_app/models/User.dart';
import 'package:synchronized/synchronized.dart';

class BleState {
  final User? user;
  final Map<String, dynamic>? result;
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
  final DiscoveredCharacteristic? mdsFeatures;
  final DiscoveredCharacteristic? mdsAuthorization;
  final DiscoveredCharacteristic? mdsDeviceId;
  final DiscoveredCharacteristic? mdsDataUri;
  final DiscoveredCharacteristic? mdsDataExport;
  final QualifiedCharacteristic? qcMdsFeatures;
  final QualifiedCharacteristic? qcMdsAuthorization;
  final QualifiedCharacteristic? qcMdsDeviceId;
  final QualifiedCharacteristic? qcMdsDataUri;
  final QualifiedCharacteristic? qcMdsDataExport;
  final String? dataUri;
  final String? deviceId;
  final String? authorizationKey;
  final String? authorizationValue;
  var lock = Lock();

  Lock get bleLock => lock;

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
    this.mdsFeatures,
    this.mdsAuthorization,
    this.mdsDataExport,
    this.mdsDataUri,
    this.mdsDeviceId,
    this.qcMdsAuthorization,
    this.qcMdsDataExport,
    this.qcMdsDataUri,
    this.qcMdsDeviceId,
    this.qcMdsFeatures,
    this.deviceId,
    this.authorizationKey,
    this.authorizationValue,
    this.dataUri,
  });

  BleState copyWith({
    User? user,
    Map<String, dynamic>? result,
    List<DiscoveredDevice>? scanResults,
    StreamSubscription<DiscoveredDevice>? scanner,
    StreamSubscription<ConnectionStateUpdate>? connection,
    String? device,
    DeviceConnectionState? state,
    List<DiscoveredService>? services,
    DiscoveredCharacteristic? tx,
    DiscoveredCharacteristic? txNotify,
    DiscoveredCharacteristic? rx,
    QualifiedCharacteristic? qcTx,
    QualifiedCharacteristic? qcTxNotify,
    QualifiedCharacteristic? qcRx,
    DiscoveredCharacteristic? mdsFeatures,
    DiscoveredCharacteristic? mdsDeviceId,
    DiscoveredCharacteristic? mdsDataUri,
    DiscoveredCharacteristic? mdsAuthorization,
    DiscoveredCharacteristic? mdsDataExport,
    QualifiedCharacteristic? qcMdsFeatures,
    QualifiedCharacteristic? qcMdsDeviceId,
    QualifiedCharacteristic? qcMdsDataUri,
    QualifiedCharacteristic? qcMdsAuthorization,
    QualifiedCharacteristic? qcMdsDataExport,
    String? dataUri,
    String? authorizationKey,
    String? authorizationValue,
    String? deviceId,
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
      mdsDeviceId: mdsDeviceId ?? this.mdsDeviceId,
      mdsDataUri: mdsDataUri ?? this.mdsDataUri,
      mdsDataExport: mdsDataExport ?? this.mdsDataExport,
      mdsAuthorization: mdsAuthorization ?? this.mdsAuthorization,
      mdsFeatures: mdsFeatures ?? this.mdsFeatures,
      qcMdsDeviceId: qcMdsDeviceId ?? this.qcMdsDeviceId,
      qcMdsDataUri: qcMdsDataUri ?? this.qcMdsDataUri,
      qcMdsDataExport: qcMdsDataExport ?? this.qcMdsDataExport,
      qcMdsAuthorization: qcMdsAuthorization ?? this.qcMdsAuthorization,
      qcMdsFeatures: qcMdsFeatures ?? this.qcMdsFeatures,
      deviceId: deviceId ?? this.deviceId,
      dataUri: dataUri ?? this.dataUri,
      authorizationKey: authorizationKey ?? this.authorizationKey,
      authorizationValue: authorizationValue ?? this.authorizationValue,
    );
  }
}