// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'offline_mutation.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class OfflineMutationAdapter extends TypeAdapter<OfflineMutation> {
  @override
  final int typeId = 101;

  @override
  OfflineMutation read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return OfflineMutation(
      collection: fields[0] as String,
      docId: fields[1] as String,
      operation: fields[2] as MutationOp,
      data: (fields[3] as Map?)?.cast<String, dynamic>(),
      timestamp: fields[4] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, OfflineMutation obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.collection)
      ..writeByte(1)
      ..write(obj.docId)
      ..writeByte(2)
      ..write(obj.operation)
      ..writeByte(3)
      ..write(obj.data)
      ..writeByte(4)
      ..write(obj.timestamp);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OfflineMutationAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class MutationOpAdapter extends TypeAdapter<MutationOp> {
  @override
  final int typeId = 100;

  @override
  MutationOp read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return MutationOp.create;
      case 1:
        return MutationOp.update;
      case 2:
        return MutationOp.delete;
      default:
        return MutationOp.create;
    }
  }

  @override
  void write(BinaryWriter writer, MutationOp obj) {
    switch (obj) {
      case MutationOp.create:
        writer.writeByte(0);
        break;
      case MutationOp.update:
        writer.writeByte(1);
        break;
      case MutationOp.delete:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MutationOpAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
