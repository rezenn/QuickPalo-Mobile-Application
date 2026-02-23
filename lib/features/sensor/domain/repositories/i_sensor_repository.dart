import 'package:quickpalo/features/sensor/domain/entities/sensor_event.dart';

abstract interface class ISensorRepository {
  Stream<SensorEvent> watchSensor(SensorType type);
  void startSensor(SensorType type);
  void stopSensor(SensorType type);
  void stopAllSensors();
}
