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


/** This is an auto generated class representing the Cartridge type in your schema. */
@immutable
class Cartridge extends Model {
  static const classType = const _CartridgeModelType();
  final String id;
  final String? _cartridgeId;
  final CartridgeType? _type;
  final ProductId? _productId;
  final int? _heaterId;
  final int? _totalResistance;
  final int? _coilResistance;
  final int? _contactResistance;
  final int? _measuredResistance;
  final int? _temperatureCoefficient;
  final int? _needleGauge;
  final int? _volume;
  final int? _fillerId;
  final int? _liquidId;
  final int? _maximumTemperature;
  final int? _minimumTemperatu;
  final int? _recommendedTemperature;
  final int? _customTemperature;
  final TemporalTimestamp? _filledTimestamp;
  final TemporalTimestamp? _expireTimestamp;
  final String? _logoKey;
  final int? _logoAddress;
  final int? _logoLength;
  final int? _version;
  final CartridgeStatus? _status;
  final CartridgeState? _state;
  final int? _position;
  final int? _doseNumber;
  final TemporalTimestamp? _connectionTime;
  final String? _lastDevice;
  final List<String>? _devices;
  final TemporalDateTime? _createdAt;
  final TemporalDateTime? _updatedAt;

  @override
  getInstanceType() => classType;
  
  @override
  String getId() {
    return id;
  }
  
  String? get cartridgeId {
    return _cartridgeId;
  }
  
  CartridgeType? get type {
    return _type;
  }
  
  ProductId? get productId {
    return _productId;
  }
  
  int? get heaterId {
    return _heaterId;
  }
  
  int? get totalResistance {
    return _totalResistance;
  }
  
  int? get coilResistance {
    return _coilResistance;
  }
  
  int? get contactResistance {
    return _contactResistance;
  }
  
  int? get measuredResistance {
    return _measuredResistance;
  }
  
  int? get temperatureCoefficient {
    return _temperatureCoefficient;
  }
  
  int? get needleGauge {
    return _needleGauge;
  }
  
  int? get volume {
    return _volume;
  }
  
  int? get fillerId {
    return _fillerId;
  }
  
  int? get liquidId {
    return _liquidId;
  }
  
  int? get maximumTemperature {
    return _maximumTemperature;
  }
  
  int? get minimumTemperatu {
    return _minimumTemperatu;
  }
  
  int? get recommendedTemperature {
    return _recommendedTemperature;
  }
  
  int? get customTemperature {
    return _customTemperature;
  }
  
  TemporalTimestamp? get filledTimestamp {
    return _filledTimestamp;
  }
  
  TemporalTimestamp? get expireTimestamp {
    return _expireTimestamp;
  }
  
  String? get logoKey {
    return _logoKey;
  }
  
  int? get logoAddress {
    return _logoAddress;
  }
  
  int? get logoLength {
    return _logoLength;
  }
  
  int? get version {
    return _version;
  }
  
  CartridgeStatus? get status {
    return _status;
  }
  
  CartridgeState? get state {
    return _state;
  }
  
  int? get position {
    return _position;
  }
  
  int? get doseNumber {
    return _doseNumber;
  }
  
  TemporalTimestamp? get connectionTime {
    return _connectionTime;
  }
  
  String? get lastDevice {
    return _lastDevice;
  }
  
  List<String>? get devices {
    return _devices;
  }
  
  TemporalDateTime? get createdAt {
    return _createdAt;
  }
  
  TemporalDateTime? get updatedAt {
    return _updatedAt;
  }
  
  const Cartridge._internal({required this.id, cartridgeId, type, productId, heaterId, totalResistance, coilResistance, contactResistance, measuredResistance, temperatureCoefficient, needleGauge, volume, fillerId, liquidId, maximumTemperature, minimumTemperatu, recommendedTemperature, customTemperature, filledTimestamp, expireTimestamp, logoKey, logoAddress, logoLength, version, status, state, position, doseNumber, connectionTime, lastDevice, devices, createdAt, updatedAt}): _cartridgeId = cartridgeId, _type = type, _productId = productId, _heaterId = heaterId, _totalResistance = totalResistance, _coilResistance = coilResistance, _contactResistance = contactResistance, _measuredResistance = measuredResistance, _temperatureCoefficient = temperatureCoefficient, _needleGauge = needleGauge, _volume = volume, _fillerId = fillerId, _liquidId = liquidId, _maximumTemperature = maximumTemperature, _minimumTemperatu = minimumTemperatu, _recommendedTemperature = recommendedTemperature, _customTemperature = customTemperature, _filledTimestamp = filledTimestamp, _expireTimestamp = expireTimestamp, _logoKey = logoKey, _logoAddress = logoAddress, _logoLength = logoLength, _version = version, _status = status, _state = state, _position = position, _doseNumber = doseNumber, _connectionTime = connectionTime, _lastDevice = lastDevice, _devices = devices, _createdAt = createdAt, _updatedAt = updatedAt;
  
  factory Cartridge({String? id, String? cartridgeId, CartridgeType? type, ProductId? productId, int? heaterId, int? totalResistance, int? coilResistance, int? contactResistance, int? measuredResistance, int? temperatureCoefficient, int? needleGauge, int? volume, int? fillerId, int? liquidId, int? maximumTemperature, int? minimumTemperatu, int? recommendedTemperature, int? customTemperature, TemporalTimestamp? filledTimestamp, TemporalTimestamp? expireTimestamp, String? logoKey, int? logoAddress, int? logoLength, int? version, CartridgeStatus? status, CartridgeState? state, int? position, int? doseNumber, TemporalTimestamp? connectionTime, String? lastDevice, List<String>? devices}) {
    return Cartridge._internal(
      id: id == null ? UUID.getUUID() : id,
      cartridgeId: cartridgeId,
      type: type,
      productId: productId,
      heaterId: heaterId,
      totalResistance: totalResistance,
      coilResistance: coilResistance,
      contactResistance: contactResistance,
      measuredResistance: measuredResistance,
      temperatureCoefficient: temperatureCoefficient,
      needleGauge: needleGauge,
      volume: volume,
      fillerId: fillerId,
      liquidId: liquidId,
      maximumTemperature: maximumTemperature,
      minimumTemperatu: minimumTemperatu,
      recommendedTemperature: recommendedTemperature,
      customTemperature: customTemperature,
      filledTimestamp: filledTimestamp,
      expireTimestamp: expireTimestamp,
      logoKey: logoKey,
      logoAddress: logoAddress,
      logoLength: logoLength,
      version: version,
      status: status,
      state: state,
      position: position,
      doseNumber: doseNumber,
      connectionTime: connectionTime,
      lastDevice: lastDevice,
      devices: devices != null ? List<String>.unmodifiable(devices) : devices);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Cartridge &&
      id == other.id &&
      _cartridgeId == other._cartridgeId &&
      _type == other._type &&
      _productId == other._productId &&
      _heaterId == other._heaterId &&
      _totalResistance == other._totalResistance &&
      _coilResistance == other._coilResistance &&
      _contactResistance == other._contactResistance &&
      _measuredResistance == other._measuredResistance &&
      _temperatureCoefficient == other._temperatureCoefficient &&
      _needleGauge == other._needleGauge &&
      _volume == other._volume &&
      _fillerId == other._fillerId &&
      _liquidId == other._liquidId &&
      _maximumTemperature == other._maximumTemperature &&
      _minimumTemperatu == other._minimumTemperatu &&
      _recommendedTemperature == other._recommendedTemperature &&
      _customTemperature == other._customTemperature &&
      _filledTimestamp == other._filledTimestamp &&
      _expireTimestamp == other._expireTimestamp &&
      _logoKey == other._logoKey &&
      _logoAddress == other._logoAddress &&
      _logoLength == other._logoLength &&
      _version == other._version &&
      _status == other._status &&
      _state == other._state &&
      _position == other._position &&
      _doseNumber == other._doseNumber &&
      _connectionTime == other._connectionTime &&
      _lastDevice == other._lastDevice &&
      DeepCollectionEquality().equals(_devices, other._devices);
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("Cartridge {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("cartridgeId=" + "$_cartridgeId" + ", ");
    buffer.write("type=" + (_type != null ? enumToString(_type)! : "null") + ", ");
    buffer.write("productId=" + (_productId != null ? enumToString(_productId)! : "null") + ", ");
    buffer.write("heaterId=" + (_heaterId != null ? _heaterId!.toString() : "null") + ", ");
    buffer.write("totalResistance=" + (_totalResistance != null ? _totalResistance!.toString() : "null") + ", ");
    buffer.write("coilResistance=" + (_coilResistance != null ? _coilResistance!.toString() : "null") + ", ");
    buffer.write("contactResistance=" + (_contactResistance != null ? _contactResistance!.toString() : "null") + ", ");
    buffer.write("measuredResistance=" + (_measuredResistance != null ? _measuredResistance!.toString() : "null") + ", ");
    buffer.write("temperatureCoefficient=" + (_temperatureCoefficient != null ? _temperatureCoefficient!.toString() : "null") + ", ");
    buffer.write("needleGauge=" + (_needleGauge != null ? _needleGauge!.toString() : "null") + ", ");
    buffer.write("volume=" + (_volume != null ? _volume!.toString() : "null") + ", ");
    buffer.write("fillerId=" + (_fillerId != null ? _fillerId!.toString() : "null") + ", ");
    buffer.write("liquidId=" + (_liquidId != null ? _liquidId!.toString() : "null") + ", ");
    buffer.write("maximumTemperature=" + (_maximumTemperature != null ? _maximumTemperature!.toString() : "null") + ", ");
    buffer.write("minimumTemperatu=" + (_minimumTemperatu != null ? _minimumTemperatu!.toString() : "null") + ", ");
    buffer.write("recommendedTemperature=" + (_recommendedTemperature != null ? _recommendedTemperature!.toString() : "null") + ", ");
    buffer.write("customTemperature=" + (_customTemperature != null ? _customTemperature!.toString() : "null") + ", ");
    buffer.write("filledTimestamp=" + (_filledTimestamp != null ? _filledTimestamp!.toString() : "null") + ", ");
    buffer.write("expireTimestamp=" + (_expireTimestamp != null ? _expireTimestamp!.toString() : "null") + ", ");
    buffer.write("logoKey=" + "$_logoKey" + ", ");
    buffer.write("logoAddress=" + (_logoAddress != null ? _logoAddress!.toString() : "null") + ", ");
    buffer.write("logoLength=" + (_logoLength != null ? _logoLength!.toString() : "null") + ", ");
    buffer.write("version=" + (_version != null ? _version!.toString() : "null") + ", ");
    buffer.write("status=" + (_status != null ? enumToString(_status)! : "null") + ", ");
    buffer.write("state=" + (_state != null ? enumToString(_state)! : "null") + ", ");
    buffer.write("position=" + (_position != null ? _position!.toString() : "null") + ", ");
    buffer.write("doseNumber=" + (_doseNumber != null ? _doseNumber!.toString() : "null") + ", ");
    buffer.write("connectionTime=" + (_connectionTime != null ? _connectionTime!.toString() : "null") + ", ");
    buffer.write("lastDevice=" + "$_lastDevice" + ", ");
    buffer.write("devices=" + (_devices != null ? _devices!.toString() : "null") + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt!.format() : "null") + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  Cartridge copyWith({String? id, String? cartridgeId, CartridgeType? type, ProductId? productId, int? heaterId, int? totalResistance, int? coilResistance, int? contactResistance, int? measuredResistance, int? temperatureCoefficient, int? needleGauge, int? volume, int? fillerId, int? liquidId, int? maximumTemperature, int? minimumTemperatu, int? recommendedTemperature, int? customTemperature, TemporalTimestamp? filledTimestamp, TemporalTimestamp? expireTimestamp, String? logoKey, int? logoAddress, int? logoLength, int? version, CartridgeStatus? status, CartridgeState? state, int? position, int? doseNumber, TemporalTimestamp? connectionTime, String? lastDevice, List<String>? devices}) {
    return Cartridge._internal(
      id: id ?? this.id,
      cartridgeId: cartridgeId ?? this.cartridgeId,
      type: type ?? this.type,
      productId: productId ?? this.productId,
      heaterId: heaterId ?? this.heaterId,
      totalResistance: totalResistance ?? this.totalResistance,
      coilResistance: coilResistance ?? this.coilResistance,
      contactResistance: contactResistance ?? this.contactResistance,
      measuredResistance: measuredResistance ?? this.measuredResistance,
      temperatureCoefficient: temperatureCoefficient ?? this.temperatureCoefficient,
      needleGauge: needleGauge ?? this.needleGauge,
      volume: volume ?? this.volume,
      fillerId: fillerId ?? this.fillerId,
      liquidId: liquidId ?? this.liquidId,
      maximumTemperature: maximumTemperature ?? this.maximumTemperature,
      minimumTemperatu: minimumTemperatu ?? this.minimumTemperatu,
      recommendedTemperature: recommendedTemperature ?? this.recommendedTemperature,
      customTemperature: customTemperature ?? this.customTemperature,
      filledTimestamp: filledTimestamp ?? this.filledTimestamp,
      expireTimestamp: expireTimestamp ?? this.expireTimestamp,
      logoKey: logoKey ?? this.logoKey,
      logoAddress: logoAddress ?? this.logoAddress,
      logoLength: logoLength ?? this.logoLength,
      version: version ?? this.version,
      status: status ?? this.status,
      state: state ?? this.state,
      position: position ?? this.position,
      doseNumber: doseNumber ?? this.doseNumber,
      connectionTime: connectionTime ?? this.connectionTime,
      lastDevice: lastDevice ?? this.lastDevice,
      devices: devices ?? this.devices);
  }
  
  Cartridge.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _cartridgeId = json['cartridgeId'],
      _type = enumFromString<CartridgeType>(json['type'], CartridgeType.values),
      _productId = enumFromString<ProductId>(json['productId'], ProductId.values),
      _heaterId = (json['heaterId'] as num?)?.toInt(),
      _totalResistance = (json['totalResistance'] as num?)?.toInt(),
      _coilResistance = (json['coilResistance'] as num?)?.toInt(),
      _contactResistance = (json['contactResistance'] as num?)?.toInt(),
      _measuredResistance = (json['measuredResistance'] as num?)?.toInt(),
      _temperatureCoefficient = (json['temperatureCoefficient'] as num?)?.toInt(),
      _needleGauge = (json['needleGauge'] as num?)?.toInt(),
      _volume = (json['volume'] as num?)?.toInt(),
      _fillerId = (json['fillerId'] as num?)?.toInt(),
      _liquidId = (json['liquidId'] as num?)?.toInt(),
      _maximumTemperature = (json['maximumTemperature'] as num?)?.toInt(),
      _minimumTemperatu = (json['minimumTemperatu'] as num?)?.toInt(),
      _recommendedTemperature = (json['recommendedTemperature'] as num?)?.toInt(),
      _customTemperature = (json['customTemperature'] as num?)?.toInt(),
      _filledTimestamp = json['filledTimestamp'] != null ? TemporalTimestamp.fromSeconds(json['filledTimestamp']) : null,
      _expireTimestamp = json['expireTimestamp'] != null ? TemporalTimestamp.fromSeconds(json['expireTimestamp']) : null,
      _logoKey = json['logoKey'],
      _logoAddress = (json['logoAddress'] as num?)?.toInt(),
      _logoLength = (json['logoLength'] as num?)?.toInt(),
      _version = (json['version'] as num?)?.toInt(),
      _status = enumFromString<CartridgeStatus>(json['status'], CartridgeStatus.values),
      _state = enumFromString<CartridgeState>(json['state'], CartridgeState.values),
      _position = (json['position'] as num?)?.toInt(),
      _doseNumber = (json['doseNumber'] as num?)?.toInt(),
      _connectionTime = json['connectionTime'] != null ? TemporalTimestamp.fromSeconds(json['connectionTime']) : null,
      _lastDevice = json['lastDevice'],
      _devices = json['devices']?.cast<String>(),
      _createdAt = json['createdAt'] != null ? TemporalDateTime.fromString(json['createdAt']) : null,
      _updatedAt = json['updatedAt'] != null ? TemporalDateTime.fromString(json['updatedAt']) : null;
  
  Map<String, dynamic> toJson() => {
    'id': id, 'cartridgeId': _cartridgeId, 'type': enumToString(_type), 'productId': enumToString(_productId), 'heaterId': _heaterId, 'totalResistance': _totalResistance, 'coilResistance': _coilResistance, 'contactResistance': _contactResistance, 'measuredResistance': _measuredResistance, 'temperatureCoefficient': _temperatureCoefficient, 'needleGauge': _needleGauge, 'volume': _volume, 'fillerId': _fillerId, 'liquidId': _liquidId, 'maximumTemperature': _maximumTemperature, 'minimumTemperatu': _minimumTemperatu, 'recommendedTemperature': _recommendedTemperature, 'customTemperature': _customTemperature, 'filledTimestamp': _filledTimestamp?.toSeconds(), 'expireTimestamp': _expireTimestamp?.toSeconds(), 'logoKey': _logoKey, 'logoAddress': _logoAddress, 'logoLength': _logoLength, 'version': _version, 'status': enumToString(_status), 'state': enumToString(_state), 'position': _position, 'doseNumber': _doseNumber, 'connectionTime': _connectionTime?.toSeconds(), 'lastDevice': _lastDevice, 'devices': _devices, 'createdAt': _createdAt?.format(), 'updatedAt': _updatedAt?.format()
  };

  static final QueryField ID = QueryField(fieldName: "cartridge.id");
  static final QueryField CARTRIDGEID = QueryField(fieldName: "cartridgeId");
  static final QueryField TYPE = QueryField(fieldName: "type");
  static final QueryField PRODUCTID = QueryField(fieldName: "productId");
  static final QueryField HEATERID = QueryField(fieldName: "heaterId");
  static final QueryField TOTALRESISTANCE = QueryField(fieldName: "totalResistance");
  static final QueryField COILRESISTANCE = QueryField(fieldName: "coilResistance");
  static final QueryField CONTACTRESISTANCE = QueryField(fieldName: "contactResistance");
  static final QueryField MEASUREDRESISTANCE = QueryField(fieldName: "measuredResistance");
  static final QueryField TEMPERATURECOEFFICIENT = QueryField(fieldName: "temperatureCoefficient");
  static final QueryField NEEDLEGAUGE = QueryField(fieldName: "needleGauge");
  static final QueryField VOLUME = QueryField(fieldName: "volume");
  static final QueryField FILLERID = QueryField(fieldName: "fillerId");
  static final QueryField LIQUIDID = QueryField(fieldName: "liquidId");
  static final QueryField MAXIMUMTEMPERATURE = QueryField(fieldName: "maximumTemperature");
  static final QueryField MINIMUMTEMPERATU = QueryField(fieldName: "minimumTemperatu");
  static final QueryField RECOMMENDEDTEMPERATURE = QueryField(fieldName: "recommendedTemperature");
  static final QueryField CUSTOMTEMPERATURE = QueryField(fieldName: "customTemperature");
  static final QueryField FILLEDTIMESTAMP = QueryField(fieldName: "filledTimestamp");
  static final QueryField EXPIRETIMESTAMP = QueryField(fieldName: "expireTimestamp");
  static final QueryField LOGOKEY = QueryField(fieldName: "logoKey");
  static final QueryField LOGOADDRESS = QueryField(fieldName: "logoAddress");
  static final QueryField LOGOLENGTH = QueryField(fieldName: "logoLength");
  static final QueryField VERSION = QueryField(fieldName: "version");
  static final QueryField STATUS = QueryField(fieldName: "status");
  static final QueryField STATE = QueryField(fieldName: "state");
  static final QueryField POSITION = QueryField(fieldName: "position");
  static final QueryField DOSENUMBER = QueryField(fieldName: "doseNumber");
  static final QueryField CONNECTIONTIME = QueryField(fieldName: "connectionTime");
  static final QueryField LASTDEVICE = QueryField(fieldName: "lastDevice");
  static final QueryField DEVICES = QueryField(fieldName: "devices");
  static var schema = Model.defineSchema(define: (ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "Cartridge";
    modelSchemaDefinition.pluralName = "Cartridges";
    
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
      key: Cartridge.CARTRIDGEID,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: Cartridge.TYPE,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.enumeration)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: Cartridge.PRODUCTID,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.enumeration)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: Cartridge.HEATERID,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.int)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: Cartridge.TOTALRESISTANCE,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.int)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: Cartridge.COILRESISTANCE,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.int)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: Cartridge.CONTACTRESISTANCE,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.int)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: Cartridge.MEASUREDRESISTANCE,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.int)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: Cartridge.TEMPERATURECOEFFICIENT,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.int)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: Cartridge.NEEDLEGAUGE,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.int)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: Cartridge.VOLUME,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.int)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: Cartridge.FILLERID,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.int)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: Cartridge.LIQUIDID,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.int)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: Cartridge.MAXIMUMTEMPERATURE,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.int)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: Cartridge.MINIMUMTEMPERATU,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.int)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: Cartridge.RECOMMENDEDTEMPERATURE,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.int)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: Cartridge.CUSTOMTEMPERATURE,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.int)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: Cartridge.FILLEDTIMESTAMP,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.timestamp)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: Cartridge.EXPIRETIMESTAMP,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.timestamp)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: Cartridge.LOGOKEY,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: Cartridge.LOGOADDRESS,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.int)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: Cartridge.LOGOLENGTH,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.int)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: Cartridge.VERSION,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.int)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: Cartridge.STATUS,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.enumeration)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: Cartridge.STATE,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.enumeration)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: Cartridge.POSITION,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.int)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: Cartridge.DOSENUMBER,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.int)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: Cartridge.CONNECTIONTIME,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.timestamp)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: Cartridge.LASTDEVICE,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: Cartridge.DEVICES,
      isRequired: false,
      isArray: true,
      ofType: ModelFieldType(ModelFieldTypeEnum.collection, ofModelName: describeEnum(ModelFieldTypeEnum.string))
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

class _CartridgeModelType extends ModelType<Cartridge> {
  const _CartridgeModelType();
  
  @override
  Cartridge fromJson(Map<String, dynamic> jsonData) {
    return Cartridge.fromJson(jsonData);
  }
}