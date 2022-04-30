import 'dart:async';

import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:kazu_app/utils/packet.dart';
import 'package:synchronized/synchronized.dart';

class BleRepository {
  final ble = FlutterReactiveBle();
  ProcessPacket processPacket = ProcessPacket();

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

  Future<void> disconnectFromDevice(StreamSubscription<ConnectionStateUpdate> connection) async {
    await connection.cancel();
  }

  Future<PacketResult?> readFromDevice(QualifiedCharacteristic rx, Lock lock) async {
    print("Reading data");
    List<int> values = [];
    await lock.synchronized(() async {
      values = await read(qc: rx);
    });
    print(values);
    if (values.length > 4) {
      Packet packet = Packet();
      packet.processRx(values);
      PacketResult? results = processPacket.processPacket(packet);
      return results;
    }
    return null;
  }
}