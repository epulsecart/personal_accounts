// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group_transaction_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GroupTransactionModelAdapter extends TypeAdapter<GroupTransactionModel> {
  @override
  final int typeId = 21;

  @override
  GroupTransactionModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return GroupTransactionModel(
      id: fields[0] as String,
      groupId: fields[1] as String,
      fromUserId: fields[2] as String,
      toUserId: fields[3] as String,
      createdBy: fields[4] as String,
      amount: fields[5] as double,
      description: fields[6] as String,
      fileUrl: fields[7] as String?,
      date: fields[8] as DateTime,
      isApproved: fields[9] as bool,
      approvedBy: fields[10] as String?,
      createdAt: fields[11] as DateTime,
      updatedAt: fields[12] as DateTime,
      isDeleted: fields[13] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, GroupTransactionModel obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.groupId)
      ..writeByte(2)
      ..write(obj.fromUserId)
      ..writeByte(3)
      ..write(obj.toUserId)
      ..writeByte(4)
      ..write(obj.createdBy)
      ..writeByte(5)
      ..write(obj.amount)
      ..writeByte(6)
      ..write(obj.description)
      ..writeByte(7)
      ..write(obj.fileUrl)
      ..writeByte(8)
      ..write(obj.date)
      ..writeByte(9)
      ..write(obj.isApproved)
      ..writeByte(10)
      ..write(obj.approvedBy)
      ..writeByte(11)
      ..write(obj.createdAt)
      ..writeByte(12)
      ..write(obj.updatedAt)
      ..writeByte(13)
      ..write(obj.isDeleted);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GroupTransactionModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
