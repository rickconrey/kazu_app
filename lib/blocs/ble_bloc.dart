import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:kazu_app/events/ble_event.dart';
import 'package:kazu_app/generated/cartridge/mutable.pb.dart';
import 'package:kazu_app/generated/telemetry.pb.dart';
import 'package:kazu_app/generated/control.pb.dart';
import 'package:kazu_app/models/User.dart';
import 'package:kazu_app/repositories/ble_repository.dart';
import 'package:kazu_app/repositories/data_repository.dart';
import 'package:kazu_app/states/ble_state.dart';
import 'package:kazu_app/utils/cobs.dart';

import '../utils/packet.dart';

class BleBloc extends Bloc<BleEvent, BleState> {
  final BleRepository bleRepository;
  final DataRepository dataRepository;
  final Guid kazuServiceUuid = Guid("c6f9b530-b0b1-b2f4-5769-7469f5b2b1b0");
  final Guid kazuTxUuid = Guid("c6f9b531-b0b1-b2f4-5769-7469f5b2b1b0");
  final Guid kazuTxNotifyUuid = Guid("c6f9b532-b0b1-b2f4-5769-7469f5b2b1b0");
  final Guid kazuRxUuid = Guid("c6f9b533-b0b1-b2f4-5769-7469f5b2b1b0");

  BleBloc({
    required this.bleRepository,
    required this.dataRepository,
  }) : super (BleState());

  @override
  Stream<BleState> mapEventToState(BleEvent event) async* {
    if (event is BleScanRequest) {
      List<ScanResult> scanResults = [];
      yield state.copyWith(scanResults: scanResults);
      var scanListener = bleRepository.ble.scan(withServices: [Guid("8D53DC1D-1DB7-4CD3-868B-8A527460AA84")], timeout: const Duration(seconds: 4)).listen((result) {
        add(BleScanResult(result: result));
      });

    } else if (event is BleScanResult) {
      List<ScanResult> results = state.scanResults ?? [];
      if (results.contains(event.result) == false) {
        results.add(event.result!);
      }
      yield state.copyWith(scanResults: results);

    } else if (event is BleConnectRequest) {
      yield state.copyWith(device: event.device.device, user: event.user);
      await state.device?.connect();
      await state.device?.requestMtu(128);
      List<BluetoothService>? services = await state.device?.discoverServices();
      for (BluetoothService service in services!) {
        if (service.uuid == kazuServiceUuid) {
          print("Found kazu service: $kazuServiceUuid");
          for (BluetoothCharacteristic characteristic in service.characteristics) {
            if (characteristic.uuid == kazuRxUuid) {
              print("Found kazu Rx");
              yield state.copyWith(rx: characteristic);
            } else if (characteristic.uuid == kazuTxNotifyUuid) {
              print("Found kazu TxNotify");
              yield state.copyWith(txNotify: characteristic);
            } else if (characteristic.uuid == kazuTxUuid) {
              print("Found kazu Tx");
              yield state.copyWith(tx: characteristic);
            }
          }
        }
      }
      yield state.copyWith(services: services);

      add(BleConnected());

    } else if (event is BleConnected) {
      yield state.copyWith(isConnected: true);
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
      _sendGetDeviceInformationMessage();
      _sendSetRtcMessage();

      await state.txNotify?.setNotifyValue(true);
      state.txNotify?.value.listen((value) async {
        if (value.isNotEmpty) {
          if (state.tx != null) {
            //List<int>? data = await bleRepository.readFromDevice(state.tx!, state.bleLock);
            PacketResult? data = await bleRepository.readFromDevice(state.tx!, state.bleLock);
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
                );
              }
            }
          }
        }
      });
    } else if (event is BleTx) {
      try {
        if (event.message != null) {
          await state.rx?.write(event.message!);
        }
      } catch (e) {
        rethrow;
      }
    } else if (event is BleDisconnected) {
      state.txNotify?.setNotifyValue(false);
      if (state.device != null) {
        await bleRepository.disconnectFromDevice(state.device!);
        yield state.copyWith(isConnected: false);
      }
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
}