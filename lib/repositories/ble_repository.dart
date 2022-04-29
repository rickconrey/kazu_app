import 'dart:async';

import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:kazu_app/utils/packet.dart';
import 'package:synchronized/synchronized.dart';

class BleRepository {
  //final FlutterBlue ble = FlutterBlue.instance;
  final ble = FlutterReactiveBle();
  ProcessPacket processPacket = ProcessPacket();

//  Future<void> scanForDevices(Duration? timeout) async {
//    try {
//    //  var scanStream = ble.scan(timeout: const Duration(seconds: 4)).listen((result) {
//    //    BleScanResult(result: result);
//    //  });
//
//    } catch (e) {
//      rethrow;
//    }
//  }

  Stream<DiscoveredDevice> scan(List<Uuid> services) {
    return ble.scanForDevices(withServices: services, scanMode: ScanMode.balanced);
  }

  Stream<ConnectionStateUpdate> connect(DiscoveredDevice device) {
    return ble.connectToDevice(id: device.id);
  }

  Future<int> requestMtu({required String deviceId, required int mtu}) async {
    return ble.requestMtu(deviceId: deviceId, mtu: mtu);
  }

  Future<List<DiscoveredService>> getServices({required String deviceId}) async {
    return ble.discoverServices(deviceId);
  }

  Future<void> write({required QualifiedCharacteristic qc, required List<int> value}) async {
    ble.writeCharacteristicWithoutResponse(qc, value: value);
  }

  Future<List<int>> read({required QualifiedCharacteristic qc}) async {
    return ble.readCharacteristic(qc);
  }

  Stream<List<int>> subscribeToNotification({required QualifiedCharacteristic qc}) {
    return ble.subscribeToCharacteristic(qc);
  }

  //StreamBuilder<List<ScanResult> scanResults() {
  //  return ble.scanResults;
  //}

//  Future<void> stopScan() async {
//    await ble.stopScan();
//  }
//
//  Future<void> setNotificationValue(BluetoothCharacteristic characteristic, bool value) async {
//   await characteristic.setNotifyValue(value);
//  }
//
//  Future<void> txMessage(BluetoothCharacteristic characteristic, List<int> message) async {
//    await characteristic.write(message);
//  }
//
//  Future<List<int>> rxMessage(BluetoothCharacteristic characteristic) async {
//    return await characteristic.read();
//  }
//
//  Future<void> connectToDevice(BluetoothDevice device) async {
//    try {
//      await device.connect(timeout: const Duration(seconds: 4), autoConnect: true);
//    } catch (e) {
//      rethrow;
//    }
//  }
//
  Future<void> disconnectFromDevice(StreamSubscription<ConnectionStateUpdate> connection) async {
    await connection.cancel();
  }

  Future<PacketResult?> readFromDevice(QualifiedCharacteristic rx, Lock lock) async {
    //if(rx.properties.read) {
      print("Reading data");
      List<int> values = [];
      await lock.synchronized(() async {
        //values = await rx.read();
        values = await read(qc: rx);
      });
      print(values);
      if (values.length > 4) {
        Packet packet = Packet();
        packet.processRx(values);
        PacketResult? results = processPacket.processPacket(packet);
        return results;
      }
    //} else {
    //  print("No read property found.");
    //}
    return null;
  }
}