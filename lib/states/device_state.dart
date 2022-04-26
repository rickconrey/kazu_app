import '../models/User.dart';
import '../models/Cartridge.dart';
import '../models/Device.dart';

class DeviceState {
  final List<int>? id;
  final Device? device;
  final Cartridge? cartridge;
  final User? user;

  DeviceState({
    this.id,
    this.device,
    this.cartridge,
    this.user,
  });

  DeviceState copyWith({
    List<int>? id,
    Device? device,
    Cartridge? cartridge,
    User? user,
  }) {
    return DeviceState(
      id: id ?? this.id,
      device: device ?? this.device,
      cartridge: cartridge ?? this.cartridge,
      user: user ?? this.user,
    );
  }
}