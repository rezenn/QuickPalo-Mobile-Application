// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'organization_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class OrganizationHiveModelAdapter extends TypeAdapter<OrganizationHiveModel> {
  @override
  final int typeId = 1;

  @override
  OrganizationHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return OrganizationHiveModel(
      id: fields[0] as String?,
      userId: fields[1] as String?,
      organizationName: fields[2] as String,
      organizationType: fields[3] as String,
      description: fields[4] as String?,
      street: fields[5] as String,
      city: fields[6] as String,
      state: fields[7] as String?,
      contactEmail: fields[8] as String?,
      contactPhone: fields[9] as String?,
      workingHours: (fields[10] as List)
          .map((dynamic e) => (e as Map).cast<String, dynamic>())
          .toList(),
      departments: (fields[11] as List)
          .map((dynamic e) => (e as Map).cast<String, dynamic>())
          .toList(),
      appointmentDuration: fields[12] as int,
      advanceBookingDays: fields[13] as int,
      timeSlots: (fields[14] as List)
          .map((dynamic e) => (e as Map).cast<String, dynamic>())
          .toList(),
      isActive: fields[15] as bool,
      isVerified: fields[16] as bool,
      createdAt: fields[17] as String?,
      updatedAt: fields[18] as String?,
      user: (fields[19] as Map?)?.cast<String, dynamic>(),
    );
  }

  @override
  void write(BinaryWriter writer, OrganizationHiveModel obj) {
    writer
      ..writeByte(20)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.userId)
      ..writeByte(2)
      ..write(obj.organizationName)
      ..writeByte(3)
      ..write(obj.organizationType)
      ..writeByte(4)
      ..write(obj.description)
      ..writeByte(5)
      ..write(obj.street)
      ..writeByte(6)
      ..write(obj.city)
      ..writeByte(7)
      ..write(obj.state)
      ..writeByte(8)
      ..write(obj.contactEmail)
      ..writeByte(9)
      ..write(obj.contactPhone)
      ..writeByte(10)
      ..write(obj.workingHours)
      ..writeByte(11)
      ..write(obj.departments)
      ..writeByte(12)
      ..write(obj.appointmentDuration)
      ..writeByte(13)
      ..write(obj.advanceBookingDays)
      ..writeByte(14)
      ..write(obj.timeSlots)
      ..writeByte(15)
      ..write(obj.isActive)
      ..writeByte(16)
      ..write(obj.isVerified)
      ..writeByte(17)
      ..write(obj.createdAt)
      ..writeByte(18)
      ..write(obj.updatedAt)
      ..writeByte(19)
      ..write(obj.user);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OrganizationHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
