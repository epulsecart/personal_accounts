// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group_join_request_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GroupJoinRequestModelAdapter extends TypeAdapter<GroupJoinRequestModel> {
  @override
  final int typeId = 23;

  @override
  GroupJoinRequestModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return GroupJoinRequestModel(
      id: fields[0] as String,
      groupId: fields[1] as String,
      requesterId: fields[2] as String,
      requesterName: fields[3] as String,
      inviteeId: fields[4] as String,
      inviteeName: fields[5] as String,
      status: fields[6] as JoinStatus,
      approverId: fields[7] as String?,
      requestedAt: fields[8] as DateTime,
      respondedAt: fields[9] as DateTime?,
      message: fields[10] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, GroupJoinRequestModel obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.groupId)
      ..writeByte(2)
      ..write(obj.requesterId)
      ..writeByte(3)
      ..write(obj.requesterName)
      ..writeByte(4)
      ..write(obj.inviteeId)
      ..writeByte(5)
      ..write(obj.inviteeName)
      ..writeByte(6)
      ..write(obj.status)
      ..writeByte(7)
      ..write(obj.approverId)
      ..writeByte(8)
      ..write(obj.requestedAt)
      ..writeByte(9)
      ..write(obj.respondedAt)
      ..writeByte(10)
      ..write(obj.message);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GroupJoinRequestModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class JoinStatusAdapter extends TypeAdapter<JoinStatus> {
  @override
  final int typeId = 22;

  @override
  JoinStatus read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return JoinStatus.pending;
      case 1:
        return JoinStatus.approved;
      case 2:
        return JoinStatus.rejected;
      default:
        return JoinStatus.pending;
    }
  }

  @override
  void write(BinaryWriter writer, JoinStatus obj) {
    switch (obj) {
      case JoinStatus.pending:
        writer.writeByte(0);
        break;
      case JoinStatus.approved:
        writer.writeByte(1);
        break;
      case JoinStatus.rejected:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is JoinStatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
