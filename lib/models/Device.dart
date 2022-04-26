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

import 'ModelProvider.dart';
import 'package:amplify_core/amplify_core.dart';
import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';


/** This is an auto generated class representing the Device type in your schema. */
@immutable
class Device extends Model {
  static const classType = const _DeviceModelType();
  final String id;
  final String? _deviceId;
  final ProductId? _productId;
  final int? _firmwareVersion;
  final int? _imageLibraryVersion;
  final String? _lastCartridge;
  final List<String>? _cartridges;
  final int? _motorId;
  final String? _bleName;
  final DeviceLockStatus? _lockStatus;
  final TemporalDateTime? _createdAt;
  final TemporalDateTime? _updatedAt;

  @override
  getInstanceType() => classType;
  
  @override
  String getId() {
    return id;
  }
  
  String? get deviceId {
    return _deviceId;
  }
  
  ProductId? get productId {
    return _productId;
  }
  
  int? get firmwareVersion {
    return _firmwareVersion;
  }
  
  int? get imageLibraryVersion {
    return _imageLibraryVersion;
  }
  
  String? get lastCartridge {
    return _lastCartridge;
  }
  
  List<String>? get cartridges {
    return _cartridges;
  }
  
  int? get motorId {
    return _motorId;
  }
  
  String? get bleName {
    return _bleName;
  }
  
  DeviceLockStatus? get lockStatus {
    return _lockStatus;
  }
  
  TemporalDateTime? get createdAt {
    return _createdAt;
  }
  
  TemporalDateTime? get updatedAt {
    return _updatedAt;
  }
  
  const Device._internal({required this.id, deviceId, productId, firmwareVersion, imageLibraryVersion, lastCartridge, cartridges, motorId, bleName, lockStatus, createdAt, updatedAt}): _deviceId = deviceId, _productId = productId, _firmwareVersion = firmwareVersion, _imageLibraryVersion = imageLibraryVersion, _lastCartridge = lastCartridge, _cartridges = cartridges, _motorId = motorId, _bleName = bleName, _lockStatus = lockStatus, _createdAt = createdAt, _updatedAt = updatedAt;
  
  factory Device({String? id, String? deviceId, ProductId? productId, int? firmwareVersion, int? imageLibraryVersion, String? lastCartridge, List<String>? cartridges, int? motorId, String? bleName, DeviceLockStatus? lockStatus}) {
    return Device._internal(
      id: id == null ? UUID.getUUID() : id,
      deviceId: deviceId,
      productId: productId,
      firmwareVersion: firmwareVersion,
      imageLibraryVersion: imageLibraryVersion,
      lastCartridge: lastCartridge,
      cartridges: cartridges != null ? List<String>.unmodifiable(cartridges) : cartridges,
      motorId: motorId,
      bleName: bleName,
      lockStatus: lockStatus);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Device &&
      id == other.id &&
      _deviceId == other._deviceId &&
      _productId == other._productId &&
      _firmwareVersion == other._firmwareVersion &&
      _imageLibraryVersion == other._imageLibraryVersion &&
      _lastCartridge == other._lastCartridge &&
      DeepCollectionEquality().equals(_cartridges, other._cartridges) &&
      _motorId == other._motorId &&
      _bleName == other._bleName &&
      _lockStatus == other._lockStatus;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("Device {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("deviceId=" + "$_deviceId" + ", ");
    buffer.write("productId=" + (_productId != null ? enumToString(_productId)! : "null") + ", ");
    buffer.write("firmwareVersion=" + (_firmwareVersion != null ? _firmwareVersion!.toString() : "null") + ", ");
    buffer.write("imageLibraryVersion=" + (_imageLibraryVersion != null ? _imageLibraryVersion!.toString() : "null") + ", ");
    buffer.write("lastCartridge=" + "$_lastCartridge" + ", ");
    buffer.write("cartridges=" + (_cartridges != null ? _cartridges!.toString() : "null") + ", ");
    buffer.write("motorId=" + (_motorId != null ? _motorId!.toString() : "null") + ", ");
    buffer.write("bleName=" + "$_bleName" + ", ");
    buffer.write("lockStatus=" + (_lockStatus != null ? enumToString(_lockStatus)! : "null") + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt!.format() : "null") + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  Device copyWith({String? id, String? deviceId, ProductId? productId, int? firmwareVersion, int? imageLibraryVersion, String? lastCartridge, List<String>? cartridges, int? motorId, String? bleName, DeviceLockStatus? lockStatus}) {
    return Device._internal(
      id: id ?? this.id,
      deviceId: deviceId ?? this.deviceId,
      productId: productId ?? this.productId,
      firmwareVersion: firmwareVersion ?? this.firmwareVersion,
      imageLibraryVersion: imageLibraryVersion ?? this.imageLibraryVersion,
      lastCartridge: lastCartridge ?? this.lastCartridge,
      cartridges: cartridges ?? this.cartridges,
      motorId: motorId ?? this.motorId,
      bleName: bleName ?? this.bleName,
      lockStatus: lockStatus ?? this.lockStatus);
  }
  
  Device.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _deviceId = json['deviceId'],
      _productId = enumFromString<ProductId>(json['productId'], ProductId.values),
      _firmwareVersion = (json['firmwareVersion'] as num?)?.toInt(),
      _imageLibraryVersion = (json['imageLibraryVersion'] as num?)?.toInt(),
      _lastCartridge = json['lastCartridge'],
      _cartridges = json['cartridges']?.cast<String>(),
      _motorId = (json['motorId'] as num?)?.toInt(),
      _bleName = json['bleName'],
      _lockStatus = enumFromString<DeviceLockStatus>(json['lockStatus'], DeviceLockStatus.values),
      _createdAt = json['createdAt'] != null ? TemporalDateTime.fromString(json['createdAt']) : null,
      _updatedAt = json['updatedAt'] != null ? TemporalDateTime.fromString(json['updatedAt']) : null;
  
  Map<String, dynamic> toJson() => {
    'id': id, 'deviceId': _deviceId, 'productId': enumToString(_productId), 'firmwareVersion': _firmwareVersion, 'imageLibraryVersion': _imageLibraryVersion, 'lastCartridge': _lastCartridge, 'cartridges': _cartridges, 'motorId': _motorId, 'bleName': _bleName, 'lockStatus': enumToString(_lockStatus), 'createdAt': _createdAt?.format(), 'updatedAt': _updatedAt?.format()
  };

  static final QueryField ID = QueryField(fieldName: "device.id");
  static final QueryField DEVICEID = QueryField(fieldName: "deviceId");
  static final QueryField PRODUCTID = QueryField(fieldName: "productId");
  static final QueryField FIRMWAREVERSION = QueryField(fieldName: "firmwareVersion");
  static final QueryField IMAGELIBRARYVERSION = QueryField(fieldName: "imageLibraryVersion");
  static final QueryField LASTCARTRIDGE = QueryField(fieldName: "lastCartridge");
  static final QueryField CARTRIDGES = QueryField(fieldName: "cartridges");
  static final QueryField MOTORID = QueryField(fieldName: "motorId");
  static final QueryField BLENAME = QueryField(fieldName: "bleName");
  static final QueryField LOCKSTATUS = QueryField(fieldName: "lockStatus");
  static var schema = Model.defineSchema(define: (ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "Device";
    modelSchemaDefinition.pluralName = "Devices";
    
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
      key: Device.DEVICEID,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: Device.PRODUCTID,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.enumeration)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: Device.FIRMWAREVERSION,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.int)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: Device.IMAGELIBRARYVERSION,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.int)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: Device.LASTCARTRIDGE,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: Device.CARTRIDGES,
      isRequired: false,
      isArray: true,
      ofType: ModelFieldType(ModelFieldTypeEnum.collection, ofModelName: describeEnum(ModelFieldTypeEnum.string))
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: Device.MOTORID,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.int)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: Device.BLENAME,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: Device.LOCKSTATUS,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.enumeration)
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

class _DeviceModelType extends ModelType<Device> {
  const _DeviceModelType();
  
  @override
  Device fromJson(Map<String, dynamic> jsonData) {
    return Device.fromJson(jsonData);
  }
}