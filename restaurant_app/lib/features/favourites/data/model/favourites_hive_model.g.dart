// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favourites_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FavouritesHiveModelAdapter extends TypeAdapter<FavouritesHiveModel> {
  @override
  final int typeId = 3;

  @override
  FavouritesHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FavouritesHiveModel(
      foodId: fields[0] as String,
      name: fields[1] as String,
      imageUrl: fields[2] as String,
      price: fields[3] as double,
      time: fields[4] as int,
    );
  }

  @override
  void write(BinaryWriter writer, FavouritesHiveModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.foodId)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.imageUrl)
      ..writeByte(3)
      ..write(obj.price)
      ..writeByte(4)
      ..write(obj.time);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FavouritesHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
