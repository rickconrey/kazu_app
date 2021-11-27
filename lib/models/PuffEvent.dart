/*
* Copyright 2021 Amazon.com, Inc. or its affiliates. All Rights Reserved.
*
* Licensed under the Apache License, Version 2.0 (the "License").
* You may not use this file except in compliance with the License.
* A copy of the License is located at
*
*  http://aws.amazon.com/apache2.0
*
* or in the "license" file accompanying this file. This file is distributed
* on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either
* express or implied. See the License for the specific language governing
* permissions and limitations under the License.
*/

// NOTE: This file is generated and may not follow lint rules defined in your app
// Generated files can be excluded from analysis in analysis_options.yaml
// For more info, see: https://dart.dev/guides/language/analysis-options#excluding-code-from-analysis

// ignore_for_file: public_member_api_docs, file_names, unnecessary_new, prefer_if_null_operators, prefer_const_constructors, slash_for_doc_comments, annotate_overrides, non_constant_identifier_names, unnecessary_string_interpolations, prefer_adjacent_string_concatenation, unnecessary_const, dead_code

import 'package:amplify_datastore_plugin_interface/amplify_datastore_plugin_interface.dart';
import 'package:flutter/foundation.dart';


/** This is an auto generated class representing the PuffEvent type in your schema. */
@immutable
class PuffEvent extends Model {
  static const classType = const _PuffEventModelType();
  final String id;
  final String? _userId;
  final TemporalTimestamp? _time;
  final String? _json;
  final String? _cartridgeId;
  final String? _deviceId;
  final int? _duration;
  final int? _doseNumber;
  final int? _amount;

  @override
  getInstanceType() => classType;
  
  @override
  String getId() {
    return id;
  }
  
  String? get userId {
    return _userId;
  }
  
  TemporalTimestamp? get time {
    return _time;
  }
  
  String? get json {
    return _json;
  }
  
  String? get cartridgeId {
    return _cartridgeId;
  }
  
  String? get deviceId {
    return _deviceId;
  }
  
  int? get duration {
    return _duration;
  }
  
  int? get doseNumber {
    return _doseNumber;
  }
  
  int? get amount {
    return _amount;
  }
  
  const PuffEvent._internal({required this.id, userId, time, json, cartridgeId, deviceId, duration, doseNumber, amount}): _userId = userId, _time = time, _json = json, _cartridgeId = cartridgeId, _deviceId = deviceId, _duration = duration, _doseNumber = doseNumber, _amount = amount;
  
  factory PuffEvent({String? id, String? userId, TemporalTimestamp? time, String? json, String? cartridgeId, String? deviceId, int? duration, int? doseNumber, int? amount}) {
    return PuffEvent._internal(
      id: id == null ? UUID.getUUID() : id,
      userId: userId,
      time: time,
      json: json,
      cartridgeId: cartridgeId,
      deviceId: deviceId,
      duration: duration,
      doseNumber: doseNumber,
      amount: amount);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PuffEvent &&
      id == other.id &&
      _userId == other._userId &&
      _time == other._time &&
      _json == other._json &&
      _cartridgeId == other._cartridgeId &&
      _deviceId == other._deviceId &&
      _duration == other._duration &&
      _doseNumber == other._doseNumber &&
      _amount == other._amount;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("PuffEvent {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("userId=" + "$_userId" + ", ");
    buffer.write("time=" + (_time != null ? _time!.toString() : "null") + ", ");
    buffer.write("json=" + "$_json" + ", ");
    buffer.write("cartridgeId=" + "$_cartridgeId" + ", ");
    buffer.write("deviceId=" + "$_deviceId" + ", ");
    buffer.write("duration=" + (_duration != null ? _duration!.toString() : "null") + ", ");
    buffer.write("doseNumber=" + (_doseNumber != null ? _doseNumber!.toString() : "null") + ", ");
    buffer.write("amount=" + (_amount != null ? _amount!.toString() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  PuffEvent copyWith({String? id, String? userId, TemporalTimestamp? time, String? json, String? cartridgeId, String? deviceId, int? duration, int? doseNumber, int? amount}) {
    return PuffEvent(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      time: time ?? this.time,
      json: json ?? this.json,
      cartridgeId: cartridgeId ?? this.cartridgeId,
      deviceId: deviceId ?? this.deviceId,
      duration: duration ?? this.duration,
      doseNumber: doseNumber ?? this.doseNumber,
      amount: amount ?? this.amount);
  }
  
  PuffEvent.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _userId = json['userId'],
      _time = json['time'] != null ? TemporalTimestamp.fromSeconds(json['time']) : null,
      _json = json['json'],
      _cartridgeId = json['cartridgeId'],
      _deviceId = json['deviceId'],
      _duration = (json['duration'] as num?)?.toInt(),
      _doseNumber = (json['doseNumber'] as num?)?.toInt(),
      _amount = (json['amount'] as num?)?.toInt();
  
  Map<String, dynamic> toJson() => {
    'id': id, 'userId': _userId, 'time': _time?.toSeconds(), 'json': _json, 'cartridgeId': _cartridgeId, 'deviceId': _deviceId, 'duration': _duration, 'doseNumber': _doseNumber, 'amount': _amount
  };

  static final QueryField ID = QueryField(fieldName: "puffEvent.id");
  static final QueryField USERID = QueryField(fieldName: "userId");
  static final QueryField TIME = QueryField(fieldName: "time");
  static final QueryField JSON = QueryField(fieldName: "json");
  static final QueryField CARTRIDGEID = QueryField(fieldName: "cartridgeId");
  static final QueryField DEVICEID = QueryField(fieldName: "deviceId");
  static final QueryField DURATION = QueryField(fieldName: "duration");
  static final QueryField DOSENUMBER = QueryField(fieldName: "doseNumber");
  static final QueryField AMOUNT = QueryField(fieldName: "amount");
  static var schema = Model.defineSchema(define: (ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "PuffEvent";
    modelSchemaDefinition.pluralName = "PuffEvents";
    
    modelSchemaDefinition.authRules = [
      AuthRule(
        authStrategy: AuthStrategy.PUBLIC,
        operations: [
          ModelOperation.CREATE,
          ModelOperation.UPDATE,
          ModelOperation.DELETE,
          ModelOperation.READ
        ])
    ];
    
    modelSchemaDefinition.addField(ModelFieldDefinition.id());
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: PuffEvent.USERID,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: PuffEvent.TIME,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.timestamp)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: PuffEvent.JSON,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: PuffEvent.CARTRIDGEID,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: PuffEvent.DEVICEID,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: PuffEvent.DURATION,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.int)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: PuffEvent.DOSENUMBER,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.int)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: PuffEvent.AMOUNT,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.int)
    ));
  });
}

class _PuffEventModelType extends ModelType<PuffEvent> {
  const _PuffEventModelType();
  
  @override
  PuffEvent fromJson(Map<String, dynamic> jsonData) {
    return PuffEvent.fromJson(jsonData);
  }
}