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


/** This is an auto generated class representing the CartridgeEvent type in your schema. */
@immutable
class CartridgeEvent extends Model {
  static const classType = const _CartridgeEventModelType();
  final String id;
  final TemporalTimestamp? _time;
  final String? _deviceId;
  final String? _userId;
  final String? _cartridgeId;
  final bool? _attached;
  final int? _position;
  final int? _doseNumber;
  final int? _measuredResistance;
  final bool? _empty;
  final String? _json;

  @override
  getInstanceType() => classType;
  
  @override
  String getId() {
    return id;
  }
  
  TemporalTimestamp? get time {
    return _time;
  }
  
  String? get deviceId {
    return _deviceId;
  }
  
  String? get userId {
    return _userId;
  }
  
  String? get cartridgeId {
    return _cartridgeId;
  }
  
  bool? get attached {
    return _attached;
  }
  
  int? get position {
    return _position;
  }
  
  int? get doseNumber {
    return _doseNumber;
  }
  
  int? get measuredResistance {
    return _measuredResistance;
  }
  
  bool? get empty {
    return _empty;
  }
  
  String? get json {
    return _json;
  }
  
  const CartridgeEvent._internal({required this.id, time, deviceId, userId, cartridgeId, attached, position, doseNumber, measuredResistance, empty, json}): _time = time, _deviceId = deviceId, _userId = userId, _cartridgeId = cartridgeId, _attached = attached, _position = position, _doseNumber = doseNumber, _measuredResistance = measuredResistance, _empty = empty, _json = json;
  
  factory CartridgeEvent({String? id, TemporalTimestamp? time, String? deviceId, String? userId, String? cartridgeId, bool? attached, int? position, int? doseNumber, int? measuredResistance, bool? empty, String? json}) {
    return CartridgeEvent._internal(
      id: id == null ? UUID.getUUID() : id,
      time: time,
      deviceId: deviceId,
      userId: userId,
      cartridgeId: cartridgeId,
      attached: attached,
      position: position,
      doseNumber: doseNumber,
      measuredResistance: measuredResistance,
      empty: empty,
      json: json);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CartridgeEvent &&
      id == other.id &&
      _time == other._time &&
      _deviceId == other._deviceId &&
      _userId == other._userId &&
      _cartridgeId == other._cartridgeId &&
      _attached == other._attached &&
      _position == other._position &&
      _doseNumber == other._doseNumber &&
      _measuredResistance == other._measuredResistance &&
      _empty == other._empty &&
      _json == other._json;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("CartridgeEvent {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("time=" + (_time != null ? _time!.toString() : "null") + ", ");
    buffer.write("deviceId=" + "$_deviceId" + ", ");
    buffer.write("userId=" + "$_userId" + ", ");
    buffer.write("cartridgeId=" + "$_cartridgeId" + ", ");
    buffer.write("attached=" + (_attached != null ? _attached!.toString() : "null") + ", ");
    buffer.write("position=" + (_position != null ? _position!.toString() : "null") + ", ");
    buffer.write("doseNumber=" + (_doseNumber != null ? _doseNumber!.toString() : "null") + ", ");
    buffer.write("measuredResistance=" + (_measuredResistance != null ? _measuredResistance!.toString() : "null") + ", ");
    buffer.write("empty=" + (_empty != null ? _empty!.toString() : "null") + ", ");
    buffer.write("json=" + "$_json");
    buffer.write("}");
    
    return buffer.toString();
  }
  
  CartridgeEvent copyWith({String? id, TemporalTimestamp? time, String? deviceId, String? userId, String? cartridgeId, bool? attached, int? position, int? doseNumber, int? measuredResistance, bool? empty, String? json}) {
    return CartridgeEvent(
      id: id ?? this.id,
      time: time ?? this.time,
      deviceId: deviceId ?? this.deviceId,
      userId: userId ?? this.userId,
      cartridgeId: cartridgeId ?? this.cartridgeId,
      attached: attached ?? this.attached,
      position: position ?? this.position,
      doseNumber: doseNumber ?? this.doseNumber,
      measuredResistance: measuredResistance ?? this.measuredResistance,
      empty: empty ?? this.empty,
      json: json ?? this.json);
  }
  
  CartridgeEvent.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _time = json['time'] != null ? TemporalTimestamp.fromSeconds(json['time']) : null,
      _deviceId = json['deviceId'],
      _userId = json['userId'],
      _cartridgeId = json['cartridgeId'],
      _attached = json['attached'],
      _position = (json['position'] as num?)?.toInt(),
      _doseNumber = (json['doseNumber'] as num?)?.toInt(),
      _measuredResistance = (json['measuredResistance'] as num?)?.toInt(),
      _empty = json['empty'],
      _json = json['json'];
  
  Map<String, dynamic> toJson() => {
    'id': id, 'time': _time?.toSeconds(), 'deviceId': _deviceId, 'userId': _userId, 'cartridgeId': _cartridgeId, 'attached': _attached, 'position': _position, 'doseNumber': _doseNumber, 'measuredResistance': _measuredResistance, 'empty': _empty, 'json': _json
  };

  static final QueryField ID = QueryField(fieldName: "cartridgeEvent.id");
  static final QueryField TIME = QueryField(fieldName: "time");
  static final QueryField DEVICEID = QueryField(fieldName: "deviceId");
  static final QueryField USERID = QueryField(fieldName: "userId");
  static final QueryField CARTRIDGEID = QueryField(fieldName: "cartridgeId");
  static final QueryField ATTACHED = QueryField(fieldName: "attached");
  static final QueryField POSITION = QueryField(fieldName: "position");
  static final QueryField DOSENUMBER = QueryField(fieldName: "doseNumber");
  static final QueryField MEASUREDRESISTANCE = QueryField(fieldName: "measuredResistance");
  static final QueryField EMPTY = QueryField(fieldName: "empty");
  static final QueryField JSON = QueryField(fieldName: "json");
  static var schema = Model.defineSchema(define: (ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "CartridgeEvent";
    modelSchemaDefinition.pluralName = "CartridgeEvents";
    
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
      key: CartridgeEvent.TIME,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.timestamp)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: CartridgeEvent.DEVICEID,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: CartridgeEvent.USERID,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: CartridgeEvent.CARTRIDGEID,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: CartridgeEvent.ATTACHED,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.bool)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: CartridgeEvent.POSITION,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.int)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: CartridgeEvent.DOSENUMBER,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.int)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: CartridgeEvent.MEASUREDRESISTANCE,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.int)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: CartridgeEvent.EMPTY,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.bool)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: CartridgeEvent.JSON,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
  });
}

class _CartridgeEventModelType extends ModelType<CartridgeEvent> {
  const _CartridgeEventModelType();
  
  @override
  CartridgeEvent fromJson(Map<String, dynamic> jsonData) {
    return CartridgeEvent.fromJson(jsonData);
  }
}