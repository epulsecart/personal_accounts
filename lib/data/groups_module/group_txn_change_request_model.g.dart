// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group_txn_change_request_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GroupTxnChangeRequestModelAdapter
    extends TypeAdapter<GroupTxnChangeRequestModel> {
  @override
  final int typeId = 26;

  @override
  GroupTxnChangeRequestModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return GroupTxnChangeRequestModel(
      id: fields[0] as String,
      groupId: fields[1] as String,
      transactionId: fields[2] as String,
      type: fields[3] as ChangeType,
      requestedBy: fields[4] as String,
      oldAmount: fields[5] as double?,
      newAmount: fields[6] as double?,
      oldDescription: fields[7] as String?,
      newDescription: fields[8] as String?,
      status: fields[9] as RequestStatus,
      approvedBy: fields[10] as String?,
      requestedAt: fields[11] as DateTime,
      respondedAt: fields[12] as DateTime?,
      reason: fields[13] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, GroupTxnChangeRequestModel obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.groupId)
      ..writeByte(2)
      ..write(obj.transactionId)
      ..writeByte(3)
      ..write(obj.type)
      ..writeByte(4)
      ..write(obj.requestedBy)
      ..writeByte(5)
      ..write(obj.oldAmount)
      ..writeByte(6)
      ..write(obj.newAmount)
      ..writeByte(7)
      ..write(obj.oldDescription)
      ..writeByte(8)
      ..write(obj.newDescription)
      ..writeByte(9)
      ..write(obj.status)
      ..writeByte(10)
      ..write(obj.approvedBy)
      ..writeByte(11)
      ..write(obj.requestedAt)
      ..writeByte(12)
      ..write(obj.respondedAt)
      ..writeByte(13)
      ..write(obj.reason);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GroupTxnChangeRequestModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ChangeTypeAdapter extends TypeAdapter<ChangeType> {
  @override
  final int typeId = 24;

  @override
  ChangeType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ChangeType.update;
      case 1:
        return ChangeType.delete;
      default:
        return ChangeType.update;
    }
  }

  @override
  void write(BinaryWriter writer, ChangeType obj) {
    switch (obj) {
      case ChangeType.update:
        writer.writeByte(0);
        break;
      case ChangeType.delete:
        writer.writeByte(1);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChangeTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class RequestStatusAdapter extends TypeAdapter<RequestStatus> {
  @override
  final int typeId = 25;

  @override
  RequestStatus read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return RequestStatus.pending;
      case 1:
        return RequestStatus.approved;
      case 2:
        return RequestStatus.rejected;
      default:
        return RequestStatus.pending;
    }
  }

  @override
  void write(BinaryWriter writer, RequestStatus obj) {
    switch (obj) {
      case RequestStatus.pending:
        writer.writeByte(0);
        break;
      case RequestStatus.approved:
        writer.writeByte(1);
        break;
      case RequestStatus.rejected:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RequestStatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
