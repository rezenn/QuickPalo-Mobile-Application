enum SensorType { proximity, accelerometer, gyroscope }

class SensorEvent {
  final SensorType type;
  final bool isTriggered;
  final Map<String, dynamic> rawData;
  SensorEvent({
    required this.type,
    required this.isTriggered,
    required this.rawData,
  });
}
