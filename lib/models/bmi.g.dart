// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bmi.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BmiAdapter extends TypeAdapter<Bmi> {
  @override
  final int typeId = 0;

  @override
  Bmi read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Bmi(
      id: fields[0] as int,
      height: fields[1] as double,
      weight: fields[2] as double,
      bmi: fields[3] as double,
      category: fields[4] as double,
      date: fields[5] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, Bmi obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.height)
      ..writeByte(2)
      ..write(obj.weight)
      ..writeByte(3)
      ..write(obj.bmi)
      ..writeByte(4)
      ..write(obj.category)
      ..writeByte(5)
      ..write(obj.date);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BmiAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
