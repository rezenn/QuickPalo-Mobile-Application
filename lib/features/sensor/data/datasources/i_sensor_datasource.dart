import 'package:quickpalo/features/sensor/domain/entities/sensor_event.dart';

abstract interface class ISensorDatasource {
  SensorType get sensorType;
  Stream<SensorEvent> get eventStream;
  void start();
  void stop();
}
