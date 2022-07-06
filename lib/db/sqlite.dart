import 'dart:io';
import 'dart:developer' as developer;

import "package:path/path.dart" as path;
import "package:sqflite/sqflite.dart";
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

typedef MigrationScripts = List<Map<String, List<String>>>;

Future<Database> initializeDatabase({
  String db = "sqlite.db",
  required int version,
  required MigrationScripts migrationScripts,
}) async {
  if (Platform.isLinux || Platform.isWindows) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  const logName = "SQLite Database";

  final dbPath = path.join(await getDatabasesPath(), db);

  developer.log("Database location: $dbPath", name: logName);

  final database = await openDatabase(
    dbPath,
    singleInstance: true,
    version: version,
    onCreate: (db, version) async {
      developer.log(
        "Initializing database to version $version",
        name: logName,
      );
      await db.transaction((txn) async {
        final batch = txn.batch();
        for (var i = 0; i < version; ++i) {
          developer.log(
            "applying migrations[$i] to initial database to version ${i + 1}",
            name: logName,
          );
          final scripts = migrationScripts[i]["up"];
          final seeds = migrationScripts[i]["seed"];

          if (scripts != null) {
            for (final script in scripts) {
              await txn.execute(script);
            }
            if (seeds != null) {
              developer.log(
                "seeding database version ${i + 1}",
                name: logName,
              );
              for (final seed in seeds) {
                await txn.execute(seed);
              }
            }
          } else {
            throw Exception("Missing up key for migration script index $i");
          }
        }
        await batch.commit(noResult: true);
      });
      developer.log(
        "Successfully initialized database to version $version",
        name: logName,
      );
    },
    onUpgrade: (db, oldVersion, newVersion) async {
      developer.log(
        "Upgrading database version $oldVersion to $newVersion",
        name: logName,
      );
      await db.transaction((txn) async {
        final batch = txn.batch();
        for (var i = oldVersion; i < newVersion; ++i) {
          developer.log(
            "applying migrations[$i] to upgrade database to version ${i + 1}",
            name: logName,
          );
          final scripts = migrationScripts[i]["up"];
          final seeds = migrationScripts[i]["seed"];

          if (scripts != null) {
            for (final script in scripts) {
              await txn.execute(script);
            }
            if (seeds != null) {
              developer.log(
                "seeding database version ${i + 1}",
                name: logName,
              );
              for (final seed in seeds) {
                await txn.execute(seed);
              }
            }
          } else {
            throw Exception("Missing up key for migration script index $i");
          }
        }
        await batch.commit(noResult: true);
      });
      developer.log(
        "Successfully upgraded from version $oldVersion to $newVersion",
        name: logName,
      );
    },
    onDowngrade: (db, oldVersion, newVersion) async {
      developer.log(
        "Downgrading database version $oldVersion to $newVersion",
        name: logName,
      );
      await db.transaction((txn) async {
        final batch = txn.batch();
        for (var i = oldVersion; i > newVersion; --i) {
          developer.log(
            "applying downgrade migration ${i - 1}",
            name: logName,
          );
          final scripts = migrationScripts[i - 1]["down"]!;
          for (final script in scripts) {
            await txn.execute(script);
          }
        }
        await batch.commit(noResult: true);
      });
      developer.log(
        "Successfully downgraded from version $oldVersion to $newVersion",
        name: logName,
      );
    },
  );
  return database;
}
