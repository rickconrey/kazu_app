import 'dart:async';
import 'dart:convert';
import 'package:amplify_datastore/amplify_datastore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:kazu_app/events/ble_event.dart';
import 'package:kazu_app/generated/cartridge/mutable.pb.dart';
import 'package:kazu_app/generated/telemetry.pb.dart';
import 'package:kazu_app/generated/control.pb.dart';
import 'package:kazu_app/repositories/ble_repository.dart';
import 'package:kazu_app/repositories/data_repository.dart';
import 'package:kazu_app/states/ble_state.dart';
import 'package:kazu_app/utils/cobs.dart';
import 'package:http/http.dart' as http;
import 'package:collection/collection.dart';

import '../models/Device.dart';
import '../utils/packet.dart';

class BleBloc extends Bloc<BleEvent, BleState> {
  final BleRepository bleRepository;
  final DataRepository dataRepository;
  final Uuid kazuUpdateUuid = Uuid([0x8d, 0x53, 0xdc, 0x1d, 0x1d, 0xb7, 0x4c, 0xd3, 0x86, 0x8b, 0x8a, 0x52, 0x74, 0x60, 0xaa, 0x84]);
  final Uuid kazuServiceUuid = Uuid([0xc6, 0xf9, 0xb5, 0x30, 0xb0, 0xb1, 0xb2, 0xf4, 0x57, 0x69, 0x74, 0x69, 0xf5, 0xb2, 0xb1, 0xb0]);
  final Uuid kazuTxUuid = Uuid([0xc6, 0xf9, 0xb5, 0x31, 0xb0, 0xb1, 0xb2, 0xf4, 0x57, 0x69, 0x74, 0x69, 0xf5, 0xb2, 0xb1, 0xb0]);
  final Uuid kazuTxNotifyUuid = Uuid([0xc6, 0xf9, 0xb5, 0x32, 0xb0, 0xb1, 0xb2, 0xf4, 0x57, 0x69, 0x74, 0x69, 0xf5, 0xb2, 0xb1, 0xb0]);
  final Uuid kazuRxUuid = Uuid([0xc6, 0xf9, 0xb5, 0x33, 0xb0, 0xb1, 0xb2, 0xf4, 0x57, 0x69, 0x74, 0x69, 0xf5, 0xb2, 0xb1, 0xb0]);

  final Uuid kazuMdsServiceUuid = Uuid([0x54, 0x22, 0x00, 0x00, 0xf6, 0xa5, 0x40, 0x07, 0xa3, 0x71, 0x72, 0x2f, 0x4e, 0xbd, 0x84, 0x36]);
  final Uuid kazuMdsFeaturesUuid = Uuid([0x54, 0x22, 0x00, 0x01, 0xf6, 0xa5, 0x40, 0x07, 0xa3, 0x71, 0x72, 0x2f, 0x4e, 0xbd, 0x84, 0x36]);
  final Uuid kazuMdsDeviceIdUuid = Uuid([0x54, 0x22, 0x00, 0x02, 0xf6, 0xa5, 0x40, 0x07, 0xa3, 0x71, 0x72, 0x2f, 0x4e, 0xbd, 0x84, 0x36]);
  final Uuid kazuMdsDataUriUuid = Uuid([0x54, 0x22, 0x00, 0x03, 0xf6, 0xa5, 0x40, 0x07, 0xa3, 0x71, 0x72, 0x2f, 0x4e, 0xbd, 0x84, 0x36]);
  final Uuid kazuMdsAuthorizationUuid = Uuid([0x54, 0x22, 0x00, 0x04, 0xf6, 0xa5, 0x40, 0x07, 0xa3, 0x71, 0x72, 0x2f, 0x4e, 0xbd, 0x84, 0x36]);
  final Uuid kazuMdsDataExportUuid = Uuid([0x54, 0x22, 0x00, 0x05, 0xf6, 0xa5, 0x40, 0x07, 0xa3, 0x71, 0x72, 0x2f, 0x4e, 0xbd, 0x84, 0x36]);
  static List<int> lastSent = [0];
  BleBloc({
    required this.bleRepository,
    required this.dataRepository,
  }) : super (BleState()) {
    //add(BleAttemptAutoConnect());
    add(BleUnknown());
  }

  @override
  Stream<BleState> mapEventToState(BleEvent event) async* {
    if (event is BleUnknown) {
      bleRepository.ble.statusStream.listen((event) {
        print("Ble status: " + event.name);
      });
      bleRepository.ble.connectedDeviceStream.listen((event) {
        print("Ble Connect Device: " + event.connectionState.name);
        add(BleConnectionEvent(update: event));
      });
    }
    if (event is BleAttemptAutoConnect) {
      yield state.copyWith(user: event.user);
      Device? device = await dataRepository.getDeviceByUserId(
          userId: state.user!.id);
      if (device != null) {
        add(BleConnectRequest(device: device.bleId!, user: state.user!));
      }
    } else if (event is BleScanRequest) {
      List<DiscoveredDevice> scanResults = [];
      yield state.copyWith(scanResults: scanResults);
      var scanListener = bleRepository.scan([kazuUpdateUuid]).listen((device) {
        add(BleScanResult(result: device));
      });
      yield state.copyWith(scanner: scanListener);
    } else if (event is BleScanResult) {
      List<DiscoveredDevice> results = state.scanResults ?? [];
      for (int i = 0; i < results.length; i++) {
        if (results[i].id == event.result!.id) {
          results.removeAt(i);
          results.insert(i, event.result!);
          yield state.copyWith(scanResults: results);
          return;
        }
      }
      results.add(event.result!);
      yield state.copyWith(scanResults: results);

    } else if (event is BleConnectRequest) {
      yield state.copyWith(device: event.device, user: event.user);
      state.scanner?.cancel();
      Stream<ConnectionStateUpdate>? stream;
      if (state.device != null) {
        stream = bleRepository.connect(id: state.device!);
      }

      if (stream != null) {
        StreamSubscription<ConnectionStateUpdate>? connection = stream.listen((
            update) {
          add(BleConnectionEvent(update: update));
        });

        yield state.copyWith(connection: connection);

        // update user associated with device if device exists
        Device? userDevice = await dataRepository.getDeviceByBleId(bleId: state.device!);
        if (userDevice != null && userDevice.userId != event.user.id) {
          Device updatedDevice = userDevice.copyWith(userId: event.user.id);
          await dataRepository.updateDevice(updatedDevice);
        }
      }

    } else if (event is BleConnectionEvent) {
      if (event.update.connectionState == DeviceConnectionState.connected) {
        add(BleConnected());
      } else if (event.update.connectionState == DeviceConnectionState.disconnected) {
        Device? device = await dataRepository.getDeviceByUserId(userId: state.user!.id);
        if (device != null) {
          TemporalTimestamp now = TemporalTimestamp.fromSeconds(DateTime.now().millisecondsSinceEpoch ~/ 1000);
          Device updated = device.copyWith(lastSynced: now);
          await dataRepository.updateDevice(updated);
        }
      }
      yield state.copyWith(state: event.update.connectionState);
    } else if (event is BleConnected) {
      int mtu = await bleRepository.requestMtu(deviceId: state.device!, mtu: 128);
      print(mtu);

      List<DiscoveredService> services = await bleRepository.getServices(deviceId: state.device!);
      for (DiscoveredService service in services) {
        if (service.serviceId == kazuServiceUuid) {
          print("Found kazu service: $kazuServiceUuid");
          for (DiscoveredCharacteristic characteristic in service.characteristics) {
            if (characteristic.characteristicId == kazuRxUuid) {
              print("Found kazu Rx");
              yield state.copyWith(
                  rx: characteristic,
                  qcRx: QualifiedCharacteristic(
                      characteristicId: characteristic.characteristicId,
                      serviceId: service.serviceId,
                      deviceId: state.device!,
                  )
              );
            } else if (characteristic.characteristicId == kazuTxNotifyUuid) {
              print("Found kazu TxNotify");
              yield state.copyWith(
                  txNotify: characteristic,
                  qcTxNotify: QualifiedCharacteristic(
                      characteristicId: characteristic.characteristicId,
                      serviceId: service.serviceId,
                      deviceId: state.device!,
                  ),
              );
            } else if (characteristic.characteristicId == kazuTxUuid) {
              print("Found kazu Tx");
              yield state.copyWith(
                  tx: characteristic,
                  qcTx: QualifiedCharacteristic(
                      characteristicId: characteristic.characteristicId,
                      serviceId: service.serviceId,
                      deviceId: state.device!,
                ),
              );
            }
          }
        } else if (service.serviceId == kazuMdsServiceUuid) {
          print("Found Mds Service");
          for (DiscoveredCharacteristic characteristic in service
              .characteristics) {
            if (characteristic.characteristicId == kazuMdsFeaturesUuid) {
              print("Found Mds Features");
              yield state.copyWith(
                  mdsFeatures: characteristic,
                  qcMdsFeatures: QualifiedCharacteristic(
                    characteristicId: characteristic.characteristicId,
                    serviceId: service.serviceId,
                    deviceId: state.device!,
                  )
              );
            } else if (characteristic.characteristicId == kazuMdsDeviceIdUuid) {
              print("Found Mds Device Id");
              yield state.copyWith(
                  mdsDeviceId: characteristic,
                  qcMdsDeviceId: QualifiedCharacteristic(
                    characteristicId: characteristic.characteristicId,
                    serviceId: service.serviceId,
                    deviceId: state.device!,
                  )
              );
            } else if (characteristic.characteristicId == kazuMdsDataUriUuid) {
              print("Found Mds Data Uri");
              yield state.copyWith(
                  mdsDataUri: characteristic,
                  qcMdsDataUri: QualifiedCharacteristic(
                    characteristicId: characteristic.characteristicId,
                    serviceId: service.serviceId,
                    deviceId: state.device!,
                  )
              );
            } else
            if (characteristic.characteristicId == kazuMdsAuthorizationUuid) {
              print("Found Mds Authorization");
              yield state.copyWith(
                  mdsAuthorization: characteristic,
                  qcMdsAuthorization: QualifiedCharacteristic(
                    characteristicId: characteristic.characteristicId,
                    serviceId: service.serviceId,
                    deviceId: state.device!,
                  )
              );
            } else
            if (characteristic.characteristicId == kazuMdsDataExportUuid) {
              print("Found Mds Data Export");
              yield state.copyWith(
                  mdsDataExport: characteristic,
                  qcMdsDataExport: QualifiedCharacteristic(
                    characteristicId: characteristic.characteristicId,
                    serviceId: service.serviceId,
                    deviceId: state.device!,
                  )
              );
            }
          }
        }
      }
      yield state.copyWith(services: services);
      //yield state.copyWith(result: {"")

      //state.device?.requestMtu(42);
      //var mtu = await state.device?.mtu.first;
      //print("MTU: $mtu");
      //if (Platform.isAndroid) {
      //  await state.device?.requestMtu(223);
      //  var mtu = await state.device?.mtu.first;
      //  print("MTU: $mtu");
      //}


      //_sendGetRtcMessage();
      _sendSetRtcMessage();
      _sendGetDeviceInformationMessage();

      //await state.txNotify?.setNotifyValue(true);
      Stream<List<int>> rxNotifications = bleRepository.subscribeToNotification(qc: state.qcTxNotify!);
      rxNotifications.listen((value) async {
        if (value.isNotEmpty) {
          if (state.qcTx != null) {
            //List<int>? data = await bleRepository.readFromDevice(state.tx!, state.bleLock);
            //PacketResult? data = await bleRepository.readFromDevice(state.tx!, state.bleLock);
            PacketResult? data = await bleRepository.readFromDevice(state.qcTx!, state.bleLock);
            //List<int>? data = await bleRepository.read(qc: state.qcTx!);
            if (data != null) {
              if (data.packetType == PacketStreamIdEnum.data.index) {
                Cobs cobs = Cobs();
                List<int> results = cobs.decode(data.data);
                Telemetry telemetry = Telemetry.fromBuffer(results);
                dataRepository.createEvent(
                  userId: state.user?.id ?? "0",
                  telemetry: telemetry,
                );
              } else if (data.packetType == PacketStreamIdEnum.control.index) {
                ControlEnvelope control = ControlEnvelope.fromBuffer(data.data);
                dataRepository.processControlResponse(
                    userId: state.user?.id ?? "0",
                    controlEnvelope: control,
                    bleId: state.device!,
                );
              }
            }
          }
        }
      });

      List<int> dataUriList = await bleRepository.read(qc: state.qcMdsDataUri!);
      List<int> authorizationList = await bleRepository.read(qc: state.qcMdsAuthorization!);
      List<int> deviceIdList = await bleRepository.read(qc: state.qcMdsDeviceId!);

      String deviceIdString = utf8.decode(deviceIdList);
      String authorizationString = utf8.decode(authorizationList);
      String dataUriString = utf8.decode(dataUriList);

      String authorizationKey = authorizationString.split(":")[0];
      String authorizationValue = authorizationString.split(":")[1];

      yield state.copyWith(
        deviceId: deviceIdString,
        dataUri: dataUriString,
        authorizationValue: authorizationValue,
        authorizationKey: authorizationKey,
      );

      Stream<List<int>> dataExportNotifications = bleRepository.subscribeToNotification(qc: state.qcMdsDataExport!);
      dataExportNotifications.listen((value) async {
        Function eq = const ListEquality().equals;
        if (value.isNotEmpty) {
          if (eq(lastSent, value) == true) {
            return;
          }
          lastSent = value;
          http.post(
            Uri.parse(state.dataUri!),
            headers: <String, String>{
              state.authorizationKey!: state.authorizationValue!,
              "Content-Type": "application/octet-stream",
            },
            body: value,
            //body: jsonEncode(<String, String>{
            //  'title': title,
            //}),
          );
        }
      });

    } else if (event is BleTx) {
      try {
        if (event.message != null && state.qcRx != null) {
          //await state.rx?.write(event.message!);
          await bleRepository.write(qc: state.qcRx!, value: event.message!);
        }
      } catch (e) {
        rethrow;
      }
    } else if (event is BleDisconnected) {
      if (state.device != null && state.connection != null) {
        if (state.state == DeviceConnectionState.connected) {
          await state.connection!.cancel();
          //await bleRepository.disconnectFromDevice(state.connection!);
          yield state.copyWith(state: DeviceConnectionState.disconnected);
        }
      }
    } else if (event is BleDelete) {
      if (state.device != null && state.connection != null) {
        if (state.state == DeviceConnectionState.connected) {
          await state.connection!.cancel();
          //await bleRepository.disconnectFromDevice(state.connection!);
          yield state.copyWith(state: DeviceConnectionState.disconnected);
        }
        Device? userDevice = await dataRepository.getDeviceByBleId(bleId: state.device!);
        if (userDevice != null) {
          Device updatedDevice = userDevice.copyWith(userId: "");
          await dataRepository.updateDevice(updatedDevice);
        }
      }
    } else if (event is BleSubmitDose) {
      _sendSetDosageMessage(event.dose);
    } else if (event is BleSubmitLock) {
      LockStatus status;
      if (event.lock == true) {
        status = LockStatus.LOCKED;
      } else {
        status = LockStatus.UNLOCKED;
      }
      _sendSetLockMessage(status);
    } else if (event is BleSubmitTemperature) {
      _sendSetTemperatureMessage(event.temperature);
    }
  }

  void _sendSetRtcMessage() {
    Packet packet = Packet();
    Map<String, bool> flags = {"requestAck": true, "encrypted": false, "compressed": false};
    ControlEnvelope controlEnvelope = ControlEnvelope.create();
    controlEnvelope.command = Command.SET_RTC;
    RtcInformation rtcInformation = RtcInformation.create();
    rtcInformation.time = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    print("Time: $rtcInformation.time");
    SetRtc setRtc = SetRtc.create();
    setRtc.rtcInformation = rtcInformation;
    controlEnvelope.setRtc = setRtc;
    //controlEnvelope.setRtc.rtcInformation.time = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    List<int> payload = controlEnvelope.writeToBuffer();
    print("Payload: $payload");
    List<List<int>>? txPackets = packet.buildTxPacket(streamId: PacketStreamIdEnum.control, flags: flags, payload: payload);
    if (txPackets != null) {
      for (List<int> message in txPackets) {
        print("Adding message to BleTx: $message");
        add(BleTx(message: message));
      }
    }
  }

  void _sendGetRtcMessage() {
    Packet packet = Packet();
    Map<String, bool> flags = {"requestAck": true, "encrypted": false, "compressed": false};
    ControlEnvelope controlEnvelope = ControlEnvelope.create();
    controlEnvelope.command = Command.GET_RTC;

    // create payload
    List<int> payload = controlEnvelope.writeToBuffer();
    print("Payload: $payload");
    List<List<int>>? txPackets = packet.buildTxPacket(streamId: PacketStreamIdEnum.control, flags: flags, payload: payload);

    // add to queue message
    if (txPackets != null) {
      for (List<int> message in txPackets) {
        print("Adding message to BleTx: $message");
        add(BleTx(message: message));
      }
    }
  }

  void _sendGetCartStatusMessage() {
    Packet packet = Packet();
    Map<String, bool> flags = {"requestAck": true, "encrypted": false, "compressed": false};
    ControlEnvelope controlEnvelope = ControlEnvelope.create();
    controlEnvelope.command = Command.GET_CART_STATUS;

    // create payload
    List<int> payload = controlEnvelope.writeToBuffer();
    print("Payload: $payload");
    List<List<int>>? txPackets = packet.buildTxPacket(streamId: PacketStreamIdEnum.control, flags: flags, payload: payload);

    // add to queue message
    if (txPackets != null) {
      for (List<int> message in txPackets) {
        print("Adding message to BleTx: $message");
        add(BleTx(message: message));
      }
    }
  }

  void _sendGetDeviceInformationMessage() {
    Packet packet = Packet();
    Map<String, bool> flags = {"requestAck": true, "encrypted": false, "compressed": false};
    ControlEnvelope controlEnvelope = ControlEnvelope.create();
    controlEnvelope.command = Command.GET_DEVICE_INFORMATION;

    // create payload
    List<int> payload = controlEnvelope.writeToBuffer();
    print("Payload: $payload");
    List<List<int>>? txPackets = packet.buildTxPacket(streamId: PacketStreamIdEnum.control, flags: flags, payload: payload);

    // add to queue message
    if (txPackets != null) {
      for (List<int> message in txPackets) {
        print("Adding message to BleTx: $message");
        add(BleTx(message: message));
      }
    }
  }

  void _sendGetDosageMessage() {
    Packet packet = Packet();
    Map<String, bool> flags = {"requestAck": true, "encrypted": false, "compressed": false};
    ControlEnvelope controlEnvelope = ControlEnvelope.create();
    controlEnvelope.command = Command.GET_DOSAGE;

    // create payload
    List<int> payload = controlEnvelope.writeToBuffer();
    print("Payload: $payload");
    List<List<int>>? txPackets = packet.buildTxPacket(streamId: PacketStreamIdEnum.control, flags: flags, payload: payload);

    // add to queue message
    if (txPackets != null) {
      for (List<int> message in txPackets) {
        print("Adding message to BleTx: $message");
        add(BleTx(message: message));
      }
    }
  }

  void _sendGetTemperatureMessage() {
    Packet packet = Packet();
    Map<String, bool> flags = {"requestAck": true, "encrypted": false, "compressed": false};
    ControlEnvelope controlEnvelope = ControlEnvelope.create();
    controlEnvelope.command = Command.GET_TEMPERATURE;

    // create payload
    List<int> payload = controlEnvelope.writeToBuffer();
    print("Payload: $payload");
    List<List<int>>? txPackets = packet.buildTxPacket(streamId: PacketStreamIdEnum.control, flags: flags, payload: payload);

    // add to queue message
    if (txPackets != null) {
      for (List<int> message in txPackets) {
        print("Adding message to BleTx: $message");
        add(BleTx(message: message));
      }
    }
  }

  void _sendGetLockMessage() {
    Packet packet = Packet();
    Map<String, bool> flags = {"requestAck": true, "encrypted": false, "compressed": false};
    ControlEnvelope controlEnvelope = ControlEnvelope.create();
    controlEnvelope.command = Command.GET_LOCK;

    // create payload
    List<int> payload = controlEnvelope.writeToBuffer();
    print("Payload: $payload");
    List<List<int>>? txPackets = packet.buildTxPacket(streamId: PacketStreamIdEnum.control, flags: flags, payload: payload);

    // add to queue message
    if (txPackets != null) {
      for (List<int> message in txPackets) {
        print("Adding message to BleTx: $message");
        add(BleTx(message: message));
      }
    }
  }

  void _sendSetDosageMessage(int dosage) {
    Packet packet = Packet();
    Map<String, bool> flags = {"requestAck": true, "encrypted": false, "compressed": false};
    ControlEnvelope controlEnvelope = ControlEnvelope.create();
    controlEnvelope.command = Command.SET_DOSAGE;

    SetDosage setDosage = SetDosage.create();
    setDosage.dosage = dosage;
    controlEnvelope.setDosage = setDosage;

    // create payload
    List<int> payload = controlEnvelope.writeToBuffer();
    print("Payload: $payload");
    List<List<int>>? txPackets = packet.buildTxPacket(streamId: PacketStreamIdEnum.control, flags: flags, payload: payload);

    // add to queue message
    if (txPackets != null) {
      for (List<int> message in txPackets) {
        print("Adding message to BleTx: $message");
        add(BleTx(message: message));
      }
    }
  }

  void _sendSetTemperatureMessage(int temperature) {
    Packet packet = Packet();
    Map<String, bool> flags = {"requestAck": true, "encrypted": false, "compressed": false};
    ControlEnvelope controlEnvelope = ControlEnvelope.create();
    controlEnvelope.command = Command.SET_TEMPERATURE;

    SetTemperature setTemperature = SetTemperature.create();
    setTemperature.temperature = temperature;
    controlEnvelope.setTemperature = setTemperature;

    // create payload
    List<int> payload = controlEnvelope.writeToBuffer();
    print("Payload: $payload");
    List<List<int>>? txPackets = packet.buildTxPacket(streamId: PacketStreamIdEnum.control, flags: flags, payload: payload);

    // add to queue message
    if (txPackets != null) {
      for (List<int> message in txPackets) {
        print("Adding message to BleTx: $message");
        add(BleTx(message: message));
      }
    }
  }

  void _sendSetLockMessage(LockStatus isLocked) {
    Packet packet = Packet();
    Map<String, bool> flags = {"requestAck": true, "encrypted": false, "compressed": false};
    ControlEnvelope controlEnvelope = ControlEnvelope.create();
    controlEnvelope.command = Command.SET_LOCK;

    SetLock setLock = SetLock.create();
    setLock.status = isLocked;
    controlEnvelope.setLock = setLock;

    // create payload
    List<int> payload = controlEnvelope.writeToBuffer();
    print("Payload: $payload");
    List<List<int>>? txPackets = packet.buildTxPacket(streamId: PacketStreamIdEnum.control, flags: flags, payload: payload);

    // add to queue message
    if (txPackets != null) {
      for (List<int> message in txPackets) {
        print("Adding message to BleTx: $message");
        add(BleTx(message: message));
      }
    }
  }

  void _sendSetCartStatusMessage(Mutable_StatusType status) {
    Packet packet = Packet();
    Map<String, bool> flags = {"requestAck": true, "encrypted": false, "compressed": false};
    ControlEnvelope controlEnvelope = ControlEnvelope.create();
    controlEnvelope.command = Command.SET_CART_STATUS;

    SetCartStatus setCartStatus = SetCartStatus.create();
    setCartStatus.status = status;
    controlEnvelope.setCartStatus = setCartStatus;

    // create payload
    List<int> payload = controlEnvelope.writeToBuffer();
    print("Payload: $payload");
    List<List<int>>? txPackets = packet.buildTxPacket(streamId: PacketStreamIdEnum.control, flags: flags, payload: payload);

    // add to queue message
    if (txPackets != null) {
      for (List<int> message in txPackets) {
        print("Adding message to BleTx: $message");
        add(BleTx(message: message));
      }
    }
  }

  Future<void> dispose() async {
    if (state.state == DeviceConnectionState.connected) {
      await state.connection?.cancel();
    }
    //bleRepository.disconnectFromDevice(state.connection!);
  }
}