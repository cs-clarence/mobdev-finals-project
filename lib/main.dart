import "package:flutter/material.dart";
import 'package:provider/provider.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
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

  await SentryFlutter.init(
    (options) {
      options.dsn =
          'https://2e64f7ea482f46ecb2e3634d44df9891@o1307972.ingest.sentry.io/6552990';
      // Set tracesSampleRate to 1.0 to capture 100% of transactions for performance monitoring.
      // We recommend adjusting this value in production.
      options.tracesSampleRate = 1.0;
    },
    appRunner: () => runApp(
      MultiProvider(
        providers: [
          Provider<Database>(
            create: (context) => db,
            dispose: (context, db) => db.close(),
          ),
        ],
        child: const App(),
      ),
    ),
  );
}
