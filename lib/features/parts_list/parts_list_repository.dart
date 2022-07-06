part of "./parts_list.dart";

abstract class PartsListRepositoryException implements Exception {
  final String message;

  const PartsListRepositoryException(this.message);
}

class PartsListNameAlreadyTakenException extends PartsListRepositoryException {
  PartsListNameAlreadyTakenException(String partsListName)
      : super("Parts List Name already taken $partsListName");
}

class PartsListDoesNotExistsException extends PartsListRepositoryException {
  PartsListDoesNotExistsException(String id)
      : super("Parts List with the id $id does not exist");
}

abstract class PartsListRepository {
  Future<Iterable<PartsListModel>> getPartsListsForUser(String userName);

  Future<void> save({
    required String userName,
    required String partsListName,
    required Iterable<String> partsUpcs,
  });

  Future<bool> isPartListOwnedByUser({
    required String userName,
    required String partListId,
  });

  Future<PartsListModel?> findById(String id);

  Future<PartsListModel> getById(String id);

  Future<void> deleteById(String id);

  Future<void> update({
    required String id,
    String? newPartsListName,
    Iterable<String>? newPartsUpcs,
  });
}

class SqlitePartsListRepository extends PartsListRepository {
  final Database _database;
  final uuid = const Uuid();

  SqlitePartsListRepository(Database database) : _database = database;

  @override
  Future<PartsListModel?> findById(String id) async {
    final results = await _database.query(
      "PartsLists",
      where: "id = ? ",
      whereArgs: [id],
      distinct: true,
      limit: 1,
    );

    if (results.isEmpty) return null;

    final partsList = results.first;

    final pcPartsToPartsListsResult = await _database.query(
      "PcPartsToPartsLists",
      where: "partsListId = ?",
      whereArgs: [id],
    );

    final resultsUpc =
        pcPartsToPartsListsResult.map((e) => e["pcPartUpc"] as String).toList();

    final pcPartsResults = await _database.query(
      "PcParts",
      where: "upc IN (${resultsUpc.map((e) => "'$e'").join(", ")})",
    );

    final pcParts = pcPartsResults.map((e) => PcPartModel.fromJson(e));

    return PartsListModel(
      id: id,
      name: partsList["name"] as String,
      parts: pcParts,
    );
  }

  @override
  Future<PartsListModel> getById(String id) async {
    final result = await findById(id);
    if (result == null) throw PartsListDoesNotExistsException(id);
    return result;
  }

  @override
  Future<Iterable<PartsListModel>> getPartsListsForUser(String userName) async {
    final partsListsQueryResult = await _database.query(
      "PartsLists",
      columns: ["id"],
      where: "userName = ?",
      whereArgs: [userName],
    );

    if (partsListsQueryResult.isEmpty) {
      return [];
    }

    final partsListIds = partsListsQueryResult.map((e) => e["id"] as String);

    final partsLists = <PartsListModel>[];

    for (final id in partsListIds) {
      partsLists.add(await getById(id));
    }

    return partsLists;
  }

  @override
  Future<void> save({
    required String userName,
    required String partsListName,
    required Iterable<String> partsUpcs,
  }) async {
    _database.transaction((txn) async {
      final batch = txn.batch();
      final id = uuid.v4();
      await txn.insert("PartsLists", {
        "id": id,
        "name": partsListName,
        "userName": userName,
      });

      for (final pcPartUpc in partsUpcs) {
        await txn.insert("PcPartsToPartsLists", {
          "partsListId": id,
          "pcPartUpc": pcPartUpc,
        });
      }

      await batch.commit(noResult: true);
    });
  }

  @override
  Future<void> update({
    required String id,
    String? newPartsListName,
    Iterable<String>? newPartsUpcs,
  }) async {
    if (newPartsListName == null &&
        (newPartsUpcs == null || newPartsUpcs.isEmpty)) {
      return;
    }

    _database.transaction((txn) async {
      final batch = txn.batch();

      if (newPartsListName != null) {
        await txn.update(
          "PartsLists",
          {
            "name": newPartsListName,
          },
          where: "id = ?",
          whereArgs: [id],
        );
      }

      await txn.delete(
        "PcPartsToPartsLists",
        where: "partsListId = ?",
        whereArgs: [id],
      );

      for (final pcPartUpc in newPartsUpcs!) {
        await txn.insert("PcPartsToPartsLists", {
          "partsListId": id,
          "pcPartUpc": pcPartUpc,
        });
      }

      await batch.commit(noResult: true);
    });
  }

  @override
  Future<void> deleteById(String id) async {
    await _database.delete(
      "PartsLists",
      where: "id = ?",
      whereArgs: [id],
    );
  }

  @override
  Future<bool> isPartListOwnedByUser({
    required String userName,
    required String partListId,
  }) async {
    final result = await _database.query(
      "PartsLists",
      where: "userName = ? AND id = ?",
      whereArgs: [userName, partListId],
    );

    return result.isNotEmpty;
  }
}
