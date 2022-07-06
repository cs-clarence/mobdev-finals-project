part of './parts_list.dart';

@JsonSerializable()
@immutable
class PartsListModel {
  final String id;
  final String name;
  final Iterable<PcPartModel> parts;

  const PartsListModel({
    required this.id,
    required this.name,
    required this.parts,
  });

  factory PartsListModel.fromJson(Map<String, dynamic> json) => _$PartsListModelFromJson(json);

  Map<String, dynamic> toJson() => _$PartsListModelToJson(this);
}
