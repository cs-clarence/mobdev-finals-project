part of "./parts_list.dart";

abstract class PcPartRepository {
  Future<Iterable<PcPartModel>> getByType(String type);

  Future<Iterable<PcPartModel>> getAll();

  Future<PcPartModel?> findByUpc(String upc);

  Future<void> save(PcPartModel pcPart);

  Future<void> update({
    required String upc,
    String? newName,
    double? newPrice,
    String? newBrand,
  });

  Future<void> deleteByUpc(String upc);
}

class SqlitePcPartRepository extends PcPartRepository {
  final Database _database;

  SqlitePcPartRepository(Database database) : _database = database;

  @override
  Future<Iterable<PcPartModel>> getByType(String type) async {
    final results = await _database.query(
      "PcParts",
      columns: ["upc", "name", "brand", "price", "type"],
      where: "type = ?",
      whereArgs: [type],
    );

    return results.map((e) => PcPartModel.fromJson(e));
  }

  @override
  Future<Iterable<PcPartModel>> getAll() async {
    final results = await _database.query(
      "PcParts",
      columns: ["upc", "name", "brand", "price", "type"],
    );

    return results.map((e) => PcPartModel.fromJson(e));
  }

  @override
  Future<PcPartModel?> findByUpc(String upc) async {
    final results = await _database.query(
      "PcParts",
      where: "upc = ?",
      whereArgs: [upc],
      distinct: true,
      limit: 1,
    );

    if (results.isEmpty) {
      return null;
    }

    return PcPartModel.fromJson(results.first);
  }

  @override
  Future<void> save(PcPartModel pcPart) async {
    await _database.insert("PcParts", pcPart.toJson());
  }

  @override
  Future<void> update({
    required String upc,
    String? newName,
    double? newPrice,
    String? newBrand,
  }) async {
    final pcPartUpdate = <String, dynamic>{};

    if (newName != null) {
      pcPartUpdate["name"] = newName;
    }

    if (newBrand != null) {
      pcPartUpdate["brand"] = newBrand;
    }

    if (newPrice != null) {
      pcPartUpdate["price"] = newPrice;
    }

    await _database.update(
      "PcParts",
      pcPartUpdate,
      where: "upc = ?",
      whereArgs: [upc],
    );
  }

  @override
  Future<void> deleteByUpc(String upc) async {
    await _database.delete(
      "PcParts",
      where: "upc = ?",
      whereArgs: [upc],
    );
  }
}
