import "package:flutter/material.dart";
import 'package:pc_parts_list/features/user/user.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';
import "./app.dart";
import 'db/migrations.dart';
import 'db/sqlite.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final db = await initializeDatabase(
    migrationScripts: migrationScripts,
    version: dbVersion,
    db: "pc_parts_list.db",
  );

  runApp(MultiProvider(
    providers: [
      Provider<Database>(
        create: (context) => db,
        dispose: (context, db) => db.close(),
      ),
    ],
    child: const App(),
  ));
}
