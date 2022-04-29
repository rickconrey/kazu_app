import 'dart:convert';

import 'package:amplify_datastore/amplify_datastore.dart';
//import 'package:amplify_flutter/amplify.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:kazu_app/generated/control.pb.dart';
import 'package:kazu_app/generated/telemetry.pb.dart';
import 'package:kazu_app/models/DeviceLockStatus.dart';
import 'package:kazu_app/models/PuffEvent.dart';
import 'package:kazu_app/models/ChargeEvent.dart';
import 'package:kazu_app/models/ResetEvent.dart';
import 'package:kazu_app/models/CartridgeEvent.dart';
import 'package:kazu_app/models/User.dart';
import 'package:rxdart/rxdart.dart';

import '../models/Cartridge.dart';
import '../models/Device.dart';

class DataRepository {
  Future<User?> getUserById(String userId) async {
    try {
      final users = await Amplify.DataStore.query(
        User.classType,
        where: User.ID.eq(userId),
      );
      return users.isNotEmpty ? users.first : null;
    } catch (e) {
      rethrow;
    }
  }

  Future<User> createUser({required String userId, required String username, String? email}) async {
    final newUser = User(id: userId, username: username, email: email, dateCreated: TemporalDateTime.now());
    try {
      await Amplify.DataStore.save(newUser);
      return newUser;
    } catch (e) {
      rethrow;
    }
  }

  Future<User> updateUser(User updatedUser) async {
    try {
      await Amplify.DataStore.save(updatedUser);
      return updatedUser;
    } catch (e) {
      rethrow;
    }
  }

  Future<Device> createDeviceFromProto({required DeviceInformation information, required String userId}) async {
    Device device;
    String deviceId = "";
    for (int i in information.id) {
      deviceId += i.toRadixString(16).padLeft(2, '0') + ":";
    }
    deviceId = deviceId.substring(0, deviceId.length - 1);
    Device? savedDevice = await getDeviceByDeviceId(deviceId: deviceId);
    DeviceLockStatus lockStatus;
    switch (information.lockStatus) {
      case LockStatus.LOCKED:
        lockStatus = DeviceLockStatus.LOCKED;
        break;
      case LockStatus.UNLOCKED:
        lockStatus = DeviceLockStatus.UNLOCKED;
        break;
      default:
        lockStatus = DeviceLockStatus.UNKNOWN;
        break;
    }
    int vbat = (((information.adcData.vbat << 1) * 1000) ~/ 1365);

    if (savedDevice == null) {
      device = Device(
        userId: userId,
        deviceId: deviceId,
        imageLibraryVersion: information.imageLibraryVersion,
        firmwareVersion: information.firmwareVersion,
        dose: information.dosage,
        temperature: information.temperature,
        lockStatus: lockStatus,
        batteryLevel: vbat,
        bleName: information.bleName,
        lastSynced: TemporalTimestamp.now(),
      );
    } else {
      device = savedDevice.copyWith(
        userId: userId,
        deviceId: deviceId,
        imageLibraryVersion: information.imageLibraryVersion,
        firmwareVersion: information.firmwareVersion,
        dose: information.dosage,
        temperature: information.temperature,
        lockStatus: lockStatus,
        batteryLevel: vbat,
        bleName: information.bleName,
        lastSynced: TemporalTimestamp.now(),
      );
    }

    try {
      await Amplify.DataStore.save(device);
      return device;
    } catch (e) {
      rethrow;
    }
  }

  Future<Device> updateDevice(Device device) async {
    try {
      await Amplify.DataStore.save(device);
      return device;
    } catch (e) {
      rethrow;
    }
  }

  Future<Device?> getDeviceByDeviceId({required String deviceId}) async {
    try {
      final devices = await Amplify.DataStore.query(
        Device.classType,
        where: Device.DEVICEID.eq(deviceId),
      );
      return devices.isNotEmpty ? devices.first : null;
    } catch (e) {
      rethrow;
    }
  }

  Future<String?> getDeviceIdByUserId({required String userId}) async {
    try {
      final devices = await Amplify.DataStore.query(
        Device.classType,
        where: Device.USERID.eq(userId),
        sortBy: [Device.LASTSYNCED.descending()],
      );
      return devices.isNotEmpty ? devices.first.deviceId : null;
    } catch (e) {
      rethrow;
    }
  }

  Future<Device?> getDeviceById({required String id}) async {
    try {
      final devices = await Amplify.DataStore.query(
        Device.classType,
        where: Device.ID.eq(id),
      );
      return devices.isNotEmpty ? devices.first : null;
    } catch (e) {
      rethrow;
    }
  }

  Future<Cartridge?> getCartridgeByCartridgeId({required String cartridgeId}) async {
    try {
      final cartridges = await Amplify.DataStore.query(
        Cartridge.classType,
        where: Cartridge.CARTRIDGEID.eq(cartridgeId),
      );
      return cartridges.isNotEmpty ? cartridges.first : null;
    } catch (e) {
      rethrow;
    }
  }

  Future<Cartridge?> getCartridgeById({required String id}) async {
    try {
      final cartridges = await Amplify.DataStore.query(
        Cartridge.classType,
        where: Device.ID.eq(id),
      );
      return cartridges.isNotEmpty ? cartridges.first : null;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> createEvent({required String userId, required Telemetry telemetry}) async {
    switch (telemetry.whichPayload()) {
      case Telemetry_Payload.puffEvent:
        createPuffEvent(userId: userId, telemetry: telemetry);
        break;
      case Telemetry_Payload.cartridgeEvent:
        createCartridgeEvent(userId: userId, telemetry: telemetry);
        break;
      case Telemetry_Payload.chargeEvent:
        createChargeEvent(userId: userId, telemetry: telemetry);
        break;
      case Telemetry_Payload.resetEvent:
        createResetEvent(userId: userId, telemetry: telemetry);
        break;
    }
  }

  Future<void> processControlResponse({required String userId, required ControlEnvelope controlEnvelope}) async {
    print(controlEnvelope);
    if (controlEnvelope.whichPayload() == ControlEnvelope_Payload.response) {
      switch (controlEnvelope.response.whichPayload()) {
        case Response_Payload.deviceInformation:
          createDeviceFromProto(
            information: controlEnvelope.response.deviceInformation,
            userId: userId,
          );
          break;
        case Response_Payload.rtcInformation:
          break;
        case Response_Payload.cartridgeInformation:
          break;
        default:
          break;
      }
    }
  }

  Future<ResetEvent> createResetEvent({required String userId, required Telemetry telemetry}) async {
    try {
      String json = jsonEncode(telemetry.toProto3Json());
      TemporalTimestamp time = TemporalTimestamp.fromSeconds(
          telemetry.time);
      String deviceId = await getDeviceIdByUserId(userId: userId) ?? "";
      bool lowpower = telemetry.resetEvent.lowpower;
      bool watchdog = telemetry.resetEvent.iwdg;
      bool brownout = telemetry.resetEvent.bor;
      bool software = telemetry.resetEvent.software;

      String reason = "";
      if (lowpower) {
        reason += "Lowpower ";
      }
      if (watchdog) {
        reason += "watchdog ";
      }
      if (brownout) {
        reason += "brownout ";
      }
      if (software) {
        reason += "software ";
      }

      reason.trim();

      final event = ResetEvent(
        userId: userId,
        id: UUID.getUUID(),
        deviceId: deviceId,
        time: time,
        json: json,
        reason: reason,
      );
      await Amplify.DataStore.save(event);
      return event;
    } catch (e) {
      rethrow;
    }
  }

  Future<CartridgeEvent> createCartridgeEvent({required String userId, required Telemetry telemetry}) async {
    try {
      String json = jsonEncode(telemetry.toProto3Json());
      TemporalTimestamp time = TemporalTimestamp.fromSeconds(
          telemetry.time);
      String deviceId = await getDeviceIdByUserId(userId: userId) ?? "";
      int doseNumber = telemetry.cartridgeEvent.doseNumber;
      int position = telemetry.cartridgeEvent.encoderPosition;
      int measuredResistance = telemetry.cartridgeEvent.measuredResistance;
      //List<int> cartridgeId = telemetry.cartridgeEvent.cartridgeId;
      String cartridgeId = ""; //telemetry.cartridgeEvent.cartridgeId;
      for (int i in telemetry.cartridgeEvent.cartridgeId) {
        cartridgeId += i.toRadixString(16).padLeft(2, '0') + ":";
      }
      cartridgeId = cartridgeId.substring(0, cartridgeId.length - 1);
      bool attached = telemetry.cartridgeEvent.cartDetected;
      bool empty = telemetry.cartridgeEvent.empty;

      final event = CartridgeEvent(
        userId: userId,
        id: UUID.getUUID(),
        deviceId: deviceId,
        cartridgeId: cartridgeId,
        attached: attached,
        empty: empty,
        time: time,
        measuredResistance: measuredResistance,
        doseNumber: doseNumber,
        position: position,
        json: json,
      );
      await Amplify.DataStore.save(event);
      return event;
    } catch (e) {
      rethrow;
    }
  }

  Future<ChargeEvent> createChargeEvent({required String userId, required Telemetry telemetry}) async {
    try {
      String json = jsonEncode(telemetry.toProto3Json());
      TemporalTimestamp time = TemporalTimestamp.fromSeconds(
          telemetry.time);
      String deviceId = await getDeviceIdByUserId(userId: userId) ?? "";
      int adcVbat = telemetry.chargeEvent.adcVbat;
      bool charging = telemetry.chargeEvent.usbDetected;

      final event = ChargeEvent(
        userId: userId,
        id: UUID.getUUID(),
        deviceId: deviceId,
        time: time,
        json: json,
        adcVbat: adcVbat,
        charging: charging,
      );
      await Amplify.DataStore.save(event);
      return event;
    } catch (e) {
      rethrow;
    }
  }

  Future<PuffEvent> createPuffEvent({required String userId, required Telemetry telemetry}) async {
    try {
      String json = jsonEncode(telemetry.toProto3Json());
      TemporalTimestamp time = TemporalTimestamp.fromSeconds(
          telemetry.time);
      //List<int> cartridgeId = telemetry.puffEvent.cartridgeId;
      String cartridgeId = ""; //telemetry.cartridgeEvent.cartridgeId;
      for (int i in telemetry.cartridgeEvent.cartridgeId) {
        cartridgeId += i.toRadixString(16).padLeft(2, '0') + ":";
      }
      if (cartridgeId.length > 1) {
        cartridgeId = cartridgeId.substring(0, cartridgeId.length - 1);
      }
      String deviceId = await getDeviceIdByUserId(userId: userId) ?? "";
      int duration = telemetry.puffEvent.duration;
      int doseNumber = telemetry.puffEvent.doseNumber;
      int amount = telemetry.puffEvent.amount;

      final event = PuffEvent(
        userId: userId,
        id: UUID.getUUID(),
        cartridgeId: cartridgeId,
        deviceId: deviceId,
        time: time,
        json: json,
        duration: duration,
        doseNumber: doseNumber,
        amount: amount,
      );
      await Amplify.DataStore.save(event);
      return event;
    } catch (e) {
      rethrow;
    }
  }
  
  Future<List<PuffEvent>?> getLatestPuffEvents() async {
    try {
      final puffEvents = await Amplify.DataStore.query(
        PuffEvent.classType,
      );
      print("Found ${puffEvents.length} puff events");
      return puffEvents.isNotEmpty ? puffEvents : null;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<PuffEvent>?> getPuffEventsByDateRange(String userId, int startTime, int endTime) async {
    try {
      final puffEvents = await Amplify.DataStore.query(
        PuffEvent.classType,
        where: PuffEvent.USERID.eq(userId).and(PuffEvent.TIME.gt(startTime)).and(PuffEvent.TIME.lt(endTime)),
      );
      return puffEvents.isNotEmpty ? puffEvents : null;
    } catch (e) {
      rethrow;
    }
  }

  Stream<QuerySnapshot<PuffEvent>> puffEventStream(String userId, bool onlyUserId) {
    if (onlyUserId == true) {
      return Amplify.DataStore.observeQuery(
        PuffEvent.classType,
        where: PuffEvent.USERID.eq(userId),
        sortBy: [PuffEvent.TIME.descending()],
      );
    }
    return Amplify.DataStore.observeQuery(
      PuffEvent.classType,
      where: PuffEvent.USERID.ne(userId),
      sortBy: [PuffEvent.TIME.descending()],
    );
  }

  Stream<QuerySnapshot<ResetEvent>> resetEventStream(String userId, bool onlyUserId) {
    if (onlyUserId == true) {
      return Amplify.DataStore.observeQuery(
        ResetEvent.classType,
        where: ResetEvent.USERID.eq(userId),
        sortBy: [ResetEvent.TIME.descending()],
      );
    }
    return Amplify.DataStore.observeQuery(
      ResetEvent.classType,
      where: ResetEvent.USERID.ne(userId),
      sortBy: [ResetEvent.TIME.descending()],
    );
  }

  Stream<QuerySnapshot<CartridgeEvent>> cartridgeEventStream(String userId, bool onlyUserId) {
    if (onlyUserId == true) {
      return Amplify.DataStore.observeQuery(
        CartridgeEvent.classType,
        where: CartridgeEvent.USERID.eq(userId),
        sortBy: [CartridgeEvent.TIME.descending()],
      );
    }
    return Amplify.DataStore.observeQuery(
      CartridgeEvent.classType,
      where: CartridgeEvent.USERID.ne(userId),
      sortBy: [CartridgeEvent.TIME.descending()],
    );
  }

  Stream<QuerySnapshot<ChargeEvent>> chargeEventStream(String userId, bool onlyUserId) {
    if (onlyUserId == true) {
      return Amplify.DataStore.observeQuery(
        ChargeEvent.classType,
        where: ChargeEvent.USERID.eq(userId),
        sortBy: [ChargeEvent.TIME.descending()],
      );
    }
    return Amplify.DataStore.observeQuery(
      ChargeEvent.classType,
      where: ChargeEvent.USERID.ne(userId),
      sortBy: [ChargeEvent.TIME.descending()],
    );
  }

  Stream<QuerySnapshot<Device>> deviceStream(String userId) {
    return Amplify.DataStore.observeQuery(
      Device.classType,
      where: Device.USERID.eq(userId),
      sortBy: [Device.LASTSYNCED.descending()],
    );
  }

  //Stream<QuerySnapshot> getEventsStream() {
  //  Stream<QuerySnapshot<PuffEvent>> _puffStream = puffEventStream();
  //  Stream<QuerySnapshot<CartridgeEvent>> _cartridgeStream = cartridgeEventStream();
  //  Stream<QuerySnapshot<ChargeEvent>> _chargeStream = chargeEventStream();
  //  Stream<QuerySnapshot<ResetEvent>> _resetStream = resetEventStream();

  //  return Rx.merge([_puffStream, _cartridgeStream, _chargeStream, _resetStream]);
  //}

  Stream<QuerySnapshot> getUserEventsStream(String userId) {
    Stream<QuerySnapshot<PuffEvent>> _puffStream = puffEventStream(userId, true);
    Stream<QuerySnapshot<CartridgeEvent>> _cartridgeStream = cartridgeEventStream(userId, true);
    Stream<QuerySnapshot<ChargeEvent>> _chargeStream = chargeEventStream(userId, true);
    Stream<QuerySnapshot<ResetEvent>> _resetStream = resetEventStream(userId, true);

    return Rx.merge([_puffStream, _cartridgeStream, _chargeStream, _resetStream]);
  }

  Stream<QuerySnapshot> getFeedEventsStream(String userId) {
    Stream<QuerySnapshot<PuffEvent>> _puffStream = puffEventStream(userId, false);
    Stream<QuerySnapshot<CartridgeEvent>> _cartridgeStream = cartridgeEventStream(userId, false);
    Stream<QuerySnapshot<ChargeEvent>> _chargeStream = chargeEventStream(userId, false);
    Stream<QuerySnapshot<ResetEvent>> _resetStream = resetEventStream(userId, false);

    return Rx.merge([_puffStream, _cartridgeStream, _chargeStream, _resetStream]);
  }

  Stream<QuerySnapshot> getDeviceStreamByUserId(String userId) {
    Stream<QuerySnapshot<Device>> _deviceStream = deviceStream(userId);

    return _deviceStream;
  }

  //void startEventStreamListener() {
  //  Stream<QuerySnapshot<PuffEvent>> _puffStream = puffEventStream();
  //  Stream<QuerySnapshot<CartridgeEvent>> _cartridgeStream = cartridgeEventStream();
  //  Stream<QuerySnapshot<ChargeEvent>> _chargeStream = chargeEventStream();
  //  Stream<QuerySnapshot<ResetEvent>> _resetStream = resetEventStream();

  //  Rx.merge([_puffStream, _cartridgeStream, _chargeStream, _resetStream]).listen((event) {

  //  });
  //}
}