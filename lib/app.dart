import 'dart:ui';

import "package:flutter_bloc/flutter_bloc.dart";
import "package:flutter/material.dart";
import 'package:pc_parts_list/features/parts_list/parts_list.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';
import "./router.dart";
import "./features/user/user.dart";

// Scroll behavior
class CustomScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        ...super.dragDevices,
        PointerDeviceKind.mouse,
      };
}

@immutable
class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final db = Provider.of<Database>(context);

    return MultiProvider(
      providers: [
        RepositoryProvider<UserRepository>(
          create: (context) => SqliteUserRepository(db),
        ),
        RepositoryProvider<PcPartRepository>(
          create: (context) => SqlitePcPartRepository(db),
        ),
        RepositoryProvider<PartsListRepository>(
          create: (context) => SqlitePartsListRepository(db),
        ),
        ProxyProvider<UserRepository, UserBloc>(
          update: (context, repo, _) => UserBloc(repo),
          dispose: (context, bloc) => bloc.close(),
        ),
        ProxyProvider<PcPartRepository, PcPartsBloc>(
          update: (context, repo, _) => PcPartsBloc(repo),
          dispose: (context, bloc) => bloc.close(),
        ),
        ProxyProvider<PartsListRepository, PartsListsBloc>(
          update: (context, repo, _) => PartsListsBloc(repo),
          dispose: (context, bloc) => bloc.close(),
        ),
        ChangeNotifierProvider(
          create: (context) => UsersService(context.read<UserRepository>()),
        ),
      ],
      child: Builder(
        builder: (context) {
          final router = buildRouter(context);

          return MaterialApp.router(
            scrollBehavior: CustomScrollBehavior(),
            routeInformationParser: router.routeInformationParser,
            routerDelegate: router.routerDelegate,
            routeInformationProvider: router.routeInformationProvider,
            themeMode: ThemeMode.dark,
            theme: ThemeData.light().copyWith(useMaterial3: true),
            darkTheme: ThemeData.dark().copyWith(useMaterial3: true),
            title: "PC Parts List",
          );
        },
      ),
    );
  }
}
