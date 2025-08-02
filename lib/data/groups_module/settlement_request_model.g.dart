// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settlement_request_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class   SettlementRequestModelAdapter
    extends TypeAdapter<SettlementRequestModel> {
  @override
  final int typeId = 27;

  @override
  SettlementRequestModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SettlementRequestModel(
      id: fields[0] as String,
      groupId: fields[1] as String,
      groupName: fields[2] as String,
      creatorId: fields[3] as String,
      creatorName: fields[4] as String,
      targetMemberId: fields[5] as String,
      targetMemberName: fields[6] as String,
      amount: fields[7] as double,
      dueDate: fields[8] as DateTime,
      settled: fields[9] as bool,
      note: fields[11] as String?,
      requestedAt: fields[10] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, SettlementRequestModel obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.groupId)
      ..writeByte(2)
      ..write(obj.groupName)
      ..writeByte(3)
      ..write(obj.creatorId)
      ..writeByte(4)
      ..write(obj.creatorName)
      ..writeByte(5)
      ..write(obj.targetMemberId)
      ..writeByte(6)
      ..write(obj.targetMemberName)
      ..writeByte(7)
      ..write(obj.amount)
      ..writeByte(8)
      ..write(obj.dueDate)
      ..writeByte(9)
      ..write(obj.settled)
      ..writeByte(10)
      ..write(obj.requestedAt)
      ..writeByte(11)
      ..write(obj.note);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SettlementRequestModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
