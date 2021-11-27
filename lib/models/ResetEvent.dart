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


/** This is an auto generated class representing the ResetEvent type in your schema. */
@immutable
class ResetEvent extends Model {
  static const classType = const _ResetEventModelType();
  final String id;
  final TemporalTimestamp? _time;
  final String? _reason;
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
  
  String? get reason {
    return _reason;
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
  
  const ResetEvent._internal({required this.id, time, reason, json, userId, deviceId}): _time = time, _reason = reason, _json = json, _userId = userId, _deviceId = deviceId;
  
  factory ResetEvent({String? id, TemporalTimestamp? time, String? reason, String? json, String? userId, String? deviceId}) {
    return ResetEvent._internal(
      id: id == null ? UUID.getUUID() : id,
      time: time,
      reason: reason,
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
    return other is ResetEvent &&
      id == other.id &&
      _time == other._time &&
      _reason == other._reason &&
      _json == other._json &&
      _userId == other._userId &&
      _deviceId == other._deviceId;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("ResetEvent {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("time=" + (_time != null ? _time!.toString() : "null") + ", ");
    buffer.write("reason=" + "$_reason" + ", ");
    buffer.write("json=" + "$_json" + ", ");
    buffer.write("userId=" + "$_userId" + ", ");
    buffer.write("deviceId=" + "$_deviceId");
    buffer.write("}");
    
    return buffer.toString();
  }
  
  ResetEvent copyWith({String? id, TemporalTimestamp? time, String? reason, String? json, String? userId, String? deviceId}) {
    return ResetEvent(
      id: id ?? this.id,
      time: time ?? this.time,
      reason: reason ?? this.reason,
      json: json ?? this.json,
      userId: userId ?? this.userId,
      deviceId: deviceId ?? this.deviceId);
  }
  
  ResetEvent.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _time = json['time'] != null ? TemporalTimestamp.fromSeconds(json['time']) : null,
      _reason = json['reason'],
      _json = json['json'],
      _userId = json['userId'],
      _deviceId = json['deviceId'];
  
  Map<String, dynamic> toJson() => {
    'id': id, 'time': _time?.toSeconds(), 'reason': _reason, 'json': _json, 'userId': _userId, 'deviceId': _deviceId
  };

  static final QueryField ID = QueryField(fieldName: "resetEvent.id");
  static final QueryField TIME = QueryField(fieldName: "time");
  static final QueryField REASON = QueryField(fieldName: "reason");
  static final QueryField JSON = QueryField(fieldName: "json");
  static final QueryField USERID = QueryField(fieldName: "userId");
  static final QueryField DEVICEID = QueryField(fieldName: "deviceId");
  static var schema = Model.defineSchema(define: (ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "ResetEvent";
    modelSchemaDefinition.pluralName = "ResetEvents";
    
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
      key: ResetEvent.TIME,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.timestamp)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: ResetEvent.REASON,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: ResetEvent.JSON,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: ResetEvent.USERID,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: ResetEvent.DEVICEID,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
  });
}

class _ResetEventModelType extends ModelType<ResetEvent> {
  const _ResetEventModelType();
  
  @override
  ResetEvent fromJson(Map<String, dynamic> jsonData) {
    return ResetEvent.fromJson(jsonData);
  }
}