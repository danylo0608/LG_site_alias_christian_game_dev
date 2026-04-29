// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WordGroupAdapter extends TypeAdapter<WordGroup> {
  @override
  final int typeId = 1;

  @override
  WordGroup read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WordGroup(
      id: fields[0] as String,
      name: fields[1] as String,
      description: fields[2] as String?,
      file: fields[3] as String?,
      wordCount: fields[4] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, WordGroup obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.file)
      ..writeByte(4)
      ..write(obj.wordCount);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WordGroupAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
