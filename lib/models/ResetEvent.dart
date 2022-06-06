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

// ignore_for_file: public_member_api_docs, annotate_overrides, dead_code, dead_codepublic_member_api_docs, depend_on_referenced_packages, file_names, library_private_types_in_public_api, no_leading_underscores_for_library_prefixes, no_leading_underscores_for_local_identifiers, non_constant_identifier_names, null_check_on_nullable_type_parameter, prefer_adjacent_string_concatenation, prefer_const_constructors, prefer_if_null_operators, prefer_interpolation_to_compose_strings, slash_for_doc_comments, sort_child_properties_last, unnecessary_const, unnecessary_constructor_name, unnecessary_late, unnecessary_new, unnecessary_null_aware_assignments, unnecessary_nullable_for_final_variable_declarations, unnecessary_string_interpolations, use_build_context_synchronously

import 'package:amplify_core/amplify_core.dart';
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
  final TemporalDateTime? _createdAt;
  final TemporalDateTime? _updatedAt;

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
  
  TemporalDateTime? get createdAt {
    return _createdAt;
  }
  
  TemporalDateTime? get updatedAt {
    return _updatedAt;
  }
  
  const ResetEvent._internal({required this.id, time, reason, json, userId, deviceId, createdAt, updatedAt}): _time = time, _reason = reason, _json = json, _userId = userId, _deviceId = deviceId, _createdAt = createdAt, _updatedAt = updatedAt;
  
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
    buffer.write("deviceId=" + "$_deviceId" + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt!.format() : "null") + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  ResetEvent copyWith({String? id, TemporalTimestamp? time, String? reason, String? json, String? userId, String? deviceId}) {
    return ResetEvent._internal(
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
      _deviceId = json['deviceId'],
      _createdAt = json['createdAt'] != null ? TemporalDateTime.fromString(json['createdAt']) : null,
      _updatedAt = json['updatedAt'] != null ? TemporalDateTime.fromString(json['updatedAt']) : null;
  
  Map<String, dynamic> toJson() => {
    'id': id, 'time': _time?.toSeconds(), 'reason': _reason, 'json': _json, 'userId': _userId, 'deviceId': _deviceId, 'createdAt': _createdAt?.format(), 'updatedAt': _updatedAt?.format()
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
    
    modelSchemaDefinition.addField(ModelFieldDefinition.nonQueryField(
      fieldName: 'createdAt',
      isRequired: false,
      isReadOnly: true,
      ofType: ModelFieldType(ModelFieldTypeEnum.dateTime)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.nonQueryField(
      fieldName: 'updatedAt',
      isRequired: false,
      isReadOnly: true,
      ofType: ModelFieldType(ModelFieldTypeEnum.dateTime)
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