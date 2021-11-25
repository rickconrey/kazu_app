import 'dart:collection';
import 'dart:io';

import 'package:flutter/material.dart';

import 'cobs.dart';
import 'package:kazu_app/generated/telemetry.pb.dart';

class Packet {
  static const int streamIdMask = 0x03;
  static const int transactionIdMask = 0x0F;
  static const int transactionTypeMask = 0x03;
  static const int sequenceNumberMask = 0x0F;
  static const int streamIdShift = 6;
  static const int transactionIdShift = 2;
  static const int transactionTypeShift = 0;
  static const int sequenceNumberShift = 4;
  static const int ackBitShift = 3;
  static const int compressedBitShift = 2;
  static const int encryptedBitShift = 1;

  int streamId = 0;
  int transactionId = 0;
  int transactionType =0;
  int sequenceNumber = 0;
  bool ackRequested = false;
  bool isEncrypted = false;
  bool isCompressed = false;
  int bufferSize = 0;
  int payloadSize = 0;
  List<int> data = [];
  List<int> rawData = [];

  Packet() : super();

  void processRx(List<int> packetData) {
    int idx = 0;
    streamId = (packetData[idx] >> streamIdShift) & streamIdMask;
    transactionId = (packetData[idx] >> transactionIdShift) & transactionIdMask;
    transactionType = (packetData[idx] >> transactionTypeShift) & transactionTypeMask;
    idx += 1;
    sequenceNumber = (packetData[idx] >> sequenceNumberShift) & sequenceNumberMask;
    ackRequested = (packetData[idx] & (1 << ackBitShift)) != 0;
    isEncrypted = (packetData[idx] & (1 << encryptedBitShift)) != 0;
    isCompressed = (packetData[idx] & (1 << compressedBitShift)) != 0;
    idx += 1;

    if (transactionType == 0) { // todo: hardcode transaction transactionType
      idx += 1; // eat reserved byte
      bufferSize = (packetData[idx] << 8);
      idx += 1;
      bufferSize |= packetData[idx];
      idx += 1;
    }

    payloadSize = packetData[idx];
    idx += 1;
    data = packetData.sublist(idx);
    rawData = packetData;

  }
}

class ProcessPacket {
  int transactionId = 0;
  int streamId = 0;
  int bufferSize = 0;
  int sequenceNumber = 0;
  List<int> data = [];

  ProcessPacket() : super();

  List<int>? processPacket(Packet packet) {
    if (packet.transactionType == 0) {
      transactionId = packet.transactionId;
      streamId = packet.streamId;
      bufferSize = packet.bufferSize;
      sequenceNumber = packet.sequenceNumber;
    }

    if (transactionId != packet.transactionId) {
      print("Error, transactionId mismatch. $transactionId, ${packet.transactionId}");
      reset();
    }

    if (streamId != packet.streamId) {
      print("Error, streamId mismatch. $streamId, ${packet.streamId}");
      reset();
    }

    if (sequenceNumber != packet.sequenceNumber) {
      print("Error, sequenceNumber mismatch. $sequenceNumber, ${packet.sequenceNumber}");
      reset();
    }

    data += packet.data;

    sequenceNumber = (sequenceNumber + 1) & 0x0F;

    print("Transaction Id $transactionId :: type ${packet.transactionType} :: stream id $streamId :: sequence number $sequenceNumber :: buffer size $bufferSize");
    if (data.length == bufferSize) {
      if (packet.transactionType == 2 || packet.transactionType == 0) {
       print("Found complete packet of size $bufferSize");
       List<int> result = List.from(data);
       reset();
       return result;
      } else {
        print("Error, invalid transaction");
        reset();
      }
      data.clear();
      reset();
    } else if (data.length > bufferSize) {
      print("Error, invalid length, ${data.length}, $bufferSize");
      data.clear();
      reset();
    }
    return null;
  }

  void reset() {
    transactionId = 0;
    streamId = 0;
    bufferSize = 0;
    sequenceNumber = 0;
    data.clear();
  }
}