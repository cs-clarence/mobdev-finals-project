part of "./parts_list.dart";

@JsonSerializable()
@immutable
class PcPartModel {
  final String name;
  final String type;
  final String upc;
  final String brand;
  final double price;

  const PcPartModel({
    required this.name,
    required this.type,
    required this.upc,
    required this.brand,
    required this.price,
  });

  factory PcPartModel.fromJson(Map<String, dynamic> json) =>
      _$PcPartModelFromJson(json);

  Map<String, dynamic> toJson() => _$PcPartModelToJson(this);
}
