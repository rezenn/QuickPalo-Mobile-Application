import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quickpalo/features/sensor/data/repositories/sensor_repository.dart';
import 'package:quickpalo/features/sensor/domain/entities/sensor_event.dart';
import 'package:quickpalo/features/sensor/domain/repositories/i_sensor_repository.dart';

final watchSensorUsecaseProvider = Provider<WatchSensorUsecase>((ref) {
  return WatchSensorUsecase(ref.read(sensorRepositoryProvider));
});

class WatchSensorUsecase {
  final ISensorRepository _repository;
  WatchSensorUsecase(this._repository);

  Stream<SensorEvent> call(SensorType type) {
    _repository.startSensor(type);
    return _repository.watchSensor(type);
  }

  void stop(SensorType type) => _repository.stopSensor(type);
  void stopAll() => _repository.stopAllSensors();
}
