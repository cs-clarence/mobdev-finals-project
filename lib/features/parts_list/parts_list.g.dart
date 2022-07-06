// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'parts_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PartsListModel _$PartsListModelFromJson(Map<String, dynamic> json) =>
    PartsListModel(
      id: json['id'] as String,
      name: json['name'] as String,
      parts: (json['parts'] as List<dynamic>)
          .map((e) => PcPartModel.fromJson(e as Map<String, dynamic>)),
    );

Map<String, dynamic> _$PartsListModelToJson(PartsListModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'parts': instance.parts.toList(),
    };

PcPartModel _$PcPartModelFromJson(Map<String, dynamic> json) => PcPartModel(
      name: json['name'] as String,
      type: json['type'] as String,
      upc: json['upc'] as String,
      brand: json['brand'] as String,
      price: (json['price'] as num).toDouble(),
    );

Map<String, dynamic> _$PcPartModelToJson(PcPartModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'type': instance.type,
      'upc': instance.upc,
      'brand': instance.brand,
      'price': instance.price,
    };
