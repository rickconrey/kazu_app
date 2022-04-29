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

import 'package:amplify_core/amplify_core.dart';
import 'Cartridge.dart';
import 'CartridgeEvent.dart';
import 'ChargeEvent.dart';
import 'Device.dart';
import 'PuffEvent.dart';
import 'ResetEvent.dart';
import 'User.dart';

export 'Cartridge.dart';
export 'CartridgeEvent.dart';
export 'CartridgeState.dart';
export 'CartridgeStatus.dart';
export 'CartridgeType.dart';
export 'ChargeEvent.dart';
export 'Device.dart';
export 'DeviceLockStatus.dart';
export 'ProductId.dart';
export 'PuffEvent.dart';
export 'ResetEvent.dart';
export 'User.dart';

class ModelProvider implements ModelProviderInterface {
  @override
  String version = "1c4415dc23129e85373dc11f9613b5fd";
  @override
  List<ModelSchema> modelSchemas = [Cartridge.schema, CartridgeEvent.schema, ChargeEvent.schema, Device.schema, PuffEvent.schema, ResetEvent.schema, User.schema];
  static final ModelProvider _instance = ModelProvider();
  @override
  List<ModelSchema> customTypeSchemas = [];

  static ModelProvider get instance => _instance;
  
  ModelType getModelTypeByModelName(String modelName) {
    switch(modelName) {
      case "Cartridge":
        return Cartridge.classType;
      case "CartridgeEvent":
        return CartridgeEvent.classType;
      case "ChargeEvent":
        return ChargeEvent.classType;
      case "Device":
        return Device.classType;
      case "PuffEvent":
        return PuffEvent.classType;
      case "ResetEvent":
        return ResetEvent.classType;
      case "User":
        return User.classType;
      default:
        throw Exception("Failed to find model in model provider for model name: " + modelName);
    }
  }
}