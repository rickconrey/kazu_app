import 'dart:collection';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';

import 'cobs.dart';
import 'package:kazu_app/generated/telemetry.pb.dart';

enum TransactionTypeEnum {
  transactionInitial,
  transactionContinue,
  transactionFinal,
  transactionControl,
}

enum PacketStreamIdEnum {
  control,
  data,
  reserved,
  reserved2,
}

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

  static List<int> lastTransactionId = [0xFF, 0xFF];

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

  int _getNextTransactionId(PacketStreamIdEnum id) {
    lastTransactionId[id.index] = (lastTransactionId[id.index] + 1) & 0x0F;
    return lastTransactionId[id.index];
  }

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

    if (transactionType == TransactionTypeEnum.transactionInitial.index) {
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

  List<List<int>>? buildTxPacket({required PacketStreamIdEnum streamId, required Map<String, bool> flags, required List<int> payload}) {
    if (payload.length > 0xFFFF) {
      return null;
    }
    int _mtuSize = 42;
    int _remainingSize = payload.length;
    int _sequenceNumber = 0;
    int _transactionId = 0;
    int _srcIndex = 0;
    List<List<int>> _packetList = [];

    while(_remainingSize > 0) {
      int _currentPacketHeaderSize = 3;
      TransactionTypeEnum _transactionType = TransactionTypeEnum
          .transactionContinue;
      if (_srcIndex == 0) {
        _transactionType = TransactionTypeEnum.transactionInitial;
        _transactionId = _getNextTransactionId(streamId);
        _currentPacketHeaderSize += 3;
      }

      int _currentPacketPayloadSize = min(
          _mtuSize - _currentPacketHeaderSize, _remainingSize);

      if (_transactionType == TransactionTypeEnum.transactionContinue &&
          _currentPacketPayloadSize == _remainingSize) {
        _transactionType = TransactionTypeEnum.transactionFinal;
      }

      _transactionType = TransactionTypeEnum.transactionControl;
      int _currentPacketSize = _currentPacketHeaderSize +
          _currentPacketPayloadSize;
      List<int> _buffer = [];

      int _dstIndex = 0;
      _buffer.add(0);
      _buffer[_dstIndex] = (streamId.index & streamIdMask) << streamIdShift;
      _buffer[_dstIndex] |=
          (_transactionId & transactionIdMask) << transactionIdShift;
      _buffer[_dstIndex] |=
          (_transactionType.index & transactionTypeMask) << transactionTypeShift;
      _dstIndex += 1;
      _buffer.add(0);
      _buffer[_dstIndex] =
          (_sequenceNumber & sequenceNumberMask) << sequenceNumberShift;
      _sequenceNumber = (_sequenceNumber + 1) & sequenceNumberMask;
      _buffer[_dstIndex] |= (flags["requestAck"]! ? (1 << ackBitShift) : 0);
      _buffer[_dstIndex] |= (flags["encrypted"]! ? (1 << encryptedBitShift) : 0);
      _buffer[_dstIndex] |=
      (flags["compressed"]! ? (1 << compressedBitShift) : 0);
      _dstIndex += 1;
      _buffer.add(0);

      if (_transactionType == TransactionTypeEnum.transactionInitial || _transactionType == TransactionTypeEnum.transactionControl) {
        _dstIndex += 1;
        _buffer.add(payload.length >> 8);
        _dstIndex += 1;
        _buffer.add(payload.length & 0x00FF);
      }

      _buffer.add(_currentPacketPayloadSize);
      _dstIndex += 1;
      _buffer += payload.sublist(_srcIndex, _currentPacketPayloadSize);
      _dstIndex += _currentPacketPayloadSize;
      _srcIndex += _currentPacketPayloadSize;

      _packetList.add(_buffer);
      _remainingSize -= _currentPacketPayloadSize;
    }

    return _packetList;
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
    if (packet.transactionType == TransactionTypeEnum.transactionInitial.index) {
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
      if (packet.transactionType == TransactionTypeEnum.transactionFinal.index ||
          packet.transactionType == TransactionTypeEnum.transactionInitial.index)
      {
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