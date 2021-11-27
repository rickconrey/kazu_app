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


/** This is an auto generated class representing the ChargeEvent type in your schema. */
@immutable
class ChargeEvent extends Model {
  static const classType = const _ChargeEventModelType();
  final String id;
  final TemporalTimestamp? _time;
  final bool? _charging;
  final int? _adcVbat;
  final String? _json;
  final String? _userId;
  final String? _deviceId;

  @override
  getInstanceType() => classType;
  
  @override
  String getId() {
    return id;
  }
  
  TemporalTimestamp? get time {
    return _time;
  }
  
  bool? get charging {
    return _charging;
  }
  
  int? get adcVbat {
    return _adcVbat;
  }
  
  String? get json {
    return _json;
  }
  
  String? get userId {
    return _userId;
  }
  
  String? get deviceId {
    return _deviceId;
  }
  
  const ChargeEvent._internal({required this.id, time, charging, adcVbat, json, userId, deviceId}): _time = time, _charging = charging, _adcVbat = adcVbat, _json = json, _userId = userId, _deviceId = deviceId;
  
  factory ChargeEvent({String? id, TemporalTimestamp? time, bool? charging, int? adcVbat, String? json, String? userId, String? deviceId}) {
    return ChargeEvent._internal(
      id: id == null ? UUID.getUUID() : id,
      time: time,
      charging: charging,
      adcVbat: adcVbat,
      json: json,
      userId: userId,
      deviceId: deviceId);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ChargeEvent &&
      id == other.id &&
      _time == other._time &&
      _charging == other._charging &&
      _adcVbat == other._adcVbat &&
      _json == other._json &&
      _userId == other._userId &&
      _deviceId == other._deviceId;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("ChargeEvent {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("time=" + (_time != null ? _time!.toString() : "null") + ", ");
    buffer.write("charging=" + (_charging != null ? _charging!.toString() : "null") + ", ");
    buffer.write("adcVbat=" + (_adcVbat != null ? _adcVbat!.toString() : "null") + ", ");
    buffer.write("json=" + "$_json" + ", ");
    buffer.write("userId=" + "$_userId" + ", ");
    buffer.write("deviceId=" + "$_deviceId");
    buffer.write("}");
    
    return buffer.toString();
  }
  
  ChargeEvent copyWith({String? id, TemporalTimestamp? time, bool? charging, int? adcVbat, String? json, String? userId, String? deviceId}) {
    return ChargeEvent(
      id: id ?? this.id,
      time: time ?? this.time,
      charging: charging ?? this.charging,
      adcVbat: adcVbat ?? this.adcVbat,
      json: json ?? this.json,
      userId: userId ?? this.userId,
      deviceId: deviceId ?? this.deviceId);
  }
  
  ChargeEvent.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _time = json['time'] != null ? TemporalTimestamp.fromSeconds(json['time']) : null,
      _charging = json['charging'],
      _adcVbat = (json['adcVbat'] as num?)?.toInt(),
      _json = json['json'],
      _userId = json['userId'],
      _deviceId = json['deviceId'];
  
  Map<String, dynamic> toJson() => {
    'id': id, 'time': _time?.toSeconds(), 'charging': _charging, 'adcVbat': _adcVbat, 'json': _json, 'userId': _userId, 'deviceId': _deviceId
  };

  static final QueryField ID = QueryField(fieldName: "chargeEvent.id");
  static final QueryField TIME = QueryField(fieldName: "time");
  static final QueryField CHARGING = QueryField(fieldName: "charging");
  static final QueryField ADCVBAT = QueryField(fieldName: "adcVbat");
  static final QueryField JSON = QueryField(fieldName: "json");
  static final QueryField USERID = QueryField(fieldName: "userId");
  static final QueryField DEVICEID = QueryField(fieldName: "deviceId");
  static var schema = Model.defineSchema(define: (ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "ChargeEvent";
    modelSchemaDefinition.pluralName = "ChargeEvents";
    
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
      key: ChargeEvent.TIME,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.timestamp)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: ChargeEvent.CHARGING,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.bool)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: ChargeEvent.ADCVBAT,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.int)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: ChargeEvent.JSON,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: ChargeEvent.USERID,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: ChargeEvent.DEVICEID,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
  });
}

class _ChargeEventModelType extends ModelType<ChargeEvent> {
  const _ChargeEventModelType();
  
  @override
  ChargeEvent fromJson(Map<String, dynamic> jsonData) {
    return ChargeEvent.fromJson(jsonData);
  }
}