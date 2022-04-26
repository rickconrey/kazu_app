import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:kazu_app/events/ble_event.dart';
import 'package:kazu_app/utils/packet.dart';
import 'package:synchronized/synchronized.dart';

class BleRepository {
  final FlutterBlue ble = FlutterBlue.instance;
  ProcessPacket processPacket = ProcessPacket();

  Future<void> scanForDevices(Duration? timeout) async {
    try {
      var scanStream = ble.scan(timeout: const Duration(seconds: 4)).listen((result) {
        BleScanResult(result: result);
      });

    } catch (e) {
      rethrow;
    }
  }

  //StreamBuilder<List<ScanResult> scanResults() {
  //  return ble.scanResults;
  //}

  Future<void> stopScan() async {
    await ble.stopScan();
  }

  Future<void> setNotificationValue(BluetoothCharacteristic characteristic, bool value) async {
   await characteristic.setNotifyValue(value);
  }

  Future<void> txMessage(BluetoothCharacteristic characteristic, List<int> message) async {
    await characteristic.write(message);
  }

  Future<List<int>> rxMessage(BluetoothCharacteristic characteristic) async {
    return await characteristic.read();
  }

  Future<void> connectToDevice(BluetoothDevice device) async {
    try {
      await device.connect(timeout: const Duration(seconds: 4), autoConnect: true);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> disconnectFromDevice(BluetoothDevice device) async {
    await device.disconnect();
  }

  Future<PacketResult?> readFromDevice(BluetoothCharacteristic rx, Lock lock) async {
    //Future<List<int>?> readFromDevice(BluetoothCharacteristic rx, Lock lock) async {
    if(rx.properties.read) {
      print("Reading data");
      List<int> values = [];
      await lock.synchronized(() async {
        values = await rx.read();
      });
      print(values);
      if (values.length > 4) {
        Packet packet = Packet();
        packet.processRx(values);
        //List<int>? results = processPacket.processPacket(packet);
        PacketResult? results = processPacket.processPacket(packet);
        return results;
      }
    } else {
      print("No read property found.");
    }
    return null;
  }
}