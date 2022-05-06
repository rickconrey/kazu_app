import 'package:kazu_app/states/form_submission_status.dart';

import '../models/User.dart';
import '../models/Cartridge.dart';
import '../models/Device.dart';

class DeviceState {
  final List<int>? id;
  final Device? device;
  final Cartridge? cartridge;
  final User? user;
  final int temperature;
  final int dose;
  final bool lock;
  final FormSubmissionStatus temperatureFormStatus;
  final FormSubmissionStatus doseFormStatus;

  bool get isValidTemperature => temperature < 400 && temperature > 180;
  bool get isValidDose => dose < 300 && dose > 0;

  DeviceState({
    this.id,
    this.device,
    this.cartridge,
    this.user,
    this.temperature = 200,
    this.temperatureFormStatus  = const InitialFormStatus(),
    this.dose = 30,
    this.lock = false,
    this.doseFormStatus = const InitialFormStatus(),
  });

  DeviceState copyWith({
    List<int>? id,
    Device? device,
    Cartridge? cartridge,
    User? user,
    int? dose,
    int? temperature,
    bool? lock,
    FormSubmissionStatus? temperatureFormStatus,
    FormSubmissionStatus? doseFormStatus,
  }) {
    return DeviceState(
      id: id ?? this.id,
      device: device ?? this.device,
      cartridge: cartridge ?? this.cartridge,
      user: user ?? this.user,
      dose: dose ?? this.dose,
      temperature: temperature ?? this.temperature,
      temperatureFormStatus: temperatureFormStatus ?? this.temperatureFormStatus,
      doseFormStatus: doseFormStatus ?? this.doseFormStatus,
      lock: lock ?? this.lock,
    );
  }
}