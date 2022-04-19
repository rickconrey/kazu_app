class DeviceState {
  final List<int>? id;

  DeviceState({
    this.id,
  });

  DeviceState copyWith({
    List<int>? id,
  }) {
    return DeviceState(
      id: id ?? this.id,
    );
  }
}