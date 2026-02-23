import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quickpalo/features/sensor/data/datasources/accelerometer_datasource.dart';
import 'package:quickpalo/features/sensor/data/datasources/i_sensor_datasource.dart';
import 'package:quickpalo/features/sensor/data/datasources/proximity_datasource.dart';
import 'package:quickpalo/features/sensor/domain/entities/sensor_event.dart';
import 'package:quickpalo/features/sensor/domain/repositories/i_sensor_repository.dart';

final sensorRepositoryProvider = Provider<ISensorRepository>((ref) {
  return SensorRepository(
    datasources: [
      ref.read(proximityDatasourceProvider),
      ref.read(accelerometerDatasourceProvider),
    ],
  );
});

class SensorRepository implements ISensorRepository {
  final Map<SensorType, ISensorDatasource> _datasources;

  SensorRepository({required List<ISensorDatasource> datasources})
      : _datasources = {for (final ds in datasources) ds.sensorType: ds};

  ISensorDatasource _get(SensorType type) {
    final ds = _datasources[type];
    if (ds == null) throw Exception('No datasource registered for $type');
    return ds;
  }

  @override
  void startSensor(SensorType type) => _get(type).start();

  @override
  void stopAllSensors() {
    for (final ds in _datasources.values) {
      ds.stop();
    }
  }

  @override
  void stopSensor(SensorType type) => _get(type).stop();

  @override
  Stream<SensorEvent> watchSensor(SensorType type) => _get(type).eventStream;
}
