import 'dart:convert';

import 'package:amplify_datastore/amplify_datastore.dart';
import 'package:amplify_flutter/amplify.dart';
import 'package:kazu_app/generated/telemetry.pb.dart';
import 'package:kazu_app/models/PuffEvent.dart';
import 'package:kazu_app/models/User.dart';

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

  Future<PuffEvent> createPuffEvent({required String userId, required Telemetry telemetry}) async {
    try {
      if (telemetry.whichPayload() == Telemetry_Payload.puffEvent) {
        String json = telemetry.writeToJson();
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
      }
    } catch (e) {
      rethrow;
    }
    return PuffEvent();
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
}