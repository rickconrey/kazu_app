import 'dart:convert';

import 'package:amplify_datastore/amplify_datastore.dart';
import 'package:amplify_flutter/amplify.dart';
import 'package:kazu_app/generated/telemetry.pb.dart';
import 'package:kazu_app/models/PuffEvent.dart';
import 'package:kazu_app/models/ChargeEvent.dart';
import 'package:kazu_app/models/ResetEvent.dart';
import 'package:kazu_app/models/CartridgeEvent.dart';
import 'package:kazu_app/models/User.dart';
import 'package:rxdart/rxdart.dart';

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

  Future<ResetEvent> createResetEvent({required String userId, required Telemetry telemetry}) async {
    try {
      String json = jsonEncode(telemetry.toProto3Json());
      TemporalTimestamp time = TemporalTimestamp.fromSeconds(
          telemetry.time);
      String deviceId = "0"; // todo: get device id
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
      String deviceId = "0"; // todo: get device id
      int doseNumber = telemetry.cartridgeEvent.doseNumber;
      int position = telemetry.cartridgeEvent.encoderPosition;
      int measuredResistance = telemetry.cartridgeEvent.measuredResistance;
      List<int> cartridgeId = telemetry.cartridgeEvent.cartridgeId;
      bool attached = telemetry.cartridgeEvent.cartDetected;
      bool empty = telemetry.cartridgeEvent.empty;

      final event = CartridgeEvent(
        userId: userId,
        id: UUID.getUUID(),
        deviceId: deviceId,
        cartridgeId: cartridgeId.toString(),
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
      String deviceId = "0"; // todo: get device id
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
      List<int> cartridgeId = telemetry.puffEvent.cartridgeId;
      String deviceId = "0"; // todo: get device id
      int duration = telemetry.puffEvent.duration;
      int doseNumber = telemetry.puffEvent.doseNumber;

      final event = PuffEvent(
        userId: userId,
        id: UUID.getUUID(),
        cartridgeId: cartridgeId.toString(),
        deviceId: deviceId,
        time: time,
        json: json,
        duration: duration,
        doseNumber: doseNumber,
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

  Stream<QuerySnapshot<PuffEvent>> puffEventStream() {
    return Amplify.DataStore.observeQuery(
      PuffEvent.classType,
      sortBy: [PuffEvent.TIME.descending()],
    );
  }

  Stream<QuerySnapshot<ResetEvent>> resetEventStream() {
    return Amplify.DataStore.observeQuery(
      ResetEvent.classType,
      sortBy: [ResetEvent.TIME.descending()],
    );
  }

  Stream<QuerySnapshot<CartridgeEvent>> cartridgeEventStream() {
    return Amplify.DataStore.observeQuery(
      CartridgeEvent.classType,
      sortBy: [CartridgeEvent.TIME.descending()],
    );
  }

  Stream<QuerySnapshot<ChargeEvent>> chargeEventStream() {
    return Amplify.DataStore.observeQuery(
      ChargeEvent.classType,
      sortBy: [ChargeEvent.TIME.descending()],
    );
  }

  Stream<QuerySnapshot> getEventsStream() {
    Stream<QuerySnapshot<PuffEvent>> _puffStream = puffEventStream();
    Stream<QuerySnapshot<CartridgeEvent>> _cartridgeStream = cartridgeEventStream();
    Stream<QuerySnapshot<ChargeEvent>> _chargeStream = chargeEventStream();
    Stream<QuerySnapshot<ResetEvent>> _resetStream = resetEventStream();

    //return Rx.combineLatest4(_puffStream, _cartridgeStream, _chargeStream, _resetStream, (a, b, c, d) {
    //  List<dynamic> events = [];
    //  return events;
    //});

    //return Rx.merge([_puffStream, _cartridgeStream, _chargeStream, _resetStream]);
    return Rx.merge([_puffStream, _cartridgeStream, _chargeStream, _resetStream]);
  }

  void startEventStreamListener() {
    Stream<QuerySnapshot<PuffEvent>> _puffStream = puffEventStream();
    Stream<QuerySnapshot<CartridgeEvent>> _cartridgeStream = cartridgeEventStream();
    Stream<QuerySnapshot<ChargeEvent>> _chargeStream = chargeEventStream();
    Stream<QuerySnapshot<ResetEvent>> _resetStream = resetEventStream();

    Rx.merge([_puffStream, _cartridgeStream, _chargeStream, _resetStream]).listen((event) {

    });
  }
}